package SQL::Phrasebook::Base;

use strict;
use warnings;

sub new {
    my $class = shift;
    
    my $self = $class->basic_new;
    
    $self->initialize(@_);
    
    return $self;
}

sub basic_new {
    return bless( {}, $_[0] );
}

sub initialize {
    return $_[0];
}

1