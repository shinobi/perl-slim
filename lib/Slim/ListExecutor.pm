package Slim::ListExecutor;

use Moose;
use namespace::autoclean;

use Slim::StatementExecutor;
use Slim::Statement;

=pod

=head1 NAME 

Slim::ListExecutor - process a list of instructions from fitnesse

=head1 Author

Jim Weaver <weaver.je@gmail.com>

=cut

sub execute {
    my ($self, @instructions) = @_;
    my @responses;
    
    print "Executing list of instructions of size:" . scalar @instructions;
    print "\n";
    
    my $instruction;
    my $index = 0;
    my $statement_executor = Slim::StatementExecutor->new();
    
    foreach $instruction (@instructions) {
        print("current instruction in loop", @$instruction, "\n");
		my $statement = Slim::Statement->new( {instruction_elements => $instruction} );
		my $response = $statement->execute($statement_executor);
		print("Executed statement, response is: ", $response, "\n");
		print("Response as array is: ", @$response, "\n");
        $responses[$index] = $response;  
        print("Response just added to responses at index $index, value at index is: ", $responses[$index], "\n");      
        $index++;
    }
    
    print("About to return, responses is: ", @responses, "\n");
    return @responses;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;