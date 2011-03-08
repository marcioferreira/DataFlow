package DataFlow::Node::SQL;

use strict;
use warnings;

# ABSTRACT: A node that generates SQL clauses
# ENCODING: utf8

# VERSION

use Moose;
extends 'DataFlow::Node';

use SQL::Abstract;

my $sql = SQL::Abstract->new;

has 'table' => (
    'is'       => 'ro',
    'isa'      => 'Str',
    'required' => 1
);

has '+process_item' => (
    'default' => sub {
        return sub {
            my ( $self, $data ) = @_;
            my ( $insert, @bind ) = $sql->insert( $self->table, $data );

            # TODO: regex ?
            map { $insert =~ s/\?/'$_'/; } @bind;
            print $insert . "\n";
          }
    }
);

__PACKAGE__->meta->make_immutable;
no Moose;

1;

