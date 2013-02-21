use 5.016;
use warnings;

package SDLx::GUI::Widget::Toplevel;
# ABSTRACT: Toplevel widget for whole app screen

use Carp        qw{ croak };
use Moose;
use MooseX::Has::Sugar;
use MooseX::SemiAffordanceAccessor;
use SDL::Video;
use SDLx::Rect;
use SDLx::Surface;

use SDLx::GUI::Debug qw{ debug };
use SDLx::GUI::Pack;

extends qw{ SDLx::GUI::Widget };


# -- attributes

=attr app

A reference to the main SDL application (a L<SDLx::App> object).
Mandatory, but storead as a weak reference.

=cut

has app => ( ro, required, weak_ref, isa=>"SDLx::App" );


# A list of widgets created inside the toplevel.
has _children => (
    ro, auto_deref,
    traits  => ['Array'],
    isa     => 'ArrayRef[SDLx::GUI::Widget]',
    default => sub { [] },
    handles => {
        _add_child  => 'push',
    },
);



# -- public methods

=method label

    my $label = $toplevel->label( %opts );

Return a new label (a L<SDLx::GUI::Widget::Label> object) created within
the C<$toplevel>.

=cut

sub label {
    my $self = shift;
    require SDLx::GUI::Widget::Label;
    my $label = SDLx::GUI::Widget::Label->new( parent=>$self, @_);
    $self->_add_child( $label );
    return $label;
}




=method draw

    $top->draw;

Request C<$top> to be redrawn on the main application window, along with
all its children.

=cut

sub draw {
    my $self = shift;

    debug( "redrawing $self\n" );
    $self->app->draw_rect( undef, $self->bg_color );

    foreach my $child ( grep { $_->is_packed } $self->_children ) {
        my $pack       = $child->_pack_info;
        my $parcel     = $pack->parcel;
        my $slave_dims = $pack->slave_dims;
        my $surface = SDLx::Surface->new(
            width  => $slave_dims->w,
            height => $slave_dims->h
        );
        debug( "child $child to be redrawn\n" );
        debug( "parcel     = " . _rects($parcel) );
        debug( "slave_dims = " . _rects($slave_dims) );
        $child->_draw( $surface );
        my $sprite = SDLx::Sprite->new(
            surface => $surface,
            x       => $parcel->x,
            y       => $parcel->y,
            ( $pack->has_clip ? ( clip => $pack->clip ) : () ),
        );
        $sprite->draw( $self->app );
    }
    debug( "completed redrawing of $self\n" );
    $self->app->update;
}


# -- private functions

#
#    $toplevel->_recompute;
#
# Request C<$toplevel> to recompute the size of all its children,
# recursively. Refer to the packer algorithm in L<SDLx::GUI::Pack> for
# more information. Note that this method doesn't request C<$toplevel>
# to be redrawn!
#
sub _recompute {
    my $self = shift;
    my $app  = $self->app;

    debug( "recomputing $self\n" );
    my $cavity = SDLx::Rect->new( 0, 0, $app->w, $app->h );
    debug( "cavity is " . _rects($cavity) . "\n" );

    foreach my $child ( grep { $_->is_packed } $self->_children ) {
        my $pack = $child->_pack_info;
        debug( "checking $child\n" );
        my ($childw, $childh) = $child->_wanted_size;

        debug( "child $child wants [$childw,$childh] at ".$pack->side. "\n" );
        my ($px, $py, $pw, $ph);
        given ( $pack->side ) {
            when ( "top" ) {
                $pw = $cavity->w;
                $ph = $childh;
                $px = $cavity->x;
                $py = $cavity->y;
                $cavity = SDLx::Rect->new(
                    $cavity->x, $cavity->y + $ph,
                    $cavity->w, $cavity->h - $ph,
                );
            }
            when ( "bottom" ) {
                $pw = $cavity->w;
                $ph = $childh;
                $px = $cavity->x;
                $py = $cavity->y + $cavity->h - $childh;
                $cavity = SDLx::Rect->new(
                    $cavity->x, $cavity->y,
                    $cavity->w, $cavity->h - $ph,
                );
            }
            when ( "left" ) {
                $pw = $childw;
                $ph = $cavity->h;
                $px = $cavity->x;
                $py = $cavity->y;
                $cavity = SDLx::Rect->new(
                    $cavity->x + $pw, $cavity->y,
                    $cavity->w - $pw, $cavity->h,
                );
            }
            when ( "right" ) {
                $pw = $childw;
                $ph = $cavity->h;
                $px = $cavity->x + $cavity->w - $childw;
                $py = $cavity->y;
                $cavity = SDLx::Rect->new(
                    $cavity->x,       $cavity->y,
                    $cavity->w - $pw, $cavity->h,
                );
            }
            default {
                croak "uh? should not get there";
            }
        }
        $pack->set_parcel( SDLx::Rect->new($px,$py,$pw,$ph) );
        $pack->set_slave_dims( SDLx::Rect->new($px,$py,$childw,$childh) );
        debug( "cavity is " . _rects($cavity) . "\n" );
    }
}


#
# my $string = _rects( $rect );
#
# Return a string with $rect main info: "[x,y,w,h]".
#
sub _rects {
    my $r = shift;
    return "[" . join(",",$r->x, $r->y, $r->w, $r->h) . "]";
}


no Moose;
__PACKAGE__->meta->make_immutable;
1;
__END__

=head1 DESCRIPTION

This package provides a widget that will cover the whole application
screen. It should be used as the base widget upon which all the other
ones will be drawn.

