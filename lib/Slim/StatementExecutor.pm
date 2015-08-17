package Slim::StatementExecutor;

use Moose;
use namespace::autoclean;
use Error;
use Slim::SlimError;


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
	if (!defined($instance))
	{
		return "__EXCEPTION__:message:<<COULD_NOT_INVOKE_CONSTRUCTOR $class_name>>";
	}
	$self->set_instance($instance_id, $instance);
	return "OK";
}

sub call {
	my($self, $instance_id, $method_name, @arguments) = @_;
	my $instance = $self->instance($instance_id);
	return "__EXCEPTION__:message:<<NO INSTANCE $instance_id>>" if !defined($instance);
	
	print("Executor retrieved instance by id: ", $instance_id, ", value is: ", $instance, "\n") if $main::debug;
	
	if (!($instance->can($method_name))) {
		print("Instance does not have method $method_name\n") if $main::debug;
		return "__EXCEPTION__:message:<<NO_METHOD_IN_CLASS $method_name $instance>>";
	}
	return $instance->$method_name(@arguments);
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
    eval {
        print("Requiring class name $class_name\n") if $main::debug;
        eval "require $class_name";
        my $class_object = $class_name->new(@constructor_arguments);
    }
    or do {
        print("Exception detected instantiating fixture: ", $@, "\n") if $main::debug;
        return undef;
    }
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
