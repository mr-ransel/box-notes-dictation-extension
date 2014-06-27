'use strict';

$(document).ready(function(){


	var input_string = "Hello, World!";

	print_input(input_string);


	function print_input(input_string)
	{
		console.log("hello");
		for (var i = 0; i < input_string.length; ++i)
		{
			simulateKeyPress(input_string[i]);
		}
	}

	function simulateKeyPress(character)
	{
		$('#innerdocbody').children().last().append(character).show();
	}

});