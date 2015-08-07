package Slim::SampleCodeUnderTest::MilkPurchaseCalculator;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = {
		cash_in_wallet => shift, 
		credit_card => shift,
		pints_of_milk_remaining => shift
	};
	
	bless($self, $class);
	return($self);
}

sub go_to_store {
	my $self = shift;
	return ( ($self->{pints_of_milk_remaining} eq 0) && ($self->have_money) ) ? "yes" : "no";
}

sub have_money {
	my $self = shift;
	if ( ("yes" eq $self->{credit_card}) || ($self->{cash_in_wallet} > 2) ) {
		return 1;
	}
	return 0;
}

1;
