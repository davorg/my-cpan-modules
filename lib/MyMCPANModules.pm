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
  for my $mod (@{ setting('modules') }) {
    my %module;
    $module{name} = $mod;
    my $data = get_module_data($mod);
    $module{desc} = $data->{abstract};
    push @$modules, \%module;
  }
  template 'index', { modules => $modules };
};

sub get_module_data {
  my ($mod) = @_;

    my $resp = LWP::Simple::get(
    "https://fastapi.metacpan.org/v1/release/$mod",
  );
  return from_json($resp);

}

true;
