app.service 'PhotoSvc', [ '$http', ($http)->
  data = []
  $http.get('http://localhost/photo/list.php')
    .success (res)->
      for item in res
        length
        data[data.length] =
          width: item.width*300/item.height
          src: 'http://localhost/photo/'+item.path
          index: data.length
          selected: no
  @fetch = () ->
    return data
]