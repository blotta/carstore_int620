package CarStore::Cars;

use strict;
use warnings;

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( getCarInfo getCarInfo_fromID getCars decQuantity );
our @EXPORT_OK = qw( getCarInfo getCarInfo_fromID getCars decQuantity );

use DBI;


sub decQuantity {
    my $carname = shift;

    #my $oldqty = getCarInfo($carname)->{qty};

    #print "Car '$carname' has $oldqty. Changing it to ", $oldqty - 1, "\n";
    
    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ UPDATE itemInfo SET qty = qty - 1 WHERE name = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $carname);

    $query_result->execute();

    $db->disconnect();

    return 0;
}

sub getCarInfo {
    my $carname = shift;

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT * FROM itemInfo WHERE name = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $carname);

    $query_result->execute();

    my $car_info = $query_result->fetchrow_hashref();

    $query_result->finish();
    $db->disconnect();

    return $car_info;
}

sub getCarInfo_fromID {
    my $pid = shift;

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT * FROM itemInfo WHERE pid = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $pid);

    $query_result->execute();

    my $car_info = $query_result->fetchrow_hashref();

    $query_result->finish();
    $db->disconnect();

    return $car_info;
}

sub getCars {
    
    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT name FROM itemInfo };
    my $query_result = $db->prepare($sql);
    $query_result->execute();

    my @carnames;

    my @row;
    while ( @row = $query_result->fetchrow_array() ){
        push( @carnames, @row );
        #print join(", ", @row), "\n";
    }

    $db->disconnect();

    my @cars;
    foreach my $carname (@carnames) {
        push( @cars, getCarInfo($carname)); 
    }

    return @cars;
}


1;
