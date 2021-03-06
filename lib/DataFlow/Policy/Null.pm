package DataFlow::Policy::Null;

use strict;
use warnings;

# ABSTRACT: A ProcPolicy that returns undef to any type

# VERSION

use Moose;
with 'DataFlow::Role::ProcPolicy';

use namespace::autoclean;

has '+default_handler' => (
    'default' => sub {
        sub { }
    },
);

__PACKAGE__->meta->make_immutable;

1;

__END__

