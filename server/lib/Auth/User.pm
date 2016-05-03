package Auth::User;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw(auth);
use Plack::Session;
use MIME::Base64;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use Auth::Register;

use YAML::Syck;
$YAML::Syck::ImplicitUnicode = 1;

sub GET {
	my ($self, $env, $id) = @_;

	my $login = $env->{'psgix.session'}{user_id};
	my $login_info = $self->auth->getUser($env, $login);

	my $userid = $env->{'rest.userid'};

	if ($userid){
		my $user;
		if (defined $login_info->{admin} || $userid eq $login){
			$user = $self->auth->getUser($env, $userid);
		}

		if ($user){
			return $user;
		}else{
			HTTP::Exception::404->throw(message=>"Not found");
		}
	}else{

		my $users = [];
		if ($login_info->{admin}){
			$users = $self->auth->getAllUsers($env);
		}else{
			$users = $self->auth->getAllUsers($env,{login=>$login});
		}
		
		my $link = (); my $count;
		my $qualFee; my $registred; my $user_list;
		foreach my $u (@$users) {
			push (@$user_list, {
				href => '/api/v1/auth/user/'.($u->{login}||''),
				firstName => $u->{firstName},
				lastName => $u->{lastName},
				login => $u->{login},
				bDay => $u->{bDay},
				qualFee => $u->{qualFee},
				registred => $u->{registred},
				gym => $u->{gym},
				category => $u->{category},
				phone => $u->{phone},
				sex => $u->{sex},
				shirt => $u->{shirt}
			});
			push (@$link, {
				href => '/api/v1/auth/user/'.($u->{login}||''),
				title => $u->{login}.' - '.$u->{firstName}.' '.$u->{lastName},
				rel => 'Auth::User::Id'
			});
			$count->{qualFee}++ if $u->{qualFee} && $u->{registred};
			$count->{registred}++ if $u->{registred};
			$count->{$u->{category}.'_'.$u->{sex}}++ if $u->{qualFee} && $u->{registred};
		}
		$count->{count} = scalar @$users;
	
		return {link => $link, count=>$count, users=>$user_list};
	}
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	if (!$data || ref $data ne 'HASH'){
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	### Clean email
	my $login = Auth::Register::clean_email($data->{login});

	### Check if usr exists
	if ($self->auth->checkUserExistence($env, $data->{login})){
		HTTP::Exception::400->throw(message=>"User exists");
	}else{
		### Gen id as password if not exists
		if (!defined $data->{password}){
			$data->{password} = 'fitmonster2016';
		}

		### Create user
		my $id = $self->auth->addUser($env, $login, delete $data->{password}, $data );

		### Check if user created
		if (!$id){
			HTTP::Exception::500->throw(message=>"Can't add user.");
		}else{

			### Return ok
			return { added => 1 };
		}
	}

	return { added => undef };
}

sub PUT {
	my ($self, $env, $params, $data) = @_;

	### Get login user
	my $login = $env->{'psgix.session'}{user_id};
	my $login_info = $self->auth->getUser($env, $login);

	my $userid = $env->{'rest.userid'};
	return HTTP::Exception::405->throw(message=>"Bad request") unless $userid;

	if ($data->{login} ne $userid){
		HTTP::Exception::400->throw(message=>"Login can't be changed. Drop and create new user.");
	}

	my $pswd = delete $data->{password};

	### Remove admin params
	if (!defined $login_info->{admin}){
		delete $data->{qualFee};
		delete $data->{registred};
		delete $data->{category};
	}

	### Update user data
	$self->auth->updateUser($env, $userid, { '$set' => $data });

	$data->{password} = $pswd;
	return $data
}

sub DELETE {
	my ($self, $env, $params, $data) = @_;

	my $userid = $env->{'rest.userid'};
	return HTTP::Exception::405->throw(message=>"Bad request") unless $userid;

	my $ret = $self->auth->removeUser($env, $userid);

	return $ret;
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $content, $par) = @_;

	if ($env->{'rest.userid'}){
		return {
			get => undef,
			delete => {
				params => {}
			},
			put => {
				params => {
					DATA => {
						type => 'textarea',
						name => 'DATA',
						default => $content
					}
				}
			}
		}
	}else{
		my $def = <<END;
--- 
bDay: 29/05/2016
category: elite
firstName: First
gym: Crossfit XYZ
lastName: Last
login: user\@mail.cz
phone: '+420603969896'
qualFee: '0'
qualified: '1'
registred: '0'
sex: male
shirt: l
startFee: '0'
terms: '1'
judge: '1'
END
		return {
			get => undef,
			post => {
				default => $def
			}
		}
	}
}

1;