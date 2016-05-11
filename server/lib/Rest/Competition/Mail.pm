package Rest::Competition::Mail;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw();
use Plack::Session;
use MIME::Base64;
use IDGen;
use boolean;

use open IO => ':encoding(utf8)';

use Mail;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use Rest::Competition::App::LBoard;
use Auth::User;

sub GET {
	my ($self, $env) = @_;

	my $login = $env->{'psgix.session'}{user_id};
	my $login_info = $self->auth->getUser($env, $login);
	my $compid = $env->{'rest.competitionid'};

	return HTTP::Exception::403->throw(message=>"Forbidden") unless defined $login_info->{admin};

	### Get mails
	my $mails = {};
	my @files = glob( $self->const->get("EmailDir").'mail_*' );
	foreach my $m (@files) {
		my ($id) = $m =~ /^.*mail_(.*?).html$/;
		$mails->{$id} = {
			path => $m,
			id => $id
		}
	}

	### Get users
	my $users_list = $self->auth->getAllUsers($env);
	my $users = [];	
	foreach my $u (@$users_list) {
		push (@$users, [$u->{lastName}.' '.$u->{firstName}, $u->{login}]);
	};


	return { mails => $mails, users => $users };
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	my $login = $env->{'psgix.session'}{user_id};
	my $login_info = $self->auth->getUser($env, $login);

	my $compid = $env->{'rest.competitionid'};

	return HTTP::Exception::403->throw(message=>"Forbidden") unless defined $login_info->{admin};

	if ((!$data->{users} && !$data->{allusers}) || !exists $data->{mail_id}){
		HTTP::Exception::400->throw(message=>"mail_id, users or allusers should be set.");
	}

	if ($data->{allusers}){
		if ($data->{allusers} eq 'registred'){
			$data->{users} = [map $_->{login}, @{$self->auth->getAllUsers($env, {'$or' => [{"registred" => 1}, {"registred" => '1'}, {"registred" => boolean::true}]})}];
		}elsif ($data->{allusers} eq 'notqualified'){
			my $rtrn = Rest::Competition::App::LBoard::GET($self, $env);
			$data->{users} = [map $_->{login}, (grep(!$_->{qualified} && $_->{login}, @{$rtrn->{lb}}))];
		}elsif ($data->{allusers} eq 'qualified'){
			my $rtrn = Rest::Competition::App::LBoard::GET($self, $env);
			$data->{users} = [map $_->{login}, (grep($_->{qualified} && $_->{login}, @{$rtrn->{lb}}))];
		}elsif ($data->{allusers} eq 'qualified_notPaid'){
			my $rtrn = Rest::Competition::App::LBoard::GET($self, $env);
			$data->{users} = [map $_->{login}, (grep($_->{qualified} && $_->{login}, @{$rtrn->{lb}}))];

			my $rtrn1 = Auth::User::GET($self, $env);
			my @logins = map $_->{login}, (grep($_->{registred} && $_->{login} && $_->{startFee}, @{$rtrn1->{users}}));
			my $startFee = {};
			map $startFee->{$_} = undef, @logins;
			$data->{users} = [grep(!exists $startFee->{$_}, @{$data->{users}})];
		}
	}

	if (ref $data->{users} ne 'ARRAY' && $data->{users}){
		$data->{users} = [$data->{users}];
	}

	if (!defined $data->{users} || !@{$data->{users}}){
		HTTP::Exception::400->throw(message=>"users should be set.");
	}

	### Get paths
	my @files = glob( $self->const->get("EmailDir").'mail_'.$data->{mail_id}."*" );
	HTTP::Exception::400->throw(message=>"Mail with mail_id: ".$data->{mail_id}."doesn't exist.") unless @files;
	my $path = shift @files;

	### Get Users
	my $mdata;
	foreach my $u (@{$data->{users}}){
		my $u_info = $self->auth->getUser($env, $u);
		HTTP::Exception::400->throw(message=>"User doesn't exists: ".$u) unless $u_info;
		push @$mdata, join("::", $u, $u_info->{firstName}, $u_info->{lastName}, $u, $u_info->{phone}, $u_info->{bDay}, $u_info->{category}, $u_info->{sex}, $u_info->{shirt}, $u_info->{gym});
		push @$mdata, join("::", $self->const->get("EmailBcc"), $u_info->{firstName}, $u_info->{lastName}, $u, $u_info->{phone}, $u_info->{bDay}, $u_info->{category}, $u_info->{sex}, $u_info->{shirt}, $u_info->{gym});
	}

	### Send mail
	my $mail = Mail->new( $self->const );
	open FILE, $path;
	my $msg;
	foreach (<FILE>){
		$msg .= $_;
	}

	### Get subject
	my ($subject) = $msg =~ /<title>(.*?)<\/title>/;
	HTTP::Exception::500->throw(message=>"<title> in email (subject) is not defined.") unless $subject;

	if ($data->{send}){
		# BULK_EMAIL {{athlete.firstName}} {{athlete.lastName}} {{athlete.email}} {{athlete.phone}} {{athlete.bDay}} {{athlete.category}} {{athlete.sex}} {{athlete.shirt}}
		my $rtrn = $mail->sendMail({
			merge_keys => [qw(BULK_EMAIL {{athlete.firstName}} {{athlete.lastName}} {{athlete.email}} {{athlete.phone}} {{athlete.bDay}} {{athlete.category}} {{athlete.sex}} {{athlete.shirt}} {{athlete.gym}})],
			list => $mdata,
			from => $self->const->get("EmailBcc"),
			subject => $subject,
			message => $msg
		});
		if (!$rtrn){
			HTTP::Exception::500->throw(message=>"Can't send email: ".$rtrn." WARNING: Some emails have been send.");
		}
		### Update params
		if ($data->{mail_id} eq 'qualFee'){
			foreach my $u (@{$data->{users}}){
				my $id = $self->auth->updateUser($env, $u, {'$set' => {'qualFee' => 1}});
			}
		}elsif ($data->{mail_id} eq 'startFee'){
			foreach my $u (@{$data->{users}}){

				my $id = $self->auth->updateUser($env, $u, {'$set' => {'startFee' => 1}});
			}
		}elsif($data->{mail_id} eq 'registrationCancel'){
			foreach my $u (@{$data->{users}}){
				my $id = $self->auth->updateUser($env, $u, {'$set' => {'registred' => 0}});
			}
		}
		$data->{sended} = 1;

	}else{
		$data->{sended} = 0;
	}

	return $data;
}

sub GET_FORM {
	my ($class, $env, $content, $par) = @_;

	my $data = "---\nmail_id: id\nusers:\n  - name\nallusers:registred\nsend: 1\n";
	if ($par && $env->{REQUEST_METHOD} eq 'POST' && exists $par->{DATA}){
		$data = $par->{DATA};
	}

	return {
		get => undef,
		post => {
			params => {
				DATA => {
					type => 'textarea',
					name => 'DATA',
					default => $data
				}
			}
		}
	}
}

1;