package Auth::Register;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw(auth);
use Plack::Session;
use MIME::Base64;
use IDGen;

use utf8;

use open IO => ':encoding(utf8)';

use Mail;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

sub GET {
	my ($self, $env) = @_;
	return { };
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	if (!$data || ref $data ne 'HASH'){
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	### Clean email
	my $login = clean_email($data->{email});

	### Check if usr exists
	if ($self->auth->checkUserExistence($env, $data->{email})){
		HTTP::Exception::400->throw(message=>"User exists");
	}else{
		### Gen id as password if not exists
		if (!defined $data->{password}){
			$data->{password} = 'fitmonster2016';
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
				merge_keys => [qw(BULK_EMAIL {{athlete.firstName}} {{athlete.lastName}} {{athlete.email}} {{athlete.phone}} {{athlete.bDay}} {{athlete.category}} {{athlete.sex}} {{athlete.shirt}} {{athlete.gym}})],
				list => [
					join("::", $email, $data->{firstName}, $data->{lastName}, $email, $data->{phone}, $data->{bDay}, $data->{category}, $data->{sex}, $data->{shirt}, $data->{gym}),
					join("::", $self->const->get("EmailBcc"), $data->{firstName}, $data->{lastName}, $email, $data->{phone}, $data->{bDay}, $data->{category}, $data->{sex}, $data->{shirt}, $data->{gym}),
				],
				from => $self->const->get("EmailBcc"),
				subject => 'Registrace Fit Monster 2016',
				message => $msg
			});
			if (!$rtrn){
				my $id = $self->auth->updateUser($env, $email, {'$set' => {emailStatus=>0}});
			}

			### Return ok
			return { registered => $id };
		}
	}

	return { registered => undef };
}

sub clean_email {
	my ($email) = @_;

	if ($email && $email =~ /.+\@.+\..+/){
		$email =~ s/\s//g;
		$email =~ s/\@\@/\@/g;
	}else{
		HTTP::Exception::400->throw(message=>"Bad email");
	}

	return $email;
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $params) = @_;
	my $def = <<END;
--- 
bDay: 29/05/2016
category: elite
firstName: First
gym: Crossfit XYZ
lastName: Last
email: user\@mail.cz
phone: '+420603969896'
qualFee: '0'
qualified: '1'
registred: '0'
sex: male
shirt: l
startFee: '0'
terms: '1'
END
	return {
		get => undef,
#		PUT => {
#			default => $params->get('content')
#		},
		post => {
			default => $def
		}
	}
}

1;