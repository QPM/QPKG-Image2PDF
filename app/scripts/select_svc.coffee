app.service 'SelectSvc', [ ()->
  data = []
  @add = (photo) ->
    photo.selected = yes
    data.push(photo)
    angular.forEach photo.album, (value, key) -> value.selected++
  @del = (photo) ->
    index = data.indexOf(photo)
    photo.selected = no
    data.splice(index, 1)
    angular.forEach photo.album, (value, key) -> value.selected--
  @clear = () ->
    angular.forEach data.splice(0), (photo, key) -> 
      photo.selected = no
      angular.forEach photo.album, (value, key) -> value.selected--
  @fetch = () ->
    data
  @length = () ->
    data.length
  @exchange = (photo_a, photo_b) ->
    index_a = data.indexOf(photo_a)
    index_b = data.indexOf(photo_b)
    data.splice(index_a, 1, photo_b)
    data.splice(index_b, 1, photo_a)
]