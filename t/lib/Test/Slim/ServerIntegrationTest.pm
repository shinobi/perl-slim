package Test::Slim::SlimCommandHandler;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

use Slim::SlimCommandHandler;

sub can_handle_make_and_call_decision_table_command : Test(1) {
	my $command = "[000002:" .
		"000123:[000006:000017:decisionTable_0_0:000004:make:000015:decisionTable_0:000025:Slim.SampleFixtures.House:000001:3:000004:1000:]:" .
		"000097:[000005:000017:decisionTable_0_4:000004:call:000015:decisionTable_0:000011:setBedrooms:000001:1:]:" .
		"]";
	my $response = Slim::SlimCommandHandler::process_command($command);
	is($response, "[000002:000044:[000002:000017:decisionTable_0_0:000002:OK:]:000052:[000002:000017:decisionTable_0_4:000010:/__VOID__/:]:]",
			 "serialized response is correct");
}

sub can_handle_call_that_returns_query_array_response :Test(1) {
		my $command = "[000002:" .
		"000123:[000006:000017:decisionTable_0_0:000004:make:000015:decisionTable_0:000025:Slim.SampleFixtures.House:000001:3:000004:1000:]:" .
		"000099:[000004:000017:decisionTable_0_4:000004:call:000015:decisionTable_0:000022:get_as_list_of_columns:]:" .
		"]";
		my $response = Slim::SlimCommandHandler::process_command($command);
		is($response, "[000002:000044:[000002:000017:decisionTable_0_0:000002:OK:]:000141:[000002:000017:decisionTable_0_4:000099:[000002:000034:[000002:000008:bedrooms:000001:3:]:000040:[000002:000011:square feet:000004:1000:]:]:]:]",
			 "serialized response is correct");

}

1;