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
	is($class_object->squareFeet, 1000, "constructor argument correctly passed");
}

1;
