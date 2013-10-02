app.service('SelectSvc', [
  function() {
    var data;
    data = [];
    this.add = function(photo) {
      photo.selected = true;
      return data.push(photo);
    };
    this.del = function(photo) {
      var index;
      index = data.indexOf(photo);
      if (index > -1) {
        return data.splice(index, 1)[0].selected = false;
      }
    };
    this.clear = function() {
      return angular.forEach(data.splice(0), function(value, key) {
        return value.selected = false;
      });
    };
    this.fetch = function() {
      return data;
    };
    return this.length = function() {
      return data.length;
    };
  }
]);

/*
//@ sourceMappingURL=select_svc.js.map
*/