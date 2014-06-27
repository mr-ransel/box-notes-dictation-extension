'use strict';

	// var e = $.Event('keypress');
 //    e.which = 65; //A
 //    $('#test').val(String.fromCharCode(e.which));

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
	// jQuery.event.trigger({ type : 'keypress', which : character.charCodeAt(0) });
	// $(document).sendkeys(character);
	var e = jQuery.Event("keydown");
	e.keyCode = character.charCodeAt(0);
	$('#test').trigger(e);
}

// $("#example").click(function() {    
//     $("#search").focus();
//     var e = jQuery.Event("keydown");
//     e.keyCode = 50;                     
//     $("#search").trigger(e);                    
// });

// function simulateKeyPress(character) {
//   var evt = document.createEvent("KeyboardEvent");
//   evt.initKeyEvent ("keypress", true, true, window,
//                     0, 0, 0, 0,
//                     0, character.charCodeAt(0));
//   var canceled = !body.dispatchEvent(evt);
//   if(canceled) {
//     // A handler called preventDefault
//     alert("canceled");
//   } else {
//     // None of the handlers called preventDefault
//     alert("not canceled");
//   }
// }