use 5.016;
use warnings;

package SDLx::GUI;
# ABSTRACT: Create GUI easily with SDL

use Exporter::Lite;

use SDLx::GUI::Widget::Toplevel;

our @EXPORT = qw{ toplevel };


# -- public functions

=method toplevel

    my $top = toplevel( %options );

Return a new toplevel widget (a L<SDLx::GUI::Widget::Toplevel> object).
Refer to this class for more information on accepted C<%options>.

=cut

sub toplevel {
    return SDLx::GUI::Widget::Toplevel->new( @_ );
}


1;
__END__

=head1 SYNOPSIS

    use SDLx::App;
    use SDLx::GUI;
    my $app = SDLx::App->new( ... );
    my $top = toplevel( app=>$app );
    $top->label( text=>"hello, world!" )->pack;


=head1 DESCRIPTION

L<SDL> is great to create nifty games, except it's cumbersome to write
a usable GUI with it... Unfortunately, almost all games do have some
part that needs buttons and checkboxes and stuff (think configuration
screens).

This module eases the pain, by providing a L<Tk>-like way of building a
GUI.


=head1 SEE ALSO

You can find more information on this module at:

=over 4

=item * Search CPAN

L<http://search.cpan.org/dist/SDLx-GUI>

=item * See open / report bugs

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=SDLx-GUI>

=item * Git repository

L<http://github.com/jquelin/sdlx-gui>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/SDLx-GUI>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/SDLx-GUI>

=back

