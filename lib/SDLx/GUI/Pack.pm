use 5.016;
use warnings;

package SDLx::GUI::Pack;
# ABSTRACT: Objects to keep track of pack options

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;

use SDLx::GUI::Debug qw{ debug };
use SDLx::GUI::Types;


# -- attributes

=attr side

On which side to pack the widget - see C<PackSide> in
L<SDLx::GUI::Types>. Defaults to C<top>.

=cut

has side  => ( ro, isa=>"PackSide", default=>"top" );


=attr parcel

The parcel devoted to the pack (a L<SDLx::Rect> object). See the
packer algorithm for more information on the parcel.

=attr slave_dims

The dimensions that the child should fill (a L<SDLx::Rect> object).
See the packer algorithm for more information on the slave dimensions.

=attr clip

A L<SDLx::Rect> used to clip a packed child if there isn't enough place.

=cut

has parcel     => (rw, isa=>"SDLx::Rect" );
has slave_dims => (rw, isa=>"SDLx::Rect" );
has clip       => (rw, isa=>"SDLx::Rect", predicate=>"has_clip" );


# -- initialization

sub BUILD    { debug( "pack object created: $_[0]\n" ); }
sub DEMOLISH { debug( "pack object destroyed: $_[0]\n" ); }



no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=for Pod::Coverage BUILD DEMOLISH

=head1 DESCRIPTION

This class defines objects keeping track of packed widgets.
