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


=attr parent

The parent widget (a L<SDLx::GUI::Widget> object).

=cut

has parent     => ( rw, weak_ref, isa=>"SDLx::GUI::Widget" );


# the pack information describing how the widget is being packed onto
# its parent. A SDLx::GUI::Pack object, refer to this module for more
# information.
has _pack_info => ( rw, isa=>"SDLx::GUI::Pack", predicate=>"is_packed" );


# -- initialization

sub BUILD    { debug( "label created: $_[0]\n" ); }
sub DEMOLISH { debug( "label destroyed: $_[0]\n" ); }


# -- public methods

=method pack

    $widget->pack( %opts );

Request C<$widget> to be packed on its parent. C<%opts> is used to
create a new L<SDLx::GUI::Pack> object - refer to this module for more
information on supported attributes.

=cut

sub pack {
    my ($self, %opts) = @_;
    my $pack = SDLx::GUI::Pack->new(%opts);
    $self->_set_pack_info( $pack );
    $self->parent->_recompute;
}


# -- private methods

#
#   $widget->_draw( $surface );
#
# Request C<$widget> to be drawn on C<$surface>.
# PLACEHOLDER: method needs to be implemented in subclasses.
#

#
#   my ($width, $height) = $widget->_wanted_size;
#

# Return the minimum C<$width> and C<$height> needed to draw C<$widget>.
# Those dimensions are guaranted to be respected by its parent container
# - even if that means that the result will be clipped! :-)
# PLACEHOLDER: method needs to be implemented in subclasses.


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=for Pod::Coverage BUILD DEMOLISH

=head1 DESCRIPTION

L<SDLx::GUI> provides some widgets to build the interface. Those widgets
all inherit from this base class.

