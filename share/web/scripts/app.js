var app;

app = angular.module("gruntNgApp", []);

app.filter('layout', function() {
  return function(input, width) {
    var item, queue, width_capacity, width_loaded, _i, _len;
    width_capacity = width;
    width_loaded = 0;
    queue = [];
    angular.forEach(input, function(value, key) {
      var item, _i, _len;
      queue.push(value);
      width_capacity -= 5;
      width_loaded += value.width;
      if (width_loaded >= width_capacity) {
        for (_i = 0, _len = queue.length; _i < _len; _i++) {
          item = queue[_i];
          item.view = item.width / width_loaded * width_capacity;
        }
        queue = [];
        width_capacity = width;
        return width_loaded = 0;
      }
    });
    for (_i = 0, _len = queue.length; _i < _len; _i++) {
      item = queue[_i];
      item.view = item.width / width_loaded * width_capacity;
    }
    return input;
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