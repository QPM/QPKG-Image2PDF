app.controller "PhotoCtrl", ($scope, $routeParams, PhotoSvc, SelectSvc, UserSvc, Tab, Configs) ->
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

  $scope.init = () ->
    Configs.set_step(1, Tab)
    $scope.toolbar = true if $scope.selected.length > 0

  # $scope.$watch $scope.selected, () ->
  #   $scope.preview = []
  #   item = SelectSvc.fetch()
  #   last = 6

  #   console.log $scope.preview

  #   item_length = item.length
  #   $scope.preview.push(input[i]) for i in [item_length-last...item_length] when i > -1

  $scope.toolbar_toggle = () ->
    $scope.toolbar = !$scope.toolbar

  $scope.select = (item) ->
    item.hover = off
    switch item.type
      when 'photo'
        if item.selected
          SelectSvc.del(item)
        else
          SelectSvc.add(item)
          $scope.toolbar = true
      when 'album'
        location.hash = '#/albumPhoto/'+item.id

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
        when 'albumPhoto'
          console.log 'album:'+$routeParams.id
          data = PhotoSvc.photo(1,$routeParams.id)
        else
          data = PhotoSvc.photo(1)
      if data instanceof Array
        $scope.items.push(item) for item in data
        $scope.$apply() unless $scope.$$phase

    setTimeout listener, 1000
  )()