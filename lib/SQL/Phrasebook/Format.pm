package SQL::Phrasebook::Format;

=head1 NAME

SQL::Phrasebook::Format - A sample pod document

=head1 SYNOPSIS

    Blah

=head1 DESCRIPTION

Phrasebook format:
    
    ----------
    query_key:
    ----------
    
    SELECT * FROM Table WHERE Field = [$ value $]
    
    ----------
    list_key:
    ----------
    
    SELECT * FROM Table WHERE Field IN [@ values @]
    
    -------
    insert:
    -------
    
    INSERT INTO Table (Field1, Field2, Field3) 
    VALUES ([$ value1 $], [$ value2 $], [$ value3 $])
    
    #comment
    -also a comment
    
    #use fragments
    
    --------------
    select_fields:
    --------------
    
    SELECT Field1, Field2, Field3 FROM Table
    
    -------
    select:
    -------
    
    [* select_fields *] WHERE Field1 = [$ value $]

=cut

=head1 SEE ALSO

L<perlpod>, L<perldoc>, L<Pod::Parser>.

=head1 COPYRIGHT

Copyright 2012 Pablo Daniel Cano.

This program is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=cut

1