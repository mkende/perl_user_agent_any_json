package UserAgent::Any::JSON;

use 5.036;

use Carp;
use JSON;
use Moo;
use UserAgent::Any 'wrap_method';
use UserAgent::Any::JSON::Response;

use namespace::clean;

our $VERSION = 0.01;

has ua => (
  is => 'ro',
  coerce => sub { UserAgent::Any->new($_[0]) },
  required => 1,
);

# This is not specific to GET and can actually handle any verb that does not
# take a request body.
sub generate_get_request ($self, $url, $params, $headers) {
  return $self->generate_post_request($url, undef, $params, $headers);
}

# The only difference with the 'get' version is that this handles the request
# body.
sub generate_post_request ($self, $url, $body = undef, $params = undef, $headers = undef) { 
  if (defined $params) {
    if (ref($params) eq 'HASH') {
      $params = '?'.join(',', map { $_.'='.$params->{$_} } keys(%{$params}));
    } elsif (ref($params) eq 'ARRAY') {
      $params = '?'.join(',', @{$params});
    } else {
      croak "TODO";
    }
  } else {
    $params = '';
  }

  my @headers;
  if (ref($headers) eq 'HASH') {
    @headers = %{$headers};
  } elsif (ref($headers) eq 'ARRAY') {
    # TODO: here we should check that the size is even.
    @headers = @{$headers};
  } elsif (defined $headers) {
    croak 'TODO';
  }

  return (
    $url.$params, 
    'Accept' => 'application/json',
    'Content-Type' => 'application/json',
    @headers,
    defined $body ? (to_json($body)) : ());
}

sub process_response ($self, $res, @) {
  return UserAgent::Any::JSON::Response->new($res);
}

wrap_method(get => \&ua => 'get', \&generate_get_request, \&process_response);
wrap_method(post => \&ua => 'post', \&generate_post_request, \&process_response);
wrap_method(delete => \&ua => 'delete', \&generate_get_request, \&process_response);

1;

__END__
