package Rest::Competition::App::LBoard;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use MIME::Base64;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

use Store::Qual;

use utf8;

use open IO => ':encoding(utf8)';

use YAML::Syck;
$YAML::Syck::ImplicitUnicode = 1;

sub GET {
	my ($self, $env, $id) = @_;

	# get login
	my $login = $env->{'psgix.session'}{user_id};
	my $login_info = $self->auth->getUser($env, $login);

	my $users = $self->qual->getAllUsers($env);

	my $resp = {};

	my $users_cat = {};

	### Clean time
	my $qual_u = {};
	foreach my $u (@$users){
		my $u_info = $self->auth->getUser($env, $u->{login});

		$u->{firstName} = $u_info->{firstName};
		$u->{lastName} = $u_info->{lastName};
		$u->{gym} = $u_info->{gym};
		$u->{category} = $u_info->{category};
		$u->{sex} = $u_info->{sex};

		# Clean
		$u->{pointsA_j} =~ s/,/./g;
		$u->{pointsB_j} =~ s/,/./g;
		$u->{pointsA_j_norep} =~ s/,/./g;
		if ( !($u->{pointsA_j} =~ /^(\d+:\d+|[\d\.]+)$/) || 
			!($u->{pointsB_j} =~ /^[\d\.]+$/) || 
			!($u->{pointsA_j_norep} =~ /^[\d\.]+$/)
		){
			$u->{err} = 1;
			next;
		}

		# A
		if ($u->{pointsA_j} =~ /:/){
			my ($min, $sec) = split(/:/,$u->{pointsA_j});
			my $score = $min*60+$sec;
			$u->{overallA} = 100000-($score+5*$u->{pointsA_j_norep});
		}else{
			$u->{overallA} = $u->{pointsA_j}-$u->{pointsA_j_norep};
		}

		# B
		$u->{overallB} = $u->{pointsB_j};
		push @{$users_cat->{$u_info->{category}}{$u_info->{sex}}}, $u;
		$qual_u->{$u->{login}} = undef;
	}

	### Add users
	my $all_users = $self->auth->getAllUsers($env);
	foreach my $u_info (@$all_users){
		my $u;
		next if (exists $qual_u->{$u_info->{login}} || !$u_info->{registred});

		$u->{firstName} = $u_info->{firstName};
		$u->{lastName} = $u_info->{lastName};
		$u->{gym} = $u_info->{gym};
		$u->{category} = $u_info->{category};
		$u->{sex} = $u_info->{sex};
		$u->{pointsA_j} = 0;
		$u->{pointsB_j} = 0;
		$u->{pointsA_j_norep} = 0;
		$u->{overallA} = 0;
		$u->{overallB} = 0;
		$u->{qualified} = 0;

		push @$users, $u;
		push @{$users_cat->{$u_info->{category}}{$u_info->{sex}}}, $u;
	}


	my $points = {};

	my $limit = {
		elite => {
			male => 50,
			female => 20,
		},
		masters => {
			male => 20,
			female => 10,
		},
		open => {
			male => 100,
			female => 50,
		},
	};

	foreach my $cat ('elite', 'masters', 'open'){
		foreach my $sex ('male','female'){

			next unless (defined $users_cat->{$cat} && defined $users_cat->{$cat}{$sex} && @{$users_cat->{$cat}{$sex}});

			foreach my $t ("A", "B"){

				@{$points->{$t}} = sort {$b->{'overall'.$t} <=> $a->{'overall'.$t}} @{$users_cat->{$cat}{$sex}};

				my $b = 1;
				my $p = 0;
				my $last = -100;
				foreach my $u (@{$points->{$t}}){
					$p = $b if ($last != $u->{"overall".$t});
					$u->{"score".$t} = $p;
					$u->{"scoreOV"} += $p;

					$last = $u->{"overall".$t};

					if ($t eq 'A' && $u->{"overall".$t} > 1000){
						$u->{"overall".$t} = 100000-$u->{"overall".$t};
						$u->{"overall".$t} = int($u->{"overall".$t}/60).':'.int($u->{"overall".$t}%60);
					}
					$b++;
				}
			}

			# overall
			my $t = 'OV';
			@{$points->{$t}} = sort {$a->{scoreOV} <=> $b->{scoreOV}} @{$users_cat->{$cat}{$sex}};

			my $b = 1;
			my $p = 0;
			my $last = -100;
			foreach my $u (@{$points->{$t}}){
				$p = $b if ($last != $u->{scoreOV});
				$u->{"placeOV"} = $p;
				if ($limit->{$cat}{$sex} < $b || (defined $u->{qualified} && $u->{qualified} == 0)){
					$u->{qualified} = 0;
				}else{
					$u->{qualified} = 1;
				}
				$last = $u->{scoreOV};

				$b++;
			}
		}
	}

	my $user_qual;
	my $user_err;
	foreach my $u (@$users) {
		if (exists $u->{err}){
			push (@$user_err, {
				firstName => $u->{firstName},
				lastName => $u->{lastName},
				category => $u->{category},
				sex => $u->{sex},
				gym => $u->{gym},
				pointsA_j => $u->{pointsA_j},
				pointsA_j_norep => $u->{pointsA_j_norep},
				pointsB_j => $u->{pointsB_j},
			});
			next;
		}
#		my $u_info = $self->auth->getUser($env, $u->{login});
		push (@$user_qual, {
			pointsA_j => $u->{pointsA_j},
			pointsA_j_norep => $u->{pointsA_j_norep},
			pointsB_j => $u->{pointsB_j},
			pointsB => $u->{overallB},
			pointsA => $u->{overallA},
			pointsO => $u->{scoreOV},
			firstName => $u->{firstName},
			lastName => $u->{lastName},
			category => $u->{category},
			sex => $u->{sex},
			gym => $u->{gym},
			scoreA => $u->{scoreA},
			scoreB => $u->{scoreB},
			scoreOV => $u->{scoreOV},
			placeA => $u->{scoreA},
			placeB => $u->{scoreB},
			placeOV => $u->{placeOV},
			qualified => $u->{qualified}
		});
	}

	my $link = ();
	return {link => $link, lb=>$user_qual, err=>$user_err};
}

