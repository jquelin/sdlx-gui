use 5.016;
use warnings;

package SDLx::GUI::Widget;
# ABSTRACT: Base class for all GUI widgets

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDLx::Sprite;

use SDLx::GUI::Debug qw{ debug };


# -- attributes

has bg_color => ( rw, default=>0xC0C0C0FF, isa=>"Int" );

has parent   => ( rw, weak_ref, isa=>"SDLx::GUI::Widget" );


# -- initialization

sub BUILD    { debug( "label created: $_[0]\n" ); }
sub DEMOLISH { debug( "label destroyed: $_[0]\n" ); }


# -- methods

=method draw

    $widget->draw( $surface );

Request C<$widget> to be drawn on C<$surface>.

=cut

# method to be implemented in subclasses.


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=for Pod::Coverage BUILD DEMOLISH

=head1 DESCRIPTION

L<SDLx::GUI> provides some widgets to build the interface. Those widgets
all inherit from this base class.

