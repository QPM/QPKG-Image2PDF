// ./bin/phantomjs ../bin/render.js ./templates/long/index.html
var system = require('system'),
    folder = system.args[1],
    web = require('webpage'),
    fs = require('fs');


// page.content = template_data;
// page.onConsoleMessage = function(msg, lineNum, sourceId) {
//     console.log("CONSOLE: " + msg + ' (from line #' + lineNum + ' in "' + sourceId + '")');
// };

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
var queue = 0;
page.open(folder+'/index.html', function(status) {
  console.log('Open Folder: ' + folder +'('+ status +')');

  index = 0;
  while(images.length>0){
    index++;
    images = page.evaluate(function(images){
      $('.image').css('background-image',function(index){
        image = images.shift();
        return image ? "url('"+image+"')" : '';
      });
      return images;
    },images);

    console.log('Write: output'+index+'.html');
    fs.write(folder+'/output'+index+'.html', page.content);
    queue++;

    (function(index){
      var output = web.create();
      output.viewportSize = {width:595, height : 842};
      output.clipRect = {
        top: 0,
        left: 0,
        width: output.viewportSize.width,
        height: output.viewportSize.height
      };
      output.open(folder+'/output'+index+'.html', function(status){
        console.log('Open: /output'+index+'.html ('+ status +')');
        
        setTimeout(function(){
          console.log('Render: tmp/test'+index+'.png');
          output.render('tmp/test'+index+'.png');

          output.close();

          queue--;
          if(queue<=0) phantom.exit();
        },500);
      });
    })(index);
  }
  // page.onResourceReceived = function(response){
  //   if(response.stage=='end'){
  //     loaded--;
  
  //     setTimeout(function(){
  //       if(loaded<=0){
  //         page.clipRect = {
  //           top: 0,
  //           left: 0,
  //           width: page.viewportSize.width,
  //           height: page.viewportSize.height
  //         };

  //         page.render('tmp/test1.png');
  //         phantom.exit();
  //       }
  //     },1000);
  //   }
  // }
});

// setTimeout((function(){ //handle content updated
//     var images = [
//       'http://localhost/photo/02.jpg',
//       'http://localhost/photo/03.jpg',
//       'http://localhost/photo/04.jpg',
//       'http://localhost/photo/05.jpg',
//       'http://localhost/photo/06.jpg'
//     ];
//     var result = page.evaluate(function(images){
//         window.loadImages(images);
//     },images);
// }()),2000);

// setTimeout(function(){
//     var height = page.evaluate(function(){
//         return document.body.clientHeight;
//     });
//     for(var i = 0 ,currentHeight = 0 ; currentHeight < height ; currentHeight+= page.viewportSize.height,++i ){
//         page.clipRect = {
//             top:   currentHeight ,
//             left:   0,
//             width:  page.viewportSize.width,
//             height: page.viewportSize.height
//         };
//         page.render('tmp/test'+i+'.png');
//     }
//     phantom.exit();
// },4000);