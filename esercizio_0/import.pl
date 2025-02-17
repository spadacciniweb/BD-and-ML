#!/usr/bin/env perl

=head
"Dimensions.Height","Dimensions.Length","Dimensions.Width","Engine Information.Driveline","Engine Information.Engine Type","Engine Information.Hybrid","Engine Information.Number of Forward Gears","Engine Information.Transmission","Fuel Information.City mpg","Fuel Information.Fuel Type","Fuel Information.Highway mpg","Identification.Classification","Identification.ID","Identification.Make","Identification.Model Year","Identification.Year","Engine Information.Engine Statistics.Horsepower","Engine Information.Engine Statistics.Torque"

Key 	                List of... 	Comment 	                                Example Value
Dimensions.Height 	Integer 	Unknown values are stored as 0. Unfortunately,
                                        many cars do not report this data. 	        140
Dimensions.Length 	Integer 	Unknown values are stored as 0. Unfortunately,
                                        many cars do not report this data. 	        143
Dimensions.Width 	Integer 	Unknown values are stored as 0. Unfortunately,
                                        many cars do not report this data.              202
Engine Information.Driveline
                        String 	        A string representing whether this is
                                        "Rear-wheel drive", "Front-wheel drive", or
                                        "All-wheel drive". 	                        "All-wheel drive"
Engine Information.Engine Type
                        String 	        How many cylinders are in this engine.
                                        Most cars are either a 6-cylinder or
                                        an 8-cylinder. 	                                "Audi 3.2L 6 cylinder 250hp 236ft-lbs"
Engine Information.Hybrid
                        Boolean 	Whether this is a hybrid engine
                                        or not - that is, if it uses both an internal
                                        combustion engine and an electric motor. 	True
Engine Information.Number of Forward Gears
                        Integer 	The number of forward gears. If no information
                                        is available, it is coded as 0. 	        6
Engine Information.Transmission
                        String 	        The full name of this type of transmission,
                                        based on its Classification and number
                                        of forward gears. 	                        "6 Speed Automatic Select Shift"
Fuel Information.City mpg
                        Integer 	The miles-per-gallon this car gets on average
                                        in cities. 	                                18
Fuel Information.Fuel Type
                        String 	        Whether this car takes "Gasoline",
                                        "Diesel fuel", "Electricity",
                                        "Compressed natural gas", or "E85" (a term that
                                        refers to high-level ethanol-gasoline blends
                                        containing 51%-83% ethanol). If it is unknown,
                                        it is left blank. 	                        "Gasoline"
Fuel Information.Highway mpg
                        Integer 	The miles-per-gallon this car gets on average
                                        on highways. 	                                25
Identification.Classification
                        String 	        Whether this is a "Manual transmission" or
                                        an "Automatic transmission". If it is unknown,
                                        it is left blank. 	                        "Automatic transmission"
Identification.ID 	String 	        A unique ID for this particular car, using
                                        the year, make, model, and transmission type. 	"2009 Audi A3 3.2"
Identification.Make 	String 	        The maker for this car. 	                "Audi"
Identification.Model Year
                        String 	        The specific name/year for this car. 	        "2009 Audi A3"
Identification.Year 	Integer 	The year that this car was released. 	        2009
Engine Information.Engine Statistics.Horsepower
                        Integer 	A measure of the engine's power. A unit
                                        of power equal to 550 foot-pounds
                                        per second (745.7 watts). 	                250
Engine Information.Engine Statistics.Torque
                        Integer 	The torque of the engine, measured in lb/ft.
                                        When an engine is said to make "200 lb-ft
                                        of torque", it means that 200 pounds of force
                                        on a 1-foot lever is needed to stop its motion. 236
=cut

use strict;
use warnings;

use Text::CSV;
use Data::Dumper;
use DateTime;
use DBI;
use ENV::Util;

ENV::Util::load_dotenv($ENV{HOME}.'/.env/bd_and_ml_25_esercizio_0');

my $dsn = sprintf("dbi:mysql:dbname=%s;host=%s;port=%s;",
                    $ENV{DB_NAME}, $ENV{DB_HOST}, $ENV{DB_PORT}
                 ) or die "Connection error: $DBI::errstr";
my $dbh = DBI->connect($dsn, $ENV{DB_USER}, $ENV{DB_PWD})
            or die "Connection error: $DBI::errstr";

my $file = $ARGV[0] or die "Need to get CSV file on the command line\n";

