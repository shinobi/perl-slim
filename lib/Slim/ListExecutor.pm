package Slim::ListExecutor;

use Moose;
use namespace::autoclean;

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
    foreach $instruction (@instructions) {
        my $operation = @$instruction[1];
        print("Operation for instruction is $operation\n");
        
        for ($operation) {
            if (/make/) {
                print("Make operation detected.\n");
                $responses[$index] = ["decisionTable_0_$index", "OK"];
            }
            if (/call/) {
                my $functionName = @$instruction[3];
                print("Call operation detected for function with name $functionName.\n");
                if ($functionName eq "outputValue") {
                    $responses[$index] = ["decisionTable_0_$index", "9"];
                }
                else {
                    $responses[$index] = ["decisionTable_0_$index", "/_VOID_/"];
                }
            }
            else {
                print("Unrecognized operation detected.");
            }
        }
        
        $index++;
    }
    @responses;
}

no Moose;
__PACKAGE__->meta->make_immutable();

1;