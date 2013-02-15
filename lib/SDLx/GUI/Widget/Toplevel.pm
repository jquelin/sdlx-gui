use 5.016;
use warnings;

package SDLx::GUI::Widget::Toplevel;
# ABSTRACT: Toplevel widget for whole app screen

use Carp        qw{ croak };
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDL::Video;
use SDLx::Rect;

extends qw{ SDLx::GUI::Widget };


# -- attribute

=attr app

A reference to the main SDL application (a L<SDLx::App> object).
Mandatory, but storead as a weak reference.

=cut

has app => ( ro, required, weak_ref, isa=>"SDLx::App" );


has _cavity => ( rw, lazy_build, isa=>"SDLx::Rect" );


# -- initialization

sub BUILD {
    my $self = shift;
    # make sure we can blit on the surface
    SDL::Video::set_alpha( $self->app, SDL_SRCCOLORKEY, 0 );
}

sub _build__cavity {
    my $self = shift;
    my $app  = $self->app;
    return SDLx::Rect->new( 0, 0, $app->w, $app->h );
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

sub pack {
    my ($self, %opts) = @_;
    my $cavity = $self->_cavity;

    $opts{child}->set_parent( $self );
    my $sprite = $opts{child}->as_sprite;
    my $childw = $sprite->w;
    my $childh = $sprite->h;

    $opts{side} //= "top";

    my ($px, $py, $pw, $ph);
    given ( $opts{side} ) {
        when ( "top" ) {
            $pw = $cavity->w;
            $ph = $childh;
            $px = $cavity->x;
            $py = $cavity->y;
            $cavity = SDLx::Rect->new(
                $cavity->x, $cavity->y + $ph,
                $cavity->w, $cavity->h - $ph,
            );
        }
        when ( "bottom" ) {
            $pw = $cavity->w;
            $ph = $childh;
            $px = $cavity->x;
            $py = $cavity->y + $cavity->h - $childh;
            $cavity = SDLx::Rect->new(
                $cavity->x, $cavity->y,
                $cavity->w, $cavity->h - $ph,
            );
        }
        when ( "left" ) {
            $pw = $childw;
            $ph = $cavity->h;
            $px = $cavity->x;
            $py = $cavity->y;
            $cavity = SDLx::Rect->new(
                $cavity->x + $pw, $cavity->y,
                $cavity->w - $ph, $cavity->h,
            );
        }
        when ( "right" ) {
            $pw = $childw;
            $ph = $cavity->h;
            $px = $cavity->x + $cavity->w - $childw;
            $py = $cavity->y;
            $cavity = SDLx::Rect->new(
                $cavity->x,       $cavity->y,
                $cavity->w - $pw, $cavity->h,
            );
        }
        default {
            croak "'side' option must be one of 'top', 'bottom', 'left' or 'right'";
        }
    }

    $sprite->draw_xy( $self->surface, $px, $py );
    $self->_set_cavity( $cavity );
    $self->surface->blit( $self->app );
    $self->app->update;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

This package provides a widget that will cover the whole application
screen. It should be used as the base widget upon which all the other
ones will be drawn.

