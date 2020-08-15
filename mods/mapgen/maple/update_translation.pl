#!/usr/bin/perl -w

use strict;
use integer;
use File::Find;
use Cwd;

my %trstrings;

{
  my $dir = getcwd();
  chdir $dir;

  find(\&translations, $dir);
  my @strings = keys %trstrings;
  my $size = @strings;
  if ($size > 0)
  {
    open my $trtemplate, ">$dir/locale/maple.en.tr";

    print $trtemplate "# textdomain:maple\n";
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
