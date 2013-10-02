app.service('PhotoSvc', [
  '$http', function($http) {
    var data;
    data = [];
    $http.get('http://localhost/photo/list.php').success(function(res) {
      var item, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = res.length; _i < _len; _i++) {
        item = res[_i];
        length;
        _results.push(data[data.length] = {
          width: item.width * 300 / item.height,
          src: 'http://localhost/photo/' + item.path,
          index: data.length,
          selected: false
        });
      }
      return _results;
    });
    return this.fetch = function() {
      return data;
    };
  }
]);

/*
//@ sourceMappingURL=photo_svc.js.map
*/