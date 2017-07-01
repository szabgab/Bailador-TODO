use v6.c;
use Test;
use File::Temp;

use Bailador::Test;

plan 4;

%*ENV<TODO_ROOT> = tempdir();
%*ENV<P6W_CONTAINER> = 'Bailador::Test';
my $app = EVALFILE "bin/app.pl6";

subtest {
    plan 4;

    my %data = run-psgi-request($app, 'GET', '/');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "text/html"], ''], 'route GET /';
    is %data<err>, '';
    like $html, rx:s/\<title\>Perl 6 Bailador based TODO\<\/title\>/;
    unlike $html, rx:s/hello world/;
}, '/';

# simple add, trimp leading and trailing spaces
subtest {
    plan 2;

    subtest {
        plan 3;
        my %data = run-psgi-request($app, 'POST', '/add', "text=%20%20hello%20world%20%20");
        my $html = %data<response>[2];
        %data<response>[2] = '';
        is-deeply %data<response>, [200, ["Content-Type" => "text/html"], ''], 'route POST /add';
        is %data<err>, '';
        like $html, rx:s/\<h1\>Item added\<\/h1\>/;
    };

    subtest {
        plan 4;

        my %data = run-psgi-request($app, 'GET', '/');
        my $html = %data<response>[2];
        %data<response>[2] = '';
        is-deeply %data<response>, [200, ["Content-Type" => "text/html"], ''], 'route GET /';
        is %data<err>, '';
        like $html, rx:s/\<title\>Perl 6 Bailador based TODO\<\/title\>/;
        like $html, rx:s/\<td\>hello world\<\/td\>/;
    };
}, '/add';

# test that < is not an accepted character
subtest {
    plan 2;

    subtest {
        plan 3;
        my %data = run-psgi-request($app, 'POST', '/add', "text=foo < barbar");
        my $html = %data<response>[2];
        %data<response>[2] = '';
        is-deeply %data<response>, [200, ["Content-Type" => "text/html"], ''], 'route POST /add';
        is %data<err>, '';
        like $html, rx:s/\<h3 id\=\"error\"\>Invalid character \&lt\;\<\/h3\>/;
    };

    subtest {
        plan 6;

        my %data = run-psgi-request($app, 'GET', '/');
        my $html = %data<response>[2];
        %data<response>[2] = '';
        is-deeply %data<response>, [200, ["Content-Type" => "text/html"], ''], 'route GET /';
        is %data<err>, '';
        like $html, rx:s/\<title\>Perl 6 Bailador based TODO\<\/title\>/;
        like $html, rx:s/hello world/;
        unlike $html, rx:s/foo/;
        unlike $html, rx:s/barbar/;
    };
}, '/add';



subtest {
    plan 3;

    my %data = run-psgi-request($app, 'GET', '/about');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "text/html"], ''], 'route GET /';
    is %data<err>, '';
    like $html, rx:s/\<h1\>About the Perl 6 Bailador based TODO\<\/h1\>/;
}, '/';


# vim: expandtab
# vim: tabstop=4

