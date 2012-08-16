package TAP::Formatter::Elapsed;
use base 'TAP::Formatter::Console';

use strict;
use Time::HiRes qw( gettimeofday tv_interval );
use POSIX qw( strftime );

our $VERSION = '0.01';

sub new {
    my $class = shift;
    my $self  = $class->SUPER::new(@_);

    $self->{'_t0'} = [ gettimeofday() ];
    $self->{'_t1'} = $self->{'_t0'};

    return $self;
}

sub _output {
    my ( $self, $line ) = @_;

    return unless defined $line;

    if ( $line =~ /^(?:not )?ok \d/ ) {
        my $format = defined $ENV{'TAP_ELAPSED_FORMAT'}
            ? $ENV{'TAP_ELAPSED_FORMAT'}
            : ' [%c, %t0, %t1 elapsed]';

        $format =~ s{%t0}{ sprintf '%.2f', tv_interval($self->{'_t0'}) }eg;
        $format =~ s{%t1}{ sprintf '%.2f', tv_interval($self->{'_t1'}) }eg;

        $line .= strftime( $format, localtime );

        $self->{'_t1'} = [ gettimeofday() ];
    }

    print { $self->stdout } $line;
}

1;

__END__

=head1 NAME

TAP::Formatter::Elapsed - Display time taken for each test

=head1 SYNOPSIS

B<prove> --formatter I<TAP::Formatter::Elapsed> ...

=head1 AUTHOR

Chris Grau L<mailto:cgrau@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (c) 2012, Chris Grau.

=cut
