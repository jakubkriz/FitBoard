package Rest::HtmlVis::Users;

use strict;
use warnings;

use parent qw( Rest::HtmlVis::Key );

my $style = '
body {
  background-color: #eee;
}

';

sub head {
	my ($self, $local) = @_;

	my $static = $self->baseurl;
	return '
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title>Users</title>

  <link rel="stylesheet" type="text/css" href="/localstatic/datatables/datatables.min.css"/>
   
  <script type="text/javascript" src="/localstatic/datatables/datatables.min.js"></script>

	<!-- Custom styles for this template -->
	<style>
	'.$style.'
	</style>
  <script>
    $(document).ready(function() {
      $(\'#users\').DataTable();
    } );
  </script>
	'
}

sub html {
  my ($self) = @_;

  my $struct = $self->getStruct;
  my $env = $self->getEnv;

use Data::Dumper;
print STDERR "ENV: ".Dumper($env->{'plack.request.query'});

  my @columns = qw/login gym bDay category phone sex shirt qualFee registred href/;

  my $table = '<table id="users" class="table table-striped table-bordered" order_column="1" cellspacing="2px" width="100%">';
  if (@$struct){
    $table .= '<thead>';
    $table .= '<th>Name</th>';
    foreach my $col (@columns) {
      $table .= '<th>'.$col.'</th>';
    }
    $table .= '</thead>';

    $table .= '<tbody>';
    foreach my $user (@$struct) {
      $table .= '<tr>';
      my $fn = delete $user->{firstName};
      my $ln = delete $user->{lastName};
      $table .= '<td>'.$fn.' '.$ln.'</td>';
      foreach my $c (@columns){
        my $v = $user->{$c};
        if ($c eq 'href'){
          $v = '<a href='.$v.'>Edit</a>';
        }
        $table .= '<td>'.$v.'</td>';
      }
      $table .= '</tr>';
    }
    $table .= '</tbody>';
  }
  $table .= '</table>';


	return '
    '.$table.'

	'
};

1;
=encoding utf-8

=head1 AUTHOR

Václav Dovrtěl E<lt>vaclav.dovrtel@gmail.comE<gt>
