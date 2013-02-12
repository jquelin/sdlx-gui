use 5.016;
use warnings;

package SDLx::GUI::Widget::Toplevel;
# ABSTRACT: Toplevel widget for whole app screen

use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;

extends qw{ SDLx::GUI::Widget };

no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

This package provides a widget that will cover the whole application
screen. It should be used as the base widget upon which all the other
ones will be drawn.

