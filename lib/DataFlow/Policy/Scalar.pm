package DataFlow::Policy::Scalar;

use strict;
use warnings;

# ABSTRACT: A ProcPolicy that treats scalars items and pass other types as-is.

# VERSION

use Moose;
with 'DataFlow::Role::ProcPolicy';

use namespace::autoclean;

has '+handlers' => (
    'default' => sub {
        my $self         = shift;
        my $type_handler = {
            'SCALAR' => \&_nop_handle,
            'ARRAY'  => \&_nop_handle,
            'HASH'   => \&_nop_handle,
            'CODE'   => \&_nop_handle,
        };
        return $type_handler;
    },
);

has '+default_handler' => (
    'default' => sub {
        return \&_handle_svalue;
    },
);

__PACKAGE__->meta->make_immutable;

1;

__END__

