package Test::Slim::StatementTransformations;

use strict;
use warnings;
use base qw(Test::Class);
use Test::More;
use Slim::Statement;;

my $statement = undef;

sub setup_fixture : Test(setup) {
    $statement = new Slim::Statement();
}

sub converts_dots_to_double_colons_when_for_class_names_qualified_by_package : Test(2) {
    is( $statement->slim_to_perl_class("package.Class"), "Package::Class", "Transforms . to ::");
    is( $statement->slim_to_perl_class("package.subPackage::class"), 
        "Package::SubPackage::Class", "Transforms . to :: and uppercases");
}

sub removes_spaces_and_camel_cases_when_package_parts_not_present : Test(2) {
	 is( $statement->slim_to_perl_class("class name sentence"), "ClassNameSentence", "Handles spaces in class names.");
	 is( $statement->slim_to_perl_class("ClassNameSentence"), "ClassNameSentence", "Works with Perl class names");
}

sub must_translate_slim_method_names_to_perl : Test(2) {
    is( $statement->slim_to_perl_method("myMethod"), "my_method", 
        "transforms case and Camel case to underscore ad lowercase ");
    is( $statement->slim_to_perl_method("myMethodTwo"), "my_method_two", 
        "transforms case and Camel case to underscore ad lowercase. Multiples ");
}



1;
