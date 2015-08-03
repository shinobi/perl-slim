package Slim::House;

use warnings;
use strict;

sub new {
	my $class = shift;
	my %options = @_;
	my $self = {bedrooms => 4, squareFeet => 1200, %options,};
	bless($self, $class);
	return($self);
}

sub bedrooms {
	my $self = shift;
	return $self->{bedrooms};
}

sub squareFeet {
	my $self = shift;
	return $self->{squareFeet};
}

1;


