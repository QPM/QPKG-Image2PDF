var app;

app = angular.module("gruntNgApp", []);

app.filter('layout', function() {
  return function(input, box) {
    var item, queue, width_capacity, width_loaded, _i, _len;
    width_capacity = box.width - 5;
    width_loaded = 0;
    queue = [];
    angular.forEach(input, function(value, key) {
      var item, _i, _len;
      queue.push(value);
      width_capacity -= 5;
      value.dis_height = box.height;
      if (value.type === 'album') {
        value.dis_width = box.height;
      } else {
        value.dis_width = box.height / value.height * value.width;
      }
      width_loaded += value.dis_width;
      if (width_loaded >= width_capacity) {
        for (_i = 0, _len = queue.length; _i < _len; _i++) {
          item = queue[_i];
          item.dis_width = item.dis_width / width_loaded * width_capacity;
        }
        queue = [];
        width_capacity = box.width - 5;
        return width_loaded = 0;
      }
    });
    for (_i = 0, _len = queue.length; _i < _len; _i++) {
      item = queue[_i];
      item.dis_width = item.dis_width / width_loaded * width_capacity;
    }
    return input;
  };
});

app.controller("UserCtrl", function($scope, UserSvc, PhotoSvc) {
  $scope.user = UserSvc.info();
  $scope.$watch(UserSvc.status, function() {
    $scope.user = UserSvc.info();
    if (UserSvc.status() === 'login') {
      return PhotoSvc.reset_sid($scope.user.sid);
    }
  });
  $scope.$watch(UserSvc.status, function() {
    return $scope.user = UserSvc.info();
  });
  $scope.username = null;
  $scope.password = null;
  return $scope.login = function() {
    return UserSvc.login($scope.username, $scope.password);
  };
});

app.directive('ngload', function($parse) {
  return function(scope, element, attrs) {
    var fn;
    fn = $parse(attrs.ngload);
    return element.load(function(event) {
      return scope.$apply(function() {
        return fn(scope, {
          $event: event
        });
      });
    });
  };
});

app.config(function($routeProvider, $httpProvider) {
  $routeProvider.when("/photo", {
    templateUrl: "views/photo.html",
    controller: "PhotoCtrl",
    resolve: {
      Tab: function() {
        return 'photo';
      }
    }
  }).when("/album", {
    templateUrl: "views/photo.html",
    controller: "PhotoCtrl",
    resolve: {
      Tab: function() {
        return 'album';
      }
    }
  }).when("/selected", {
    templateUrl: "views/photo.html",
    controller: "PhotoCtrl",
    resolve: {
      Tab: function() {
        return 'selected';
      }
    }
  }).when("/albumPhoto/:id", {
    templateUrl: "views/photo.html",
    controller: "PhotoCtrl",
    resolve: {
      Tab: function() {
        return 'albumPhoto';
      }
    }
  }).when("/template", {
    templateUrl: "views/template.html",
    controller: "TemplateCtrl"
  }).otherwise({
    redirectTo: "/photo"
  });
  return delete $httpProvider.defaults.headers.common['X-Requested-With'];
});

/*
//@ sourceMappingURL=app.js.map
*/