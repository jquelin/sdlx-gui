use 5.016;
use warnings;

package SDLx::GUI::Widget::Label;
# ABSTRACT: Label widget to display some text/image

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDL::Video;
use SDLx::Surface;
use SDLx::Text;

extends qw{ SDLx::GUI::Widget };


# -- attributes

has text => ( rw, required, isa=>"Str" );
has _sdlxtext => ( ro, lazy_build, isa=>"SDLx::Text" );


# -- initialization

sub _build_surface {
    my $self = shift;

    my $sdlxt = $self->_sdlxtext;
    my $surface =  SDLx::Surface->new( width=>$sdlxt->w,
        height=>$sdlxt->h );
    $surface->draw_rect( undef, $self->bg_color );
    $sdlxt->write_to( $surface );
    return $surface;
}

sub _build__sdlxtext {
    my $self = shift;
    my $text = SDLx::Text->new(
        size    => 18,
        h_align => 'left',
        text    => $self->text,
    );
    return $text;
}


# -- public methods


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

This package provides a widget to display some text and/or image.

