use v6.c;
use Test;
use Bailador::Test;

plan 1;

%*ENV<P6W_CONTAINER> = 'Bailador::Test';
my $app = EVALFILE "bin/app.pl6";

subtest {
    plan 3;
    my %data = run-psgi-request($app, 'GET', '/');
    my $html = %data<response>[2];
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "text/html"], ''], 'route GET /';
    is %data<err>, '';
    like $html, rx:s/\<title\>Perl 6 Bailador based TODO\<\/title\>/;
}, '/';


# vim: expandtab
# vim: tabstop=4

