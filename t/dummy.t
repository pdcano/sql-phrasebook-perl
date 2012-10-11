#!/usr/bin/perl -w

use strict;
use warnings;

use lib 'lib';
use lib '../lib';

use DummyTest;

DummyTest->runtests;