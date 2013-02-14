#!perl

use 5.016;
use warnings;

use Test::More;
use SDLx::App;
use SDLx::GUI::Widget::Toplevel;

# main sdl application
my $app = SDLx::App->new(
    title        => 'SDLx::GUI tests',
    width        => 640,
    height       => 480,
    exit_on_quit => 1,
    depth        => 32
);

# create a toplevel
my $top = SDLx::GUI::Widget::Toplevel->new( app => $app,
    bg_color=>0xFFEC8BFF );
$top->draw;

# run the test
local $SIG{ALRM} = sub {
    pass("made it this far");
    done_testing;
    exit;
};
alarm 1;
$app->run;

