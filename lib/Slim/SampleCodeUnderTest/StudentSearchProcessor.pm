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

sub search_by_ids {
	my @id_array = shift;
	my @all_students = Slim::SampleCodeUnderTest::StudentEnrollmentManager->get_all_students;
	my @matching_students;
	my $student;
	
	foreach $student (@all_students) {
		if (id_in($student->id, @id_array))
		{
			push(@matching_students, $student);
		}
    }

	return @matching_students;
}

sub id_in {
	my $target_id = shift;
	my @id_array = shift;
	
	my $cur_id;
	foreach $cur_id (@id_array) {
		if ($cur_id eq $target_id)
		{
			return 1;
		}
    }
    return 0;	
}

1;
