package Slim::SampleFixtures::ShouldIBuyMilk;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::MilkPurchaseCalculator;

sub new {
	my $class = shift;
	my $self = {
		cash_in_wallet => undef, 
		credit_card => undef,
		pints_of_milk_remaining => undef,
		milk_calculator => undef
	};
	
	bless($self, $class);
	return($self);
}

sub set_cash_in_wallet {
	my $self = shift;
	$self->{cash_in_wallet} = shift;
	return;
}

sub set_credit_card {
	my $self = shift;
	$self->{credit_card} = shift;
	return;	
}

sub set_pints_of_milk_remaining {
	my $self = shift;
	$self->{pints_of_milk_remaining} = shift;
	return;	
}

sub go_to_store {
	my $self = shift;
	return ($self->{milk_calculator})->go_to_store;
}


# The following functions are optional for decision tables.  If they aren't declared they'll be ignored by Fitnesse.

sub table() {
	#table is called just after the constructor and before the first row is processed. It is passed a list of lists that contain 
	# all the cells of the table except for the very first row. The argument contains a list of rows, each row is a list of cells.
}

sub beginTable() {
	# beginTable is called once, just after the table method, and just before the rows are processed. This is for setup and initialization stuff.
}

sub reset() {
	#reset is called once for each row before any set or output functions are called.
}

sub execute() {
	# execute is called once for each row just after all the set functions have been called, and just before 
	#   the first output function (if any) are called.
	my $self = shift;
	print("execute method of ShouldIBuyMilk fixture called by fitnesse\n");
	$self->{milk_calculator} = Slim::SampleCodeUnderTest::MilkPurchaseCalculator->new($self->{cash_in_wallet}, $self->{credit_card}, $self->{pints_of_milk_remaining});
}

sub endTable() {
	# endTable is called once, just after the last row has been processed. 
	#   It's the last function to be called by the table. Use it for cleanup and closedowns.
}

1;
