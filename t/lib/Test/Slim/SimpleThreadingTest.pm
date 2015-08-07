package Test::Slim::SimpleThreadingTest;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::SimpleThreadExample;

my $simple = undef;

sub setup_fixture : Test(setup) {
    $simple = Slim::SimpleThreadExample->new(1);
}

sub can_construct_with_initial_counter_Value : Test(1) {
	is($simple->counter, 1, "initial counter value correct");
}

sub can_increment_counter : Test(1) {
	$simple->increment_counter();
	is($simple->counter, 2, "initial counter value correct");
}

sub can_increment_counter_in_thread : Test(1) {
	$simple->increment_counter_in_thread();
	is($simple->counter, 2, "initial counter value correct");
}

1;