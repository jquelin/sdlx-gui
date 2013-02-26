use 5.016;
use warnings;

package SDLx::GUI::Widget::Label;
# ABSTRACT: Label widget to display some text/image

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

The text to be displayed on the label (a string).

=attr size

The font size to use to display the string.

=cut

has fg_color => ( rw, lazy_build, isa=>"SDL::Color" );
has text => ( rw, required, isa=>"Str" );
has size => ( rw, default=>18, isa=>"Int" );


# A L<SDLx::Text> object that will be used to draw the label text.
has _sdlxtext => ( ro, lazy_build, isa=>"SDLx::Text" );


# -- initialization

sub _build__sdlxtext {
    my $self = shift;
    my $text = SDLx::Text->new(
        size    => $self->size,
        h_align => 'left',
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
    my $sdlxt = $self->_sdlxtext;

    $surface->draw_rect( undef, $self->bg_color );
    $sdlxt->write_to( $surface );
    $surface->update;
}


sub _wanted_size {
    my $self = shift;
    my $sdlxt = $self->_sdlxtext;
    return $sdlxt->w, $sdlxt->h;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

This package provides a widget to display some text and/or image.

