package Test::Slim::StatementParsingTests;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::Statement;
use Slim::StatementExecutor;

sub can_retrieve_word_from_statement_elements_by_index : Test(2) {
	my $statement = Slim::Statement->new( ["instruction_id", "command_name", "instance_id", "method_name"] );
	is($statement->instruction_element(0), "instruction_id", "element retrieved is correct");
	is($statement->instruction_element(3), "method_name", "element retrieved is correct");  
}

sub can_retrieve_instruction_id : Test(1) {
	my $statement = Slim::Statement->new(["instruction_id", "command_name", "instance_id", "method_name"] );
	is($statement->instruction_id(), "instruction_id");
}

sub can_retrieve_command_name : Test(1) {
	my $statement = Slim::Statement->new( ["instruction_id", "command_name", "instance_id", "method_name"] );
	is($statement->command_name(), "command_name");
}

sub can_retrieve_arguments : Test(3) {
	my $statement = Slim::Statement->new( ["inst_id", "call", "instance_id", "method_name", "arg1", "arg2"] );
	my @arguments = $statement->get_arguments(4);
	my $arguments_returned = scalar (@arguments);
	is($arguments_returned, 2, "Correct number of arguments returned");
	is($arguments[0], "arg1", "First argument correct");
	is($arguments[1], "arg2", "Second argument correct");
}

sub can_make_an_object_returns_ok : Test(3) {
	my $statementExecutor = Slim::StatementExecutor->new();
	my $statement = Slim::Statement->new( ["inst_1", "make", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"] );
	my $response = $statement->execute($statementExecutor);
	my $instance_created = $statementExecutor->instance("obj_1");
	is(@$response[0], "inst_1", "instruction id returned as first element");
	is(@$response[1], "OK", "ok returned as second element");
	is($instance_created->square_feet, 1000, "instance created with correct constructor arguments");
}

sub can_call_method_on_instance_returns_ok_and_value : Test(2) {
	my $statementExecutor = Slim::StatementExecutor->new();
	my $statement = Slim::Statement->new( ["inst_1", "make", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"] );
	$statement->execute($statementExecutor);
	
	my $call_statement = Slim::Statement->new( ["inst_2", "call", "obj_1", "totalCost", "10"] );
	my $response = $call_statement->execute($statementExecutor);
	is(@$response[0], "inst_2", "instruction id returned as first element");
	is(@$response[1], "10000", "method return value returned as second element");
}

sub can_call_method_with_no_return_value_on_instance_and_return_void_string : Test(2) {
	my $statementExecutor = Slim::StatementExecutor->new();
	my $statement = Slim::Statement->new( ["inst_1", "make", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"] );
	$statement->execute($statementExecutor);
	
	my $call_statement = Slim::Statement->new( ["inst_2", "call", "obj_1", "setBedrooms", "1"] );
	my $response = $call_statement->execute($statementExecutor);
	is(@$response[0], "inst_2", "instruction id returned as first element");
	is(@$response[1], "/__VOID__/", "void returned as second element");
}

sub can_return_exception_if_unrecognized_command_supplied : Test(2) {
	my $statementExecutor = Slim::StatementExecutor->new();
	my $statement = Slim::Statement->new( ["inst_1", "implode", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"] );
	my $response = $statement->execute($statementExecutor);
	is(@$response[0], "inst_1", "instruction id returned as first element");
	is(@$response[1], "message:<<INVALID_STATEMENT: implode.>>", "Unrecognized command exception is returned as second element.");
}

sub can_call_method_that_returns_a_list : Test(2) {
	my $statementExecutor = Slim::StatementExecutor->new();
	my $statement = Slim::Statement->new( ["inst_1", "make", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"] );
	$statement->execute($statementExecutor);
	
	my $call_statement = Slim::Statement->new( ["inst_2", "call", "obj_1", "get_as_list_of_columns"] );
	my $response = $call_statement->execute($statementExecutor);
	is(@$response[0], "inst_2", "instruction id returned as first element");
	is(ref @$response[1], 'ARRAY', "response to instruction is an array reference.");
}


sub can_call_method_and_assign_result_to_symbol : Test(3) {
	my $statementExecutor = Slim::StatementExecutor->new();
	my $statement = Slim::Statement->new( ["inst_1", "make", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"] );
	$statement->execute($statementExecutor);
	
	my $call_statement = Slim::Statement->new( ["inst_2", "callAndAssign", '$current_cost', "obj_1", "totalCost", "10"] );
	my $response = $call_statement->execute($statementExecutor);
	is(@$response[0], "inst_2", "instruction id returned as first element");
	is(@$response[1], "10000", "method return value returned as second element");
	is($statementExecutor->get_symbol_value("current_cost"), "10000", "Symbol added with correct method return value.");
}

1;
