package PidFile;

=head1 NAME

PidFile - managing your pid file

=head1 SYNOPSIS

  use PidFile;

  my $pid_file = PidFile->new("/var/run/ProgramName.pid");
  die "I am running..." unless $pid_file;

=head1 DESCRIPTION

This module implements a simple logic for managing pid file.
If pid file exists, then konstructor return is false.
Pid file will delete automaticly by destructor.

=cut

use v5.10;
use strict;
use warnings;

use Carp;
use Fcntl qw[ :DEFAULT :flock ];

use base qw[Exporter];
our @EXPORT_OK = qw[ new ];

my $mode = LOCK_NB | LOCK_EX;
my $fh   = undef;
my $file = undef;
my $pidExist = undef;
my $err_msg = undef;

sub new {
	my ($class, $file_name) = @_;

	return unless $file_name;
	return if $pidExist;
	$file = $file_name;

	return 0 unless ( _init() );
	bless {}, $class;
}

sub _init {
	my $umask = umask;
	umask 0000;

	unless ( open($fh, ">", $file) ) {
		$err_msg = "Could not open file $file for locking: $!";
		return 0;
	}

	unless ( flock($fh, $mode) ) {
		$err_msg = "Could not lock file $file: $!";
		return 0;
	}

	umask $umask;
	print $fh $$, "\n";
	close($fh);

	$pidExist = 1;
}

sub DESTROY {
	unlink $file;
}

1;
