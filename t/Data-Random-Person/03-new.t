use strict;
use warnings;

use Data::Random::Person;
use English;
use Error::Pure::Utils qw(clean);
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Data::Random::Person->new;
isa_ok($obj, 'Data::Random::Person');

# Test.
eval {
	Data::Random::Person->new(
		'domain' => '@bad',
	);
};
is($EVAL_ERROR, "Parameter 'domain' is not valid.\n",
	"Parameter 'domain' is not valid (\@bad).");
clean();
