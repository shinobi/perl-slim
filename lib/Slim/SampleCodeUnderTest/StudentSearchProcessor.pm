package Slim::SampleCodeUnderTest::StudentSearchProcessor;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::StudentEnrollmentManager;

sub search_by_school_year {
	my $school_year_for_search = shift;
	my @all_students = Slim::SampleCodeUnderTest::StudentEnrollmentManager->get_all_students;
	my @matching_students;
	my $student;
	
	foreach $student (@all_students) {
		if ($student->school_year eq $school_year_for_search)
		{
			push(@matching_students, $student);
		}
    }

	return @matching_students;
}

1;
