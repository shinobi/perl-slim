package Slim::SampleFixtures::QueryStudentsByYear;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::StudentSearchProcessor;

sub new {
	my $class = shift;
	my $self = {
		school_year_to_search => shift 
	};
	
	bless($self, $class);
	return($self);
}

#query fixtures must implement this method, return a list of rows, with each row a list of columns (name, value).
sub query() {
	my $self = shift;
	my @matching_students = Slim::SampleCodeUnderTest::StudentSearchProcessor::search_by_school_year($self->{school_year_to_search});
	print("**** Found matching students ****, count of students is ", scalar @matching_students, "\n");
	my @list_of_rows;
	my $student;
	foreach $student (@matching_students) {
		my @row;
		push(@row, ["name", $student->name]);
		push(@row, ["school year", $student->school_year]);
		push(@row, ["age", $student->age]);
		print(@row, "\n");
		print("Size of row is ", scalar @row, "\n");
		push(@list_of_rows, \@row);
    }
    print("Size of list of rows is ", scalar @list_of_rows, "\n");
    return \@list_of_rows;
}

1;
