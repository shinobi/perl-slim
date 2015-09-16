package Slim::List::Serializer;

use Encode;

use constant START_STR => "[";
use constant END_STR => "]";

=pod

=head1 NAME 

Slim::ListSerializer - Serialization of list datastructures

=head1 Author

Knut Haugen <knuthaug@gmail.com>

=cut


sub new {
	my $class = shift;
	my @chars;
	my $self = { };
	bless($self, $class);
	load_char_width_library();
	return($self);
}

sub load_char_width_library {
	if ($main::pure_perl_charwidth) {
		require Text::CharWidth::PurePerl;
		Text::CharWidth::PurePerl->import(qw(mbswidth));
	}
	else
	{
		require Text::CharWidth;
		Text::CharWidth->import(qw(mbswidth));
	}
}

sub serialize {

    my ($self, @list) = @_;
    my @out = (START_STR);
    
    push(@out, $self->encode_length( scalar(@list)) );
    push(@out, $self->process_elements(@list));
    push(@out, END_STR);

    join "", @out;

}

=back

=cut

sub process_elements {
    my($self, @list) = @_;

    my @out;
    foreach my $element ( @list ) {
        $element = 'null' unless defined $element;
        $element = $self->serialize(@$element) if ref $element eq 'ARRAY';
        my $element_length = length($element);
        print("Element length calculated: $element_length.\n");
        push(@out, $self->encode_length($element_length));
        push(@out, "$element:");
    }

    join "", @out;
   
}

sub encode_length {
    my($self, $length) = @_;
    sprintf("%06d:", $length);
}

1;
