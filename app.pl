use v6;
use Bailador;

get '/' => sub {
    template("index.tmpl", {
        title      => 'Perl 6 Bailador based TODO',
        site_title => 'TODO',
    });
}

baile();

# vim: expandtab
# vim: tabstop=4
