#!/usr/bin/perl
if (!$::Driver) { use FindBin; exec("$FindBin::Bin/bootstrap.pl", @ARGV, $0); die; }
# DESCRIPTION: Verilator: Verilog Test driver/expect definition
#
# Copyright 2003-2009 by Wilson Snyder. This program is free software; you can
# redistribute it and/or modify it under the terms of either the GNU
# General Public License or the Perl Artistic License.

top_filename("t/t_tri_gate.v");

compile (
	 make_top_shell => 0,
	 make_main => 0,
	 v_flags2 => ['+define+T_NOTIF1',],
	 make_flags => 'CPPFLAGS_ADD=-DT_NOTIF1',
	 verilator_flags2 => ["--exe $Self->{t_dir}/t_tri_gate.cpp"],
	 ) if $Self->{v3};

execute (
	 check_finished=>1,
	 ) if $Self->{v3};

ok(1);
1;
