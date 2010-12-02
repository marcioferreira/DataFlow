
package OpenData::Transformer::HTML;

use Moose;
use Data::Dumper;
use Scalar::Util qw/reftype/;
use HTML::TreeBuilder::XPath;

with 'OpenData::Transformer';

has node_xpath => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has value_xpath => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has _data => (
    is  => 'rw',
    isa => 'Any',
);

sub _transform_element {
    my $self = shift;
    #warn 'vanilla _transform_element';
    return wantarray ? @_ : shift @_;
}

sub transform {
    my $self = shift;
    my $raw  = shift;

    my $reftype = reftype($raw) || '';
    return unless $reftype eq 'ARRAY' && scalar( @{$raw} );

    $self->_data( [] );
    foreach my $part ( @{$raw} ) {
        my $tree  = HTML::TreeBuilder::XPath->new_from_content($part);
        my $nodes = $tree->findnodes( $self->node_xpath );

        $self->confess( 'Cannot match node_xpath (' . $self->node_xpath . ')' )
          unless scalar( @{$nodes} );

        #warn 'node = '.$self->node_xpath;
        #warn "\nnodes = ". Dumper($nodes);
        foreach my $value ( @{$nodes} ) {
            #warn 'value = '. $value->as_HTML;
            my $value_html = HTML::TreeBuilder::XPath->new_from_content( $value->as_HTML );
            my $cut = [ $value_html->findvalues( $self->value_xpath ) ];

            $self->confess(
                'Cannot match value_xpath (' . $self->value_xpath . ')' )
              unless scalar( @{$cut} );

            #warn 'cut = '.Dumper($cut);
            my $d = $self->_transform_element($cut);
            push @{ $self->_data }, $d;

            $value_html->delete;
        }
        $tree->delete;
    }

    #warn 'transformed data = ' . Dumper($self->_data);
    return $self->_data;
}

1;

