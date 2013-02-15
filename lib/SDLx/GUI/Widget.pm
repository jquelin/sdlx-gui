use 5.016;
use warnings;

package SDLx::GUI::Widget;
# ABSTRACT: Base class for all GUI widgets

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDLx::Sprite;


# -- attributes

has bg_color => ( rw, default=>0xC0C0C0FF, isa=>"Int" );

has parent   => ( rw, weak_ref, isa=>"SDLx::GUI::Widget" );
has surface  => ( rw, lazy_build, isa=>"SDLx::Surface" );


# -- methods

=method draw

    $widget->draw;

Request C<$widget> to be drawn.

=cut

sub draw { }


=method as_sprite

    $widget->as_sprite;

Return a L<SDLx::Sprite> where C<$widget> painted itself.

=cut

sub as_sprite {
    my $self = shift;
    return SDLx::Sprite->new( surface => $self->surface );
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

L<SDLx::GUI> provides some widgets to build the interface. Those widgets
all inherit from this base class.

