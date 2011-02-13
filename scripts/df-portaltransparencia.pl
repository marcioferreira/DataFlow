#!/usr/bin/env perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use aliased 'DataFlow::Node';
use aliased 'DataFlow::Node::Chain';
use aliased 'DataFlow::Node::LiteralData';
use aliased 'DataFlow::Node::HTMLFilter';
use aliased 'DataFlow::Node::URLRetriever';
use aliased 'DataFlow::Node::MultiPageURLGenerator';
use aliased 'DataFlow::Node::SQL';

#use Scalar::Util qw/reftype/;

my $base = join( '/',
    q{http://www.portaltransparencia.gov.br},
    q{ceis}, q{EmpresasSancionadas.asp?paramEmpresa=0} );

my $chain = Chain->new(
    initial_data  => [ $base ],
    links => [
        #DumperNode->new,
        MultiPageURLGenerator->new(
            first_page => -2,
            #last_page     => 35,
            produce_last_page => sub {
                my $url = shift;

                use DataFlow::Node::URLRetriever::Get;
                use HTML::TreeBuilder::XPath;

                #print STDERR qq{produce_last_page url = $url\n};
                my $get  = DataFlow::Node::URLRetriever::Get->new;
                my $html = $get->get($url);

                #print STDERR 'html = '.$html."\n";
                my $texto =
                  HTML::TreeBuilder::XPath->new_from_content($html)
                  ->findvalue('//p[@class="paginaAtual"]');
                die q{Não conseguiu determinar a última página} unless $texto;
                return $1 if $texto =~ /\d\/(\d+)/;
            },
            make_page_url => sub {
                my ( $self, $url, $page ) = @_;

                use URI;

                my $u = URI->new($url);
                $u->query_form( $u->query_form, Pagina => $page );
                return $u->as_string;
            },
        ),
        #DumperNode->new,
        URLRetriever->new( process_into => 1, ),
        #DumperNode->new,
        HTMLFilter->new(
            search_xpath =>
              '//div[@id="listagemEmpresasSancionadas"]/table/tbody/tr',
        ),
        #DumperNode->new,
        HTMLFilter->new(
            search_xpath => '//td',
            result_type  => 'VALUE',
            ref_result   => 1,
        ),
#        Node->new(
#            process_into => 1,
#            process_item => sub {
#                shift; print STDERR 'type = ', shift, "\n";
#            },
#        ),
        Node->new(
            process_into => 1,
            process_item => sub {
                shift; local $_ = shift;
                s/^\s*//; s/\s*$//;
                return $_;
            }
        ),
        SQL->new( table => 'ceis' ),
    ],
);

$chain->flush;

