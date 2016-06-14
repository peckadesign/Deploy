<?php

namespace Pd\Deploy;

use Symfony;


class EchoOutput extends Symfony\Component\Console\Output\Output
{

	protected function doWrite($message, $newline)
	{
		echo $message;

		if ($newline) {
			echo "\n";
		}

		flush();
	}
}
