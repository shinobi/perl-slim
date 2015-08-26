package Slim::SocketHandler;

use threads;
use threads::shared;
use IO::Socket;

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

sub new {
	my $class = shift;
	my $self = {
		port => shift,
		action => undef,
		listener_thread => undef,
		socket => undef
	};
	bless($self, $class);
	return($self);
}

sub port {
	my $self = shift;
	return $self->{port};
}

sub action {
	my $self = shift;
	return $self->{action};
}

sub listener_thread {
	my $self = shift;
	return $self->{listener_thread};
}

sub socket {
	my $self = shift;
	return $self->{socket};
}

sub set_port {
	my $self = shift;
	$self->{port} = shift;
	return;
}

sub set_action {
	my $self = shift;
	$self->{action} = shift;
	return;
}

sub set_listener_thread {
	my $self = shift;
	$self->{listener_thread} = shift;
	return;
}

sub set_socket {
	my $self = shift;
	$self->{socket} = shift;
	return;
}


sub handle { 
    my($self, $action, $connected) = @_;
    $self->set_action($action);
    $self->set_socket($self->open_socket() );
 
    $self->set_listener_thread(threads->create( 'listen', $self, $connected));
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
    print("Here, port is: ", $self->port, "\n");
    while ( my $connection = $self->{socket}->accept() ) {
    	print("Accepted connection on socket.\n") if $main::debug;
   		my $peer_address = $connection->peerport();
     	threads->create('handle_connection', $self, $connection, $connected);
    }
}

sub handle_connection {
    my($self, $connection, $connected) = @_;
    my $return = $self->action()->($self, $connection);
    $connection->close;
    $$connected = 0;
    print("Finished handle_connection, closed connection.\n") if $main::debug;;
    return $return;
}

sub open_socket {
    my($self) = @_;
    my $socket = IO::Socket::INET->new(LocalPort => $self->port,
                                       LocalHost => 'localhost',
                                       Reuse     => 1,
                                       Listen    => 1,
                                       Type      => SOCK_STREAM,
                                       Proto     => 'tcp', 
                                       Blocking  => 1);
    return $socket;
    
}

1;

