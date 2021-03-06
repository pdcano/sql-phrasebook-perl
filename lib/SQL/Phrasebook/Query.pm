package SQL::Phrasebook::Query;

use strict;
use warnings;

use base qw(SQL::Phrasebook::Base);

sub initialize {
    my $self = shift;
    my ( $statement, @params ) = @_;
    
    $self->statement( $statement || '' );
    $self->params( @params );
    
    return $_[0];
}

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

    eval {
        $sth->execute( $self->params ) || die "Could not execute statement";
    };
    if ($@) {
        warn "execute statement failed";
        warn  $self->statement;
        warn join ' ,', map { defined $_ ? $_ : 'NULL' } $self->params;
        die $@;
    }
    
    return $sth;
}

1;