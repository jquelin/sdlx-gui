use 5.016;
use warnings;

package SDLx::GUI::Debug;
# ABSTRACT: Centralized debug utility

use DateTime;
use Exporter::Lite;
use Time::HiRes qw{ time };

our @EXPORT_OK = qw{ debug };


=method debug

    debug( @stuff );

Output C<@stuff> on C<STDERR>, with a timestamp and the caller sub.

=cut

*debug = $ENV{SDLX_GUI_DEBUG} ? sub {
        my $now = DateTime->from_epoch( epoch => time() );
        my $ts = $now->hms . "." . $now->millisecond;
        my $sub = (caller 1)[3]; $sub =~ s/SDLx::GUI/SxG/;
        warn "[$ts] [$sub] @_";
    } : sub {};

1;
__END__

=head1 DESCRIPTION

To facilitate debugging, this module provides a single function to log
traces. However, the C<debug()> function will not output anything unless
the environment variable C<SDLX_GUI_DEBUG> is set to a true value. If it
isn't set or set to a false value, then the function will be optimized
out.

