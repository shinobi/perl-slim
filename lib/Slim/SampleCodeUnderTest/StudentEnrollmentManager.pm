package Slim::SampleCodeUnderTest::StudentEnrollmentManager;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::Student;

my @students;

sub add_student {
	my $name = shift;
	my $school_year = shift;
	my $age = shift;
	my $student_to_add = Slim::SampleCodeUnderTest::Student->new($name, $school_year, $age);
	push(@students, $student_to_add);
}

sub get_all_students {
	return @students;
}
1;
