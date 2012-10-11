package SQL::Phrasebook::Query;

use strict;
use warnings;

sub statement {
    my $self = shift; 

    if (defined $_[0]) {
        $self->{ statement } = $_[0]
    }
    
    return $self->{ statement };
}

sub params {
    my $self = shift; 

    if ( @_ ) {
        $self->{ params } = [ @_ ];
    }
    
    return defined $self->{ params } ? @{ $self->{ params } } : ();
}

sub execute {
    my $self = shift; 
    my $dbh  = shift;

    my $sth = $dbh->prepare_cached( $self->statement ) || die "Could not prepare statement";

    $sth->execute( $self->params ) || die "Could not execute statement";

    return $sth;
}


###############################################################################
# new / basic_new / initialize
###############################################################################

sub initialize {
    my $self = shift;
    my ( $statement, @params ) = @_;
    
    $self->statement( $statement || '' );
    $self->params( @params );
    
    return $_[0];
}

sub new {
    my $class = shift;
    
    my $self = $class->basic_new;
    
    $self->initialize(@_);
    
    return $self;
}

sub basic_new {
    return bless( {}, $_[0] );
}

1;