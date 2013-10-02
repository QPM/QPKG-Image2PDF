#!/bin/sh

folder=../output/xyz
cp -r ../web/templates/long $folder
phantomjs render.js $folder

#phantomjs render.js
#convert -page a4 tmp/test0.png tmp/test1.png tmp/test2.png tmp/test3.png tmp/test4.png tmp/test5.png  test.pdf
#convert -page a4 tmp/*.png test.pdf