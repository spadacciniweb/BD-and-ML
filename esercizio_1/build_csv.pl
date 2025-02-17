#!/usr/bin/env perl

=head
bank_account
"username","euro","datetime"
username String
euro     2 decimal value
datetime YYYY-MM-DDThh:mm:ss

bank_movements
"username","type","euro","datetime"
username String
type     String
euro     2 decimal value
datetime YYYY-MM-DDThh:mm:ss.mil
=cut

use strict;
use warnings;

use Text::CSV;
use Data::Dumper;
use DateTime::HiRes;
use ENV::Util;

ENV::Util::load_dotenv($ENV{HOME}.'/.env/bd_and_ml_25_esercizio_1');

my $records = $ENV{NRECORDS} or die "Need to get number of records to save\n";
die "The number of records must be integer\n"
    if $records !~ /^\d+$/;

my $dt_start = time();

deletePrev()
    if $ENV{DELETE};

my @username = qw/ ms john bill/;
my @type = qw/ ADD SUB /;

build_accounts()
    if $ENV{DELETE};
build_movements();

my $delta_t = time() - $dt_start;
my_log( sprintf "END in %d minutes %d seconds", $delta_t / 60, $delta_t % 60 )
    if $ENV{DEBUG};

exit 0;

sub my_log {
    $_ = shift;
    printf "[%s] %s\n", DateTime->now->datetime(' '), $_ || '-> missing <-';
}

sub build_accounts {
    my_log( sprintf "build file '%s'...", $ENV{BANK_ACCOUNTS})
        if $ENV{DEBUG};
    my $csv = Text::CSV->new({binary => 1, eol => $/, always_quote => 1 })
        or die "Failed to create a CSV handle: $!";
    open my $fh, ">:encoding(utf8)", $ENV{BANK_ACCOUNTS}
        or die "failed to create $ENV{BANK_ACCOUNTS}: $!";

    my (@heading) = ("username", "euro", "datetime");
    $csv->print($fh, \@heading);

    foreach my $i (0..$#username) {
        my $dt = DateTime::HiRes->now();
        my (@datarow) = ($username[$i],
                         (sprintf "%.2f", rand(10_000)),
                         sprintf("%s", $dt->datetime())
                        );
        $csv->print($fh, \@datarow);
    }

    close $fh or die "failed to close $ENV{BANK_ACCOUNTS}: $!";
}

sub build_movements {
    my_log( sprintf "build file '%s'...", $ENV{BANK_MOVEMENTS})
        if $ENV{DEBUG};
    my $csv = Text::CSV->new({binary => 1, eol => $/, always_quote => 1 })
        or die "Failed to create a CSV handle: $!";
    open my $fh, ">>:encoding(utf8)", $ENV{BANK_MOVEMENTS}
        or die "failed to create $ENV{BANK_MOVEMENTS}: $!";

    if ($ENV{DELETE}) {
        my (@heading) = ("username", "type", "euro", "datetime.mil");
        $csv->print($fh, \@heading);
    }

    foreach my $i (1..$records) {
        my_log( sprintf "write %d-th line...", $i)
            if $i % 1000 == 0;
        my $dt = DateTime::HiRes->now();
        my (@datarow) = ($username[$i % scalar(@username)],
                         $type[$i % scalar(@type)],
                         (sprintf "%.2f", (rand(1_000)) ),
                         sprintf("%s.%03d", $dt->datetime(), $dt->millisecond)
                        );
        $csv->print($fh, \@datarow);
    }

    close $fh or die "failed to close $ENV{BANK_MOVEMENTS}: $!";
}

sub deletePrev {
    unlink $ENV{BANK_MOVEMENTS}, $ENV{BANK_ACCOUNTS};
    my_log( sprintf "delete file '%s'", $ENV{BANK_MOVEMENTS})
        if $ENV{DEBUG};
    
}
