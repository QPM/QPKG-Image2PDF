app.controller "PhotoCtrl", ($scope, $routeParams, PhotoSvc, SelectSvc, UserSvc, Tab) ->
  $scope.items = []
  $scope.tab = Tab
  # $scope.preview = []
  $scope.selected = SelectSvc.fetch()
  $scope.box =
    width: 1000
    height: 300

  $scope.toolbar = false
  
  $scope.user = UserSvc.info()

  $scope.$watch UserSvc.status, () ->
    $scope.user = UserSvc.info()

  # $scope.$watch $scope.selected, () ->
  #   $scope.preview = []
  #   item = SelectSvc.fetch()
  #   last = 6

  #   console.log $scope.preview

  #   item_length = item.length
  #   $scope.preview.push(input[i]) for i in [item_length-last...item_length] when i > -1

  $scope.toolbar_toggle = () ->
    $scope.toolbar = !$scope.toolbar

  $scope.select = (photo) ->
    photo.hover = off
    if photo.selected
      SelectSvc.del(photo)
    else
      SelectSvc.add(photo)
      $scope.toolbar = true

  $scope.clear = () ->
    SelectSvc.clear()

  (listener = ()->
    width = $('#main').width()
    if width isnt $scope.box.width
      $scope.box.width = width
      $scope.$apply() unless $scope.$$phase

    if $scope.items.length < 1 and UserSvc.status() is 'login'
      switch Tab
        when 'album'
          data = PhotoSvc.album(1)
          console.log data
        when 'selected'
          data = SelectSvc.fetch()
        else
          data = PhotoSvc.photo(1)
      if data instanceof Array
        $scope.items.push(item) for item in data
        $scope.$apply() unless $scope.$$phase

    setTimeout listener, 1000
  )()