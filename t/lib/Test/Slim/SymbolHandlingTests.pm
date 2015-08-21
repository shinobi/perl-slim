package Test::Slim::SymbolHandlingTests;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::StatementExecutor;

my $statementExecutor = undef;

sub setup_fixture : Test(setup) {
    $statementExecutor = Slim::StatementExecutor->new();
}

sub can_add_and_retrieve_symbols : Test(1) {
	$statementExecutor->add_symbol("testSymbol", "value");
	is($statementExecutor->get_symbol_value("testSymbol"), "value", "Symbol added and retrieved with correct value.");
}

sub can_acquire_symbol_when_present : Test(1) {
	$statementExecutor->add_symbol("testSymbol", "value");
	is($statementExecutor->acquire_symbol('$testSymbol'), "value", "Symbol added and retrieved with correct value.");
}

sub can_acquire_symbol_when_not_present : Test(1) {
	is($statementExecutor->acquire_symbol('$testSymbol'), "testSymbol", "Name of symbol returned if value not present.");
}

sub can_detect_symbol : Test(2) {
	is($statementExecutor->is_a_symbol('$testSymbol'), 1, "Symbol detected correctly.");
	is($statementExecutor->is_a_symbol('testSymbol'), 0, "Non symbol detected correctly.");
}

sub can_replace_symbol_with_value_if_symbol_is_all_the_text : Test(1) {
	$statementExecutor->add_symbol("name", "Jim");
	is($statementExecutor->replace_symbol_in_text_words('$name'), "Jim", "Symbol replaced correctly if symbol constitutes all the text.");
}

sub can_replace_symbol_with_value_if_symbol_is_inside_the_text : Test(1) {
	$statementExecutor->add_symbol("name", "Jim");
	is($statementExecutor->replace_symbol_in_text_words('Hi, $name!'), "Hi, Jim!", "Symbol replaced correctly if symbol appears in middle of text.");
}

sub can_replace_multiple_symbols_in_text : Test(1) {
	$statementExecutor->add_symbol("name", "Jim");
	$statementExecutor->add_symbol("greeting", "Hello");
	is($statementExecutor->replace_symbol_in_text_words('$greeting, $name!'), "Hello, Jim!", "Multiple symbol values replaced correctly.");
}

sub can_replace_multiple_occurrences_of_same_symbol : Test(1) {
	$statementExecutor->add_symbol("name", "Jim");
	is($statementExecutor->replace_symbol_in_text_words('Hi, $name!  Bye, $name!'), "Hi, Jim!  Bye, Jim!", "Symbol replaced correctly if symbol appears in middle of text.");
}

sub can_replace_symbols_in_array_of_items : Test(2) {
	$statementExecutor->add_symbol("name", "Jim");
	my @array_of_items = ('Hi, $name!', 'Bye, $name!');
	
	my @results = $statementExecutor->replace_symbols_in_array(@array_of_items);
	
	is($results[0], 'Hi, Jim!', "Array element replaced correctly.");
	is($results[1], 'Bye, Jim!', "Array element replaced correctly.");
}


1;
