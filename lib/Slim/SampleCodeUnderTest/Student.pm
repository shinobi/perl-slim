package Slim::SampleCodeUnderTest::Student;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = {
		name => shift, 
		school_year => shift,
		age => shift
	};
	
	bless($self, $class);
	return($self);
}

sub name {
	my $self = shift;
	return $self->{name};
}

sub set_name {
	my $self = shift;
	$self->{name} = shift;
}

sub school_year {
	my $self = shift;
	return $self->{school_year};
}

sub set_school_year {
	my $self = shift;
	$self->{school_year} = shift;
}

sub age {
	my $self = shift;
	return $self->{age};
}

sub set_age {
	my $self = shift;
	$self->{age} = shift;
}

1;
