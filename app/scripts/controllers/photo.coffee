app.controller "PhotoCtrl", ($scope, $routeParams, PhotoSvc, SelectSvc) ->
  $scope.items = PhotoSvc.fetch()
  $scope.selected = SelectSvc.fetch()
  $scope.main_width = 1000

  $scope.select = (photo) ->
    photo.hover = off
    if photo.selected
      SelectSvc.del(photo)
    else
      SelectSvc.add(photo)

  $scope.clear = () ->
    SelectSvc.clear()

  (listener_width = ()->
    width = $(window).width() - 200 - 5
    if width isnt $scope.main_width
      $scope.main_width = width
      $scope.$apply() unless $scope.$$phase
    setTimeout listener_width, 1000
  )()