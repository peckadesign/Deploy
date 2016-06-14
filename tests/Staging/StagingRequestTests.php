<?php

namespace PdTests\Deploy\Staging;

require __DIR__ . '/../bootstrap.php';

use Nette;
use Pd;
use PdTests;
use Tester;


class StagingRequestTests extends Tester\TestCase
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


	public function testNotMasterUpdate()
	{
		$payload = [
			'payload' => Nette\Utils\Json::encode(['ref' => 'master']),
		];
		$this->exceptionTest($payload, Pd\Deploy\OmitException::class);

		$payload = [
			'payload' => Nette\Utils\Json::encode(['ref' => 'refs/heads/foo']),
		];
		$this->exceptionTest($payload, Pd\Deploy\OmitException::class);
	}


	public function testMasterUpdate()
	{
		$payload = [
			'payload' => Nette\Utils\Json::encode(['ref' => 'refs/heads/master']),
		];
		$stagingRequest = new Pd\Deploy\StagingRequest(__DIR__);

		ob_start();
		$stagingRequest->process($payload);
		$output = ob_get_clean();


		Tester\Assert::equal("Foo\n", $output);
	}


	private function exceptionTest(array $payload, $exceptionClass)
	{
		$stagingRequest = new Pd\Deploy\StagingRequest(__DIR__);
		$cb = function () use ($payload, $stagingRequest) {
			$stagingRequest->process($payload);
		};

		Tester\Assert::exception($cb, $exceptionClass);
	}
}


(new StagingRequestTests())->run();
