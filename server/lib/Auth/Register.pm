package Auth::Register;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw(auth);
use Plack::Session;
use MIME::Base64;
use IDGen;

use Mail;

use HTTP::Exception qw(3XX);

sub GET {
	my ($self, $env) = @_;
	return { };
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	### Check if usr exists
	if (
		defined $data->{email} 
		&& (my $projects = $self->auth->checkUserExistence($env, $data->{email}))
	){
		HTTP::Exception::400->throw(message=>"User exists");
	}else{
		### Gen id as password if not exists
		if (!defined $data->{password}){
			$data->{password} = IDGen::GetID();
		}

		my $email = delete $data->{email};
		### Create user
		my $id = $self->auth->addUser($env, $email, delete $data->{password}, $data );

		### Check if user created
		if (!$id){
			HTTP::Exception::500->throw(message=>"Can't register user.");
		}else{
			### Send email
			my $mail = Mail->new( $self->const );
			open FILE, $self->const->get("EmailReg");
			my $msg;
			foreach (<FILE>){
				$msg .= $_;
			}

			# BULK_EMAIL {{athlete.firstName}} {{athlete.lastName}} {{athlete.email}} {{athlete.phone}} {{athlete.bDay}} {{athlete.category}} {{athlete.sex}} {{athlete.shirt}}
			my $rtrn = $mail->sendMail({
				list => [
					join("::", $email, $data->{firstName}, $data->{lastName}, $email, $data->{phone}, $data->{bDay}, $data->{category}, $data->{sex}, $data->{shirt}),
					join("::", $self->const->get("EmailBcc"), $data->{firstName}, $data->{lastName}, $email, $data->{phone}, $data->{bDay}, $data->{category}, $data->{sex}, $data->{shirt}),
				],
				from => $self->const->get("EmailBcc"),
				subject => 'Registrace Fit Monster 2016',
				message => $msg
			});
			if (!$rtrn){
				use Data::Dumper;
				print STDERR "ERR: ".Dumper($rtrn);
#				my $id = $self->auth->addUser($env, $email, delete $data->{password}, $data );
			}

			### Return ok
			return { registered => $id };
		}
	}

	return { registered => undef };
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $params) = @_;
	return {
		GET => undef,
#		PUT => {
#			default => $params->get('content')
#		},
		POST => {
			default => "---\nemail: email"."\nxyz: xyz"
		}
	}
}

1;