sub POST {
	my ($self, $env, $params, $data) = @_;

	if (!$data || ref $data ne 'HASH'){
		HTTP::Exception::400->throw(message=>"Bad request");
	}

	if (! $data->{login}){
		HTTP::Exception::400->throw(message=>"Login has to be defined");
	}

## Compute values and save
## nejmensi cas az nejvetsi, body nejvic az nejmin (do knihovny)
## zvlast A a zvlast B pak dohromady (nejelepsi bod 1 atd.. )
## stejne skore za stejne body dalsi v rade (1body, 1body dalsi 3body) 

	# # Get login
	# my $login = $env->{'psgix.session'}{user_id};
	# HTTP::Exception::403->throw(message=>"Forbidden") unless $login;
	# my $login_info = $self->auth->getUser($env, $login);

	# if (!($login_info->{admin} || $login_info->{judge})){
	# 	HTTP::Exception::403->throw(message=>"Forbidden");
	# }

	# my $type = $env->{'rest.qualtype'} ? lc($env->{'rest.qualtype'}) : '';
	# my $compid = $env->{'rest.competitionid'};

	# if ($type eq 'reserve'){
	# 	my $qual_login = $data->{login};
	# 	if ($self->qual->checkUserExistence($env, $qual_login)){
	# 		my $user = $self->qual->getUser($env, $qual_login);
	# 		if (!$user->{reserved} && !$user->{judge}){
	# 			### Update user
	# 			$self->qual->updateUser($env, $qual_login, { '$set' => {'reserved' => $login} });
	# 		}else{
	# 			HTTP::Exception::400->throw(message=>"Qual taken by another judge");
	# 		}
	# 	}else{
	# 		HTTP::Exception::400->throw(message=>"Qual for user doesn't exists");
	# 	}
		
	# }elsif ($type eq 'judge'){
	# 	my $qual_login = $data->{login};
	# 	if ($self->qual->checkUserExistence($env, $qual_login)){
	# 		my $user = $self->qual->getUser($env, $qual_login);
	# 		if ($user->{reserved} eq $login){
	# 			$data->{'reserved'} = '';
	# 			$data->{'judge'} = $login;

	# 			### Update user
	# 			$self->qual->updateUser($env, $qual_login, { '$set' => $data });
	# 		}else{
	# 			HTTP::Exception::400->throw(message=>"Judge not reserved for this qual");
	# 		}
	# 	}else{
	# 		HTTP::Exception::400->throw(message=>"Qual for user doesn't exists");
	# 	}

	# }else{
	# 	HTTP::Exception::400->throw(message=>"Bad request");
	# }

	return { qual => undef };
}

### Return form for gray pages
sub GET_FORM {
	my ($class, $env, $content, $par) = @_;

	return {
		get => undef,
#		post => {
#			params => {	}
#		}
	}
}

1;