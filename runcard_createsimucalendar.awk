#!/usr/bin/gawk -f
#
# Author: Patrick Brockmann
# Contact: Patrick.Brockmann@cea.fr
# $Date: 2009/05/14 15:09:35 $
# $Name: ATLAS_608_1_5 $
# $Revision: 1.1.1.2 $
# History:
# Modification:
#
#==========================
# Create a ferret script to display for each period ( line from run.card) a line 
# in real calendar from RunDateBegin to RunDateEnd
#
#==========================
# Lines from run.card are
# CumulPeriod | PeriodDateBegin |   PeriodDateEnd |        RunDateBegin |          RunDateEnd |     RealCpuTime |     UserCpuTime |      SysCpuTime | ExeDate
#           1 |        18500101 |        18500130 | 2008-06-15T18:15:23 | 2008-06-15T18:32:25 |      1022.02607 |      6543.68308 |        27.43715 | ATM_2009-06-12T09:34+SRF_2009-06-12T09:34+OCE_2009-06-12T09:34+ICE_2009-06-12T09:34+CPL_2009-06-12T09:34
# There are 9 fields to read

#==========================
function convertdatetoferretformat(date) {
# Transform YYYY-MM-DDThh:mm:ss to DD-MMM-YYYY

# RunDateBegin
YYYY=substr(date,1,4)
MM=substr(date,6,2)
DD=substr(date,9,2)

if (MM ~ "01")      MMM="JAN"
else if (MM ~ "02") MMM="FEB"
else if (MM ~ "03") MMM="MAR"
else if (MM ~ "04") MMM="APR"
else if (MM ~ "05") MMM="MAY"
else if (MM ~ "06") MMM="JUN"
else if (MM ~ "07") MMM="JUL"
else if (MM ~ "08") MMM="AUG"
else if (MM ~ "09") MMM="SEP"
else if (MM ~ "10") MMM="OCT"
else if (MM ~ "11") MMM="NOV"
else if (MM ~ "12") MMM="DEC"

return DD"-"MMM"-"YYYY" "substr(date,12,length(date)-1)
}


#==========================
BEGIN {

# Field separator is '|'
# 9 fields are then detected
FS = "|"

print ""
print "!=================================="
print "set memory/size=100"
print ""
print "!=================================="
print "sp rm -f ($01)"
print ""

firstdate=0
numbern=0
minRealCPUTime=1E9
maxRealCPUTime=0
sumRealCPUTime=0
minUserCPUTime=1E9
maxUserCPUTime=0
sumUserCPUTime=0
}

