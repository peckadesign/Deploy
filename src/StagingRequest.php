<?php

namespace Pd\Deploy;

use Nette;
use Symfony;


class StagingRequest
{

	/**
	 * @var string
	 */
	private $binPath;


	public function __construct($binPath)
	{
		$this->binPath = $binPath;
	}


	public function process(array $post)
	{
		if ( ! isset($post['payload'])) {
			throw new \Exception('Nebyla předána data z hooku');
		}

		$payload = Nette\Utils\Json::decode($post['payload'], Nette\Utils\Json::FORCE_ARRAY);

		if ( ! isset($payload['ref']) || $payload['ref'] !== 'refs/heads/master') {
			throw new OmitException('Nedošlo k aktualizaci větve master');
		}

		$cb = function ($type, $buffer) {
			echo $buffer;
			flush();
		};

		$process = new Symfony\Component\Process\Process($this->binPath . '/staging.sh');
		$process->mustRun($cb);
	}
}
