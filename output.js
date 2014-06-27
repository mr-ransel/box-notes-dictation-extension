'use strict';

function print_input(input_string)
{

}

function simulateKeyPress(character)
{
  jQuery.event.trigger({ type : 'keypress', which : character.charCodeAt(0) });
}