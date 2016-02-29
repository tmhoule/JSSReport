#!/bin/sh
#Todd Houle
#Feb2016
#This script will build an ugly html page with unused scripts and groups in your JSS


########### EDIT THESE ##################################
JSSURL="https://jss.edu:8443"
user="xxxx"
pass="xxxx"
############################################################


JSS="$JSSURL/JSSResource"
outFile="/private/tmp/UnUsed.html"

mkdir /tmp/JSSCleanup 2>/dev/null

#Get Scripts
curl -H "Accept: application/xml" -sfku "$user:$pass" "$JSS/scripts" -X GET | xmllint --format - > /private/tmp/JSSCleanup/scripts.xml

#get policies
curl -H "Accept: application/xml" -sfku "$user:$pass" "$JSS/policies" -X GET | xmllint --format - > /private/tmp/JSSCleanup/policies.xml

#get SmartGroups
curl -H "Accept: application/xml" -sfku "$user:$pass" "$JSS/computergroups" -X GET | xmllint --format - > /private/tmp/JSSCleanup/groups.xml

#get Configurations
curl -H "Accept: application/xml" -sfku "$user:$pass" "$JSS/computerconfigurations" -X GET | xmllint --format - > /private/tmp/JSSCleanup/configurations.xml

#empty lists
SCRIPTSUSED=()
GROUPSUSED=()

#used at end to compare scripts used and not
scriptList=`cat /tmp/JSSCleanup/scripts.xml |grep "<id>"| awk -F\> '{print $2}'|awk -F\< '{print $1}'`
scriptListArray=($scriptList)

groupsList=`cat /tmp/JSSCleanup/groups.xml |grep "<id>"| awk -F\> '{print $2}'|awk -F\< '{print $1}'`
groupListArray=($groupsList)


#a comment block.
#: <<EOF
#EOF

#loop through Policies
policyList=`cat /tmp/JSSCleanup/policies.xml |grep -i \<id\>|awk -F\> '{print $2}'|awk -F\< '{print $1}'`
arr=($policyList)

#get all policies from JSS and build a list of scripts used
for thisPolicy in "${arr[@]}"; do
    curl -H "Accept: application/xml" -sfku "$user:$pass" "$JSS/policies/id/$thisPolicy" -X GET | xmllint --format - > /private/tmp/JSSCleanup/policy$thisPolicy.xml

    scriptsInPol=`xpath /tmp/JSSCleanup/policy$thisPolicy.xml '/policy/scripts'|grep "<id>"| awk -F\> '{print $2}'|awk -F\< '{print $1}'`
    scrarr=($scriptsInPol)
    for oneScript in "${scrarr[@]}"; do
	echo "script ID $oneScript used in policy number $thisPolicy"

	#Add scripts from policy to array of scripts in use
	if [[ " ${SCRIPTSUSED[@]} " =~ " ${oneScript} " ]]; then
            # whatever you want to do when arr contains value
	    echo "script $oneScript is already listed in use"
	else
            # whatever you want to do when arr doesn't contain value
	    echo "adding script $oneScript to SCRIPTSUSED array"
	    SCRIPTSUSED+=($oneScript)
	fi
    done

    #look for unused smartGroups
    smrtGrpInPol=`xpath /tmp/JSSCleanup/policy$thisPolicy.xml '/policy/scope/computer_groups'|grep "<id>"| awk -F\> '{print $2}'|awk -F\< '{print $1}'`
    smrtGrpArr=($smrtGrpInPol)
    for oneGrp in "${smrtGrpArr[@]}"; do
	echo "group ID $oneGrp used in policy number $thisPolicy"
	if [[ " ${GROUPSUSED[@]} " =~ " ${oneGrp} " ]]; then
            # whatever you want to do when arr contains value
            echo "script $oneGrp is already listed in use"
        else
            # whatever you want to do when arr doesn't contain value
            echo "adding grp $oneGrp to GRPUSED array"
            GROUPSUSED+=($oneGrp)
        fi
    done

    #look for unused smartgroupsExcludedInPolicies
    smrtGrpInPolEx=`xpath /tmp/JSSCleanup/policy$thisPolicy.xml '/policy/scope/exclusions/computer_groups'|grep "<id>"| awk -F\> '{print $2}'|awk -F\< '{print $1}'`
    smrtGrpArr2=($smrtGrpInPolEx)
    for oneGrp in "${smrtGrpArr2[@]}"; do
	echo "group exclusion $oneGrp used in policy number $thisPolicy"
        if [[ " ${GROUPSUSED[@]} " =~ " ${oneGrp} " ]]; then
            # whatever you want to do when arr contains value 
            echo "script $oneGrp is already listed in use"
        else
            # whatever you want to do when arr doesn't contain value 
            echo "adding grp $oneGrp to GRPUSED array"
            GROUPSUSED+=($oneGrp)
        fi
    done



