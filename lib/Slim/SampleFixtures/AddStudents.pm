package Slim::SampleFixtures::AddStudents;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::StudentEnrollmentManager;

sub new {
	my $class = shift;
	my $self = {
		name => undef, 
		school_year => undef,
		age => undef
	};
	
	bless($self, $class);
	return($self);
}

sub set_name {
	my $self = shift;
	$self->{name} = shift;
}

sub set_school_year {
	my $self = shift;
	$self->{school_year} = shift;
}

sub set_age {
	my $self = shift;
	$self->{age} = shift;
}

sub execute() {
	my $self = shift;
	Slim::SampleCodeUnderTest::StudentEnrollmentManager::add_student($self->{name}, $self->{school_year}, $self->{age});
	my @current_students = Slim::SampleCodeUnderTest::StudentEnrollmentManager::get_all_students();
	print("**** Added Student ****, count of students is ", scalar @current_students, "\n");
}

1;
