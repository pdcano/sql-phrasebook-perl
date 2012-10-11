package DummyTest;

use strict;
use warnings;
use base qw( Test::Class );
use Test::More;

sub dummy : Test(no_plan) {
    my $self = shift;

    ok(1);
};

1;