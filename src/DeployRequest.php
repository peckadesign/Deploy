<?php

namespace Pd\Deploy;

use Nette;
use Symfony;


class DeployRequest
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

		if ( ! isset($payload['action']) || $payload['action'] !== 'published') {
			throw new OmitException('Nedošlo k vydání nového releasu');
		}

		$cb = function ($type, $buffer) {
			echo $buffer;
			flush();
		};

		$process = new Symfony\Component\Process\Process($this->binPath . '/deploy.sh');
		$process->mustRun($cb);
	}
}
