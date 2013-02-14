use 5.016;
use warnings;

package SDLx::GUI::Widget::Toplevel;
# ABSTRACT: Toplevel widget for whole app screen

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDL::Video;

extends qw{ SDLx::GUI::Widget };


# -- attribute

=attr app

A reference to the main SDL application (a L<SDLx::App> object).
Mandatory, but storead as a weak reference.

=cut

has app => ( ro, required, weak_ref, isa=>"SDLx::App" );



# -- initialization

sub BUILD {
    my $self = shift;
    # make sure we can blit on the surface
    SDL::Video::set_alpha( $self->app, SDL_SRCCOLORKEY, 0 );
}

sub _build_surface {
    my $self = shift;
    my ($w, $h) = map { ($_->w,$_->h) } $self->app;
    return SDLx::Surface->new( width=>$w,height=>$h );
}


# -- public methods

override draw => sub {
    my $self = shift;
    my $surface = $self->surface;
    $surface->draw_rect( undef, $self->bg_color );
    $surface->blit( $self->app, [0,0,$surface->w,$surface->h] );
};


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

This package provides a widget that will cover the whole application
screen. It should be used as the base widget upon which all the other
ones will be drawn.

