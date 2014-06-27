'use strict';

var input_string = "Hello, World!";

print_input(input_string);

function print_input(input_string)
{
	console.log("hello");
	for (var i = 0; i < input_string.length; ++i)
	{
		// console.log(character);
		// simulateKeyPress(character);
		console.log(input_string[i]);
		simulateKeyPress(input_string[i]);
	}
}

function simulateKeyPress(character)
{
	// console.log("hello");
	jQuery.event.trigger({ type : 'keypress', which : character.charCodeAt(0) });
}