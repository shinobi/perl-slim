package Slim::SampleFixtures::InitializeWithCars;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = {
		vin => undef, 
		description => undef,
		daily_rate => undef
	};
	
	bless($self, $class);
	return($self);
}

sub set_vin {
	my $self = shift;
	$self->{vin} = shift;
}

sub set_description {
	my $self = shift;
	$self->{description} = shift;
}

sub set_daily_rate {
	my $self = shift;
	$self->{daily_rate} = shift;
}

# The following functions are optional for decision tables.  If they aren't declared they'll be ignored by Fitnesse.

sub table() {
	#table is called just after the constructor and before the first row is processed. It is passed a list of lists that contain 
	# all the cells of the table except for the very first row. The argument contains a list of rows, each row is a list of cells.
}

sub begin_table() {
	# beginTable is called once, just after the table method, and just before the rows are processed. This is for setup and initialization stuff.
}

sub reset() {
	#reset is called once for each row before any set or output functions are called.
}

sub execute() {
	# execute is called once for each row just after all the set functions have been called, and just before 
	#   the first output function (if any) are called.
	my $self = shift;
	print("execute method of Initialze Cars fixture called by fitnesse - here is where we can add an individual car to the system\n");
	#$self->{milk_calculator} = Slim::SampleCodeUnderTest::MilkPurchaseCalculator->new($self->{cash_in_wallet}, $self->{credit_card}, $self->{pints_of_milk_remaining});
}

sub end_table() {
	# endTable is called once, just after the last row has been processed. 
	#   It's the last function to be called by the table. Use it for cleanup and closedowns.
}

1;
