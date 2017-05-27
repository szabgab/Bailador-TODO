use v6;
use Bailador;

get '/' => sub {
    template("index.tmpl", {
        title      => 'Perl 6 Bailador based TODO',
    });
}

get '/about' => sub {
    template("about.tmpl");
}


baile();

# vim: expandtab
# vim: tabstop=4
