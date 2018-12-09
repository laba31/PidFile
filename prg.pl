#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;

use lib "./";
use PidFile;

# more suitable directory /var/run or run in own directory structure
my $pid_file = PidFile->new("/tmp/MyPidFile.pid");
sleep 3;
my $second_pid = PidFile->new("/tmp/MyPidFile.pid");
die "I am running..." unless $second_pid;

