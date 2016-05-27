package Rest::Competition::User;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use MIME::Base64;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use Store::Start;

use utf8;

use open IO => ':encoding(utf8)';

use YAML::Syck;
$YAML::Syck::ImplicitUnicode = 1;

sub GET {
	my ($self, $env, $id) = @_;

	my $login = $env->{'psgix.session'}{user_id};
	HTTP::Exception::403->throw(message=>"Forbidden") unless $login;
	my $login_info = $self->auth->getUser($env, $login);

	my $userid = $env->{'rest.userid'};
	my $compid = $env->{'rest.competitionid'};

	if ($userid){
		my $user;
		if (defined $login_info->{admin} || $userid eq $login){
			$user = $self->start->getUser($env, $userid);
		}

		if ($user){
			return $user;
		}else{
			HTTP::Exception::404->throw(message=>"Not found");
		}
	}else{

		my $users = [];
		if ($login_info->{admin}){
			$users = $self->start->getAllUsers($env);
		}else{
			$users = $self->start->getAllUsers($env,{login=>$login});
		}

		my $link = []; my $count = {};
		my $user_list = [];


		### Prepare array
		my $start_u = {}; my $users_cat = {};
		foreach my $u (@$users){
			my $u_info = $self->auth->getUser($env, $u->{login});

			$u->{firstName} = $u_info->{firstName};
			$u->{lastName} = $u_info->{lastName};
			$u->{gym} = $u_info->{gym};
			$u->{category} = $u_info->{category};
			$u->{sex} = $u_info->{sex};
			$u->{login} = $u_info->{login};
			$u->{shirt} = $u_info->{shirt};

			# For all
			foreach my $wod (1..6){
				# Clean
				$u->{"points_wod".$wod."_j"} =~ s/,/./g if $u->{"points_wod".$wod."_j"};

				if ($u->{"points_wod".$wod."_j"} && $u->{"points_wod".$wod."_j"} =~ /:/){
					my ($min, $sec) = split(/:/,$u->{"points_wod".$wod."_j"});
					my $score = $min*60+$sec;
					$u->{"overall_wod".$wod} = 100000-$score;
				}elsif(defined $u->{"points_wod".$wod."_j"}){
					$u->{"overall_wod".$wod} = $u->{"points_wod".$wod."_j"};
				}else{
					$u->{"overall_wod".$wod} = 0;
				}
			}

			push @{$users_cat->{$u_info->{category}}{$u_info->{sex}}}, $u;
			$start_u->{$u->{login}} = undef;
		}
			

		### Compute points and place
		foreach my $cat ('elite', 'masters', 'open'){
			foreach my $sex ('male','female'){

				my $points = {};

				next unless (defined $users_cat->{$cat} && defined $users_cat->{$cat}{$sex} && @{$users_cat->{$cat}{$sex}});

				foreach my $t (1..6){

					@{$points->{$t}} = sort {$b->{'overall_wod'.$t} <=> $a->{'overall_wod'.$t}} @{$users_cat->{$cat}{$sex}};

					my $b = 1;
					my $p = 0;
					my $last = -100;
					foreach my $u (@{$points->{$t}}){
						$p = $b if ($last != $u->{"overall_wod".$t});
						$u->{"score_wod".$t} = $p;
						$u->{"scoreOV_1"} += $p if $t <= 3;
						$u->{"scoreOV_2"} += $p if $t <= 4;
						$u->{"scoreOV_3"} += $p if $t <= 5;
						$u->{"scoreOV_4"} += $p*2 if $t <= 6;

						$last = $u->{"overall_wod".$t};

						if ($u->{"overall_wod".$t} > 1000){
							$u->{"overall_wod".$t} = 100000-$u->{"overall_wod".$t};
							$u->{"overall_wod".$t} = int($u->{"overall_wod".$t}/60).':'.int($u->{"overall_wod".$t}%60);
						}
						$b++;
					}
				}

				# overall
				foreach my $t (1..4){
					@{$points->{"OV_".$t}} = sort {$a->{"scoreOV_".$t} <=> $b->{"scoreOV_".$t}} @{$users_cat->{$cat}{$sex}};

					my $b = 1;
					my $p = 0;
					my $last = -100;
					foreach my $u (@{$points->{'OV_'.$t}}){
						$p = $b if ($last != $u->{'scoreOV_'.$t});
						$u->{"placeOV_".$t} = $p;
						# if ($limit->{$cat}{$sex} < $b || (defined $u->{qualified} && $u->{qualified} == 0)){
						# 	$u->{qualified} = 0;
						# }else{
						# 	$u->{qualified} = 1;
						# }
						$last = $u->{'scoreOV_'.$t};

						$b++;
					}
				}

				foreach my $u (@{$points->{"OV_4"}}) {
					my $usr = {
						href => $self->refToUrl($env, 'Rest::Competition::User::UserId', {'rest.userid'=>($u->{login}||'')}),
						login => ($login_info && $login_info->{admin} ?  $u->{login} : ''),
						firstName => $u->{firstName},
						lastName => $u->{lastName},
						category => $u->{category},
						sex => $u->{sex},
						gym => $u->{gym},
						startN => $u->{startN},
						modified => $u->{modified},
					};
					foreach my $t (1..4){
						$usr->{'scoreOV_'.$t} = $u->{"scoreOV_".$t};
						$usr->{'placeOV_'.$t} = undef;
						$usr->{'placeOV_'.$t} = $u->{"placeOV_".$t};
					}
					foreach my $t (1..6){
						$usr->{"points_wod".$t."_j"} = $u->{"points_wod".$t."_j"};
						$usr->{'overall_wod'.$t} = $u->{"overall_wod".$t};
						$usr->{'score_wod'.$t} = $u->{"score_wod".$t};
						$usr->{"judgeN_wod".$t} = $u->{"judgeN_wod".$t};
					}
					push (@$user_list, $usr);

					push (@$link, {
						href => $self->refToUrl($env, 'Rest::Competition::User::UserId', {'rest.userid'=>($u->{login}||'')}),
						title => $u->{login},
						rel => 'Rest::Competition::User::UserId'
					});

					$count->{$u->{sex}}{$u->{category}}++;
					$count->{count}++;
				}

			}
		}

		return {link => $link, count=>$count, users=>$user_list};
	}
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	if (!$data || ref $data ne 'HASH'){
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	### Clean email
	my $login = $data->{login};
	my $startN = $data->{startN};

	### Check if usr exists
	if($startN && !$login){
		$login = $self->start->getUserByStartN($env, $startN);
		if (!$login){
			HTTP::Exception::400->throw(message=>"StartN doesn't exist");
		}
	}elsif(!$login){
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	if (!$self->auth->checkUserExistence($env, $login)){
		HTTP::Exception::400->throw(message=>"User doesn't exist");
	}
	my $user = $self->auth->getUser($env, $login);
	if (!$user->{registred}){
		HTTP::Exception::400->throw(message=>"User not registred");
	}
	if ($self->start->checkUserExistence($env, $login)){
		HTTP::Exception::400->throw(message=>"Start for user exists");
	}else{

		### Create user
		my $id = $self->start->addUser($env, $login, $data );

		### Check if user created
		if (!$id){
			HTTP::Exception::500->throw(message=>"Can't add start for user.");
		}

		### Return ok
		return { start => $id };
	}

	return { start => undef };
}

sub PUT {
	my ($self, $env, $params, $data) = @_;

	my $userid = $env->{'rest.userid'};
	return HTTP::Exception::400->throw(message=>"Bad request") unless $userid;

	if ($data->{login} ne $userid){
		HTTP::Exception::400->throw(message=>"Login can't be changed. Drop and create new start.");
	}
	if (!$self->start->checkUserExistence($env, $userid)){
		HTTP::Exception::400->throw(message=>"User doesn't exist");
	}

	### Update user data
	$self->start->updateUser($env, $userid, { '$set' => $data });
	return $data
}

sub DELETE {
	my ($self, $env, $params, $data) = @_;

	my $userid = $env->{'rest.userid'};
	return HTTP::Exception::405->throw(message=>"Bad request") unless $userid;

	my $ret = $self->start->removeUser($env, $userid);

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
		return {
			get => undef,
			post => {
				default => "---\nlogin: email\npoints_wodX_j: 10\nstartN: 100"
			},
		}
	}
}

1;