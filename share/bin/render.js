// ./bin/phantomjs ../bin/render.js ./templates/long/index.html
var system = require('system'),
    template = system.args[1],
    target = system.args[2],
    web = require('webpage'),
    system = require('system'),
    fs = require('fs');

var images = JSON.parse(fs.read(target));
target = /(.+)\./i.exec(target)[1];

fs.copyTree(template, target + system.pid);
template = target + system.pid;

var page = web.create();
page.onConsoleMessage = function(msg, lineNum, sourceId) {
    console.log("Tmplate: " + msg);
};

page.open(template+'/index.html', function(status) {
  console.log('Open target: ' + template +'('+ status +')');

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

    var output_file = template+'/output.html';
    console.log('Write: '+output_file);
    fs.write(output_file, page.content);

    var output = web.create();
    output.paperSize = { format: 'A4', orientation: 'portrait', border: '0' };
    output.open(output_file, function(status){
      console.log('Open: '+output_file+' ('+ status +')');
      
      setTimeout(function(){
        var render_file = target+'.pdf'
        console.log('Render: '+render_file);
        output.render(render_file);

        output.close();
        page.close();
        phantom.exit();
        fs.removeTree(template);
      },1000*images.length+500);
    });
  });
});