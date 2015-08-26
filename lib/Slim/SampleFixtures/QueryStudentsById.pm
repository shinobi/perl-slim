package Slim::SampleFixtures::QueryStudentsById;

use warnings;
use strict;

use Slim::SampleCodeUnderTest::StudentSearchProcessor;

sub new {
	my $class = shift;
	my $self = {
		id_to_search => shift 
	};
	
	bless($self, $class);
	return($self);
}

#query fixtures must implement this method, return a list of rows, with each row a list of columns (name, value).
sub query() {
	my $self = shift;
	my @id_array;
	push(@id_array, $self->{id_to_search});
	my @matching_students = Slim::SampleCodeUnderTest::StudentSearchProcessor::search_by_ids(@id_array);
	print("**** Found matching students by Id ****, count of students is ", scalar @matching_students, "\n");
	my @list_of_rows;
	my $student;
	foreach $student (@matching_students) {
		my @row;
		push(@row, ["name", $student->name]);
		push(@row, ["school year", $student->school_year]);
		push(@row, ["age", $student->age]);
		push(@list_of_rows, \@row);
    }
    return \@list_of_rows;
}

1;
