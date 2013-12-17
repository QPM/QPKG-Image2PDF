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

app.filter 'lastTo', () ->
  (input, max) ->
    num = input.length - max
    num = 0 if num < 0
    return input.slice(num).reverse();

app.controller "UserCtrl", ($scope, UserSvc, PhotoSvc) ->
  $scope.user = UserSvc.info()

  $scope.$watch UserSvc.status, () ->
    $scope.user = UserSvc.info()

  $scope.username = null
  $scope.password = null
  $scope.remember = no

  $scope.toggle_remember = () ->
    $scope.remember = !$scope.remember

  $scope.login = () ->
    return unless $scope.username and $scope.password
    UserSvc.login $scope.username, $scope.password

app.directive 'ngload', ($parse) ->
  (scope, element, attrs) ->
    fn = $parse(attrs.ngload);
    element.load (event) ->
      scope.$apply () ->
        fn(scope, {$event:event});

app.directive 'ngKeydown', ($parse) ->
  (scope, element, attrs) ->
    fn = $parse(attrs.ngKeydown);
    $(element).on 'keydown', (event) ->
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

app.run ($rootScope) ->
  keys = [38,38,40,40,37,39,37,39,66,65]
  key_str =
    38: '↑'
    40: '↓'
    37: '←'
    39: '→'
    65: 'A'
    66: 'B'
  key_index = 0
  $rootScope.title = 'Image2PDF'
  $rootScope.tip = ''
  $rootScope.out_type = 'pdf'
  $rootScope.keyman = ($e) ->
    if keys[key_index] is parseInt($e.keyCode)
      $rootScope.tip = $rootScope.tip+key_str[keys[key_index]]
      key_index++
    else
      $rootScope.tip = ''
      key_index = 0
    if key_index >= keys.length
      $rootScope.title = 'PinPin'
      $rootScope.out_type = 'png'
      $rootScope.tip = ''
      key_index = 0      
  return on