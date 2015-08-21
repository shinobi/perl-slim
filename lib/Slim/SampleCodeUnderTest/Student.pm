package Slim::SampleCodeUnderTest::Student;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = {
		id => shift,
		name => shift, 
		school_year => shift,
		age => shift
	};
	
	bless($self, $class);
	return($self);
}

sub id {
	my $self = shift;
	return $self->{id};
}

sub set_id {
	my $self = shift;
	$self->{id} = shift;
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
