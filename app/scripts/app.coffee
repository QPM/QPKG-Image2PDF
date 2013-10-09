app = angular.module("gruntNgApp", [])

app.filter 'lastTo', () ->
  (input, num) ->
    input = input.slice(input.length-num)
    for i in [input.length...6]
      input.push {
        type: 'none'
        src: './images/selected_icon.png'
      }

    return input

app.filter 'layout', () ->
  (input, box) ->
    width_capacity = box.width - 5
    width_loaded = 0
    queue = []
    angular.forEach input, (value, key)->
      queue.push value
      width_capacity -= 5
      value.dis_height = box.height
      if value.type is 'album'
        value.dis_width = box.height
      else
        value.dis_width = box.height / value.height * value.width
      width_loaded += value.dis_width
      if width_loaded >= width_capacity
        item.dis_width = item.dis_width/width_loaded*width_capacity for item in queue
        queue = []
        width_capacity = box.width - 5
        width_loaded = 0

    item.dis_width = item.dis_width/width_loaded*width_capacity for item in queue
    return input

app.controller "UserCtrl", ($scope, UserSvc, PhotoSvc) ->
  $scope.user = UserSvc.info()
  $scope.$watch UserSvc.status, () ->
    $scope.user = UserSvc.info()
    PhotoSvc.reset_sid($scope.user.sid) if UserSvc.status() is 'login'

  $scope.$watch UserSvc.status, () ->
    $scope.user = UserSvc.info()

  $scope.username = null
  $scope.password = null

  $scope.login = () ->
    UserSvc.login $scope.username, $scope.password

app.directive 'ngload', ($parse) ->
  (scope, element, attrs) ->
    fn = $parse(attrs.ngload);
    element.load (event) ->
      scope.$apply () ->
        fn(scope, {$event:event});

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
  .when("/albumPhoto/:id",
    templateUrl: "views/photo.html"
    controller: "PhotoCtrl"
    resolve:
      Tab: -> 'albumPhoto'
  )
  .when("/template",
    templateUrl: "views/template.html"
    controller: "TemplateCtrl"
  )
  .otherwise redirectTo: "/photo"

  delete $httpProvider.defaults.headers.common['X-Requested-With']