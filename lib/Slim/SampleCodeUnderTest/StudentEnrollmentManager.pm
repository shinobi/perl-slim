package Slim::SampleCodeUnderTest::StudentEnrollmentManager;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::Student;

our $id_sequence = 100;

my @students;

sub add_student {
	my $name = shift;
	my $school_year = shift;
	my $age = shift;
	my $student_id = generate_id();
	my $student_to_add = Slim::SampleCodeUnderTest::Student->new($student_id, $name, $school_year, $age);
	push(@students, $student_to_add);
	print("Added student, returning student id: ", $student_id, "\n");
	return $student_id;
}

sub get_all_students {
	return @students;
}

sub generate_id {
	return $id_sequence++;
}
1;
