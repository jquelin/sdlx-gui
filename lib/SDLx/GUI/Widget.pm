use 5.016;
use warnings;

package SDLx::GUI::Widget;
# ABSTRACT: Base class for all GUI widgets

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDL::Color;
use SDLx::Sprite;

use SDLx::GUI::Debug qw{ debug };


# -- attributes

has bg_color => ( rw, lazy_build, isa=>"SDL::Color" );


=attr parent

The parent widget (a L<SDLx::GUI::Widget> object).

=cut

has parent     => ( rw, weak_ref, isa=>"SDLx::GUI::Widget" );


# the pack information describing how the widget is being packed onto
# its parent. A SDLx::GUI::Pack object, refer to this module for more
# information.
has _pack_info => ( rw, isa=>"SDLx::GUI::Pack", predicate=>"is_packed" );


# -- initialization

sub BUILD    { debug( "widget created: $_[0]\n" ); }
sub DEMOLISH { debug( "widget destroyed: $_[0]\n" ); }
sub _build_bg_color { SDL::Color->new(192,192,192); }

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


=method is_visible

    my $bool = $widget->is_visible;

Return true if C<$widget> is currently visible, ie if it is packed and
there's enough place on the screen for it to be shown.

=cut

sub is_visible {
    my $self = shift;
    return $self->_pack_info && $self->_pack_info->_slave_dims;
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

