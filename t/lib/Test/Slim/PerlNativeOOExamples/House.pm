package Test::Slim::PerlNativeOOExamples::House;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = {
		bedrooms => shift, 
		squareFeet => shift
	};
	
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


