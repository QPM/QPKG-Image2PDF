app.service 'SelectSvc', [ ()->
  data = []
  @add = (photo) ->
    photo.selected = yes
    data.push(photo)
  @del = (photo) ->
    index = data.indexOf(photo)
    data.splice(index, 1)[0].selected = no if index > -1
  @clear = () ->
    angular.forEach data.splice(0), (value, key) -> value.selected = no
  @fetch = () ->
    data
  @length = () ->
    data.length
]