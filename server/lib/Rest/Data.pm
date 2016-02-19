package Rest::Data;

use strict;
use warnings;

use parent 'Plack::App::RESTMy';
use Event::Store;

use HTTP::Exception;

my @OBJ = ('dataset','event','device');

sub GET {
	my ($self, $env) = @_;

	my $db = Event::Store->new($self->const->get("DBDir"), $env->{'rest.login'});
	my $data;

	my $ids = $env->{'rest.ids'};
	my $limit = ($env->{'parsecontent.data'}->{'limit'} || 100);

	if (!$ids) {
		### show from more tables
		my $items = $db->getAllItemsFromTables($limit, @OBJ);
		my $links = $self->structToLinksByType('Rest::Obj', '/'.$env->{'rest.project'}.$env->{SCRIPT_NAME}, $items);
		$data = {links => $links, count=>scalar @$links};

	}else{

		my ($table, $id) = @$ids;
		_checkTable($table);

		if ($id){
			$data = $db->getItem($table, $id)->{$id};
			if (!$data){
				HTTP::Exception::404->throw(message=>'Not found.');
			}
		}else{
			my $items = $db->getAllItems($table, $limit);
			my $links = $self->structToLinks('Rest::Obj', '/'.$env->{'rest.project'}.$env->{SCRIPT_NAME}.'/'.$table, $items);
			$data = {links => $links, count=>scalar @$links};
		}
	}

	return $data;
}

sub POST {
	my ($self, $env, undef, $data) = @_;

	HTTP::Exception::400->throw(message=>'Bad structure.') unless ref $data eq 'HASH';

	my $ids = $env->{'rest.ids'};
	my $table; my $id;

	if (!$ids){
		$table = delete $data->{type};
	}else{
		($table, $id) = @$ids;
		_checkTable($table);
	}

	HTTP::Exception::404->throw() unless $table;

	my $db = Event::Store->new($self->const->get("DBDir"), $env->{'rest.login'});

	my $res;
	if ($id){
		HTTP::Exception::405->throw(allow=>'GET,PUT,DELETE');
	}else{
		$res = $db->addItem($table, $data);
	}

	return  {
		links => [$self->idToLink('Rest::Obj', '/'.$env->{'rest.project'}.$env->{SCRIPT_NAME}.'/'.$table, $res, $data->{name})],
		status => 'created'
	};
}

sub PUT {
	my ($self, $env, undef, $data) = @_;

	my $ids = $env->{'rest.ids'};
	HTTP::Exception::404->throw() unless $ids;

	my ($table, $id) = @$ids;
	_checkTable($table);

	my $db = Event::Store->new($self->const->get("DBDir"), $env->{'rest.login'});

	my $res;
	if ($id){
		$res = $db->updateItem($id, $table, $data);
	}else{
		HTTP::Exception::405->throw(allow=>'GET,PUT,DELETE');
	}

	return $res;
}

sub DELETE {
	my ($self, $env) = @_;

	my $ids = $env->{'rest.ids'};
	HTTP::Exception::404->throw() unless $ids;

	my ($table, $id) = @$ids;
	_checkTable($table);
	my $db = Event::Store->new($self->const->get("DBDir"), $env->{'rest.login'});

	my $res;
	if ($id){
		$res = $db->deleteItem($id, $table);
	}else{
		HTTP::Exception::405->throw(allow=>'GET,POST');
	}

	return $res;	
}

sub GET_FORM {
	my ($class, $env, $params) = @_;

	my $ids = $env->{'rest.ids'};
	my $type = '['.join("|",@OBJ).']';
	my $struct = _struct();

	my $str;
	my $obj;
	if ($ids) { 
		my ($table, $id) = @$ids;
		$obj = $id if $id;
		$type = $table;
		$str = _serialize($struct, [$type]);
	}else{
		$str = _serialize($struct, \@OBJ, 'addType');
	}

	my $limit = $env->{'parsecontent.data'}->{'limit'};

	my $res = {
		GET => {
			params => [
				{
					default => ($limit||100),
					type => 'text',
					name => 'limit'
				}
			]
		},
	};
	if ($obj){
		$res->{PUT} = {
			default => $params->get('content')
		};
		$res->{DELETE} = {};
	}else{
		$res->{POST} = {
			default => $str
		};
	}
	return $res
}

sub _struct {
	my $struct = {
		event => {
			dataset_id => 'number',
			value => 'number',
			timestamp => time
		},
		dataset => {
			device_id => ' number',
			name => 'string'
		},
		device => {
			name => 'string'
		}
	};

	return $struct;
}

sub _serialize {
	my ($struct, $types, $addType) = @_;

	my @ret;
	foreach my $type (@$types) {
		push @ret, '---';
		foreach my $key (keys %{$struct->{$type}}){
			push @ret, $key.': '.$struct->{$type}{$key};
		};
		push @ret, "type: ".$type if $addType;
	}

	return join("\n", @ret);
}

sub _checkTable {
	my $t = shift;
	if ( grep( $t eq $_, @OBJ) ){
		return;
	}

	HTTP::Exception::400->throw(message=>'Bad resource');
}


1;