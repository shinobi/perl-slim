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
	my($self, $instance_name, $class_name, @constructor_arguments) = @_;
	my $instance = $self->construct_instance($class_name, @constructor_arguments);
	$self->set_instance($instance_name, $instance);
	return "OK";
}

sub set_instance {
    my($self, $instance_name, $instance) = @_;
    $self->fixture_instances->{$instance_name} = $instance;
}

sub instance {
	my($self, $instance_name) = @_;
	return $self->fixture_instances->{$instance_name};
}

sub construct_instance {
	my($self, $class_name, @constructor_arguments) = @_;
	print(@constructor_arguments, "\n");
	print("Instantiating fixture class: ", $class_name, "\n");
    eval {
        eval "require $class_name";
        my $class_object = $class_name->new(@constructor_arguments);
    }
    or do {
    	throw Slim::FixtureInvocationError("Could not invoke constructor on class $class_name.\n  Exception: $@.");
    }
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
