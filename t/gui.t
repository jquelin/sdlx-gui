#!perl

use 5.016;
use warnings;

use Test::More;
use SDLx::App;
use SDLx::GUI;

# main sdl application
my $app = SDLx::App->new(
    title        => 'SDLx::GUI tests',
    width        => 640,
    height       => 480,
    exit_on_quit => 1,
    depth        => 32
);

# create a toplevel
my $top = toplevel( app => $app, bg_color=>0xFFEC8BFF );
my $i = 0;
foreach my $side ( qw{ left top top right bottom } ) {
    $i++;
    my $lab = $top->label(text=>"$i $side");
    $lab->pack( side=>$side );
}
$top->draw;

# run the test
local $SIG{ALRM} = sub {
    pass("made it this far");
    done_testing;
    exit;
};
alarm 2;
$app->run;

