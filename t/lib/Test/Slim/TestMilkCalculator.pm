package Test::Slim::TestMilkCalculator;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

use Slim::SampleCodeUnderTest::MilkPurchaseCalculator;

my $calculator = undef;

sub setup_fixture : Test(setup) {
}


sub can_handle_have_milk_case_correctly : Test(1) {
	$calculator = Slim::SampleCodeUnderTest::MilkPurchaseCalculator->new(5, "yes", 2);
	is($calculator->go_to_store, "no", "Should return no if we have milk in fridge.");
}

1;
