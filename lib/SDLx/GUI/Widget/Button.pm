use 5.016;
use warnings;

package SDLx::GUI::Widget::Button;
# ABSTRACT: Classical button widget

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDL::Color;
use SDL::Video;
use SDLx::Surface;
use SDLx::Text;

use SDLx::GUI::Debug qw{ debug };

extends qw{ SDLx::GUI::Widget };


# -- attributes

=attr text

The text to be displayed on the button (a string).

=attr size

The font size to use to display the string.

=cut

has fg_color => ( rw, lazy_build, isa=>"SDL::Color" );
has text => ( rw, required, isa=>"Str" );
has size => ( rw, default=>18, isa=>"Int" );


# A L<SDLx::Text> object that will be used to draw the button text.
has _sdlxtext => ( ro, lazy_build, isa=>"SDLx::Text" );
has _border_color => ( rw, default=>0x000000FF, isa=>"Int" );


# -- initialization

sub _build__sdlxtext {
    my $self = shift;
    my $text = SDLx::Text->new(
        size    => $self->size,
        h_align => 'center',
        text    => $self->text,
        color   => $self->fg_color,
    );
    return $text;
}

sub _build_fg_color { SDL::Color->new(0,0,0); }


# -- public methods


# -- private methods

sub _draw {
    my ($self, $surface) = @_;
    my $sdlxt  = $self->_sdlxtext;
    my ($w,$h) = ($surface->w, $surface->h);
    my $wline = 2;
    my $space = 4;

    $surface->draw_rect( [0,0,$w,$h], $self->_border_color );
    $surface->draw_rect( [$wline,$wline,$w-$wline*2,$h-$wline*2], $self->bg_color );
    $sdlxt->write_xy( $surface, $w/2, $wline+$space );
    $surface->update;
}


sub _on_mouse_up {
    debug( "click!\n" );
}

sub _on_mouse_enter {
    my ($self, $event) = @_;
    $self->_set_border_color( 0xFFFFFFFF );
    $self->parent->draw;
}

sub _on_mouse_leave {
    my ($self, $event) = @_;
    $self->_set_border_color( 0x000000FF );
    $self->parent->draw;
}

sub _wanted_size {
    my $self = shift;
    my $sdlxt = $self->_sdlxtext;
    return $sdlxt->w + 12 , $sdlxt->h + 12;
}



no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

This package provides a button widget.

