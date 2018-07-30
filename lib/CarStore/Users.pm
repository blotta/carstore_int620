package CarStore::Users;

use strict;
use warnings;

use Exporter;
our @ISA = qw( Exporter );
our @EXPORT = qw( do_login checkUserExists getUserInfo getUserState addUser );
our @EXPORT_OK = qw( do_login checkUserExists getUserInfo getUserState addUser );

use DBI;
use Crypt::PasswdMD5;

use CarStore::Postal;

sub do_login{
    my ($user, $pass) = @_;
    my $salt = '100';
    my $enc_pass = apache_md5_crypt($pass, $salt);


    if (checkUserExists($user) <= 0){
        # bring back to login screen
        #print "Check user failed";
        return 0;
    }

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT password FROM users WHERE username = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $user);
    $query_result->execute();

    if( my @row = $query_result->fetchrow_array()){
        if ($enc_pass eq $row[0]){
            return 1;
        } else {
            #print "enc pass does not match: $enc_pass $row[0]";
            return 0;
        }
    }
}

#sub do_logout {
#    $session{logged_in} = 0;
#}

sub addUser {
    my ($username, $password, $fname, $lname, $phone, $street, $pcode, $email, $city, $state) = @_ ;
    my $salt = '100';


    addPostal($pcode, $city, $state);

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    # Get sections
    my $sql = qq{ INSERT INTO users (username, password, fname, lname, phone, street, pcode, email)
               VALUES (?, ?, ?, ?, ?, ?, ?, ?) };

    my $query_result = $db->prepare($sql);

    $query_result->bind_param(1, $username);
    $query_result->bind_param(2, apache_md5_crypt($password, $salt) );
    $query_result->bind_param(3, $fname);
    $query_result->bind_param(4, $lname);
    $query_result->bind_param(5, $phone);
    $query_result->bind_param(6, $street);
    $query_result->bind_param(7, $pcode);
    $query_result->bind_param(8, $email);

    $query_result->execute() or die "Query failed: $DBI::errstr";

    $db->disconnect();
}

sub getUserInfo {
    my $username = shift;

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT * FROM users WHERE username = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $username);

    $query_result->execute();

    my $user_info = $query_result->fetchrow_hashref();

    $query_result->finish();
    $db->disconnect();

    #return %{$user_info};
    return $user_info;
}

sub getUserState {
    my $username = shift;

    my $user_info = getUserInfo($username);
    my $postal_info = getPostalInfo($user_info->{pcode});

    return $postal_info->{province};
}

sub checkUserExists {
    my $username = shift;

    my $db = DBI->connect("dbi:mysql:carstore_int620:localhost","root","toor")
        or die "Database not reachable\n";

    my $sql = qq{ SELECT count(*) FROM users WHERE username = ? };

    my $query_result = $db->prepare($sql);
    $query_result->bind_param(1, $username);

    $query_result->execute();

    my $count = $query_result->fetchrow_array();

    $db->disconnect();

    return $count;
}

1;
