<?php

return call_user_func(function () {

	require __DIR__ . '/../vendor/autoload.php';

	if ( ! class_exists('Tester\Assert')) {
		echo 'Install Nette Tester using `composer install --dev`';
		exit(1);
	}
	Tester\Environment::setup();
	
	return;
});
