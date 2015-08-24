package Test::Slim::TestStudentSearch;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;

use Slim::SampleCodeUnderTest::StudentEnrollmentManager;
use Slim::SampleCodeUnderTest::StudentSearchProcessor;
use Slim::SampleFixtures::QueryStudentsByYear;
use Slim::SampleFixtures::QueryStudentsById;


use Slim::List::Serializer;

sub setup_fixture : Test(setup) {
	Slim::SampleCodeUnderTest::StudentEnrollmentManager::clear_students;
}


sub can_search_by_year : Test(1) {
	Slim::SampleCodeUnderTest::StudentEnrollmentManager::add_student("John", "K", 5);
	Slim::SampleCodeUnderTest::StudentEnrollmentManager::add_student("Jane", "1", 6);
	Slim::SampleCodeUnderTest::StudentEnrollmentManager::add_student("Michael", "1", 6);

	my @results = Slim::SampleCodeUnderTest::StudentSearchProcessor::search_by_school_year("1");
    my $results_size = scalar (@results);
    
    my $fixture = Slim::SampleFixtures::QueryStudentsByYear->new("1");
    my @query_fixture_results = $fixture->query();
    my $serializer = new Slim::List::Serializer();
    my $serialzed_string_list_of_list_of_list = $serializer->serialize(@query_fixture_results);
    print($serialzed_string_list_of_list_of_list);

	is($results_size, 2, "Search returns correct number of results.");
}

sub can_search_by_id : Test(1) {
	Slim::SampleCodeUnderTest::StudentEnrollmentManager::add_student("John", "K", 5);
	Slim::SampleCodeUnderTest::StudentEnrollmentManager::add_student("Jane", "1", 6);
	my $michael_id = Slim::SampleCodeUnderTest::StudentEnrollmentManager::add_student("Michael", "1", 6);

    my @id_array;
	push(@id_array, $michael_id);
	my @results = Slim::SampleCodeUnderTest::StudentSearchProcessor::search_by_ids(@id_array);
    my $results_size = scalar (@results);
    
    my $fixture = Slim::SampleFixtures::QueryStudentsById->new($michael_id);
    my @query_fixture_results = $fixture->query();
    my $serializer = new Slim::List::Serializer();
    my $serialzed_string_list_of_list_of_list = $serializer->serialize(@query_fixture_results);
    print($serialzed_string_list_of_list_of_list);

	is($results_size, 1, "Search returns correct number of results.");
}


1;
