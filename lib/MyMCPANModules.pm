package MyMCPANModules;
use Dancer2;

our $VERSION = '0.1';

use LWP::Simple ();

get '/:modname' => sub {
  my $mod = route_parameters->get('modname');

  template 'module', { module => get_module_data($mod) };
};

get '/' => sub {
  my $modules;
  my $dists = get_distributions();
  template 'index', { modules => $dists };
};

sub get_distributions {
  my $pause_id = setting('pause_id');
  my $url = 'https://fastapi.metacpan.org/v1/release/_search' .
            "?q=author:$pause_id%20AND%20status:latest" .
            '&sort=distribution' .
            '&size=50' .
            '&fields=distribution,abstract';

  my $data = from_json(LWP::Simple::get($url));
  my $dists;

  foreach (@{ $data->{hits}{hits} }) {
    push @$dists, $_->{fields};
  }

  return $dists;
}

sub get_module_data {
  my ($mod) = @_;

    my $resp = LWP::Simple::get(
    "https://fastapi.metacpan.org/v1/release/$mod",
  );
  return from_json($resp);

}

true;
