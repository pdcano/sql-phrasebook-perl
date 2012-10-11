package SQL::Phrasebook::Parser;

use strict;
use warnings;

use base qw(SQL::Phrasebook::Object);

sub parse {
    my $class = shift;
    my $buffer = shift;

    my $self = $class->new;
    
    for (split /^/, $buffer) {
        $self->process_line( $_ );
    }

    $self->process_params;
    
    return $self;
}

sub parse_file {
    my $class = shift;
    my $fh = shift;

    my $self = $class->new;
    
    while (<$fh>) {
        $self->process_line( $_ );
    }

    $self->process_params;
    
    return $self;
}

sub result {
    return shift->{book}
}

sub process_line {
    my $self = shift;
    my $line = shift;

    $line =~ s/\n+/ /;                      # newlines to space
    return if $line =~ m/^\s*$|^[#|-]/;       #skip empty or commented lines
    
    if ($line =~ m/^([\w|-]+)\s*:\s*$/) {
        $self->{current_key} = $1;          #a phrasebook key
    }
    else {                                  #a statement line
        $self->process_statement( $line );
    } 

    return $self;
}

sub process_statement {
    my $self = shift;
    my $line = shift;

    my $key = $self->{current_key};
    
    $line =~ s/^\s+//g unless defined $self->{book}->{ $key }->{ statement };
    $line =~ s/\s+/ /g;

    $line =~ s/\[\*\s*([\w|-]+)\s*\*\]/$self->{book}->{$1}->{statement}/g;            
                
    $self->{book}->{ $key }->{ statement } = '' unless defined $self->{book}->{ $key }->{ statement };  
    $self->{book}->{ $key }->{ statement } .= $line;
    
    return $self;
}

sub process_params {
    my $self = shift;
    
    foreach my $key (keys %{ $self->{book} } ) {
        $self->process_query_params( $key );     
        $self->process_dynamic_query_params( $key );             
    }
    
    return $self;
}

sub process_query_params {
    my $self = shift;
    my $key  = shift;

    $self->{book}->{ $key }->{ params } = [] unless defined $self->{book}->{ $key }->{ params };

    my @params;
    if (@params = $self->{book}->{ $key }->{ statement } =~ m/\[[\$|\@]\s*(\w+)\s*[\$|\@]\]/g) {
        push @{ $self->{book}->{ $key }->{ params } }, @params;
    }
        
    $self->{book}->{ $key }->{ statement } =~ s/\[\$\s*\w+\s*\$\]/?/g; #put placeholders only for static params

    return $self;
}

sub process_dynamic_query_params {
    my $self = shift;
    my $key  = shift;

    $self->{book}->{ $key }->{ listparams } = [] unless defined $self->{book}->{ $key }->{ params };

    my @listparams;
    if (@listparams = $self->{book}->{ $key }->{ statement } =~ m/\[\@\s*(\w+)\s*\@\]/g) {
        push @{ $self->{book}->{ $key }->{ listparams } }, @listparams if @listparams;
    }
    
    return $self;
}

1;