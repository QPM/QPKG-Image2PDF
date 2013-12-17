app.controller "TemplateCtrl", ($scope, $rootScope, $timeout, SelectSvc, UserSvc, Configs) ->
  $scope.tid = null
  $scope.progress = null
  $scope.status = 'output'

  $scope.page =
    total: 1
    now: 1

  $scope.box =
    wrap_width: 1000
    wrap_height: 1000

  $scope.wait = 0

  $scope.temps = [
    {
      name: 'base_a'
      icon: './templates/base_a/icon.png'
    },
    {
      name: 'base_b'
      icon: './templates/base_b/icon.png'
    },
    {
      name: 'base_c'
      icon: './templates/base_c/icon.png'
    },
    {
      name: 'temp_a'
      icon: './templates/temp_a/icon.png'
    },
    {
      name: 'temp_b'
      icon: './templates/temp_b/icon.png'
    },
    {
      name: 'temp_c'
      icon: './templates/temp_c/icon.png'
    },
    {
      name: 'temp_d'
      icon: './templates/temp_d/icon.png'
    },
    {
      name: 'temp_e'
      icon: './templates/temp_e/icon.png'
    },
    {
      name: 'temp_f'
      icon: './templates/temp_f/icon.png'
    }
  ]

  $scope.temp = 'temp_a'

  $scope.user = UserSvc.info()

  $scope.$watch UserSvc.status, () -> $scope.user = UserSvc.info()

  $scope.init = () ->
    $('body').attr('class','view-template')

  $scope.break = () -> location.hash = '#/' + (Configs.get_step(1) || 'photo')

  $scope.select = (item) -> $scope.temp = item.name

  $scope.output = () ->
    if $scope.status isnt 'output'
      if $scope.status is 'download'
        window.open './api.php?action=download&tid='+$scope.tid
      else
        alert('Wait for progress...')
    else
      images = []
      $(SelectSvc.fetch()).each () -> 
        images.push
          src: 'http://127.0.0.1'+@output
          x: @x
          y: @y
      $scope.status = 'wait'
      $.ajax({
        type: "POST"
        url: "./api.php?action=output&template="+$scope.temp+"&type="+$rootScope.out_type
        cache: false
        data: {images: images}
        dataType: 'json'
      }).done (res) ->
        $scope.tid = res.tid
        $scope.wait = images.length*2 + 3

  $scope.pageLoad = (e) ->
    images = SelectSvc.fetch().slice(0)
    preview = $(e.target).contents()
    temp = $('.document',preview).detach()
    while images.length>0
      doc = temp.clone()
      $('.image',doc).each ()->
        image = images.shift()
        if image?
          $(this).css 'background-image', "url('"+image.src+"')"
          $(this).data 'image', image
        else
          $(this).css 'background-image', null
      $('body',preview).append doc, $('<div />').css({
        'page-break-inside': 'avoid'
        'background': '#C1C1C1'
        'height': '50px'
        'border': '1px solid #C1C1C1'
      })
    $('body',preview).on 'mousewheel', '.image', (e, delta, deltaX, deltaY)->
      # 滾動縮放大小
      # e.preventDefault()
      # img = $(e.target).data 'image'
      # scale = parseInt($(e.target).css('background-size'))
      # unless scale > 0
      #   scale_width = $(e.target).width() / img.width
      #   scale_height = $(e.target).height() / (img.height * scale_width)
      #   if scale_height > 1
      #     scale = scale_height * 100
      #   else
      #     scale = scale_width * 100
      #   img.min_scale = scale
      # scale += delta
      # console.log img.min_scale
      # scale = img.min_scale if scale < img.min_scale
      # $(e.target).css('background-size', scale+'%')
    $('body',preview).on 'mousedown', '.image', (e)->
      oDom = e.target
      oImg = $(e.target).data 'image'
      return unless oImg
      oDom_Width = $(oDom).width()
      oDom_Height = $(oDom).height()
      mouse =
        X: e.offsetX
        Y: e.offsetY
      $(oDom).on 'mousemove', (e) ->
        # offset =
        #   X: e.offsetX - mouse.X
        #   Y: e.offsetY - mouse.Y
        # background = /([0-9]+)% ([0-9]+)%/.exec($(oDom).css('background-position'))
        # if background
        #   pos =
        #     X: background[1]
        #     Y: background[2]
        # else
        #   pos =
        #     X: 50
        #     Y: 50

        # console.log position
        $(oDom).css('background-position', (100 - (e.offsetX / oDom_Width) * 100) + '% ' + (100 - (e.offsetY / oDom_Height) * 100) + '%')
        # mouse.X = e.offsetX
        # mouse.Y = e.offsetY
      $('body',preview).on 'mouseenter', '.image', (e)->
        tImg = $(e.target).data('image')
        return unless tImg
        $(e.target).css 'background-image', "url('"+oImg.src+"')"
        $(oDom).css 'background-image', "url('"+tImg.src+"')"
      $('body',preview).on 'mouseleave', '.image', (e)->
        tImg = $(e.target).data('image')
        return unless tImg
        $(e.target).css 'background-image', "url('"+tImg.src+"')"
        $(oDom).css 'background-image', "url('"+oImg.src+"')"
      $('body',preview).on 'mouseleave mouseup', (e)->
        $('body',preview).off('mouseenter mouseleave mouseup')
        $(oDom).off('mousemove')
        
        tImg = $(e.target).data('image')
        return unless tImg

        if e.type is 'mouseup'
          $(e.target).data 'image', oImg
          $(oDom).data 'image', tImg
          SelectSvc.exchange oImg, tImg

          if $(e.target).is(oDom)
            oImg.x = (100 - (e.offsetX / oDom_Width) * 100)
            oImg.y = (100 - (e.offsetY / oDom_Height) * 100)
          else
            $(oDom).css('backgroundPosition', '50% 50%')
            $(e.target).css('backgroundPosition', '50% 50%')

      return false


  (listener = ()->
    reDisplay = off

    height = $(window).height()
    if height isnt $scope.box.wrap_height
      $scope.box.wrap_height = height
      $('.iframe').css('transform', 'scale('+((height-41-43)/1123)+')')
      reDisplay = on

    if $scope.status is 'wait'
      if $scope.wait > 0
        $scope.wait--
        reDisplay = on
      else
        $scope.status = 'progress'
        (listen = () ->
          $scope.wait = null
          $.ajax({
            type: "GET"
            url: "./api.php?action=progress&tid="+$scope.tid
            cache: false
            dataType: 'json'
          }).always (res,status) ->
            if status is 'success' and parseInt(res.progress,10) >= 100
              # $scope.progress = parseInt(res.progress,10)
              $scope.status = 'download'
              $scope.$apply() if reDisplay and !$scope.$$phase
            else
              setTimeout listen, 1000
        )()

    $scope.$apply() if reDisplay and !$scope.$$phase

    $scope.listen = $timeout(listener, 1000)

  )()

  $scope.$on '$locationChangeStart', () ->
    $timeout.cancel($scope.listen) if $scope.listen