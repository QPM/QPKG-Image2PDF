app.controller("PhotoCtrl", function($scope, $routeParams, PhotoSvc, SelectSvc, UserSvc, Tab, Configs) {
  var listener;
  $scope.items = [];
  $scope.tab = Tab;
  $scope.selected = SelectSvc.fetch();
  $scope.box = {
    wrap_width: 1000,
    wrap_height: 1000,
    width: 1,
    height: 1
  };
  $scope.toolbar = false;
  $scope.user = UserSvc.info();
  $scope.$watch(UserSvc.status, function() {
    return $scope.user = UserSvc.info();
  });
  $scope.init = function() {
    Configs.set_step(1, Tab);
    if ($scope.selected.length > 0) {
      $scope.toolbar = true;
    }
    switch (Tab) {
      case 'album':
        return $scope.box.type = 'album';
      default:
        return $scope.box.type = 'photo';
    }
  };
  $scope.toolbar_toggle = function() {
    return $scope.toolbar = !$scope.toolbar;
  };
  $scope.select = function(item) {
    item.hover = false;
    switch (item.type) {
      case 'photo':
        if (item.selected) {
          SelectSvc.del(item);
          angular.forEach(item.album, function(value, key) {
            return value.selected--;
          });
          return item.album;
        } else {
          SelectSvc.add(item);
          angular.forEach(item.album, function(value, key) {
            return value.selected++;
          });
          return $scope.toolbar = true;
        }
        break;
      case 'album':
        return location.hash = '#/albumPhoto/' + item.id;
    }
  };
  $scope.clear = function() {
    return SelectSvc.clear();
  };
  return (listener = function() {
    var data, height, item, reDisplay, width, _i, _len;
    reDisplay = false;
    width = $('#main').width();
    if (width !== $scope.box.wrap_width) {
      $scope.box.wrap_width = width;
      reDisplay = true;
    }
    height = $('#main').height();
    if (height !== $scope.box.wrap_height) {
      $scope.box.wrap_height = height;
      reDisplay = true;
    }
    if ($scope.items.length < 1 && UserSvc.status() === 'login') {
      switch (Tab) {
        case 'album':
          data = PhotoSvc.album(1);
          break;
        case 'selected':
          data = SelectSvc.fetch();
          break;
        case 'albumPhoto':
          data = PhotoSvc.photo(1, $routeParams.id);
          break;
        default:
          data = PhotoSvc.photo(1);
      }
      if (data instanceof Array) {
        for (_i = 0, _len = data.length; _i < _len; _i++) {
          item = data[_i];
          $scope.items.push(item);
        }
        reDisplay = true;
      }
    }
    if (!(reDisplay ? $scope.$$phase : void 0)) {
      $scope.$apply();
    }
    return setTimeout(listener, 1000);
  })();
});

/*
//@ sourceMappingURL=photo.js.map
*/