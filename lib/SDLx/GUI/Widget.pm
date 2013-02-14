use 5.016;
use warnings;

package SDLx::GUI::Widget;
# ABSTRACT: Base class for all GUI widgets

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;


# -- attributes

has bg_color => ( rw, default=>0x000000FF, isa=>"Int" );

has surface  => ( rw, lazy_build, isa=>"SDLx::Surface" );


# -- methods

=method draw

    $widget->draw;

Requestion C<$widget> to be drawn.

=cut

sub draw { }


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

L<SDLx::GUI> provides some widgets to build the interface. Those widgets
all inherit from this base class.

