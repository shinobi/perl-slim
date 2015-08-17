package Slim::SampleFixtures::LoginDialogDriver;

use warnings;
use strict;

sub new {
	my $class = shift;
	my $self = {
		username => shift,
		password => shift,
		message => "",
		login_attempts => 0
	};
	
	bless($self, $class);
	return($self);
}

# note, since just an example, this fixture not calling out to system under test to verify password, get message, as it would in real case.
sub login_with_username_and_password {
	my ($self, $username, $password) = @_;
	
	$self->{login_attempts}++;
	my $result;
	if ( ($self->{username} eq $username) && ($self->{password} eq $password) ) {
		$result = "true";
		$self->{message} = "$username logged in.";
	} else {
		$result = "false";
		$self->{message} = "$username not logged in.";
	}
	return $result;
}

sub number_of_login_attempts {
	my $self = shift;
	return $self->{login_attempts};
}

sub login_message {
	my $self = shift;
	return $self->{message};
}

1;
