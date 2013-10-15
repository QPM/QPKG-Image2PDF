app.service 'PhotoSvc', [ () ->

  ps =
    path: "/photo"
    sid: null
    page_limit: 100

  photo_lite = {}
  album_lite = {}

  photo_array =
    data: []
    count: 0
    selected: 0
    page: 0
    looading: no

  album_array =
    data: []
    count: 0
    page: 0

  get_photo_from_dblite = (photo, album) ->
    id = $('id', photo).text()
    unless photo_lite[id]
      photo_lite[id] = 
        id: id
        type: 'photo'
        src: '/photo/api/thumb.php?f='+id
        output: '/photo/api/photo.php?&'+$.param({a: 'display', f: id, sid:ps.sid})
        width: $('iWidth', photo).text()
        height: $('iHeight', photo).text()
        selected: no
        album: []
    photo_lite[id].album.push(album) if album
    return photo_lite[id]

  get_album_from_dblite = (album) ->
    id = $('iPhotoAlbumId', album).text()
    unless album_lite[id]
      album_lite[id] = 
        id: id
        type: 'album'
        src: '/photo/api/thumb.php?f='+id
        count: $('PhotoCount', album).text()
        title: $('cAlbumTitle', album).text()
        created: $('DateCreated', album).text()
        modified: $('DateModified', album).text()
        selected: 0
        data: []
        page: 1
        looading: no
    return album_lite[id]

  fetch_photo = (page,id) ->
    sid = ps.sid
    if id
      target = album_lite[id]
      svc = ps.path+"/api/list.php?t=albumPhotos&"+$.param({a: id, p: page, c:ps.page_limit})
    else
      target = photo
      svc = ps.path+"/api/list.php?t=photos&"+$.param({p: page, c:ps.page_limit})
    
    $.ajax({
      type: "GET"
      url: svc
      cache: false
      dataType: 'xml'
    }).done (res) ->
      return if sid isnt ps.sid
      count = $('photoCount',res).text()
      target.count = count if count > 0
      $('FileItem',res).each () ->
        if $('MediaType',@).text() is 'photo'
          item = get_photo_from_dblite(@,target)
          target.data.push item
          target.selected++ if item.selected


  fetch_album = () ->
    sid = ps.sid
    $.ajax({
      type: "GET"
      url: ps.path+"/api/list.php?t=albums&"+$.param({p: ++album_array.page, c:ps.page_limit})
      cache: false
      dataType: 'xml'
    }).always (res, status) ->
      return if sid isnt ps.sid
      $('FileItem',res).each(() -> album_array.data.push get_album_from_dblite(@)) if status is 'success'
      setTimeout(fetch_album, 500) if album_array.data.length < album_array.count

  fetch_album_photo = () ->


  @photo = (page, id) ->
    page = 1 if page < 1
    if id
      target = album_lite[id]
    else
      target = photo

    return false unless target instanceof Object

    if target.data[page] instanceof Array
      return if target.data[page].length > 0 then target.data[page] else false
    else
      fetch_photo(page, id) if ps.sid
      return false

  @album = (page) ->
    page = 1 if page < 1

    if album.data[page] instanceof Array
      return if album.data[page].length > 0 then album.data[page] else false
    else
      fetch_album(page) if ps.sid
      return false

  @reset_sid = (sid) ->
    if sid isnt ps.sid
      ps.sid = sid
      photo.count = 0
      photo.data.shift() while photo.data.length
      album.count = 0
      album.data.shift() while album.data.length
      photo_lite = {}
      album_lite = {}
      fetch_album()

  @photo_count = () -> photo.count

  (auto_fetch = ()->
    angular.forEach album_array.data, (album, key) ->
  )()
]