<?php

namespace PdTests;

class HttpResponse
{

	/**
	 * @var int
	 */
	private $code;

	/**
	 * @var string
	 */
	private $content;


	public function __construct($code, $content)
	{
		$this->code = $code;
		$this->content = $content;
	}


	/**
	 * @return int
	 */
	public function getCode()
	{
		return $this->code;
	}


	/**
	 * @return string
	 */
	public function getContent()
	{
		return $this->content;
	}

}
