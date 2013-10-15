app = angular.module("gruntNgApp", [])

app.filter 'layout', () ->
  (input, box) ->

    switch box.type
      when 'photo'
        index = 0
        height = box.height * 300
        while index < input.length
          queue = []
          width_capacity = box.wrap_width - 5
          width_loaded = 0
          while width_loaded < width_capacity and index < input.length
            item = input[index++]
            queue.push item
            item.dis_height = height
            item.dis_width = height / item.height * item.width
            width_capacity -= 5
            width_loaded += item.dis_width
          item.dis_width = item.dis_width/width_loaded*width_capacity for item in queue
      when 'album'
        width = box.width * 160
        size = box.wrap_width / Math.ceil(box.wrap_width / width)
        angular.forEach input, (value, key)->
          value.dis_width = size - 5
          value.dis_height = size - 5
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