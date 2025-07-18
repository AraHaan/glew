#!/usr/bin/env perl
##
## Copyright (C) 2008-2025, Nigel Stewart <nigels[]nigels com>
## Copyright (C) 2002-2008, Marcelo E. Magallon <mmagallo[]debian org>
## Copyright (C) 2002-2008, Milan Ikits <milan ikits[]ieee org>
##
## This program is distributed under the terms and conditions of the GNU
## General Public License Version 2 as published by the Free Software
## Foundation or, at your option, any later version.

use strict;
use warnings;
use File::Basename;

use lib '.';
do 'bin/make.pl';

##
## Make Extension-enabled Index
##

my @extlist = ();

if (@ARGV)
{
	@extlist = @ARGV;

	print "/* Detected in the extension string or strings */\n";
	print "static GLboolean  _glewExtensionString[" . scalar @extlist . "];\n";

	print "/* Detected via extension string or experimental mode */\n";
	print "static GLboolean* _glewExtensionEnabled[] = {\n";;

	foreach my $ext (sort { basename($a) cmp basename($b) } @extlist)
	{
		my ($extname, $exturl, $extstring, $reuse, $types, $tokens, $functions, $exacts) = 
			parse_ext($ext);

		my $extvar = $extname;
		$extvar =~ s/GL(X*)_/GL$1EW_/;

		print "#ifdef $extname\n";
		print "  &__$extvar,\n";
		print "#endif\n";
	}

	print "  NULL\n};\n\n";
}
