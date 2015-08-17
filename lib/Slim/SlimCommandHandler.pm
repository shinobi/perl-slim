package Slim::SlimCommandHandler;

use namespace::autoclean;

use Slim::List::Deserializer;
use Slim::List::Serializer;
use Slim::ListExecutor;

sub process_command {
	my $command = shift;
	my @instructions = new Slim::List::Deserializer()->deserialize($command);
    my @responses = new Slim::ListExecutor()->execute(@instructions);
    my $serializedResponses = new Slim::List::Serializer()->serialize(@responses);
    return $serializedResponses;
}

1;
				   