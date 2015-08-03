package Slim::SocketHandler;

use Moose;
use threads;
use threads::shared;
use namespace::autoclean;
use Error;
use Time::HiRes qw(alarm);
use IO::Socket;


has 'port' => (
               is => 'rw', 
               default => 12345,
               isa => 'Int',
              );

has 'action' => (
                 is => 'rw', 
                 isa => 'CodeRef',
                );

has 'listener_thread' => (
                          is => 'rw', 
                          isa => 'Object',
                         );

has 'socket' => (
                 is => 'rw', 
                 isa => 'IO::Socket',
                );



=pod

=head1 NAME 

Slim::SocketHandler - low level socket handler

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut

=head1 Public API

=over 4

=item handle ()

Run a socket listening on the port given in the constructor

=cut

sub handle { 
    my($self, $action, $connected) = @_;
    print("*** value of connected is $connected\n");
    $self->action($action);
    $self->socket($self->open_socket() );
 
    $self->listener_thread(threads->create( 'listen', $self, \$connected));
    print("finished handle method");
}

sub pending_sessions {
    my ($self) = @_;
    return scalar threads->list();
}

sub close_all {
    my($self) = @_;
    
    $self->socket->shutdown(2);
    foreach my $thread (threads->list()) {
        $thread->join();
    }
}


=back

=cut



sub listen {
    my($self, $connected) = @_;
    print("In listen value of connected is $connected\n");
    while ( my $connection = $self->socket()->accept() ) {
         print("Listening on socket....\n");
         my $peer_address = $connection->peerport();
         print "Accepted New Client Connection From : $peer_address\n";

        threads->create('handle_connection', $self, $connection, $connected);
    }
    print("Finished listen loop\n");
}

sub handle_connection {
    my($self, $connection, $connected) = @_;
    print("Invoking handler action....\n");
    my $return = $self->action->($self, $connection);
    print("Done handler action, closing connection....\n");
    $connection->close;
    print("Setting connected, which is $connected, to value 0\n");
    $$connected = 0;
    print("Finished handle_connection\n");
    return $return; 
}

sub open_socket {
    print("Opening socket....\n");
    my($self) = @_;
    my $socket = IO::Socket::INET->new(LocalPort => $self->port,
                                       LocalHost => 'localhost',
                                       Reuse     => 1,
                                       Listen    => 1,
                                       Type      => SOCK_STREAM,
                                       Proto     => 'tcp', 
                                       Blocking  => 1)
      or confess "Couldn't create a tcp server on port " . $self->port() . " : $@\n";
    return $socket;
    
}



no Moose;

__PACKAGE__->meta->make_immutable();

1;

