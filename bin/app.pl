use v6;
use Bailador;
use JSON::Fast;

my $root = $*PROGRAM-NAME.IO.absolute.IO.dirname.IO.dirname;
my $db   = $root.IO.child("todo.json");

get '/' => sub {
    my @todo = read_list();
    template("index.tmpl", {
        title      => 'Perl 6 Bailador based TODO',
        list       => @todo,
    });
}

post '/add' => sub {
    my $text = request.params<text>;
    store($text);
    template("added.tmpl", {
        title      => 'Perl 6 Bailador based TODO',
    });
}

get '/about' => sub {
    template("about.tmpl");
}

sub store(Str $text) {
    my @todo;
    if $db.e {
        @todo = read_list();
    }

    @todo.push: {
        text => $text,
        added => time,
    };
    my $json_str = to-json @todo;

    $db.spurt($json_str);

    return;
}

sub read_list() {
    my $json_str = $db.slurp: :close;
    my @todo = | from-json $json_str;
    return @todo;
}


baile();

# vim: expandtab
# vim: tabstop=4
