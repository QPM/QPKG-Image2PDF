app.controller "TemplateCtrl", ($scope, SelectSvc) ->
  $scope.tid = null
  $scope.progress = null
  $scope.status = 'output'

  $scope.output = () ->
    if $scope.status isnt 'output'
      if $scope.status is 'download'
        window.open './api.php?action=download&tid='+$scope.tid
      else
        alert('PDF製作中')
    else
      images = []
      $(SelectSvc.fetch()).each () -> images.push('http://127.0.0.1/'+@src)
      console.log images
      $scope.status = 'progress'
      $.ajax({
        type: "POST"
        url: "./api.php?action=output"
        cache: false
        data: {images: images}
        dataType: 'json'
      }).done (res) ->
        $scope.tid = res.tid
        console.log res.tid
        (listen = () ->
          $.ajax({
            type: "GET"
            url: "./api.php?action=progress&tid="+$scope.tid
            cache: false
            dataType: 'json'
          }).always (res,status) ->
            if status is 'success'
              $scope.progress = parseInt(res.progress,10)
              if $scope.progress >= 100
                $scope.status = 'download'
              else
                setTimeout listen, 1000
            
              $scope.$apply()
            else
              setTimeout listen, 1000
        )()

  $scope.pageLoad = (e) ->
    console.log 'pageLoad'
    images = SelectSvc.fetch().slice(0)
    console.log images
    preview = $(e.target).contents()
    temp = $('.document',preview).detach()
    while images.length>0
      doc = temp.clone()
      $('.image',doc).css 'background-image', (index) ->
        image = images.shift()
        if image?
          return "url('"+image.src+"')"
        else
          return null
      $('body',preview).append doc, $('<div />').css('page-break-inside','avoid')