package Test::Settings;

use strict;
use warnings;

use Exporter;
our @ISA = qw(Exporter);

our @EXPORT_OK = qw(
	want_smoke
	want_non_interactive
	want_extended
	want_author
	want_release

	enable_smoke
	enable_non_interactive
	enable_extended
	enable_author
	enable_release

	disable_smoke
	disable_non_interactive
	disable_release
	disable_extended
	disable_author
	disable_release

	current_settings
);

our %EXPORT_TAGS = (
	'all' => \@EXPORT_OK,
);

sub want_smoke           { return $ENV{AUTOMATED_TESTING} };
sub want_non_interactive { return $ENV{NON_INTERACTIVE}   };
sub want_extended        { return $ENV{EXTENDED_TESTING}  };
sub want_author          { return $ENV{AUTHOR_TESTING}    };
sub want_release         { return $ENV{RELEASE_TESTING}   };

sub enable_smoke           { $ENV{AUTOMATED_TESTING} = 1; }
sub enable_non_interactive { $ENV{NON_INTERACTIVE}   = 1; }
sub enable_extended        { $ENV{EXTENDED_TESTING}  = 1; }
sub enable_author          { $ENV{AUTHOR_TESTING}    = 1; }
sub enable_release         { $ENV{RELEASE_TESTING}   = 1; }

sub disable_smoke           { delete $ENV{AUTOMATED_TESTING} }
sub disable_non_interactive { delete $ENV{NON_INTERACTIVE} }
sub disable_extended        { delete $ENV{EXTENDED_TESTING} }
sub disable_author          { delete $ENV{AUTHOR_TESTING} }
sub disable_release         { delete $ENV{RELEASE_TESTING}  }

sub current_settings {
	my @values = (
		want_smoke() || '',
		want_non_interactive() || '',
		want_extended() || '',
		want_author() || '',
		want_release() || '',
	);

	return sprintf(<<EOF, @values);
want_smoke:           %s
want_non_interactive: %s
want_extended:        %s
want_author:          %s
want_release:         %s
EOF

}

1;
__END__

=head1 NAME

Test::Settings - Ask or tell when certain types of tests should be run

=head1 SYNOPSIS

Check the current settings

  use Test::Settings qw(:all);

  if (want_smoke) {
    printf("I must be a smoke tester\n");
  }  

  if (want_non_interactive) { ... }
  if (want_extended) { ... }
  if (want_author) { ... }
  if (want_release) { ... }

Change settings

  enable_smoke;
  enable_non_interactive;
  enable_extended;
  enable_author;
  enable_release;

  disable_smoke;
  disable_non_interactive;
  disable_extended;
  disable_author;
  disable_release;

Helper - see the settings as a string

  print current_settings;

=head1 DESCRIPTION

There are a number of Environment variables used to control how tests should 
behave, and sometimes these can change names or meaning.

This library tries to provide a consistent interface so that testers/toolchain 
users can determine the state of testing without having to care about the 
intricacies behind the scenes.

=head2 Inspecting the state of things

Currently, the following methods are provided to see what the current state of 
testing options are. Unless explicitly requested by a user or tool, these will 
usually all return false.

=head3 want_smoke

  if (want_smoke) { ... }

Returns true if we are currently being run by a smoker or a 'robot'.

=head3 want_non_interactive

  if (want_non_interactive) { ... }

Returns true if we are in non-interactive mode. This means tests should not 
prompt the user for information.

=head3 want_extended

  if (want_extended) { ... }

Returns true if extended testing has been requested. Often modules will ship 
with extra (non author/release) tests that users may opt in to run.

=head3 want_author

  if (want_author) { ... }

Returns true if author testing has been requested. Author tests are used during 
development time only.

=head3 want_release

  if (want_release) { ... }

Returns true if release testing has been requested. Release tests are used when 
a new release of a distribution is going to be built to check sanity before 
pushing to CPAN.

=head2 Changing the state of things

The methods below allow modification of the state of testing. This can be used 
by smokers and build tools to inform testing tools how to run.

=head3 enable_smoke

=head3 disable_smoke

  enable_smoke();
  disable_smoke();

This enables or disables (default) smoke testing.

=head3 enable_non_interactive

=head3 disable_non_interactive

  enable_non_interactive();
  disable_non_interactive();

This enables or disables (default) non-interactive testing.

=head3 enable_extended

=head3 disable_extended

  enable_extended();
  disable_extended();

This enables or disables (default) extended testing.

=head3 enable_author

=head3 disable_author

  enable_author();
  disable_author();

This enables or disables (default) author testing.

=head3 enable_release

=head3 disable_release

  enable_release();
  disable_release();

This enables or disables (default) release testing.

=head2 Extra information

If you'd like a quick representation of the current state of things, the methods 
below will help you inspect them.

=head3 current_settings

  my $str = current_settings();
  print $str;

Displays a table of the current settings of all wants.

=head1 SEE ALSO

L<Test::Is> - Skip test in a declarative way, following the Lancaster Consensus

=head1 AUTHOR

Matthew Horsfall (alh) - <wolfsage@gmail.com>

=head1 LICENSE

You may distribute this code under the same terms as Perl itself.

=cut
