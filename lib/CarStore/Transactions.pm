package CarStore::Transactions;

use strict;
use warnings;

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( addTransaction );
our @EXPORT_OK = qw( addTransaction );

use DBI;

use lib '/export/srv/www/vhosts/main/store_int620/lib';
use CarStore::Cars;
use CarStore::Users;

sub addTransaction {
    my ($username, $carname, $paymentInfo, $cardType, $price, $expiry, $sec) = @_ ;

    my $cid = getUserInfo($username)->{cid};
    my $pid = getCarInfo($carname)->{pid};

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    # Get sections
    my $sql = qq{ INSERT INTO transactions (cid, pid, paymentInfo, cardType, price, expiry, sec)
               VALUES ( ?, ?, ?, ?, ?, ?, ?) };

    my $query_result = $db->prepare($sql);

    $query_result->bind_param(1, $cid);
    $query_result->bind_param(2, $pid);
    $query_result->bind_param(3, $paymentInfo);
    $query_result->bind_param(4, $cardType);
    $query_result->bind_param(5, $price);
    $query_result->bind_param(6, $expiry);
    $query_result->bind_param(7, $sec);

    $query_result->execute() or die "Query failed: $DBI::errstr";


    $query_result->finish();
    $db->disconnect();

    decQuantity($carname);

    return 1;
}

1;
