package Slim::StatementExecutor;


=pod

=head1 NAME 

Slim::StatementExecutor - Communicate with perl code under test and maintain symbols used during test.

=head1 Author

Jim Weaver <weaver.je@gmail.com>

=cut

sub new {
	my $class = shift;
	my $self = {};
	$self->{fixture_instances} = { };
	$self->{symbols} = { };
	$self->{modules} = ['Slim::NoSuch', 'Slim::SampleFixtures'];
	bless($self, $class);
	return($self);
}

sub create {
	my($self, $instance_id, $class_name, @constructor_arguments) = @_;
	my $instance = $self->construct_instance($class_name, @constructor_arguments);
	if (!defined($instance))
	{
		return "__EXCEPTION__:message:<<COULD_NOT_INVOKE_CONSTRUCTOR $class_name>>";
	}
	$self->set_instance($instance_id, $instance);
	return "OK";
}

sub fixture_instances {
	my($self) = shift;
	return $self->{fixture_instances};
}

sub symbols {
	my($self) = shift;
	return $self->{symbols};
}

sub add_module {
    my($self, $module) = @_;
	push(@{$self->{modules}}, $module);
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
	my @args_with_symbols_replaced = $self->replace_symbols_in_array(@arguments);
	return $instance->$method_name(@args_with_symbols_replaced);
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
        my $located_class = $self->require_class($class_name);
        
        my @args_with_symbols_replaced = $self->replace_symbols_in_array(@constructor_arguments);
        print("Arguments after symbol substitution: ", @arguments, "\n") if $main::debug;

        my $class_object = $located_class->new(@args_with_symbols_replaced);
    }
    or do {
        print("Exception detected instantiating fixture: ", $@, "\n");
        return undef;
    }
}

sub require_class {
	my($self, $class_name) = @_;
	
	if ($self->class_name_already_fully_qualified($class_name))
	{
		print("Attempting require of name $class_name\n") if $main::debug;
		return $self->require_class_fully_qualified($class_name);
	} else {
		print("Class name [", $class_name, "] not fully qualified, will try module names as prefixes.\n") if $main::debug;
		return $self->require_class_unqualified($class_name);
	}
}

sub class_name_already_fully_qualified {
	my($self, $class_name) = @_;
	if (index($class_name, '::') != -1)
	{
		print("Class name determined to be fully qualified.\n");
		return 1;
	}
	print("Class name not fully qualified, will need to check modules.\n");
	return 0;
}

sub require_class_fully_qualified {
	my($self, $class_name) = @_;
	eval {
		eval "require $class_name";
	} or do {
		my $error = $@;
		print("Exception detected during require of fully qualified class name: ", $error, "\n") if $main::debug;
	};
	return $class_name;
}

sub require_class_unqualified {
	my($self, $class_name) = @_;
	my @fully_qualified_names_to_try = $self->build_names_from_modules($class_name);
		
	foreach $class_to_try (@fully_qualified_names_to_try) {
		print("Attempting require of name $class_to_try.\n") if $main::debug;
		eval {
			eval "require $class_to_try";
		} or do {
			my $error = $@;
			print($error, "Not a valid class name: $class_to_try.  Skipping this one.\n");
			next;
		};
		print("Found valid class name by using modules: ", $class_to_try, ".\n") if $main::debug;
		return $class_to_try;
	}
}

sub build_names_from_modules {
	my($self, $class_name) = @_;
	my @names_to_try;
	foreach $module (@{$self->{modules}}) {
		my $concat_name = $module . '::' . $class_name;
		print("Will need to try name ", $concat_name, ".\n");
		push(@names_to_try, $concat_name);
	}
	my $size_of_names_to_try = scalar @names_to_try;
	print("Total number of names to try with modules added: ", $size_of_names_to_try, ".\n");
	return @names_to_try;
}

sub add_symbol {
	my($self, $symbol_name, $symbol_value) = @_;
	print("Setting symbol $symbol_name to value $symbol_value.\n") if $main::debug;
	$self->symbols->{$symbol_name} = $symbol_value;
	my $size_of_symbols_hash = keys $self->{symbols};
	print("Size of symbol hash now: ", $size_of_symbols_hash, ".\n") if $main::debug;
}

sub get_symbol_value {
	my($self, $symbol_name) = @_;
	return $self->symbols->{$symbol_name};
}

# $symbolname is format from fitnesse
sub acquire_symbol {
	my($self, $symbol_from_fitnesse) = @_;
	my $symbol_name = substr($symbol_from_fitnesse, 1, (length $symbol_from_fitnesse));
	my $size_of_symbols_hash = keys $self->{symbols};
	print("Looking for symbol [", $symbol_name, "] in current map of symbols, size of symbols is: [", $size_of_symbols_hash, "].\n") if $main::debug;
	my $symbol_value = $self->get_symbol_value($symbol_name);
	return $symbol_value if defined $symbol_value;
	return $symbol_name;
}

sub is_a_symbol {
	my($self, $text) = @_;
	if ($text =~ /\A\$\w*\z/) {
		return 1;
	}
	return 0;
}

sub replace_symbol_in_text_words {
	my($self, $text) = @_;
	
	if ($self->is_a_symbol($text)) {
		print("Entire text is a symbol.\n");
		return $self->acquire_symbol($text);
	}
	else {
		return $self->replace_symbols_word_by_word_in_text($text);
	}
}

sub replace_symbols_word_by_word_in_text {
	my($self, $text) = @_;
	my $located_symbol;
	my $symbol_value;
	while ($text =~ /(\$\w*)/g) {
		$located_symbol = $1;
		$symbol_value = $self->acquire_symbol($located_symbol);
		print("Found symbol: ", $located_symbol, ", replacing with value: ", $symbol_value, "\n") if $main::debug;
		$text =~ s/\Q$located_symbol/$symbol_value/;
	}
	return $text;
}

sub replace_symbols_in_array {
	my($self, @text_array) = @_;
	my @result_array;
		
    foreach $text (@text_array) {
        push(@result_array, $self->replace_symbol_in_text_words($text));
    }
    return @result_array;
}

1;
