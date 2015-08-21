package Test::Slim::StatementExecution;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::StatementExecutor;

my $statementExecutor = undef;

sub setup_fixture : Test(setup) {
    $statementExecutor = Slim::StatementExecutor->new();
}

sub can_add_and_retrieve_instance_of_perl_class_to_hash : Test(1) {
	my $sampleInstance = {name => 'sample object'};
	$statementExecutor->set_instance("key", $sampleInstance);
	is($statementExecutor->instance("key"), $sampleInstance, "object instance returned from hash matches what was added");
}

sub can_handle_request_for_unkown_key : Test(1) {
	is($statementExecutor->instance("key"), undef, "object instance returned from hash matches what was added");
}

sub can_construct_perl_native_object_without_arguments_from_classname : Test(1) {
	my $class_object = $statementExecutor->construct_instance("Test::Slim::PerlNativeOOExamples::House");
	isnt($class_object, undef, "an instance of an object is returned");
}

sub can_construct_perl_native_object_with_arguments : Test(3) {
	my @argument_array = (5, 1000);
	my $class_object = $statementExecutor->construct_instance("Test::Slim::PerlNativeOOExamples::House", @argument_array);
	isnt($class_object, undef, "an instance of an object is returned");
	is($class_object->bedrooms, 5, "constructor argument correctly passed");
	is($class_object->square_feet, 1000, "constructor argument correctly passed");
}

sub can_create_instance_and_store : Test(1) {
	my @argument_array = (5, 1000);
	$statementExecutor->create("id_1", "Test::Slim::PerlNativeOOExamples::House", @argument_array);
	isnt($statementExecutor->instance("id_1"), undef, "an instance was stored and retrieved");
}

sub can_call_method_without_args_on_instance_and_return_result : Test(1) {
	my @constructor_args = (5, 1000);
	$statementExecutor->create("id_1", "Test::Slim::PerlNativeOOExamples::House", @constructor_args);
	
	my @method_args = ();
	my $result = $statementExecutor->call("id_1", "bedrooms", @method_args);
	is($result, 5, "call of method without args returned value from method");
}

sub can_call_method_with_args_on_instance_and_return_result : Test(1) {
	my @constructor_args = (5, 1000);
	$statementExecutor->create("id_1", "Test::Slim::PerlNativeOOExamples::House", @constructor_args);
	
	my @method_args = (10);
	my $result = $statementExecutor->call("id_1", "total_cost", @method_args);
	is($result, 10000, "call of method with args returned value from method");
}

sub can_call_method_with_no_return_value : Test(1) {
	my @constructor_args = (5, 1000);
	$statementExecutor->create("id_1", "Test::Slim::PerlNativeOOExamples::House", @constructor_args);
	
	my @method_args = (1);
	my $result = $statementExecutor->call("id_1", "set_bedrooms", @method_args);
	is($result, undef, "method with no return value called, returns undef as result");
}

sub can_call_method_that_returns_a_list : Test(1) {
	my @constructor_args = (5, 1000);
	$statementExecutor->create("id_1", "Test::Slim::PerlNativeOOExamples::House", @constructor_args);
	
	my @method_args = ();
	my $result = $statementExecutor->call("id_1", "get_as_list_of_columns", @method_args);
	is(ref $result, 'ARRAY', "Executor returns a reference to an array.");
}

sub can_call_constructor_with_symbols_substituted : Test(2) {
	my @constructor_args = (5, '$sq_feet');
	$statementExecutor->add_symbol("sq_feet", "2000");
	
	my $class_object = $statementExecutor->construct_instance("Test::Slim::PerlNativeOOExamples::House", @constructor_args);
	
	is($class_object->bedrooms, 5, "constructor argument correctly passed");
	is($class_object->square_feet, 2000, "constructor argument symbol substitution performed");
}

sub can_call_method_with_symbols_substituted : Test(1) {
	my @constructor_args = (5, 1000);
	my $class_object = $statementExecutor->construct_instance("Test::Slim::PerlNativeOOExamples::House", @constructor_args);
	$statementExecutor->set_instance("id_1", $class_object);
	$statementExecutor->add_symbol("bedrooms_quantity", "2");
	
	my @method_args = ('$bedrooms_quantity');
	$statementExecutor->call("id_1", "set_bedrooms", @method_args);
	is($class_object->bedrooms, 2, "symbol substituted before method called.");

}



1;
