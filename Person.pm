package Data::Random::Person;

use strict;
use warnings;

use Class::Utils qw(set_params);
use Data::Person;
use Error::Pure qw(err);
use List::Util 1.33 qw(none);
use Mock::Person::CZ qw(name);
use Text::Unidecode;

our $VERSION = 0.01;

sub new {
	my ($class, @params) = @_;

	# Create object.
	my $self = bless {}, $class;

	# Domain.
	$self->{'domain'} = 'example.com';

	# Id.
	$self->{'id'} = 1;
	$self->{'cb_id'} = sub {
		return $self->{'id'}++;
	};

	# Name callback.
	$self->{'cb_name'} = sub {
		return name();
	};

	# Add id or not.
	$self->{'mode_id'} = 0;

	# Number of users.
	$self->{'num_users'} = 10;

	# Process parameters.
	set_params($self, @params);

	# Check domain.
	if ($self->{'domain'} !~ m/^[a-zA-Z0-9\-\.]+$/ms) {
		err "Parameter 'domain' is not valid.";
	}

	return $self;
}

sub random {
	my $self = shift;

	my $data_ar = [];
	foreach my $i (1 .. $self->{'num_users'}) {
		my $ok = 1;
		while ($ok) {
			my $people = $self->{'cb_name'}->($self);
			my $email = $self->_name_to_email($people);
			if (none { $_->email eq $email } @{$data_ar}) {
				my $id;
				if ($self->{'mode_id'}) {
					$id = $self->{'cb_id'}->($self);
				}
				push @{$data_ar}, Data::Person->new(
					'email' => $email,
					defined $id ? ('id' => $id) : (),
					'name' => $people,
				);
				$ok = 0;
			} else {
				print "Fail\n";
			}
		}
	}

	return $data_ar;
}

sub _name_to_email {
	my ($self, $name) = @_;

	my $email = unidecode(lc($name));
	$email =~ s/\s+/\./g;
	$email .= '@'.$self->{'domain'};

	return $email;
}

1;

__END__
