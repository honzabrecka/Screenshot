<?php

$outputDir = implode(DIRECTORY_SEPARATOR, ['tests', 'fixtures']);

if (isset($_SERVER['HTTP_X_FILE_NAME']))
{
  $filename = $_SERVER['HTTP_X_FILE_NAME'];
  $input = fopen('php://input', 'rb');
  mkdir($outputDir);
  $file = fopen(implode(DIRECTORY_SEPARATOR, [$outputDir, $filename]), 'wb');
  stream_copy_to_stream($input, $file);
  fclose($input);
  fclose($file);

  die("done");
}

echo 'missing filename';