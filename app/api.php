<?php
  //$params = json_decode(file_get_contents('php://input'));
  function get_query($name){
    return isset($_GET[$name]) ? preg_replace('/\W*/i','',$_GET[$name]) : null;
  }
  switch($_GET['action']){
    case 'list':
      break;
    case 'output':
      $template = get_query('template');
      if(!$template) $template = 'temp_a';
      $tid = time();
      $target = dirname(__DIR__) . '/output/' . $tid . '.json';
      $source = __DIR__ . '/templates/' . $template;
      file_put_contents($target, json_encode($_POST['images']));
      $bin = dirname(__DIR__) . '/bin';
      passthru($bin.'/phantomjs '.$bin.'/render.js '.$source.' '.$target.' > /dev/null &');
      echo json_encode(array(
        'tid' => $tid
      ));
      break;
    case 'download':
      $tid = get_query('tid');
      $target = dirname(__DIR__) . '/output/' . $tid;
      if(file_exists($target.'.pdf')){
        header('Content-disposition: attachment; filename='.$tid.'.pdf');
        header('Content-type: application/pdf');
        readfile($target.'.pdf');
      }else if(file_exists($target.'.json')){
        header('HTTP/1.0 202 Accepted', true, 202);
        echo json_encode(array(
          'code' => 202,
          'message' => 'Image2pdf progressing...'
        ));
      }else header('HTTP/1.0 404 Not Found', true, 404);
      break;
    case 'show':
      break;
    case 'progress':
      $tid = get_query('tid');
      $target = dirname(__DIR__) . '/output/' . $tid;
      if(file_exists($target.'.pdf')){
        echo json_encode(array(
          'code' => 200,
          'progress' => 100,
          'message' => 'Completed'
        ));
      }else if(file_exists($target.'.json')){
        echo json_encode(array(
          'code' => 200,
          'progress' => 50,
          'message' => 'Progress...'
        ));
      }else header('HTTP/1.0 404 Not Found', true, 404);
      break;
    default:
      echo json_encode(array(
        'code' => 404
      ));
  }