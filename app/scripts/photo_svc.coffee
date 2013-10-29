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

  timer =
    photo: null
    albumPhoto: null

  get_photo_from_dblite = (photo, album) ->
    id = $('id', photo).text()
    photo_lite[id] = {} unless photo_lite[id]
    obj = photo_lite[id]
    obj.id = id
    obj.type = 'photo'
    obj.src = '/photo/api/thumb.php?'+$.param({s:1, f:id})
    obj.output = '/photo/api/photo.php?'+$.param({a:'display', f:id, sid:ps.sid})
    obj.width = $('iWidth', photo).text()
    obj.height = $('iHeight', photo).text()
    obj.album = [] unless obj.album
    obj.album.push(album) if album
    # photo.selected = no
    return obj

  get_album_from_dblite = (album) ->
    id = $('iPhotoAlbumId', album).text()
    album_lite[id] = {} unless album_lite[id]
    obj = album_lite[id]
    obj.id = id
    obj.type = 'album'
    obj.src = '/photo/api/thumb.php?f='+$('iAlbumCover', album).text()
    obj.count = $('PhotoCount', album).text()
    obj.title = $('cAlbumTitle', album).text()
    obj.created = $('DateCreated', album).text()
    obj.modified = $('DateModified', album).text()
    obj.selected = 0
    obj.data = [] unless obj.data
    obj.page = 0 unless obj.page
    return obj

  fetch_photo = (id, completed) ->
    sid = ps.sid
    if id
      target = album_lite[id]
      svc = ps.path+"/api/list.php?t=albumPhotos&"+$.param({a: id, p: ++target.page, c:ps.page_limit})
    else
      target = photo_array
      svc = ps.path+"/api/list.php?t=photos&"+$.param({p: ++target.page, c:ps.page_limit})
    
    $.ajax({
      type: "GET"
      url: svc
      cache: false
      dataType: 'xml'
    }).always (res, status) ->
      return if sid isnt ps.sid
      if status is 'success'
        count = $('photoCount',res).text()
        target.count = count if count > 0
        $('FileItem',res).each () ->
          if $('MediaType',@).text() is 'photo'
            item = get_photo_from_dblite(@,if id then target else null)
            target.data.push item
            target.selected++ if item.selected

      completed() if angular.isFunction(completed)

  fetch_album = (wait=1000) ->
    sid = ps.sid
    $.ajax({
      type: "GET"
      url: ps.path+"/api/list.php?t=albums"
      cache: false
      dataType: 'xml'
    }).always (res, status) ->
      return if sid isnt ps.sid
      if status is 'success'
        $('FileItem',res).each () ->
          album_array.data.push get_album_from_dblite(@)
          album_array.count = album_array.data.length
      else
        setTimeout (() -> fetch_album(wait+500)), wait

  @photo = (id) ->
    if id
      target = @get_album(id)
    else
      target = photo_array

    return target.data

  @album = () -> album_array.data

  @get_album = (id) ->
    album_lite[id] = {} unless album_lite[id]
    obj = album_lite[id]
    obj.id = id unless obj.id
    obj.data = [] unless obj.data
    obj.page = 0 unless obj.page
    obj

  @reset_sid = (sid) ->
    if sid isnt ps.sid
      ps.sid = sid
      photo_array.count = 0
      photo_array.data.shift() while photo_array.data.length
      album_array.count = 0
      album_array.data.shift() while album_array.data.length
      photo_lite = {}
      album_lite = {}

      clearTimeout(timer.albumPhoto) if timer.albumPhoto
      (auto_fetch_album_photo = (limitPage) ->
        for album in album_array.data
          if album.page < limitPage and album.data.length < album.count
            fetch_photo album.id, () ->
              timer.albumPhoto = setTimeout (()-> auto_fetch_album_photo(limitPage)), 500
            return;
        if album_array.data.length > 0
          timer.albumPhoto = setTimeout (()-> auto_fetch_album_photo(limitPage+1)), 500
        else
          timer.albumPhoto = setTimeout (()-> auto_fetch_album_photo(limitPage)), 500
      )(1)

      clearTimeout(timer.photo) if timer.photo
      (auto_fetch_photo = () ->
        fetch_photo null, ()->
          setTimeout(auto_fetch_photo, 1000) if photo_array.data.length < photo_array.count
      )()

      fetch_album()

  @photo_count = () -> photo.count
]