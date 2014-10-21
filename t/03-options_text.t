#! /usr/bin/perl

#  Copyright (C) 2010, Geoffrey Leach

#===============================================================================
#
#         FILE:  03-options_text.t
#
#  DESCRIPTION:  Test some variations on the text in POD options
#
#        FILES:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  Geoffrey Leach (), geoff@hughes.net
#      COMPANY:
#      VERSION:  1..9.0
#      CREATED:  11/05/2009 04:31:11 PM
#     REVISION:  ---
#===============================================================================

use strict;
use warnings;

use Test::More tests => 6;
use Test::Output;
use Getopt::Auto( { test => 1 } );

use 5.006;
our $VERSION = "1.9.0";

## no critic (ProhibitImplicitNewlines)
## no critic (ProtectPrivateSubs)
## no critic (RequireLocalizedPunctuationVars)
## no critic (ProtectPrivateVars)
## no critic (ProhibitPackageVars)
## no critic (ProhibitEmptyQuotes)

# Will be assigned by Getopt::Auto
our %options;

# What we expect to find in the spec list
my @exspec = (
    [ '--tar', '', undef, \&tar ],
    [   '--foo', 'do a foo', 'Test long help for foo.

And this is the second paragraph for foo\'s help.
', \&foo
    ],
    [ '--bar', 'do a bar', undef, \&bar ],
);

# What we expect to find in the options hash
# This is the proof that --far is processed correctly:
# there is no option entry for it
my %ex_options = (
    '--foo' => {
        'longhelp' => 'Test long help for foo.

And this is the second paragraph for foo\'s help.
',
        'code'       => \&foo,
        'shorthelp'  => 'do a foo',
        'options'    => 'main::options',
        'package'    => 'main',
        'registered' => 1,
    },
    '--bar' => {
        'longhelp'   => undef,
        'code'       => \&bar,
        'shorthelp'  => 'do a bar',
        'options'    => 'main::options',
        'package'    => 'main',
        'registered' => 1,
    },
    '--tar' => {
        'longhelp'   => undef,
        'code'       => \&tar,
        'shorthelp'  => '',
        'options'    => 'main::options',
        'package'    => 'main',
        'registered' => 1,
    },
    '--version' => {
        'shorthelp'  => 'Prints the version number',
        'code'       => \&Getopt::Auto::_version,
        'registered' => 1,
    },
    '--help' => {
        'shorthelp'  => 'This text',
        'code'       => \&Getopt::Auto::_help,
        'registered' => 1,
    },
);

my $is_foo_called;
sub foo { ++$is_foo_called; return; }

my $is_bar_called;
sub bar { ++$is_bar_called; return; }

my $is_tar_called;
sub tar { ++$is_tar_called; return; }

my $is_far_called;
sub far { ++$is_far_called; return; }

is_deeply( Getopt::Auto::_get_spec_ref(),
    \@exspec, 'Spec gets built correctly' );
is_deeply( Getopt::Auto::_get_options_ref(),
    \%ex_options, '... and gets converted to options OK' );

@ARGV = qw(--foo --bar --tar --far);
stderr_is(
    \&Getopt::Auto::_parse_args,
    "Getopt::Auto: --far is not a registered option\n",
    '--far is not a registered option'
);
ok( $is_foo_called, 'Sub foo() was called' );
ok( $is_bar_called, 'Sub bar() was called' );
ok( $is_tar_called, 'Sub tar() was called' );

exit 0;

__END__

=pod

=begin stopwords
foo
=end stopwords

=head2 --foo - do a foo

Test long help for foo.

And this is the second paragraph for foo's help.

=head2 --bar - do a bar

=head2 --tar - 

=head2 --far -

=cut

