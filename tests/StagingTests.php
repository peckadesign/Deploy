<?php

namespace PdTests\Staging;

require __DIR__ . '/../bootstrap.php';

use Pd;
use PdTests;
use Tester;


class StagingTests extends Tester\TestCase
{

	public function testEmptyRequest()
	{
		$httRequest = new PdTests\HttpRequest('/staging.php', []);
		$httpResponse = $httRequest->run();
		Tester\Assert::equal(500, $httpResponse->getCode());
	}


//	public function testWrongPayload()
//	{
//		$payload = [
//			'foo' => 'bar',
//		];
//		$httRequest = new PdTests\HttpRequest('/staging.php', $payload);
//		$httpResponse = $httRequest->run();
//		Tester\Assert::equal(500, $httpResponse->getCode());
//
//		$payload = [
//			'payload' => 'bar',
//		];
//		$httRequest = new PdTests\HttpRequest('/staging.php', $payload);
//		$httpResponse = $httRequest->run();
//		Tester\Assert::equal(500, $httpResponse->getCode());
//
//		$payload = [
//			'payload' => [
//				'foo' => 'bar',
//			],
//		];
//		$httRequest = new PdTests\HttpRequest('/staging.php', $payload);
//		$httpResponse = $httRequest->run();
//		Tester\Assert::equal(500, $httpResponse->getCode());
//
//		$payload = [
//			'payload' => [
//			],
//		];
//		$httRequest = new PdTests\HttpRequest('/staging.php', $payload);
//		$httpResponse = $httRequest->run();
//		Tester\Assert::equal(500, $httpResponse->getCode());
//	}
//
//
//	public function testNotMasterUpdate()
//	{
//		$payload = [
//			'payload' => [
//				'ref' => 'master',
//			],
//		];
//		$httRequest = new PdTests\HttpRequest('/staging.php', $payload);
//		$httpResponse = $httRequest->run();
//		Tester\Assert::equal(500, $httpResponse->getCode());
//
//		$payload = [
//			'payload' => [
//				'ref' => 'refs/heads/foo',
//			],
//		];
//		$httRequest = new PdTests\HttpRequest('/staging.php', $payload);
//		$httpResponse = $httRequest->run();
//		Tester\Assert::equal(500, $httpResponse->getCode());
//	}
//
//
//	public function testMasterUpdate()
//	{
//		$payload = [
//			'payload' => [
//				'ref' => 'refs/heads/master',
//			],
//		];
//		$httRequest = new PdTests\HttpRequest('/staging.php', $payload);
//		$httpResponse = $httRequest->run();
//		Tester\Assert::equal(500, $httpResponse->getCode());
//	}
}


(new StagingTests())->run();
