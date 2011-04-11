#!/usr/bin/env perl

use strict;
use warnings;

die 'must pass a numeric argument' unless @ARGV;

use FindBin qw($Bin);
use lib "$Bin/../lib";

use DataFlow;
use Data::Dumper;

my $flow = DataFlow->new(
    procs => [
        sub {
            my $num = shift;

            #print "AAA: ".$num."\n";
            my @res = map { chr( 64 + $_ ) } ( 1 .. $num );

            #print "BBB: ".Dumper(\@res);;
            return [@res];
        },
		DataFlow::Proc->new(
			dump_input => 1,
			dump_output => 1,
			process_into => 0,
			p => sub { return lc(shift); },
		),
    ],
);

$flow->input(shift);

my @res = $flow->flush;
print Dumper(@res);
