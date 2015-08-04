package Slim::StatementExecutor;

use Moose;
use namespace::autoclean;
use Error;
use Slim::FixtureInvocationError;


has 'fixture_instances' =>	(
                   				is => 'ro',
                   				default => sub { {} }, 
                   				isa => 'HashRef[Object]',
                   			);

=pod

=head1 NAME 

Slim::StatementExecutor - Communicate with perl code under test and maintain symbols used during test.

=head1 Author

Jim Weaver <weaver.je@gmail.com>

=cut

sub create {
	#symbol support and lib creation not implemented yet, just class instantiation
	#returning exception for fitnesse not implemented yet.
	my($self, $instance_id, $class_name, @constructor_arguments) = @_;
	my $instance = $self->construct_instance($class_name, @constructor_arguments);
	$self->set_instance($instance_id, $instance);
	return "OK";
}

sub call {

	my($self, $instance_id, $method_name, @arguments) = @_;
	my $instance = $self->instance($instance_id);
	my $return_value;

	print("Executor retrieved instance by id: ", $instance_id, ", value is: ", $instance, "\n");
	if (!($instance->can($method_name))) {
		print("Instance does not have method $method_name\n");
		return "message:NO_METHOD_IN_CLASS $method_name";
	}
	$return_value = $instance->$method_name(@arguments);
	print("Return value is : ", $return_value, "\n");
	return $return_value;
}

sub set_instance {
    my($self, $instance_id, $instance) = @_;
    $self->fixture_instances->{$instance_id} = $instance;
}

sub instance {
	my($self, $instance_id) = @_;
	return $self->fixture_instances->{$instance_id};
}

sub construct_instance {
	my($self, $class_name, @constructor_arguments) = @_;
	print(@constructor_arguments, "\n");
	print("Instantiating fixture class: ", $class_name, "\n");
	print("Hello?\n");
    eval {
        print "in eval\n";
        eval "require $class_name";
        print "required class name\n";
        my $class_object = $class_name->new(@constructor_arguments);
    }
    or do {
        print("Execption detected instantiating fixture: ", $@, "\n");
    	throw Slim::FixtureInvocationError("Could not invoke constructor on class $class_name.\n  Exception: $@.");
    }
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
