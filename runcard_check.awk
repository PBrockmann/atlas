#!/usr/bin/gawk -f
#
# Author: Patrick Brockmann
# Contact: Patrick.Brockmann@cea.fr
# $Date: 2011/09/12 12:17:38 $
# $Name: ATLAS_672_1_1 $
# $Revision: 1.1.1.3 $
# History:
# Modification:
#
#==========================
# Lines from run.card are
# CumulPeriod | PeriodDateBegin |   PeriodDateEnd |        RunDateBegin |          RunDateEnd |     RealCpuTime |     UserCpuTime |      SysCpuTime | ExeDate
#           1 |        18500101 |        18500130 | 2008-06-15T18:15:23 | 2008-06-15T18:32:25 |      1022.02607 |      6543.68308 |        27.43715 | ATM_2008-05-30T19:39 OCE_2008-05-30T19:10 CPL_2008-05-30T19:03
# There are 9 fields to read

#==========================
BEGIN {

# Field separator is '|'
# 9 fields are then detected
FS = "|"

nb=0
}

#==========================
#--------------------------
# Remove all blanks and character #
{
gsub(/[# ]/,"")
#print NR, NF
}

#--------------------------
# http://www.gnu.org/manual/gawk/html_node/Regexp-Operators.html

# Process only if 9 fields, if the 1st field is number (this removes head of array) and if the 9 fields are not empty 
NF == 9 && 
match($1,/^[0-9]+$/) && 
length($1) != 0 &&
length($2) != 0 &&
length($3) != 0 &&
length($4) != 0 &&
length($5) != 0 &&
length($6) != 0 &&
length($7) != 0 &&
length($8) != 0 &&
length($9) != 0 {

print $0 
nb=nb+1
}

#==========================
END {
if (nb <= 1) { 
	print "STOP"
}
}

