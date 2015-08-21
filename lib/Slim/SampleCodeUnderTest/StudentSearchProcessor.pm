package Slim::SampleCodeUnderTest::StudentSearchProcessor;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::StudentEnrollmentManager;

sub search_by_school_year {
	my $school_year_for_search = shift;
	my @all_students = Slim::SampleCodeUnderTest::StudentEnrollmentManager->get_all_students;
	print("Got all students, number found is: ", scalar @all_students, ".\n");
	my @matching_students;
	my $student;
	
	foreach $student (@all_students) {
		print("Comparing enrolled student in year ", $student->school_year, " to year being searched: ", $school_year_for_search, ".\n");
		if ($student->school_year eq $school_year_for_search)
		{
			push(@matching_students, $student);
		}
    }

	return @matching_students;
}

1;
