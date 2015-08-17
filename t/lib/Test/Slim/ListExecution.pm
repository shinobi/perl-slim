package Test::Slim::ListExecution;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

use Slim::ListExecutor;

my $list_executor = undef;

sub setup_fixture : Test(setup) {
    $list_executor = Slim::ListExecutor->new();
}


sub can_execute_instruction_list_with_make_and_call : Test(6) {
	my @instruction_list;
	$instruction_list[0] =  [ "inst_1", "make", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"];
	$instruction_list[1] = ["inst_2", "call", "obj_1", "setBedrooms", "1"];
	
	my @responses = $list_executor->execute(@instruction_list);
	my $responses_size = scalar (@responses);
		
	isnt(@responses, undef, "responses object is not undefined");
	is($responses_size, 2, "one response per instruction executed should be returned");
	is($responses[0]->[0], "inst_1", "instruction 1 result present");
	is($responses[0]->[1], "OK", "ok result for instruction 1 present");
	is($responses[1]->[0], "inst_2", "instruction 2 result present");
	is($responses[1]->[1], "/__VOID__/", "result for instruction 2 present");
}

sub can_execute_instrution_list_with_nested_list_response : Test(6) {
	my @instruction_list;
	$instruction_list[0] =  [ "inst_1", "make", "obj_1", "Test::Slim::PerlNativeOOExamples::House", "3", "1000"];
	$instruction_list[1] = ["inst_2", "call", "obj_1", "get_as_list_of_columns"];
	
	my @responses = $list_executor->execute(@instruction_list);
	my $responses_size = scalar (@responses);
		
	isnt(@responses, undef, "responses object is not undefined");
	is($responses_size, 2, "one response per instruction executed should be returned");
	is($responses[0]->[0], "inst_1", "instruction 1 result present");
	is($responses[0]->[1], "OK", "ok result for instruction 1 present");
	is($responses[1]->[0], "inst_2", "instruction 2 result present");
	is(ref $responses[1]->[1], "ARRAY", "result for instruction 2 present");
}

1;
