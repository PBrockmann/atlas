#!/usr/bin/gawk -f
#
# Author: Patrick Brockmann
# Contact: Patrick.Brockmann@cea.fr
# $Date: 2011/10/11 14:57:58 $
# $Name: ATLAS_672_1_1 $
# $Revision: 1.1.1.4 $
# History:
# Modification:
#
#==========================
BEGIN {

# Field separator is '|'
# 9 fields are then detected
FS = "|"

print "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\""
print "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\" >"
print "<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en-us\">"
print ""
print "<head>"
print "<meta http-equiv=\"Content-Type\" content=\"application/html; charset=utf-8\" />"
print "<title>run.card as sortable table</title>"
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\" />"
print "<script type=\"text/javascript\" src=\"html/jquery-1.6.min.js\"></script>"
print "<link type=\"text/css\" href=\"html/jquery.tablesorter.css\" rel=\"stylesheet\" />"
print "<script type=\"text/javascript\" src=\"html/jquery.tablesorter.min.js\"></script>"
print "<style type=\"text/css\">"
print "body { font-family: Arial,Helvetica,sans-serif; }"
print "</style>"
print "</head>"
print ""
print "<body>"
print ""
print "<table class=\"tablesorter\" id=\"table-1\" cellspacing=\"1\">"
print "<thead>"
print "<tr>"
print "<th>CumulPeriod</th>"
print "<th>PeriodDateBegin</th>"
print "<th>PeriodDateEnd</th>"
print "<th>RunDateBegin</th>"
print "<th>RunDateEnd</th>"
print "<th>RealCpuTime</th>"
print "<th>UserCpuTime</th>"
print "<th>SysCpuTime</th>"
print "<th>ExeDate</th>"
print "</tr>"
print "</thead>"
print ""
print "<tbody>"

N=1
}

#==========================
#--------------------------
# Remove all blanks and character #
{
gsub(/[# ]/,"")
#print NR, NF
}

#--------------------------
# Process only if 9 fields, if the 1st field is number (this removes head of array)
NF == 9 && 
match($1,/^[0-9]+$/) {

print "<tr>"
for (i=1; i<=9 ; i++) {
	print "<td>"$i"</td>"
}
print "</tr>"

N=N+1
}

#==========================
END {

print "</tbody>"
print "</table>"
print ""
print "<script type=\"text/javascript\">"
print "// http://tablesorter.com/docs/"
print "$(document).ready(function() {" 
print "	// extend the default setting to always include the zebra widget." 
print "	$.tablesorter.defaults.widgets = ['zebra'];" 
print "	// extend the default setting to always sort on the first column" 
print "	$.tablesorter.defaults.sortList = [[0,0]];" 
print "	// call the tablesorter plugin" 
print "	$(\"#table-1\").tablesorter();" 
print "});" 
print "</script>"
print ""
print "</body>"
print "</html>"

}