my $dt_start = time();

deletePrev();

my $foreignKeys = getTables();
if ($ENV{DEBUG}) {
    my_log( sprintf "Dump foreign keys\n%s", Dumper($foreignKeys) )
}
 
my $csv = Text::CSV->new({
  binary    => 1,
  auto_diag => 1,
  sep_char  => ','
});

my $line = 0;
open(my $data, '<:encoding(utf8)', $file) or die "Could not open '$file' $!\n";
$csv->getline( $data ); # skip header
my $sql_car = 'INSERT INTO car (height, length, width, driveline_id, engine_type, hybrid, forward_gears, trasmission, fuel_city, fuel_type_id, fuel_highway, classification_id, identification_key, make_id, model_year, year, horsepower, torque) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)';
my $sth_car = $dbh->prepare($sql_car);
while (my $fields = $csv->getline( $data )) {
    $line++;
    my_log( sprintf "line %d...", $line )
        if $line % 1000 == 0;
    #warn Dumper($fields);
    my %car = (
        height             => $fields->[0],
        length             => $fields->[1],
        width              => $fields->[2],
        driveline_id       => getKey('driveline', $fields->[3]),
        engine_type        => $fields->[4],
        hybrid             => ($fields->[5] =~ /True/i)
            ? 1
            : 0,
        forward_gears      => $fields->[6],
        trasmission        => $fields->[7],
        fuel_city          => $fields->[8],
        fuel_type_id       => getKey('fuel_type', $fields->[9]),
        fuel_highway       => $fields->[10],
        classification_id  => getKey('classification', $fields->[11]),
        identification_key => $fields->[12],
        make_id            => getKey('make', $fields->[13]),
        model_year         => $fields->[14],
        year               => $fields->[15],
        horsepower         => $fields->[16],
        torque             => $fields->[17],
    );
    $sth_car->execute( $car{height}, $car{length}, $car{width}, $car{driveline_id},
                       $car{engine_type}, $car{hybrid}, $car{forward_gears},
                       $car{trasmission}, $car{fuel_city}, $car{fuel_type_id},
                       $car{fuel_highway}, $car{classification_id},
                       $car{identification_key}, $car{make_id}, $car{model_year},
                       $car{year}, $car{horsepower}, $car{torque}
                     );
}
if (not $csv->eof) {
  $csv->error_diag();
}
close $data;

my $delta_t = time() - $dt_start;
my_log( sprintf "END in %d minutes %d seconds", $delta_t / 60, $delta_t % 60 )
    if $ENV{DEBUG};

exit 0;

sub my_log {
    $_ = shift;
    printf "[%s] %s\n", DateTime->now->datetime(' '), $_ || '-> missing <-';
}

sub getTables {
    return { 'driveline'      => getHashTable('driveline'),
             'fuel_type'      => getHashTable('fuel_type'),
             'classification' => getHashTable('classification'),
             'make'           => getHashTable('make')
           };
}

sub getHashTable {
    my $table = shift;
    my $sql = sprintf "SELECT id, description FROM %s", $table;
    my $hash_ref = $dbh->selectall_hashref($sql, 'description');
    my %hash = map { $_ => $hash_ref->{$_}->{id} }
                keys %{ $hash_ref };
    return \%hash;
}

sub getKey {
    my $table = shift;
    my $key = shift;
    return $foreignKeys->{ $table }->{ $key }
        if $foreignKeys->{ $table }->{ $key };
    $foreignKeys->{ $table }->{ $key } = (scalar keys %{ $foreignKeys->{ $table } }) + 1;
    my $sth = $dbh->prepare( sprintf "INSERT INTO %s (id, description) VALUES (?, ?)", $table );
    $sth->execute($foreignKeys->{ $table }->{ $key }, $key );
    my_log( sprintf "insert key '%s' with id '%d' into table '%s'",
                $key, $foreignKeys->{ $table }->{ $key }, $table
          )
        if $ENV{DEBUG};
    return $foreignKeys->{ $table }->{ $key };
}

sub deletePrev {
    my @tables = qw/ car /;
    push @tables, qw/ driveline fuel_type classification make /
        if $ENV{DELETE};
    foreach my $table (@tables) {
        my $sql = sprintf "DELETE FROM %s", $table;
        $dbh->do( $sql );
        my_log( sprintf "DELETE TABLE %s", $table)
            if $ENV{DEBUG};
    }
}
