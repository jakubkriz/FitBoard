package Rest::HtmlVis::Table;

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
  my $title = $self->{env}{'REST.class'};
	return '
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title>'.$title.'</title>

  <link rel="stylesheet" type="text/css" href="/localstatic/datatables/datatables.min.css"/>
  <link rel="stylesheet" type="text/css" href="/localstatic/datatables/Buttons-1.1.2/css/buttons.dataTables.min.css"/>
   
  <script type="text/javascript" src="/localstatic/datatables/datatables.min.js"></script>
  <script type="text/javascript" src="/localstatic/datatables/Buttons-1.1.2/js/dataTables.buttons.min.js"></script>
  <script type="text/javascript" src="/localstatic/datatables/Buttons-1.1.2/js/buttons.html5.min.js"></script>
  <script type="text/javascript" src="/localstatic/datatables/jszip.min.js"></script>

	<!-- Custom styles for this template -->
	<style>
	'.$style.'
	</style>
  <script>
    $(document).ready(function() {
      var table = $(\'#users\').DataTable({
        buttons: [
            \'copyHtml5\',
            \'excelHtml5\',
            \'csvHtml5\',
        ]
      });
      table.buttons().container()
      .appendTo( $(\'.col-sm-6:eq(0)\', table.table().container() ) );
    } );
  </script>
	'
}

sub html {
  my ($self) = @_;

  my $struct = $self->getStruct;
  my $env = $self->getEnv;

  my @columns = sort keys %{$struct->[0]} if $struct && @$struct;

  my $table = '<table id="users" class="table table-striped table-bordered" order_column="1" cellspacing="2px" width="100%">';
  if (@$struct){
    $table .= '<thead>';
    foreach my $col (@columns) {
      $table .= '<th>'.$col.'</th>';
    }
    $table .= '</thead>';

    $table .= '<tbody>';
    foreach my $user (@$struct) {
      $table .= '<tr>';
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