#==========================
#--------------------------
# Remove all blanks and character #
{
gsub(/[# ]/,"")
#print NR, NF
}

#--------------------------
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

# RunDateBegin
date1_str=convertdatetoferretformat($4)
#print date1_str
# RunDateEnd
date2_str=convertdatetoferretformat($5)
#print date2_str

print "!=================================="
print "let tt=t[gt=mytaxis]"
print ""
print "def axis/T=\"01-JAN-2008\":\""date1_str"\":1/units=\"seconds\"/t0=\"01-JAN-2008\"/cal=GREGORIAN mytaxis"
print "let task_start=`tt,return=lsize`"
print "def axis/T=\"01-JAN-2008\":\""date2_str"\":1/units=\"seconds\"/t0=\"01-JAN-2008\"/cal=GREGORIAN mytaxis"
print "let task_end=`tt,return=lsize`"
print "list/quiet/nohead/format=(F20.3,' ',F20.3)/append/file=\"($01)\" "$1",task_start"
print "list/quiet/nohead/format=(F20.3,' ',F20.3)/append/file=\"($01)\" "$1",task_end"
print "list/quiet/nohead/format=(F20.3,' ',F20.3)/append/file=\"($01)\" "$1",-999"

if (firstdate == 0) firstdate=currentdate
lastdate=currentdate
lastn=currentn
currentdate=date2_str
currentn=$1

numbern=numbern+1

if ($6 < minRealCPUTime) minRealCPUTime=$6
if ($6 > maxRealCPUTime) maxRealCPUTime=$6
sumRealCPUTime=sumRealCPUTime+$6

if ($7 < minUserCPUTime) minUserCPUTime=$7
if ($7 > maxUserCPUTime) maxUserCPUTime=$7
sumUserCPUTime=sumUserCPUTime+$7

}

#==========================
END {
print ""
print "!=================================="
print "file/var=V1_read,V2_read ($01)"
print "let/bad=-999 V1=V1_read ; let/bad=-999 V2=V2_read"
print ""

print "!=================================="
print "def sym CalendarType=($02)"
print "def sym Delta=($03)"
print "def sym Units=($04)"
print "def sym DateBegin=($05)"
print "def sym DateEnd=($06)"
print "def sym ImageFile=($07)"
print "def axis/t=\"($DateBegin)\":\"($DateEnd)\":($Delta)/edges/units=\"($Units)\"/cal=\"($CalendarType)\" simutaxis1"
print "show axis simutaxis1"
print "let tt2=t[gt=simutaxis1]"
print "def sym yend=`tt2,return=lend`"
print ""
print "!=================================="
print "let a=(y2-y1)/(x2-x1)"
print "let b=y1-a*x1"
print ""
# Get number of seconds from a date to another by creation of an axis to finally get its length
# Note that this is the only way to get a double precision in ferret 
# since all variables are with single precision
print "def axis/T=\"01-JAN-2008\":\""lastdate"\":1/units=\"seconds\"/t0=\"01-JAN-2008\"/cal=GREGORIAN mytaxis"
print "let x1=`tt,return=lsize`"
print "let y1="lastn
print "def axis/T=\"01-JAN-2008\":\""currentdate"\":1/units=\"seconds\"/t0=\"01-JAN-2008\"/cal=GREGORIAN mytaxis"
print "let x2=`tt,return=lsize`"
print "let y2="currentn
print ""
print "def axis/T=\"01-JAN-2008\":\""firstdate"\":1/units=\"seconds\"/t0=\"01-JAN-2008\"/cal=GREGORIAN mytaxis"
print "let xstart=`tt,return=lsize`"
print "let xend=(($yend)-b)/a"
print ""
# Added to avoid memory error when xend_date_str is calculated
print "def axis/T=\"01-JAN-2008\":\"01-JAN-2058\":1/units=\"seconds\"/t0=\"01-JAN-2008\"/cal=GREGORIAN mytaxis"
print ""
print "def sym xend_date_str=`TAX_DATESTRING(xend/86400,tt,\"days\")`"
print ""
print "!=================================="
print "go gif_setsize 800 600"
print ""
print "!=================================="
print "set v full"
print "go margins_set 15 15 20 10"
print "plot/hlim=`xstart`:`xend`/vlim=1:($yend)/nolab/graticule=(dash,grey) tt[l=1]"
print "plot/over/nolab/vs/line/color=2 V2,V1"
print "plot/over/nolab/line/color=green/vs {`x2`,`xend`},{`y2`,($yend)}"
print ""
print "!=================================="
print "def viewport/x=0:1/y=0:1 full2"
print "set v full2"
print "go margins_set 15 15 10 10"
print "plot/nolab/transpose/axes=0,0,1,0 tt2*0+(-1E34)"
print ""
print "!=================================="
print "go text_put 10 85 \" Simulation date\" -1 0.25 50" 
print "go text_put 20 85 \" Simulation period\" -1 0.25 50"
print "go text_put 55 05 \"Execution date\" 0 0.25 0"
print "go text_put 90 88 \"End scheduled : ($xend_date_str)\" +1 0.5 0"
print ""
print "!=================================="
print "spawn echo \"($xend_date_str)\" > progress.txt"
print ""
print "!=================================="
print "frame/file=($ImageFile)"
print ""
print "!=================================="
printf "! RCPUMIN = %10.2f\n",minRealCPUTime
printf "! RCPUMAX = %10.2f\n",maxRealCPUTime
printf "! RCPUAVE = %10.2f\n",sumRealCPUTime/numbern
printf "! UCPUMIN = %10.2f\n",minUserCPUTime
printf "! UCPUMAX = %10.2f\n",maxUserCPUTime
printf "! UCPUAVE = %10.2f\n",sumUserCPUTime/numbern
print ""
print "!=================================="
printf "! NUMBERN     = %20s\n",numbern
printf "! LASTN       = %20s\n",lastn 
printf "! LASTDATE    = %20s\n",lastdate
printf "! CURRENTN    = %20s\n",currentn
printf "! CURRENTDATE = %20s\n",currentdate
print ""

}

