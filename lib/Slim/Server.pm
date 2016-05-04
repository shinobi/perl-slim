our $debug = 0;
our $pure_perl_charwidth = 0;

package Slim::Server;

use threads;
use threads::shared;

use Slim::SocketHandler;
use Slim::List::Deserializer;
use Slim::List::Serializer;
use Slim::ListExecutor;
my $port;
my $connected : shared = 1;
my $socket_handler;
				   
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
	process_command_line_args();
    print("Starting Slim Perl Server on port: $port, debug is: ",  $main::debug, "\n");
    initialize();
    $socket_handler->handle(\&serve_perl_slim, \$connected);
    while ($connected)
    {
        sleep(0.1);
    }
    print("Shutting down Slim Perl Server\n");
}

sub process_command_line_args {
	foreach my $arg(@ARGV) {
		if ("DEBUG" eq $arg) {
			$debug = 1;
		}
		elsif ("PERL_CHARWIDTH" eq $arg) {
			$pure_perl_charwidth = 1;
		}
		else {
			$port = $arg;
		}
	}
}

sub initialize {
    $socket_handler = Slim::SocketHandler->new($port);
}

sub serve_perl_slim {
	my ($self,$conn) = @_;
    print $conn "Slim -- V1.0\n";
                
    my $said_bye = 0;
    while (!$said_bye) {
    	my $command_length = "length of command";
        my $command = "command data";
        
        $conn->recv($command_length, 6);
        $conn->recv($command, 1);  #skip colon following length of command
        my $total = 0;
        $command = '';
        while ($total < $command_length) {
          my $buf;
          last unless defined $conn->recv($buf, $command_length);
          $total += length $buf;
          $command .= $buf;
        } 
        print("Command received from fitnesse of length: $command_length, payload: \n$command\n") if $main::debug;

        if (!($command eq "bye")) {
            my $serializedResponses = process_command($command);
            print("Sending responses back to fitnesse: $serializedResponses") if $main::debug;
            print $conn sprintf("%06d:%s", length($serializedResponses), $serializedResponses);
       	}
        else {
      		print("Received bye from fitnesse, exiting listen loop\n") if $main::debug;
          	$said_bye = 1;
      	}
	}
	return;
}

sub process_command {
	my $command = shift;
	my @instructions = new Slim::List::Deserializer()->deserialize($command);
    my @responses = new Slim::ListExecutor()->execute(@instructions);
    my $serializedResponses = new Slim::List::Serializer()->serialize(@responses);
    return $serializedResponses;
}

=back

=cut

run();
1;

