package UserAgent::Any::JSON::Response;

use 5.036;

use Carp;
use JSON;
use Moo;
use Scalar::Util 'blessed';

use namespace::clean;

# We expect a single argument to this class, so we take it without the need to
# pass it in a hash. See:
# https://metacpan.org/pod/Moo#BUILDARGS
around BUILDARGS => sub {
  my ( $orig, $class, @args ) = @_;
 
  return { res => $args[0] }
    if @args == 1 && (ref($args[0]) ne 'HASH' || !blessed($args[0]));
 
  return $class->$orig(@args);
};

has _res => (
  init_arg => 'res',
  is => 'ro',
  handles => 'UserAgent::Any::Response',
  # coerce is not really needed because we should always be initialized with a
  # UserAgent::Any::Response, but having that in place might help with some
  # specific use cases (and it costs almost nothing).
  coerce => sub { UserAgent::Any::Response->new($_[0]) },
  required => 1,
);

has data => (
  is => 'ro',
  lazy => 1,
  default => sub ($self) { return from_json($self->content) },
);

1;
