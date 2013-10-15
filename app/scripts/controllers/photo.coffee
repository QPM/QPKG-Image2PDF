app.controller "PhotoCtrl", ($scope, $routeParams, PhotoSvc, SelectSvc, UserSvc, Tab, Configs) ->
  $scope.items = []
  $scope.tab = Tab
  # $scope.preview = []
  $scope.selected = SelectSvc.fetch()
  $scope.box =
    wrap_width: 1000
    wrap_height: 1000
    width: 1
    height: 1

  $scope.toolbar = false
  
  $scope.user = UserSvc.info()

  $scope.$watch UserSvc.status, () ->
    $scope.user = UserSvc.info()

  $scope.init = () ->
    Configs.set_step(1, Tab)
    $scope.toolbar = true if $scope.selected.length > 0
    switch Tab
      when 'album'
        $scope.box.type = 'album'
      else
        $scope.box.type = 'photo'

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
          angular.forEach item.album, (value, key) -> value.selected--
          item.album 
        else
          SelectSvc.add(item)
          angular.forEach item.album, (value, key) -> value.selected++
          $scope.toolbar = true
      when 'album'
        location.hash = '#/albumPhoto/'+item.id

  $scope.clear = () ->
    SelectSvc.clear()

  (listener = ()->
    reDisplay = off

    width = $('#main').width()
    if width isnt $scope.box.wrap_width
      $scope.box.wrap_width = width
      reDisplay = on

    height = $('#main').height()
    if height isnt $scope.box.wrap_height
      $scope.box.wrap_height = height
      reDisplay = on

    if $scope.items.length < 1 and UserSvc.status() is 'login'
      switch Tab
        when 'album'
          data = PhotoSvc.album(1)
        when 'selected'
          data = SelectSvc.fetch()
        when 'albumPhoto'
          data = PhotoSvc.photo(1,$routeParams.id)
        else
          data = PhotoSvc.photo(1)
      if data instanceof Array
        $scope.items.push(item) for item in data
        reDisplay = on

    $scope.$apply() unless $scope.$$phase if reDisplay

    setTimeout listener, 1000
  )()