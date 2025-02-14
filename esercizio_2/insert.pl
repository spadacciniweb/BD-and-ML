use strict;
use warnings;

use MongoDB;
use DateTime;
use ENV::Util;
use JSON;
use Data::Dumper;

ENV::Util::load_dotenv($ENV{HOME}.'/.env/bd_and_ml_25_esercizio_2');

my $client = MongoDB::MongoClient->new;
my $db = $client->get_database( 'bd_and_ml' );

my $bd_and_ml = $db->get_collection( 'esercizio_2' );

my $dt_start = DateTime->now;

deletePrev()
    if $ENV{DELETE};

insertJson();

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

sub insertJson {
    my $dir = $ENV{ES_2_DIR};
    my $i = 0;
    my_log( sprintf "Start read %s/", $ENV{ES_2_DIR});
    foreach my $filename (glob("$dir/*.json")) {
        $i++;
        my_log( sprintf "read %d-th file...", $i )
            if $ENV{TRACE}
               or
               $ENV{DEBUG} and $i % 100 == 0;
        #printf "%s\n", $filename;
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
                $bd_and_ml->insert_one( $hash );
            } else {
                print 'm'
                    if $ENV{TRACE};
            }
        }
    }
    my_log( sprintf "%d files have been readed", $i )
        if $ENV{TRACE}
               or
               $ENV{DEBUG};
}
