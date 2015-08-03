package Slim::Statement;

use Moose;
use Switch;
use namespace::autoclean;

has 'instruction_elements' =>	(
                   					is => 'ro',
                   					isa => 'ArrayRef',
                   				);

=pod

=head1 NAME 

Slim::Statement - A slim statement

=head1 Author

Knut Haugen <knuthaug@gmail.com>, Jim Weaver <weaver.je@gmail.com>

=cut


sub execute() {
    my($self, $statement_executor) = @_;
    print("Executing.... command name is ", $self->command_name, "\n");
    switch($self->command_name)
    {
        case "make" {
            print("In make clause\n");
            print("Instance id is: ", $self->instance_id, "\n");
            my $class_name = $self->slim_to_perl_class($self->instruction_element(3));
            print("Class name is: ", $class_name, "\n");
            
            #my @arguments = $statement->get_arguments(4);
            my @arguments = $self->get_arguments(4);
            my $arguments_found = scalar (@arguments);
            print("Arguments Found ", $arguments_found, "\n");

            my $response_string = $statement_executor->create($self->instance_id, $class_name, @arguments);
            return [$self->instruction_id, $response_string];
        }
        
        case "call" {
            print("In call clause\n");
            return $self->call_method_from_index($statement_executor);
        }
    }
}

sub call_method_from_index() {
	    my($self, $statement_executor) = @_;
	    my $slim_method_name = $self->instruction_element(3);
	    print("Method name unconverted is : ", $slim_method_name, "\n");
        my $method_name = $self->slim_to_perl_method($slim_method_name);
        print("Method name to call is: ", $method_name, "\n");
        my @arguments = $self->get_arguments(4);
        my $return_value = $statement_executor->call($self->instance_id, $method_name, @arguments);
        print("Return value is: ", $return_value, "\n");
        if (!defined($return_value)) {
            print("Returning void\n");
        	return [$self->instruction_id, "/__VOID__/"];
        }
        return [$self->instruction_id, $return_value];
}


sub slim_to_perl_class {
    my($self, $class_string) = @_;
    my @parts = split /\.|\:\:/, $class_string;
    join "::", map { ucfirst $_ } @parts;
 
}

sub slim_to_perl_method {
    my($self, $method_string) = @_;
    print("Method sting passed in is: ", $method_string, "\n");
    $method_string =~ s|([A-Z])|"_" . lc($1)|eg;
    $method_string;
}

sub instruction_element() {
	my($self, $index) = @_;
	return $self->instruction_elements()->[$index];
}

sub instruction_id {
	my($self) = @_;
	return $self->instruction_element(0);
}

sub command_name {
	my($self) = @_;
	return $self->instruction_element(1);
}

sub instance_id {
	my($self) = @_;
	return $self->instruction_element(2);
}

sub get_arguments() {
	my($self, $from_index) = @_;
	my @temp = @{$self->instruction_elements()};
	return @temp[$from_index..$#temp];
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;
