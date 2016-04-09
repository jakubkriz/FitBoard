package Rest::Competition::Roster;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';

use Plack::Util::Accessor qw();
use Plack::Session;
use MIME::Base64;
use IDGen;
use boolean;

use utf8;

use HTTP::Exception qw(3XX);
use HTTP::Exception qw(4XX);
use HTTP::Exception qw(5XX);

sub GET {
	my ($self, $env) = @_;

	my $query = exists $env->{'plack.request.query'}? $env->{'plack.request.query'} : undef;

	my $filter = {};

	my @filter_params;
	foreach my $param ("category","sex") {
		next unless defined $query->{$param};
		push @filter_params, {$param=>$query->{$param}};
	}
	push @filter_params, {"registred" => 1};

	if (@filter_params){
		$filter = {'$and' => \@filter_params};
	}

	my $link = $self->returnResourcesLinks($env);

	my $users = $self->auth->getAllUsers($env, $filter, {firstName=>1, lastName=>1, gym=>1, _id=>0, category=>1}, {lastName=>1, firstName=>1, gym=>1});
	my $userList = [];
	foreach my $u (@$users) {
		push @$userList, {
			lastName => $u->{lastName},
			firstName => $u->{firstName},
			gym => $u->{gym},
			category => $u->{category},
			sex => $u->{sex}
		};
	}

	return { users => $userList, link => $link, form=>GET_FORM($env, $query)};
}

sub GET_FORM {
	my ($env, $params) = @_;

	return {
		get => {
			params => [
				{
					name =>'category',
					type=>'radio',
					values=>['elite','masters','open'],
					default=>($params->{'category'}||'')
				},
				{
					name =>'sex',
					type=>'radio',
					values=>['male', 'female'],
					default=>($params->{'sex'}||'')
				},
			],
		},
	}	
}

1;