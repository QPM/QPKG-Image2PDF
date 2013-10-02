app = angular.module("gruntNgApp", [])

app.filter 'layout', () ->
  (input, width) ->
    width_capacity = width
    width_loaded = 0
    queue = []
    angular.forEach input, (value, key)->
      queue.push value
      width_capacity -= 5
      width_loaded += value.width
      if width_loaded >= width_capacity
        item.view = item.width/width_loaded*width_capacity for item in queue
        queue = []
        width_capacity = width
        width_loaded = 0
    item.view = item.width/width_loaded*width_capacity for item in queue
    return input

app.config ($routeProvider, $httpProvider) ->
  $routeProvider
  .when("/photo",
    templateUrl: "views/photo.html"
    controller: "PhotoCtrl"
    resolve:
      Tab: -> 'photo'
  )
  .when("/album",
    templateUrl: "views/photo.html"
    controller: "PhotoCtrl"
    resolve:
      Tab: -> 'album'
  )
  .when("/selected",
    templateUrl: "views/photo.html"
    controller: "PhotoCtrl"
    resolve:
      Tab: -> 'selected'
  )
  .when("/template",
    templateUrl: "views/template.html"
    controller: "TemplateCtrl"
  )
  .otherwise redirectTo: "/photo"

  delete $httpProvider.defaults.headers.common['X-Requested-With']