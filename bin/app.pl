use v6;
use Bailador;
use JSON::Fast;

get '/' => sub {
    my $root = $*PROGRAM-NAME.IO.absolute.IO.dirname.IO.dirname;
    template("index.tmpl", {
        title      => 'Perl 6 Bailador based TODO',
    });
}

post '/add' => sub {
    my $text = request.params<text>;
    #store($text);
    template("added.tmpl", {
        title      => 'Perl 6 Bailador based TODO',
    });
}

get '/about' => sub {
    template("about.tmpl");
}

sub store(Str $text) {
    
}


baile();

# vim: expandtab
# vim: tabstop=4
