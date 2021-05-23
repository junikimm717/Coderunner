#!/usr/bin/env perl -w

use strict;
use warnings;
use diagnostics;

use JSON;
use File::Basename;
use File::Spec;

my $dirname = File::Spec->rel2abs(dirname(__FILE__));


# Create a code runner script (run any applicable file)
# 

# verify that the arguments are passed in validly.


sub verifiers {
    return ($#ARGV >= 0);
}

if (!verifiers()) {
    say STDERR "arguments passed improperly.";
    exit 1;
}

if (! -e "$dirname/output") {
    system("$dirname/langs.pl");
}

# configuration hash for determining regular expressions to language types.

sub construct_json {
    my $f = shift or die "not enough arguments";
    if (open(FH, "<", $f)) {
        my $s = "";
        while (<FH>) {
            $s = $s . $_;
        }
        return %{ decode_json $s };
    }
    return ();
}

my %languages = construct_json("$dirname/output/re.cr.json");


my @files = @ARGV;

sub ftype {
    my $f = $_[0];
    for my $k (keys %languages) {
        if ($f =~ /$k/) {
            return $languages{$k};
        }
    }
    return "undefined";
}

sub run {
    my $file = $_[0];
    my $filetype = ftype $file;

    # configuration hash for determining how to interpret code.
    my %execute = construct_json("$dirname/output/run.cr.json");

    if (not -e "$file") {
        print "$file does not exist.\n";
        return;
    }
    for my $k (keys %execute) {
        $execute{$k} = sprintf ("$execute{$k}", "$file");
        if ($filetype eq $k) {
            system("$execute{$k}");
            return;
        }
    }
    print "$file cannot be executed.\n";
    return;
}

run($ARGV[0]);
