<?php

namespace PdTests\Deploy\Deploy;

require __DIR__ . '/../bootstrap.php';

use Nette;
use Pd;
use PdTests;
use Tester;


class DeployRequestTests extends Tester\TestCase
{

	public function testEmptyRequest()
	{
		$payload = [];
		$this->exceptionTest($payload, \Exception::class);
	}


	public function testWrongPayload()
	{
		$payload = [
			'foo' => 'bar',
		];
		$this->exceptionTest($payload, \Exception::class);

		$payload = [
			'payload' => 'bar',
		];
		$this->exceptionTest($payload, \Exception::class);

		$payload = [
			'payload' => Nette\Utils\Json::encode(['foo' => 'bar']),
		];
		$this->exceptionTest($payload, \Exception::class);

		$payload = [
			'payload' => Nette\Utils\Json::encode([]),
		];
		$this->exceptionTest($payload, \Exception::class);
	}


	public function testPush()
	{
		$payload = [
			'payload' => Nette\Utils\Json::encode(['ref' => 'master']),
		];
		$this->exceptionTest($payload, \Exception::class);

		$payload = [
			'payload' => Nette\Utils\Json::encode(['ref' => 'refs/heads/foo']),
		];
		$this->exceptionTest($payload, \Exception::class);

		$payload = [
			'payload' => Nette\Utils\Json::encode(['ref' => 'refs/heads/master']),
		];
		$this->exceptionTest($payload, \Exception::class);
	}


	public function testReleasePublished()
	{
		$payload = [
			'payload' => Nette\Utils\Json::encode(['action' => 'published']),
		];
		$deployRequest = new Pd\Deploy\DeployRequest(__DIR__);

		ob_start();
		$deployRequest->process($payload);
		$output = ob_get_clean();


		Tester\Assert::equal("Foo\n", $output);
	}


	private function exceptionTest(array $payload, $exceptionClass)
	{
		$deployRequest = new Pd\Deploy\DeployRequest(__DIR__);
		$cb = function () use ($payload, $deployRequest) {
			$deployRequest->process($payload);
		};

		Tester\Assert::exception($cb, $exceptionClass);
	}
}


(new DeployRequestTests())->run();
