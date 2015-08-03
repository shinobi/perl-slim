package Test::Slim::StatementParsingTests;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::Statement;
use Slim::StatementExecutor;

sub can_retrieve_word_from_statement_elements_by_index : Test(2) {
	my $statement = Slim::Statement->new( {instruction_elements => ["instruction_id", "command_name", "instance_id", "method_name"]} );
	is($statement->instruction_element(0), "instruction_id", "element retrieved is correct");
	is($statement->instruction_element(3), "method_name", "element retrieved is correct");  
}

sub can_retrieve_instruction_id : Test(1) {
	my $statement = Slim::Statement->new( {instruction_elements => ["instruction_id", "command_name", "instance_id", "method_name"]} );
	is($statement->instruction_id(), "instruction_id");
}

sub can_retrieve_command_name : Test(1) {
	my $statement = Slim::Statement->new( {instruction_elements => ["instruction_id", "command_name", "instance_id", "method_name"]} );
	is($statement->command_name(), "command_name");
}

sub can_retrieve_arguments : Test(3) {
	my $statement = Slim::Statement->new( {instruction_elements => ["inst_id", "call", "instance_id", "method_name", "arg1", "arg2"]} );
	my @arguments = $statement->get_arguments(4);
	my $arguments_returned = scalar (@arguments);
	is($arguments_returned, 2, "Correct number of arguments returned");
	is($arguments[0], "arg1", "First argument correct");
	is($arguments[1], "arg2", "Second argument correct");
}

sub can_make_an_object_returns_ok : Test(3) {
	my $statementExecutor = Slim::StatementExecutor->new();
	my $statement = Slim::Statement->new( {instruction_elements => ["inst_1", "make", "obj_1", 
		"Test::Slim::PerlNativeOOExamples::House", "3", "1000"]} );
	my $response = $statement->execute($statementExecutor);
	my $instance_created = $statementExecutor->instance("obj_1");
	is(@$response[0], "inst_1", "instruction id returned as first element");
	is(@$response[1], "OK", "ok returned as second element");
	is($instance_created->squareFeet, 1000, "instance created with correct constructor arguments");
}

1;