package CarStore::Postal;

use strict;
use warnings;

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( addPostal getPostalInfo checkPostalExists );
our @EXPORT_OK = qw( addPostal getPostalInfo checkPostalExists );

use DBI;


sub addPostal {
    my $postal = shift;
    my $city = shift;
    my $state = shift;

    if (checkPostalExists($postal) <= 0 ){
        my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
            or die "Database not reachable\n";

        my $sql = qq{ INSERT INTO postal ( pcode, city, province ) VALUES ( ?, ?, ? ) };
        my $query_result = $db->prepare($sql);

        $query_result->bind_param(1, $postal);
        $query_result->bind_param(2, $city);
        $query_result->bind_param(3, $state);

        $query_result->execute() or die "Query failed: $DBI::errstr";

        $db->disconnect();

        #print "Created postal";
    }else{
        #print "Postal exists";
    }
}

sub getPostalInfo {
    my $pcode = shift;

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT * FROM postal WHERE pcode = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $pcode);

    $query_result->execute();

    my $postal_info = $query_result->fetchrow_hashref();

    $db->disconnect();

    return $postal_info;
}

sub checkPostalExists {
    my $pcode = shift;

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT count(*) FROM postal WHERE pcode = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $pcode);

    $query_result->execute();

    my $count = $query_result->fetchrow_array();

    $db->disconnect();

    return $count;
}
