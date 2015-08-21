package Slim::Statement;

use Switch;

use constant EXCEPTION_TAG => "";

=pod

=head1 NAME 

Slim::Statement - A slim statement

=head1 Author

Knut Haugen <knuthaug@gmail.com>, Jim Weaver <weaver.je@gmail.com>

=cut

sub new() {
	my $class = shift;
	my $self = {
		instruction_elements => shift
	};
	bless($self, $class);
	return($self);
}


sub execute() {
    my($self, $statement_executor) = @_;
    print("Parsing command for execution ", $self->command_name, "\n") if $main::debug;
    eval {
        $self->handle_command($statement_executor);
	}
	or do {
		my $error = $@;
		print("Exception detected during command excecution: ", $error, "\n") if $main::debug;
		return [$self->instruction_id, "message:<<UNEXPECTED_ERROR: " . $error . ".>>"];
	}
}

sub handle_command() {
	my($self, $statement_executor) = @_;
	switch($self->command_name)
	{
		case "make" {
	    	print("Performing make instruction.\n") if $main::debug;
	        return $self->make_instance($statement_executor);
	    }
	        
	    case "call" {
	    	print("Performing call method instruction.\n") if $main::debug;
	       	return $self->call_method_on_instance($statement_executor, 3);
	   	}
	   	case "callAndAssign" {
	   		print("Performing call and assign instruction.\n") if $main::debug;
	   		my $symbol_name = $self->instruction_element(2);
	   		my $result =  $self->call_method_on_instance($statement_executor, 4);
	   		print("Assigning symbol ", $symbol_name, " to result value of method: ", @$result[1], ".\n") if $main::debug;
	   		$statement_executor->add_symbol($symbol_name, @$result[1]);
	   		return $result;
	   	}
	    else {
	    	return [$self->instruction_id, EXCEPTION_TAG . "message:<<INVALID_STATEMENT: " . $self->command_name . ".>>"];
	    }
	}   
}

sub make_instance() {
	my($self, $statement_executor) = @_;

    my $class_name = $self->slim_to_perl_class($self->instruction_element(3));
    print("Class name for instance to be created is: ", $class_name, "\n") if $main::debug;
            
    my @arguments = $self->get_arguments(4);
    my $arguments_found = scalar (@arguments);
    print("Number of constructor arguments found: ", $arguments_found, "\n") if $main::debug;

    my $response_string = $statement_executor->create($self->instance_id, $class_name, @arguments);
    return [$self->instruction_id, $response_string];
}

sub call_method_on_instance() {
	my($self, $statement_executor, $start_index) = @_;
	my $slim_method_name = $self->instruction_element($start_index);
	my $method_name = $self->slim_to_perl_method($slim_method_name);
	print("Method to be called on instance is: ", $method_name, "\n") if $main::debug;
        
	my @arguments = $self->get_arguments($start_index + 1);
	print("Arguments retrieved", @arguments, "\n") if $main::debug;
        
	my $return_value = $statement_executor->call($self->instance_id, $method_name, @arguments);
        
    if (!defined($return_value)) {
    	return [$self->instruction_id, "/__VOID__/"];
    }
    if (ref $return_value eq 'ARRAY') {
        print("Array returned from method call.\n");
    }
    else {
    	print("Return value from method call is: ", $return_value, "\n") if $main::debug;
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
    $method_string =~ s|([A-Z])|"_" . lc($1)|eg;
    $method_string;
}

sub instruction_element() {
	my($self, $index) = @_;
	return $self->{instruction_elements}->[$index];
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
	if ("callAndAssign" eq $self->command_name) {
		return $self->instruction_element(3);
	}
	return $self->instruction_element(2);
}

sub get_arguments() {
	my($self, $from_index) = @_;
	my @temp = @{$self->{instruction_elements}};
	return @temp[$from_index..$#temp];
}

1;
