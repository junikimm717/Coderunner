#!/usr/bin/env perl -w

use strict;
use warnings;
use diagnostics;

use JSON;
use Data::Dumper;
use File::Basename;
use File::Spec;
use Cwd;

my $dirname = File::Spec->rel2abs(dirname(__FILE__));

# gets and dumps all available languages.

my %langs = ();
if (open(FR, "<", "$dirname/languages.json")) {
    my $json = "";
    while (<FR>) {
        chomp;
        $json = $json . $_;
    }
    %langs = %{ decode_json ($json) };
    close(FR);
}
else {
    print "there will be no supported languages";
}

sub cmdexists {
    my $cmd = shift() || die "cmdexists did not get an arg.";
    if (system("which $cmd > /dev/null") != 0) {
        return 0;
    }
    return 1;
}

if (! -e "$dirname/output") {
    mkdir "output";
}

open (RE, ">", "$dirname/output/re.cr.json") or 
die "$dirname/output/re.cr.json cannot be opened";

open (RU, ">", "$dirname/output/run.cr.json") or 
die "$dirname/output/run.cr.json cannot be opened";

my %re = ();
my %ru = ();

foreach my $lang (keys %langs) {
    my $rule = $langs{$lang}{"rule"};
    my $run = $langs{$lang}{"run"};
    my @a = split (/\s+/, $run);
    my $prog = $a[0] || die "impossible";
    
    if (cmdexists($prog)) {
        $re{$rule} = $lang;
        $ru{$lang} = $run;
    }
}

print RE encode_json(\%re);
print RU encode_json(\%ru);

close(RE);
close(RU);

# Add shells
system("$dirname/shell.pl")
