package CarStore::Postal;

use strict;
use warnings;

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( addPostal checkPostalExists );
our @EXPORT_OK = qw( addPostal checkPostalExists );

use DBI;


sub addPostal {
    my $postal = shift;

    if (checkPostalExists($postal) <= 0 ){
        my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
            or die "Database not reachable\n";

        my $sql = qq{ INSERT INTO postal ( pcode, city, province ) VALUES ( ?, ?, ? ) };
        my $query_result = $db->prepare($sql);

        $query_result->bind_param(1, $postal);
        $query_result->bind_param(2, 'Toronto');
        $query_result->bind_param(3, 'ON');

        $query_result->execute() or die "Query failed: $DBI::errstr";

        $db->disconnect();

        #print "Created postal";
    }else{
        #print "Postal exists";
    }
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
