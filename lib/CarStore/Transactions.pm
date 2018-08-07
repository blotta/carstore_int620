package CarStore::Transactions;

use strict;
use warnings;

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( addTransaction transactionDetails _sendEmailReceipt userTransactions );
our @EXPORT_OK = qw( addTransaction transactionDetails _sendEmailReceipt userTransactions );

use DBI;

use lib '/export/srv/www/vhosts/main/store_int620/lib';
use CarStore::Cars;
use CarStore::Users;
use CarStore::Postal;

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

    _sendEmailReceipt($username, $carname, $paymentInfo, $cardType, $price);

    return 1;
}

sub _sendEmailReceipt {
    my ($username, $carname, $paymentInfo, $cardType, $price) = @_;

    my $user = getUserInfo($username);
    my $postal = getPostalInfo($user->{pcode});
    my $car = getCarInfo($carname);

    open (MAIL, "|/usr/lib/sendmail -t");
    #open (MAIL, ">>", '/export/srv/www/vhosts/main/store_int620/sentmail') 
    #    or die "Could not open the file: $!";

    print MAIL "From: orders\@AutoV.com\n";
    print MAIL "Subject: Thank you for your purchase!\n";
    print MAIL "To: $user->{email}\n\n";
    print MAIL "Great news $user->{fname}! Your purchase of $car->{name} was a success\n";
    print MAIL "---------------------------------------------------------------------------------\n";
    print MAIL "$car->{name}\t\tTotal: $price\n";
    print MAIL "Payment: $cardType\t************", substr($paymentInfo, -4) ,"\n";
    print MAIL "Customer Info:\n\n";
    print MAIL "Name: $user->{fname} $user->{lname}\n";
    print MAIL "Street: $user->{street}\n";
    print MAIL "City: $postal->{city}\n";
    print MAIL "Province/State: $postal->{province}\n";
    print MAIL "Postal/Zip Code: $user->{pcode}\n";
    print MAIL "Phone Number: $user->{phone}";

    #print "From: orders\@AutoV.com\n";
    #print "Subject: Thank you for your purchase!\n";
    #print "To: $user->{email}\n\n";
    #print "Great news $user->{fname}! Your purchase of $car->{name} was a success\n";
    #print "---------------------------------------------------------------------------------\n";
    #print "$car->{name}\t\tTotal: $price\n";
    #print "Payment: $cardType\t$paymentInfo\n";
    #print "Customer Info:\n\n";
    #print "Name: $user->{fname} $user->{lname}\n";
    #print "Street: $user->{street}\n";
    #print "City: $postal->{city}\n";
    #print "Province/State: $postal->{province}\n";
    #print "Postal/Zip Code: $user->{pcode}\n";
    #print "Phone Number: $user->{phone}";

    close (MAIL);
}

sub userTransactions {
    my $username = shift;

    my @ret;

    my $cid = getUserInfo($username)->{cid};

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT * FROM transactions WHERE cid = ? };

    my $query_result = $db->prepare($sql);

    $query_result->bind_param(1, $cid);
    
    $query_result->execute();

    my $row;
    while ($row = $query_result->fetchrow_hashref) {
        push( @ret, $row );
    }

    $query_result->finish();
    $db->disconnect();

    return \@ret;
}

sub transactionDetails {
    my $t = shift;

    my %ret;

    my $user = getUserInfo_fromID($t->{cid}) or die "ERROR: $!";
    my $car = getCarInfo_fromID($t->{pid});

    $ret{user} = $user;
    $ret{car} = $car;
    $ret{transaction} = $t;

    return \%ret;
}


1;
