app.controller("TemplateCtrl", function($scope, SelectSvc, UserSvc, Configs) {
  $scope.tid = null;
  $scope.progress = null;
  $scope.status = 'output';
  $scope.temps = [
    {
      name: 'temp_a',
      icon: './templates/temp_a/icon.png'
    }, {
      name: 'temp_b',
      icon: './templates/temp_b/icon.png'
    }
  ];
  $scope.temp = 'temp_a';
  $scope.user = UserSvc.info();
  $scope.$watch(UserSvc.status, function() {
    return $scope.user = UserSvc.info();
  });
  $scope["break"] = function() {
    return location.hash = '#/' + (Configs.get_step(1) || 'photo');
  };
  $scope.select = function(item) {
    return $scope.temp = item.name;
  };
  $scope.output = function() {
    var images;
    if ($scope.status !== 'output') {
      if ($scope.status === 'download') {
        return window.open('./api.php?action=download&tid=' + $scope.tid);
      } else {
        return alert('PDF製作中');
      }
    } else {
      images = [];
      $(SelectSvc.fetch()).each(function() {
        return images.push('http://127.0.0.1' + this.output);
      });
      console.log(images);
      $scope.status = 'progress';
      return $.ajax({
        type: "POST",
        url: "./api.php?action=output&template=" + $scope.temp,
        cache: false,
        data: {
          images: images
        },
        dataType: 'json'
      }).done(function(res) {
        var listen;
        $scope.tid = res.tid;
        console.log(res.tid);
        return (listen = function() {
          return $.ajax({
            type: "GET",
            url: "./api.php?action=progress&tid=" + $scope.tid,
            cache: false,
            dataType: 'json'
          }).always(function(res, status) {
            if (status === 'success') {
              $scope.progress = parseInt(res.progress, 10);
              if ($scope.progress >= 100) {
                $scope.status = 'download';
              } else {
                setTimeout(listen, 1000);
              }
              return $scope.$apply();
            } else {
              return setTimeout(listen, 1000);
            }
          });
        })();
      });
    }
  };
  return $scope.pageLoad = function(e) {
    var doc, images, preview, temp, _results;
    console.log('pageLoad');
    images = SelectSvc.fetch().slice(0);
    console.log(images);
    preview = $(e.target).contents();
    temp = $('.document', preview).detach();
    _results = [];
    while (images.length > 0) {
      doc = temp.clone();
      $('.image', doc).css('background-image', function(index) {
        var image;
        image = images.shift();
        if (image != null) {
          return "url('" + image.src + "')";
        } else {
          return null;
        }
      });
      _results.push($('body', preview).append(doc, $('<div />').css('page-break-inside', 'avoid')));
    }
    return _results;
  };
});

/*
//@ sourceMappingURL=template.js.map
*/