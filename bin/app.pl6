use v6;
use Bailador;
use JSON::Fast;

my $root = $*PROGRAM-NAME.IO.absolute.IO.dirname.IO.dirname;
my $db   = $root.IO.child("todo.json");
if %*ENV<TODO_ROOT> {
    $db = %*ENV<TODO_ROOT>.IO.child('todo.json');
}

get '/' => sub {
    my @todo = read_list();
    template("index.html", {
        title      => 'Perl 6 Bailador based TODO',
        list       => @todo,
    });
}

post '/add' => sub {
    if not request.params<text>.defined {
        return template('error.html', { message => 'Missing input' });
    }

    my $text = request.params<text> // '';
    if $text ~~ /\</ {
        return template('error.html', {
            message => 'Invalid character &lt;';
        });
    }
    store($text);
    template("added.html", {
        title      => 'Perl 6 Bailador based TODO',
    });
}

get '/about' => sub {
    template("about.html");
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
    return () if not $db.e;
    my $json_str = $db.slurp: :close;
    my @todo = | from-json $json_str;
    return @todo;
}


baile();

# vim: expandtab
# vim: tabstop=4
