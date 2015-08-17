package Test::Slim::PerlNativeOOExamples::House;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = {
		bedrooms => shift, 
		square_feet => shift
	};
	
	bless($self, $class);
	return($self);
}

sub bedrooms {
	my $self = shift;
	return $self->{bedrooms};
}

sub set_bedrooms {
	my $self = shift;
	$self->{bedrooms} = shift;
	return;
}

sub set_square_feet {
	my $self = shift;
	$self->{square_feet} = shift;
	return;	
}

sub square_feet {
	my $self = shift;
	return $self->{square_feet};
}

sub total_cost {
	my $self = shift;
	my $cost_per_square_foot = shift;
	return ($self->{square_feet}) * $cost_per_square_foot;
}

sub get_as_list_of_columns {
	my $self = shift;
	my @list_of_columns;
	push(@list_of_columns, ["bedrooms", $self->bedrooms]);
	push(@list_of_columns, ["square feet", $self->square_feet]);
	return \@list_of_columns;
}

1;


