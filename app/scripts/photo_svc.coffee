app.service 'PhotoSvc', [ () ->

  ps =
    path: "/photo"
    sid: null
    page_limit: 100

  photo =
    data: []
    count: 0

  album =
    data: []
    count: 0

  albumPhoto = {}

  fetch_photo = (page,id) ->
    sid = ps.sid
    if id
      albumPhoto[id].data[page] = []
      target = albumPhoto[id]
      svc = ps.path+"/api/list.php?t=albumPhotos&"+$.param({a: id, p: page, c:ps.page_limit})
    else
      photo.data[page] = []
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
          id = $('id',@).text()
          target.data[page].push {
            id: id
            type: 'photo'
            src: '/photo/api/thumb.php?f='+id
            output: location.protocol+'//'+location.host+'/photo/api/photo.php?&'+$.param({a: 'display', f: id, sid:ps.sid})
            width: $('iWidth',@).text()
            height: $('iHeight',@).text()
          }

  fetch_album = (page) ->
    sid = ps.sid
    album.data[page] = []
    $.ajax({
      type: "GET"
      url: ps.path+"/api/list.php?t=albums&"+$.param({p: page, c:ps.page_limit})
      cache: false
      dataType: 'xml'
    }).done (res) ->
      return if sid isnt ps.sid
      # count = $('Count',res).text()
      # photo.count = count if count > 0
      $('FileItem',res).each () ->
        id = $('iPhotoAlbumId',@).text()
        album.data[page].push {
          id: id
          type: 'album'
          src: '/photo/api/thumb.php?f='+id
          count: $('PhotoCount',@).text()
          title: $('cAlbumTitle',@).text()
          created: $('DateCreated',@).text()
          modified: $('DateModified',@).text()
        }

  @photo = (page, id) ->
    page = 1 if page < 1
    if id
      albumPhoto[id] = {data: [], count: 0} unless albumPhoto[id]
      target = albumPhoto[id]
    else
      target = photo

    if target.data[page] instanceof Array
      return if target.data[page].length > 0 then target.data[page] else false
    else
      console.log 'req photo'
      fetch_photo(page, id) if ps.sid
      return false

  @album = (page) ->
    page = 1 if page < 1

    if album.data[page] instanceof Array
      return if album.data[page].length > 0 then album.data[page] else false
    else
      console.log 'req album'
      fetch_album(page) if ps.sid
      return false

  @reset_sid = (sid) ->
    if sid isnt ps.sid
      ps.sid = sid
      photo.count = 0
      photo.data[i] = null for item, i in photo.data
      album.count = 0
      album.data[i] = null for item, i in photo.data
      albumPhoto = {}

  @photo_count = () -> photo.count
]