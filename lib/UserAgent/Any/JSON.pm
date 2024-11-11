package UserAgent::Any::JSON;

use 5.036;

use Carp;
use JSON;
use Moo;
use Readonly;
use Scalar::Util 'blessed';
use UserAgent::Any 'wrap_method';
use UserAgent::Any::JSON::Response;

use namespace::clean;

our $VERSION = 0.01;

has ua => (
  is => 'ro',
  coerce => sub { UserAgent::Any->new($_[0]) },
  required => 1,
);

wrap_method(get => \&ua => 'get', sub ($self, $url, $params, $headers) { 
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
    @headers = @{$headers};
  } elsif (defined $headers) {
    croak 'TODO';
  }

  return (
    $url.$params, 
    'Accept' => 'application/json',
    'Content-Type' => 'application/json',
    @headers);
}, sub ($self, $res, @) {
  return UserAgent::Any::JSON::Response->new($res);
});

wrap_method(post => \&ua => 'post', sub ($self, $url, $body = undef, $params = undef, $headers = undef) { 
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
}, sub ($self, $res, @) {
  return UserAgent::Any::JSON::Response->new($res);
});

1;

__END__
