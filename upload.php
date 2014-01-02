<?php

if (isset($_SERVER['HTTP_X_FILE_NAME']))
{
	$filename = $_SERVER['HTTP_X_FILE_NAME'];
	$input = fopen('php://input', 'rb');
	$file = fopen($filename, 'wb');
	stream_copy_to_stream($input, $file);
	fclose($input);
	fclose($file);

	die("done");
}

echo 'missing filename';