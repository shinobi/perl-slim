package Slim::Server;

use Moose;
use namespace::autoclean;
use Error;
use Time::HiRes qw(alarm);

use SocketHandler;
use Slim::List::Deserializer;
use Slim::List::Serializer;
use ListExecutor;
use constant DEBUG => 1;
my $port = $ARGV[0];
my $connected = 1;
my $socket_handler;
my $executor;
				   
=pod

=head1 NAME 

Slim::Server - networking parts

=head1 Author

Knut Haugen <knuthaug@gmail.com>, Jim Weaver (weaverj@gmail.com)

=cut

=head1 Public API

=over 4

=item run ()

Run a server on the port given in the constructor

=cut

sub run {
    print "Starting Slim Perl Server on port: $port\n";
    print (\$connected);
    initialize();
    $socket_handler->handle(\&serve_perl_slim, \$connected);
    print("When does this print?");
    
    while ($connected)
    {
        sleep(0.1);
    }
}

sub initialize {
    $socket_handler = new Slim::SocketHandler({port => $port});
    $executor = new Slim::ListExecutor();
}

sub serve_perl_slim {
	my ($self,$conn) = @_;
	print $self;
    print $conn "Slim -- V1.0\n";
    print ($self);
    print "Header sent to Fitnesse, awaiting data…\n" if DEBUG;
                
    my $said_bye = 0;
    while (!$said_bye) {
    	my $command_length = "length of command";
        my $command = "command data";
        
        $conn->recv($command_length, 6);
        $conn->recv($command, 1);  #skip colon following length of command
        $conn->recv($command, $command_length);
        
        print("Command received from fitnesse of length: $command_length, payload: \n$command\n") if DEBUG;

        if (!($command eq "bye")) {
			my @instructions = new Slim::List::Deserializer()->deserialize($command);
       		my @responses = new Slim::ListExecutor()->execute(@instructions);
            print("Responses array to send back to fitnesse: @responses\n") if DEBUG;
            my $serializedResponses = new Slim::List::Serializer()->serialize(@responses);
            print("Sending responses back to fitnesse: $serializedResponses") if DEBUG;
            print $conn sprintf("%06d:%s", length($serializedResponses), $serializedResponses);
       	}
        else {
      		print("Received bye from fitnesse, exiting listen loop\n") if DEBUG;;
          	$said_bye = 1;
      	}
	}
	print("Exited while loop for commands from fitnesse\n") if DEBUG;
	return;
}

=back

=cut


no Moose;

__PACKAGE__->meta->make_immutable();

run();
1;