done


#Get all configurations from JSS 
configurationList=`cat /tmp/JSSCleanup/configurations.xml |grep -i \<id\>|awk -F\> '{print $2}'|awk -F\< '{print $1}'`
arrConfig=($configurationList)
for thisConfig in "${arrConfig[@]}"; do
    curl -H "Accept: application/xml" -sfku "$user:$pass" "$JSS/computerconfigurations/id/$thisConfig" -X GET | xmllint --format - > /private/tmp/JSSCleanup/config$thisConfig.xml
    scriptsInConfig=`xpath /tmp/JSSCleanup/config$thisConfig.xml '/computer_configuration/scripts/script/id'| awk -F\> '{print $2}'|awk -F\< '{print $1}'`
    confiArr=($scriptsInConfig)
    for oneConScript in "${confiArr[@]}"; do
	echo "script ID $oneConScript used in config $thisConfig"
	#Add scripts from policy to array of scripts in use                                                                                                                                               
	if [[ " ${SCRIPTSUSED[@]} " =~ " ${oneConScript} " ]]; then
            # whatever you want to do when arr contains value
            echo "script $oneConScript is already listed in use"
	else
            echo "adding script $oneConScript to SCRIPTSUSED array"
            SCRIPTSUSED+=($oneConScript)
	fi
    done
done


echo "Moving to part two now..."
echo ""

#build array of script id's that are not used in any policies
Array3=()
for i in "${scriptListArray[@]}"; do
    skip=
    for j in "${SCRIPTSUSED[@]}"; do
        [[ $i == $j ]] && { skip=1; break; }
    done
    [[ -n $skip ]] || Array3+=("$i")
done
declare -p Array3



ArrayGrp=()
for x in "${groupListArray[@]}"; do
    skip=
    for y in "${GROUPSUSED[@]}"; do
	[[ $x == $y ]] && { skip=1; break; }
    done
    [[ -n $skip ]] || ArrayGrp+=("$x")
done
declare -p ArrayGrp


scriptCount=0
echo ""  > $outFile

for unusedScript in "${Array3[@]}"; do
    ((scriptCount=scriptCount+1))
done
echo "There are $scriptCount unused Scripts in your JSS"

echo "<h2>Unused Scripts: $scriptCount</h2>" >> $outFile
echo "<ul>" >> $outFile
for unusedScript in "${Array3[@]}"; do
    scriptName=`grep -A1 "<id>$unusedScript</id>" /tmp/JSSCleanup/scripts.xml |grep "<name>" |awk -F\> '{print $2}'|awk -F\< '{print $1}'`
    echo "<li><a target=\"_blank\" href=\"$JSSURL/scripts.html?id=$unusedScript\">Script: $scriptName</a><BR>" >> $outFile
done
echo "</ul>" >> $outFile



grpCount=0
for unusedGroup in "${ArrayGrp[@]}"; do
    ((grpCount=grpCount+1))
done
echo "There are $grpCount unused Groups in your JSS"

echo "<h2>Unused Groups: $grpCount</h2>" >> $outFile
echo "<ul>" >> $outFile
for unusedgroup in "${ArrayGrp[@]}"; do
    groupType=`grep -A2 "<id>$unusedgroup</id>" /tmp/JSSCleanup/groups.xml |grep "<is_smart>" |awk -F\> '{print $2}'|awk -F\< '{print $1}'`
    
    groupName=`grep -A1 "<id>$unusedgroup</id>" /tmp/JSSCleanup/groups.xml |grep "<name>" |awk -F\> '{print $2}'|awk -F\< '{print $1}'`
    if [ "$groupType" == "true" ]; then
	echo "<li><a target=\"_blank\" href=\"$JSSURL/smartComputerGroups.html?id=$unusedgroup\">Smart Group: $groupName</a><BR>" >> $outFile
    else
	echo "<li><a target=\"_blank\" href=\"$JSSURL/staticComputerGroups.html?id=$unusedgroup\">Static Group: $groupName</a><BR>" >> $outFile
    fi
done
echo "</ul>" >> $outFile



open $outFile



