package SQL::Phrasebook::Object::Singleton;

use base qw(SQL::Phrasebook::Object);

use strict;
use warnings;

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