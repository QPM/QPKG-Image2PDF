// ./bin/phantomjs ../bin/render.js ./templates/long/index.html
var system = require('system'),
    template = system.args[1],
    target = system.args[2],
    web = require('webpage'),
    system = require('system'),
    fs = require('fs');

// 讀取要套template的image list (JSON)
var images = JSON.parse(fs.read(target));
// 取得檔案的名稱(去除副檔名.json)
target = /(.+)\./i.exec(target)[1];

// 複製template的資料夾 to JSON檔的資料夾
fs.copyTree(template, target + system.pid);
template = target + system.pid;

// 初始化 page object, 並建立console.log的截取function
var page = web.create();
page.onConsoleMessage = function(msg, lineNum, sourceId) {
    console.log("Tmplate: " + msg);
};

// 在page object裡，載入 template 裡面的 index.html
page.open(template+'/index.html', function(status) {
  console.log('Open target: ' + template +'('+ status +')');
  //  載入 jquery library
  page.includeJs('http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min.js', function(){
    // page.evaluate 在 page object，執行javascript
    page.evaluate(function(images){
      // 把template的sample DOM截取出來
      var temp = $('.document').detach();
      // 跑images list迴圈
      while(images.length>0){
        // clone 一個page(document)
        var doc = temp.clone();
        // 把image append document
        $('.image',doc).each(function(index){
          // shift 取出1個image Object
          image = images.shift();
          console.log(image);
          if(image){
            // 套入 image url 和 position 和 size
            $(this).css('background-image', "url('"+image.src+"')");
            $(this).css('background-position', image.x+'% '+image.y+'%');
          }
        });
        doc.appendTo('body');
        // append分頁符號
        $('<div />').css('page-break-inside','avoid').appendTo('body');
      }
    },images);

    // 把template的index.html存入output.html
    var output_file = template+'/output.html';
    console.log('Write: '+output_file);
    fs.write(output_file, page.content);

    // 初始化 output的page
    var output = web.create();
    // 設定 size A4
    output.paperSize = { format: 'A4', orientation: 'portrait', border: '0' };
    output.open(output_file, function(status){
      console.log('Open: '+output_file+' ('+ status +')');
      // 倒數計時 拍照(Render)
      setTimeout(function(){
        console.log('Render: '+target+'.temp.pdf');
        // render成PDF
        output.render(target+'.temp.pdf');

        // 記憶體釋放
        output.close();
        page.close();
        phantom.exit();
        // 刪除template
        fs.removeTree(template);
        // 把pdf檔名從.temp.pdf改成.pdf
        fs.move(target+'.temp.pdf',target+'.pdf');
      },2000*images.length+500);
    });
  });
});