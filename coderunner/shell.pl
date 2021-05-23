#!/usr/bin/env perl -w

use strict;
use warnings;
use diagnostics;

use JSON;
use Data::Dumper;
use File::Basename;
use File::Spec;
use Cwd;

# As there are multiple interpreters for shell scripts,
# This script chooses the one that you use.

my $dirname = File::Spec->rel2abs(dirname(__FILE__));

# get
my $shell = $ENV{'SHELL'};
my $interpreter;
my @available = ('/zsh', '/bash', '/sh', '/dash');

foreach my $s (@available) {
    if ($shell =~ /$s$/) {
        $interpreter = $s;
        last;
    }
}

if (! $interpreter) {
    print "$shell is not supported.";
    exit 1;
}

sub fromjson {
    my $file = shift or die "no args";
    my $handler;
    open ($handler, "<", $file) or die "$file cannot be opened";
    my $str = "";
    while (<$handler>) {
        $str = $str . $_;
    }
    close($handler);
    return decode_json($str);
}

my %re = %{ fromjson("$dirname/output/re.cr.json") };
my %ru = %{ fromjson("$dirname/output/run.cr.json") };

$re{".sh\$"} = "shell";
$ru{"shell"} = "$interpreter %s";

open(RE, ">", "$dirname/output/re.cr.json") or die "$dirname/output";
open(RU, ">", "$dirname/output/run.cr.json") or die "$dirname/output";

print RE encode_json(\%re);
print RU encode_json(\%ru);

close(RE);
close(RU);
