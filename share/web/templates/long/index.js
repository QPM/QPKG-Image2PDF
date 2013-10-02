var loadImages;

loadImages = function(data) {
  var dom, height;
  dom = [];
  height = 842 - 10;
  $.each(data, function() {
    return dom.push($('<div class="item" />').height(height / data.length - 10).css('background-image', 'url(\'' + this.src + '\')'));
  });
  return $('.main').append(dom);
};

/*
//@ sourceMappingURL=index.js.map
*/