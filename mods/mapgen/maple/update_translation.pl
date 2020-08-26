#!/usr/bin/perl -w

use strict;
use integer;
use File::Basename;
use File::Find;
use File::Spec;
use Cwd;

my %trstrings;

{
  my $dir = getcwd() or die "Don't know which directory to run from: $!\n";
  chdir $dir;

  find(\&translations, $dir);
  my @strings = keys %trstrings;
  my $size = @strings;
  if ($size > 0)
  {
    my $modname = &get_current_modname($dir);
    my $englishfile = File::Spec->catfile($dir, "locale", "$modname.en.tr");
    open my $trtemplate, ">$englishfile" or die "Cannot write to file $englishfile: $!\n";

    print $trtemplate "# textdomain:$modname\n";
    foreach my $string (sort @strings)
    {
      print $trtemplate "$string=$string\n";
    }

    close $trtemplate;
  }
}

sub translations()
{
  if (-T $_)
  {
    if (m/\.lua/)
    {
      open my $codefile, "<$_";

      while (<$codefile>)
      {
        if (m/S\("(.*?)"\)/)
        {
          if (defined $1)
          {
            $trstrings{$1} = 1;
          }
        }
      }

      close $codefile;
    }
  }
}


sub get_current_modname($)
{
  my ($dir) = @_;

  my $defaultmodname = "modname";
  my $modname = $defaultmodname;

  my $modconf = File::Spec->catfile($dir, "mod.conf");
  if (-T $modconf)
  {
    open my $modconffile, "<$modconf";

    while (<$modconffile>)
    {
      if (m/name\s*=\s*(\S*)/)
      {
        if ($1)
        {
          $modname = $1;
        }
      }
    }

    close $modconffile;
  }

  if ($modname eq $defaultmodname)
  {
    $modname = basename($dir);
  }

  return $modname;
}