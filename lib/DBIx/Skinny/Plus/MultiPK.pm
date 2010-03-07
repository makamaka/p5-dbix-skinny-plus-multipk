package DBIx::Skinny::Plus::MultiPK;


use strict;
use warnings;
use Carp ();

our $VERSION = '0.01';


BEGIN {
    local $^W;
    no warnings;

    sub DBIx::Skinny::Row::_update_or_delete_cond {
        my ($self, $table) = @_;

        unless ($table) {
            Carp::croak "no table info";
        }

        my $schema_info = $self->{skinny}->schema->schema_info;
        unless ( $schema_info->{$table} ) {
            Carp::croak "unknown table: $table";
        }

        # get target table pk
        my $pk = $schema_info->{$table}->{pk};
        unless ($pk) {
            Carp::croak "$table have no pk.";
        }

        # multi primary keys
        if ( ref $pk eq 'ARRAY' ) {
            my %pks = map { $_ => 1 } @$pk;

            unless ( ( grep { exists $pks{ $_ } } @{$self->{select_columns}} ) == @$pk ) {
                Carp::croak "can't get primary columns in your query.";
            }

            return +{ map { $_ => $self->$_() } @$pk };
        }

        unless (grep { $pk eq $_ } @{$self->{select_columns}}) {
            Carp::croak "can't get primary column in your query.";
        }

        return +{ $pk => $self->$pk };
    }

}


1;
__END__

=pod

=head1 NAME

DBIx::Skinnyy::Plus::MultiPK - multi primary key acceptable

=head1 SYNOPSIS

    package Your::Model::Schema;
    
    install_table 'a_multi_pk_table' => schema {
        pk [ qw( id_a id_b ) ]; # set an array reference
        columns qw( id_a id_b etc );
    };
    
    #
    pakcage Your::Model;
    use DBIx::Skinny setup => +{
        dsn => 'dbi:SQLite:',
        username => '',
        password => '',
    };
    use DBIx::Skinny::Schema::Plus::MultiPK;
    
    # ...
    
    package main;
    
    use Your::Model;
    
    my $row = Your::Model->single( 'a_multi_pk_table', { id_a => 'a', id_b => 'b' } );
    $row->update( { etc => 'foobar' } );
    $row->delete();

=head1 DESCRIPTION

L<DBIx::Skinny> assumes single primary key schemas.
Using this module enable you to set multi primary kyes.

Use this module after C<use DBIx::Skinny> in your model class.

Then in your schema class, only pass an array reference of primary keys to C<pk>.

=head1 SEE ALSO

L<DBIx::Skinny>

=head1 AUTHOR

Makamaka Hannyaharamitu, E<lt>makamaka[at]cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Makamaka Hannyaharamitu

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut

