<?php

namespace PdTests;

class HttpRequest
{

	/**
	 * @var string
	 */
	private $url;

	/**
	 * @var array
	 */
	private $post;


	public function __construct($url, array $post)
	{
		$this->url = $url;
		$this->post = $post;
	}


	public function run()
	{
		// create curl resource
		$ch = curl_init();

		// set url
		curl_setopt($ch, CURLOPT_URL, "http://localhost:8000/" . $this->url);

		//return the transfer as a string
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

		// $output contains the output string
		$output = curl_exec($ch);

		$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);

		// close curl resource to free up system resources
		curl_close($ch);

		$response = new HttpResponse($httpCode, $output);

		return $response;
	}

}
