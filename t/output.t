#!perl -w

use strict;
use Test::More 0.88;

use TAP::Formatter::Elapsed;

my $formatter = TAP::Formatter::Elapsed->new;
isa_ok $formatter, 'TAP::Formatter::Elapsed';
isa_ok $formatter, 'TAP::Formatter::Console';

my $output;

delete $ENV{'TAP_ELAPSED_FORMAT'};

# These lines shouldn't be modified.

$output = capture_output( $formatter, '# does not add a timestamp' );
is $output, '# does not add a timestamp', 'no change';

$output = capture_output( $formatter, 'ok     34 ms' );
is $output, 'ok     34 ms', 'no change';

# Test the default format.

my $default = qr/ \[\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d, \d\.\d\d, \d\.\d\d elapsed\]$/;

$output = capture_output( $formatter, 'ok 1' );
like $output, qr/^ok 1 \[/, 'ok 1';
like $output, $default, 'default format';

$output = capture_output( $formatter, 'not ok 2' );
like $output, qr/^not ok 2 \[/, 'not ok 2';
like $output, $default, 'default format';

# Now that we've tested the default format, use a format more easily parsed
# for testing.

$ENV{'TAP_ELAPSED_FORMAT'} = 'TODO';

done_testing;

sub capture_output {
    my ( $formatter, $line ) = @_;

    open my $fh, '>', \my $stdout or die $!;
    $formatter->stdout($fh);
    $formatter->_output($line);
    close $fh;

    return $stdout;
}
