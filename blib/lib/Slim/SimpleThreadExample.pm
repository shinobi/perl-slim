package Slim::SimpleThreadExample;

use warnings;
use strict;
use threads;
use threads::shared;

my $counter : shared;

sub new {
	my $class = shift;
	my $self = {};
	$counter = shift;
	bless($self, $class);
	return($self);
}

sub counter {
	my $self = shift;
	return $counter;
}

sub increment_counter {
	my $self = shift;
	$counter ++;
}

sub increment_counter_in_thread {
	my $self = shift;
	my $thr = threads->new(\&increment_in_subroutine, $self);
	$thr->join;
}

sub increment_in_subroutine()
{
	print("here\n");
	my $self = shift;
	$self->increment_counter;
	print("value of counter is ", $self->counter, "\n");
}

1;


