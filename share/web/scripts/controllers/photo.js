app.controller("PhotoCtrl", function($scope, $routeParams, PhotoSvc, SelectSvc, Tab) {
  var listener_width;
  $scope.items = [];
  $scope.selected = SelectSvc.fetch();
  $scope.main_width = 1000;
  $scope.init = function() {
    switch (Tab) {
      case 'album':
        return $scope.items = [];
      case 'selected':
        return $scope.items = SelectSvc.fetch();
      default:
        return $scope.items = PhotoSvc.fetch();
    }
  };
  $scope.select = function(photo) {
    photo.hover = false;
    if (photo.selected) {
      return SelectSvc.del(photo);
    } else {
      return SelectSvc.add(photo);
    }
  };
  $scope.clear = function() {
    return SelectSvc.clear();
  };
  return (listener_width = function() {
    var width;
    width = $(window).width() - 200 - 5;
    if (width !== $scope.main_width) {
      $scope.main_width = width;
      if (!$scope.$$phase) {
        $scope.$apply();
      }
    }
    return setTimeout(listener_width, 1000);
  })();
});

/*
//@ sourceMappingURL=photo.js.map
*/