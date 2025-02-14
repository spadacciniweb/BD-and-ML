use strict;
use warnings;

use MongoDB;
use DateTime;
use ENV::Util;
use JSON;
use Parallel::ForkManager;
use Data::Dumper;

ENV::Util::load_dotenv($ENV{HOME}.'/.env/bd_and_ml_25_esercizio_2');

my $dt_start = DateTime->now;

my $client = MongoDB::MongoClient->new;
my $db = $client->get_database( 'bd_and_ml' );
my $bd_and_ml = $db->get_collection( 'esercizio_2' );

deletePrev()
    if $ENV{DELETE};

my @filename = glob("$ENV{ES_2_DIR}/*.json");
parallel_mongodb();

my $delta_t = DateTime->now - $dt_start;
my_log( sprintf "END in %d minutes %d seconds", $delta_t->minutes, $delta_t->seconds )
    if $ENV{DEBUG};

exit 0;

sub my_log {
    $_ = shift;
    printf "[%s] %s\n", DateTime->now, $_ || '-> missing <-';
}

sub deletePrev {
    $bd_and_ml->delete_many({});
    my_log("delete collection")
        if $ENV{DEBUG};
}

sub parallel_mongodb {
    my_log( sprintf "Start read %s/ in parallel", $ENV{ES_2_DIR});

    my $pm = Parallel::ForkManager->new( $ENV{MAX_PROCESSES} || 8 );
    foreach my $i (0..($ENV{MAX_PROCESSES}-1) ) {
        $pm->start and next;

        my @slice = @filename[ map { $_ % $ENV{MAX_PROCESSES} == $i ? $_ : () } 0 .. $#filename ];
        my_log( sprintf "child [%d] start reading %d files...", $i, scalar @slice )
            if $ENV{DEBUG}; # and $i % 100 == 0;
        my @hash;
        foreach my $filename (@slice) {
            my $json_text = do {
               open(my $json_fh, "<:encoding(UTF-8)", $filename)
                  or die("Can't open \"$filename\": $!\n");
               local $/;
               <$json_fh>;
        #       close $json_fh or die "can't read close '$filename': $!";
            };

            my $full_hash = decode_json $json_text;
            foreach my $hash ( @{ $full_hash->{data} } ) {
                if ($hash and $hash->{temp}) {
                    push @hash, $hash;
                } else {
                    print 'm'
                        if $ENV{TRACE};
                }
            }
        }

        my_log( sprintf "child [%d] start inserting %d JSON...", $i, scalar @hash )
            if $ENV{DEBUG};
        $client->reconnect;
        $bd_and_ml->insert_many( \@hash )
            if scalar @hash;
        $pm->finish;
    }

    $pm->wait_all_children;

    my_log( sprintf "%d files have been readed", scalar @filename )
        if $ENV{DEBUG};
}
