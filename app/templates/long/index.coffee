$ ->
  data = window.top.selected
  dom = []
  height = 842 - 10
  $.each data, ->
    dom.push $('<div class="item" />').height(height/data.length-10).css('background-image','url(\''+@src+'\')')
  console.log dom
  $('.main').append(dom)