var app;

app = angular.module("gruntNgApp", []);

app.filter('layout', function() {
  return function(input, box) {
    var height, index, item, queue, size, width, width_capacity, width_loaded, _i, _len;
    switch (box.type) {
      case 'photo':
        index = 0;
        height = box.height * 300;
        while (index < input.length) {
          queue = [];
          width_capacity = box.wrap_width - 5;
          width_loaded = 0;
          while (width_loaded < width_capacity && index < input.length) {
            item = input[index++];
            queue.push(item);
            item.dis_height = height;
            item.dis_width = height / item.height * item.width;
            width_capacity -= 5;
            width_loaded += item.dis_width;
          }
          for (_i = 0, _len = queue.length; _i < _len; _i++) {
            item = queue[_i];
            item.dis_width = item.dis_width / width_loaded * width_capacity;
          }
        }
        break;
      case 'album':
        width = box.width * 160;
        size = box.wrap_width / Math.ceil(box.wrap_width / width);
        angular.forEach(input, function(value, key) {
          value.dis_width = size - 5;
          return value.dis_height = size - 5;
        });
    }
    return input;
  };
});

app.filter('lastTo', function() {
  return function(input, max) {
    var num;
    num = input.length - max;
    if (num < 0) {
      num = 0;
    }
    return input.slice(num).reverse();
  };
});

app.controller("UserCtrl", function($scope, UserSvc, PhotoSvc) {
  $scope.user = UserSvc.info();
  $scope.$watch(UserSvc.status, function() {
    return $scope.user = UserSvc.info();
  });
  $scope.username = null;
  $scope.password = null;
  $scope.remember = false;
  $scope.toggle_remember = function() {
    return $scope.remember = !$scope.remember;
  };
  return $scope.login = function() {
    if (!($scope.username && $scope.password)) {
      return;
    }
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