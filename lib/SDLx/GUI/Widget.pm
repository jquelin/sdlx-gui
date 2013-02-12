use 5.016;
use warnings;

package SDLx::GUI::Widget;
# ABSTRACT: Base class for all GUI widgets

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

L<SDLx::GUI> provides some widgets to build the interface. Those widgets
all inherit from this base class.

