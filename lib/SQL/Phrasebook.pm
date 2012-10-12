package SQL::Phrasebook;

use strict;
use warnings;

use base qw(SQL::Phrasebook::Base);

use SQL::Phrasebook::Query;
use SQL::Phrasebook::Parser;

sub initialize {
    my $self = shift;

    no strict 'refs';

    my $class = ref $self;
    my $parser = SQL::Phrasebook::Parser->parse_file( \*{ "$class\::DATA" } );

    $self->{catalog} = $parser->result;
    
    return $self;
}

sub load {
    shift->instance( @_ );
}

sub catalog {
    return shift->{catalog};
}

sub query {
    my $self   = shift;
    my ( $key, $qparams ) = @_;

    die "query '$key' not found" unless $self->catalog->{ $key };
    
    my $q = $self->catalog->{ $key };
 
    my $statement = $q->{ statement };

    if ( defined $q->{ listparams } ) {
        foreach my $lp ( @{ $q->{ listparams } } ) {
            my $ph = join ',', ( '?' ) x @{ $qparams->{ $lp } };
            $statement =~ s/\[\@\s*$lp\s*\@\]/$ph/;
        } 
    }

    my $query = SQL::Phrasebook::Query->new( $statement );
    $query->params( $self->get_param_list( $qparams, $q ) );
    
    return $query;
}

sub get_param_list {
    my $self    = shift;
    my ( $qparams, $q ) = @_;
    
    return map { ref $_ eq 'ARRAY' ? @$_ : $_ } @{ $qparams }{ @{ $q->{ params } } }
}

###############################################################################
# Singleton stuff
###############################################################################

sub instance {
    my $class = shift;

    no strict 'refs';
    my $instance = \${ "$class\::_instance" };
    
    return $$instance if defined $$instance;
    
    $$instance = $class->basic_new();
    $$instance->initialize( @_ );
    
    return $$instance;
}

sub new {
    return shift->instance( @_ );
}

1;