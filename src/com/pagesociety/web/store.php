<?php

$key 		= $_GET['key'];
$value 		= $_GET['value'];
$action 	= $_GET['action'];
$f 			= "data/".$_GET['fbuid'].".txt";

if (file_exists($f))
{
	$so = file_get_contents($f);
	$store = unserialize($so);
}
else
{
	$store = array();
}

if ($action == "get")
{
	$response = $store[$key];
}

if ($action == "put")
{
	$store[$key] = $value;
	$str = serialize($store); 
	$fh = fopen($f, 'w');
	fwrite($fh, $str);
	fclose($fh);
}

if ($_GET['jsonp_callback']!=null)
{

	echo $_GET['jsonp_callback'] . '(' . json_encode($response) . ');';
}
else
{
	echo $response;
}
?>