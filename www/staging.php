<?php

require __DIR__ . '/../vendor/autoload.php';

header('Content-Type: text/plain; charset=UTF-8');
set_time_limit(120);

try {

	$stagingRequest = new Pd\Deploy\StagingRequest(__DIR__ . '/..');
	$stagingRequest->process($_POST);

} catch (Pd\Deploy\OmitException $e) {
	echo $e->getMessage();

} catch (\Exception $e) {
	http_response_code(500);
	echo $e->getMessage();
}
