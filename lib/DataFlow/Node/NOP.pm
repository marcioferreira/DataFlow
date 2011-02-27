package DataFlow::Node::NOP;
#ABSTRACT: A No-Op node, input data is passed unmodified to the output

use strict;
use warnings;

# VERSION

use Moose;
extends 'DataFlow::Node';

has '+process_item' => (
    default => sub {
        return sub { shift; return shift; }
    },
);

__PACKAGE__->meta->make_immutable;

1;

__END__

=pod

=head1 NAME

DataFlow::Node::NOP - A No-Op node, input data is passed unmodified to the output

=head1 SYNOPSIS

    use DataFlow::NOP;

    my $nop = DataFlow::Node::NOP->new;

    my $result = $nop->process( 'abc' );
    # $result == 'abc'

=head1 DESCRIPTION

This class represents a no-op node: the very input is passed without
modifications to the output.

This class is more useful as parent class than by itself.

=head1 METHODS

The interface for C<DataFlow::Node::NOP> is the same of
C<DataFlow::Node>.

=head1 DEPENDENCIES

L<DataFlow::Node>

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

Please report any bugs or feature requests to
C<bug-dataflow@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.

=cut
