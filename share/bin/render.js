// ./bin/phantomjs ../bin/render.js ./templates/long/index.html
var system = require('system'),
    folder = system.args[1],
    web = require('webpage'),
    fs = require('fs');

var images = [
  'http://localhost/photo/02.jpg',
  'http://localhost/photo/03.jpg',
  'http://localhost/photo/04.jpg',
  'http://localhost/photo/05.jpg',
  'http://localhost/photo/06.jpg',
  'http://localhost/photo/07.jpg',
  'http://localhost/photo/08.jpg',
  'http://localhost/photo/09.jpg'
];

var page = web.create();
page.onConsoleMessage = function(msg, lineNum, sourceId) {
    console.log("Tmplate: " + msg);
};
page.open(folder+'/index.html', function(status) {
  console.log('Open Folder: ' + folder +'('+ status +')');

  page.includeJs('http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js', function(){
    page.evaluate(function(images){
      var temp = $('.document').detach();
      while(images.length>0){
        var doc = temp.clone();
        $('.image',doc).css('background-image',function(index){
          image = images.shift();
          console.log(image);
          return image ? "url('"+image+"')" : '';
        })
        doc.appendTo('body');
        $('<div />').css('page-break-inside','avoid').appendTo('body');
      }
    },images);

    var output_file = folder+'/output.html';
    console.log('Write: '+output_file);
    fs.write(output_file, page.content);

    var output = web.create();
    output.paperSize = { format: 'A4', orientation: 'portrait', border: '0' };
    output.open(output_file, function(status){
      console.log('Open: '+output_file+' ('+ status +')');
      
      setTimeout(function(){
        var render_file = folder+'/output.pdf'
        console.log('Render: '+render_file);
        output.render(render_file);

        output.close();
        page.close();
        phantom.exit();
      },50*images.length);
    });
  });
});