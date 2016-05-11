package Rest::HtmlVis::Mail;

use strict;
use warnings;

use parent qw( Rest::HtmlVis::Key );

my $style = '
body {
}

.formClass { 
  padding: 10px;
}

';

sub head {
	my ($self, $local) = @_;

	my $static = $self->baseurl;
	return '
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title>Users</title>

  <link rel="stylesheet" type="text/css" href="/localstatic/chosen/chosen.min.css"/>
   
  <script type="text/javascript" src="/localstatic/chosen/chosen.jquery.min.js"></script>

	<!-- Custom styles for this template -->
	<style>
	'.$style.'
	</style>
  <script>

    $(document).ready(function() {
      $(".chosen-select").chosen()
      $(".chosen-select1").chosen()
    } );
  </script>
	'
}

sub setStruct {
  my ($self, $key, $content, $env) = @_;

  if ($content && ref $content eq 'HASH' && $content->{$key}){
    $self->{struct} = $content;
    $self->{env} = $env;
    return 1;
  }

  return 0
}

sub html {
  my ($self) = @_;

  my $struct = $self->getStruct;
  my $env = $self->getEnv;

  my $mails = "";
  foreach my $m (sort keys %{$struct->{mails}}){
    $mails .= '<option value="'.$m.'">'.$m.'</option>'."\n";
  }

  my $users = "";
  foreach my $u (@{$struct->{users}}){
    $users .= '<option value="'.$u->[1].'">'.$u->[0].' - '.$u->[1].'</option>'."\n";
  }

	my $msg = '
<form class="formClass" method="POST">
  <fieldset class="form-group">
  <select name="mail_id" id="mail_id" class="chosen-select1" data-placeholder="Choose email..." style="width:350px;" tabindex="1">
';
  $msg .= $mails;
  $msg .= '</select></fieldset>';
  $msg .= '<fieldset class="form-group"><select name="users"  id="users" class="chosen-select" data-placeholder="Choose user..." style="width:100%;" multiple="" tabindex="3">
              <option value=""></option>
  ';
  $msg .= $users;
  $msg .= '
  </select></fieldset>
  <fieldset class="form-group">
  <select name="allusers" id="allusers" class="chosen-select1" data-placeholder="Choose group of users..." style="width:350px;" tabindex="1">
  <option value=""></option>
  <option value="registred">All registred users</option>
  <option value="qualified">All qualified users</option>
  <option value="notqualified">All not qualified users</option>
  <option value="qualified_notPaid">All qualified - not paid users</option>
  </select></fieldset>
  <div class="checkbox">
    <label>
      <input type="checkbox" name="send" id="send"> Send
    </label>
  </div>
  <button class="btn btn-primary">SEND</button>
  </fieldset>
</form>
';

};

1;
=encoding utf-8

=head1 AUTHOR

Václav Dovrtěl E<lt>vaclav.dovrtel@gmail.comE<gt>
