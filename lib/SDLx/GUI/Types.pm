use 5.016;
use warnings;

package SDLx::GUI::Types;
# ABSTRACT: Types used in the distribution

use Moose::Util::TypeConstraints;

enum 'PackSide' => [qw{ top bottom left right }];

1;
__END__

=head1 DESCRIPTION

This module implements the specific types used by the distribution, and
exports them (exporting is done by L<Moose::Util::TypeConstraints>).

Current types defined:

=over 4

=item * PackSide - a simple enumeration, allowing C<top>, C<bottom>,
C<left> and C<right>.

=back

