package Slim::ListExecutor;

use Slim::StatementExecutor;
use Slim::Statement;

=pod

=head1 NAME 

Slim::ListExecutor - process a list of instructions from fitnesse

=head1 Author

Jim Weaver <weaver.je@gmail.com>

=cut

sub new {
	my $class = shift;
	my $self = {};
	bless($self, $class);
	return($self);
}

sub execute {
    my ($self, @instructions) = @_;
    my @responses;
    
    print ("Executing list of instructions of size: ", scalar @instructions, "\n") if $main::debug;
    
    my $instruction;
    my $index = 0;
    my $statement_executor = Slim::StatementExecutor->new();
    
    foreach $instruction (@instructions) {
        my $response = $self->execute_instruction($instruction, $statement_executor);
        $responses[$index] = $response;  
        $index++;
    }
    return @responses;
}

sub execute_instruction {
	my ($self, $instruction, $statement_executor) = @_;
	print("Carrying out instruction: ", @$instruction, "\n") if $main::debug;
	my $statement = Slim::Statement->new($instruction);
	my $response = $statement->execute($statement_executor);
	print("Executed instruction, response to return to fitnesse is: ", @$response, "\n") if $main::debug;
	return $response;
}

1;