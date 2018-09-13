#!/bin/bash

## Original script created by Todd Houle
## 11June2015

## Ridiculously huge amounts of code contribued by MM2270
## Figured to use SavedSearch instead of direct API access per computer
## 28-July-2015

## Update 
## 21-Aug-2015 added enrollment and PO date reports.

## Update
## 4-Sept-2018 added new OS versions. Made Year Manufacture graph

## See ReadMe for usage Information

## API username & password & JSS URL
username="APIUSER"
password="p@ssw0rd"
server="https://server.company.org:8443"

## Variables for final report file and JSS Advanced Search name
final_report="/private/tmp/Mac-report_${dateString}.html"
savedSearchName="JSSReport"

###################

## Get the script start time in seconds
timeStart=$(date +"%s")

## Generate a date string for titlebar
dateString=$(date +"%b-%d-%Y")

rm -f /private/tmp/system-data-report.xml

## Generate the source file from the saved JSS report
## NOTE: This is the primary and only API pull taking place
echo "Getting report $savedSearchName from server....."
curl -H "Accept: application/xml" -sfku "$username:$password" "$server/JSSResource/computerreports/name/$savedSearchName" -X GET | xmllint --format - > /private/tmp/system-data-report.xml

## Set the source file variable
source_file="/private/tmp/system-data-report.xml"

## Pull total # of Macs
numComps=$(awk -F'>|<' '/<Computer_Name>/{print $2}' "$source_file" | wc -l | sed 's/^ *//')

if [ "$numComps" == "0" ]; then
    echo "Error: no computers in set to build report on!"
    exit 1
fi

todayDate=$(date +"%d-%b-%Y %T")

echo "Found $numComps Computers"
echo "<html>  <head> <title>$todayDate --  $numComps Computers in $server</title></head><body>" > "$final_report"


echo "<script type=\"text/javascript\" src=\"https://www.gstatic.com/charts/loader.js\"></script>
    <script type=\"text/javascript\">
      google.charts.load('current', {'packages':['bar','controls','corechart']});
      google.charts.setOnLoadCallback(drawChart_chart_divOsv);
      google.charts.setOnLoadCallback(drawChart_chart_divMod2);
      google.charts.setOnLoadCallback(drawChart_chart_yearManf);
      google.charts.setOnLoadCallback(drawChart_chart_divMod);
      google.charts.setOnLoadCallback(drawChart_chart_divFV2);
      google.charts.setOnLoadCallback(drawChart_chart_divProc);
      google.charts.setOnLoadCallback(drawChart_chart_divRam);
      google.charts.setOnLoadCallback(drawChart_chart_divEnroll);">> "$final_report"


function getManufYear ()
{
awk -F'>|<' '/<Serial_Number>/{print $3}' "$source_file" > /tmp/serialnumList.$$

m2010=0
m2011=0
m2012=0
m2013=0
m2014=0
m2015=0
m2016=0
m2017=0
m2018=0
m2019=0
munkn=0 #made in unknown                                                                                                                                                                                                                                                                             

while read -r LINE; do
    thisChar=$(echo "$LINE" |head -c 4 |tail -c 1)

    case $thisChar in
[C]*)
   m2010=$((m2010+1))
;;
[D]*)
   m2010=$((m2010+1))
;;
[F]*)
   m2011=$((m2011+1))
;;
[G]*)
   m2011=$((m2011+1))
;;
[H]*)
   m2012=$((m2012+1))
;;
[J]*)
   m2012=$((m2012+1))
;;
[K]*)
   m2013=$((m2013+1))
;;
[L]*)
   m2013=$((m2013+1))
;;
[M]*)
   m2014=$((m2014+1))
;;
[N]*)
   m2014=$((m2014+1))
;;
[P]*)
   m2015=$((m2015+1))
;;
[Q]*)
   m2015=$((m2015+1))
;;
[R]*)
   m2016=$((m2016+1))
;;
[S]*)
   m2016=$((m2016+1))
;;
[T]*)
   m2017=$((m2017+1))
;;
[V]*)
   m2017=$((m2017+1))
;;
[W]*)
   m2018=$((m2018+1))
;;
[X]*)
   m2018=$((m2018+1))
;;
[Y]*)
   m2019=$((m2019+1))
;;
[Z]*)
   m2019=$((m2019+1))
;;
*)
  munkn=$((munkn+1))
;;
esac

done < /tmp/serialnumList.$$

#echo "$m2010, $m2011, $m2012, $m2013, $m2014, $m2015, $m2016, $m2017, $m2018, $m2019 unknown $munkn"

{
echo "function drawChart_chart_yearManf() {

// Create the data table.
var data = google.visualization.arrayToDataTable([
"

echo "['Year', 'Quantity']",
echo "['2010', $m2010],"
echo "['2011', $m2011],"
echo "['2012', $m2012],"
echo "['2013', $m2013],"
echo "['2014', $m2014],"
echo "['2015', $m2015],"
echo "['2016', $m2016],"
echo "['2017', $m2017],"
echo "['2018', $m2018],"
echo "['2019', $m2019],"
echo "['Unknown', $munkn]"

echo "]);

// Set chart options
var options = {chart: {
title: 'year of Manufacture',
subtitle: 'Quantity per year',
'width':1100,
'height':1100,
},
bars: 'horizontal' // Required for Material Bar Charts.
};


// Instantiate and draw our chart, passing in some options.
var chart = new google.charts.Bar(document.getElementById('chart_yearManf'));        
chart.draw(data, options);
}"

} >> "$final_report"


rm /tmp/serialnumList.$$
}



function genOSVers ()
{

## FUNCTION TO GRAB ALL OS VERSIONS

echo "Determining OS Versions..."

## Parse xml file for list of all major OS versions and associated counts
allOSVers=$(awk -F'>|<' '/Operating_System/{print $3}' "$source_file" | sed '/^$/d;/^[ ]/d' | cut -d. -f2 \
    | sort -r | uniq -c | sed 's/^ *//g' | awk '{t=$1; $1=""; $(NF+1)=t}1' | sed 's/^ *//g' | sort -nr)

## Loop over results, setting variables and placing OS versions/names and associated counts into final array
while read osMajKey; do
    ## Get Major OS version number and qty
    osMajNum=$(echo "$osMajKey" | awk '{print $1}')
    osMajCount=$(echo "$osMajKey" | awk '{print $2}')
    
    case $osMajNum in
	14) 
	    OSName="Mojave" ;;
	13)
	    OSName="High Sierra" ;;
	12) 
	    OSName="Sierra" ;;
	11)
	    OSName="El Capitan" ;;
	10)
	    OSName="Yosemite" ;;
	9)
	    OSName="Mavericks" ;;
	8)
	    OSName="Mountain Lion" ;;
	7)
	    OSName="Lion" ;;
	6)
	    OSName="Snow Leopard" ;;
	5)
	    OSName="Leopard" ;;
	4)
	    OSName="Tiger" ;;
	3)
	    OSName="Panther" ;;
	2)
	    OSName="Jaguar" ;;
	1)
	    OSName="Puma" ;;
	0)
	    OSName="Cheetah" ;;
	*)
	    OSName="Unknown" ;;
    esac
    
    osVersArray+=("['10.${osMajNum}.x \"${OSName}\" (${osMajCount})', ${osMajCount}],")
done < <(printf '%s\n' "$allOSVers")

{
echo "function drawChart_chart_divOsv() {
var data = google.visualization.arrayToDataTable([
['Quantity', 'OS X'],
"

printf '%s\n' "${osVersArray[@]}"

echo "]);

var options = {
chart: {
title: 'OS X',
subtitle: 'Major OS Version Numbers',
'width': 1000,
'height': 500,
},
bars: 'horizontal' // Required for Material Bar Charts.
};

var chart = new google.charts.Bar(document.getElementById('chart_divOsv'));
chart.draw(data, options);
}
"

} >> "$final_report"

}


function genFV2Status ()
{

## FUNCTION TO GATHER FILEVAULT 2 STATUS

echo "Determining FileVault status..."

## Parse xml file for FileVault status strings and associated counts
allFV2Status=$(awk -F'>|<' '/<FileVault_2_Status>/{print $3}' "$source_file" | sed '/^$/d' | sort -n | uniq -c | sed 's/^ *//g')

## Loop over results, creating variables and final array
while read encryption; do
    encState=$(echo "$encryption" | cut -d" " -f2-)
    encCount=$(echo "$encryption" | awk '{print $1}')
    
    encryptionArray+=("['${encState} (${encCount})', ${encCount}],")
done < <(printf '%s\n' "$allFV2Status")


{
echo "function drawChart_chart_divFV2() {

// Create the data table.
var data = new google.visualization.DataTable();
data.addColumn('string','Ram');
data.addColumn('number','Macs');
data.addRows([
"

printf '%s\n' "${encryptionArray[@]}"

echo "
]);

// Set chart options
var options = {
'title':'FileVault Encryption Compliance',
'legend':'left',
//'width':1000,
//'height':500,
is3D: true,
};

// Instantiate and draw our chart, passing in some options.
var chart = new google.visualization.PieChart(document.getElementById('chart_divFV2'));
chart.draw(data, options);
}
"

} >> "$final_report"

}


function genModelTypes ()
{

## FUNCTION TO GATHER GENERAL HARDWARE TYPES

echo "Determining Hardware Type..."

Mini=0
MacBook=0
MacBookPro=0
MacBookAir=0
MacPro=0
G5=0
VMware=0
iMac=0

## Parse xml file for model types and counts
allModelTypes=$(awk -F'>|<' '/Model_Identifier/{print $3}' "$source_file" | sed -e '/^$/d;/system_profiler/d' | sed -e 's/[0-9]//g;s/,$//g' | sort -f | uniq -c | sed 's/^ *//g')

## Loop over results, extracting model genres and associated counts
while read hardwareModel; do
modelType=$(echo "$hardwareModel" | awk '{print $2}')
modelCount=$(echo "$hardwareModel" | awk '{print $1}')

if [[ "$modelType" == "iMac" ]]; then
iMac=$((iMac+$modelCount))
fi

if [[ "$modelType" == "MacBook" ]]; then
MacBook=$((MacBook+$modelCount))
fi

if [[ "$modelType" == "MacBookAir" ]]; then
MacBookAir=$((MacBookAir+$modelCount))
fi

if [[ "$modelType" == "MacBookPro" ]]; then
MacBookPro=$((MacBookPro+modelCount))
fi

if [[ "$modelType" == "Macmini" ]]; then
Mini=$((Mini+modelCount))
fi

if [[ "$modelType" == "MacPro" ]]; then
    MacPro=$((MacPro+$modelCount))
    fi

if [[ "$modelType" == "VMware" ]]; then
    Vmware=$((Vwware+$modelCount))
    fi

if [[ "$modelType" == "G5" ]]; then
    G5=$((G5+$modelCount))
    fi

done < <(printf '%s\n' "$allModelTypes")

{
echo "function drawChart_chart_divMod() {

// Create the data table.
var data = new google.visualization.DataTable();
data.addColumn('string','Model');
data.addColumn('number','Macs');
data.addRows([
"

echo "['Mac Mini ($Mini)', $Mini],"
echo "['MacBookPro ($MacBookPro)', $MacBookPro],"
echo "['MacBookAir ($MacBookAir)', $MacBookAir],"
echo "['MacBook ($MacBook)', $MacBook],"
echo "['G5 ($G5)', $G5],"
echo "['VMWare ($Vmware)', $Vmware],"
echo "['iMac ($iMac)', $iMac],"
echo "['MacPro ($MacPro)', $MacPro],"

echo "
]);

// Set chart options
var options = {'title':'General Mac Model Type',
'legend':'left',
//'width':1000,
//'height':500,
is3D: true
};

// Instantiate and draw our chart, passing in some options.
var chart = new google.visualization.PieChart(document.getElementById('chart_divMod'));        
chart.draw(data, options);
}"

} >> "$final_report"

}


function genModelsFull ()
{

## FUNCTION TO PULL ALL SPECIFIC MODEL DETAILS

echo "Determining individual Mac model counts..."

## Parse xml file for specific model info, and produce counts
allModelsGranular=$(awk -F'>|<' '/<Model>/{print $3}' "$source_file" | sed -e '/^$/d;/system_profiler/d' | sort -f | uniq -c | sed 's/^ *//g')

## Loop over results, extracting model name and associated counts, placing into final array
while read hardwareModel; do
    modelSpecific=$(echo "$hardwareModel" | cut -d" " -f2-)
    modelCountExact=$(echo "$hardwareModel" | cut -d" " -f1)
    
    modelArray+=("['${modelSpecific} ($modelCountExact)', $modelCountExact],")
done < <(printf '%s\n' "$allModelsGranular")


{
echo "function drawChart_chart_divMod2() {

// Create the data table.
var data = google.visualization.arrayToDataTable([
['Individual Models', 'Quantity'],
"

printf '%s\n' "${modelArray[@]}"

echo "
]);

// Set chart options
var options = {chart: {
title: 'Mac Models',
subtitle: 'Individual model counts',
'width':1100,
'height':1100,
},
bars: 'horizontal' // Required for Material Bar Charts.

};

// Instantiate and draw our chart, passing in some options.
var chart = new google.charts.Bar(document.getElementById('chart_divMod2'));        
chart.draw(data, options);
}
"

} >> "$final_report"


}


##################################
function getEnrollmentDate ()
{

## FUNCTION TO GET PURCHASE DATE OF MAC

echo "Determining enrollment date of machine..."

## Parse xml file for specific model info, and produce counts
allEnrollmentDates=$(awk -F'>|<' '/<Last_Enrollment>/{print $3}' "$source_file"|awk '{print $1}'|cut -c1-7| sed -e '/^$/d;/system_profiler/d' | sort -f | uniq -c | sed 's/^ *//g')

## Loop over results, extracting purchase date and associated counts, placing into final array
while read EnrollmentDate; do
    EnrollMentDateSpecific=$(echo "$EnrollmentDate" |  awk '{print $2}')
    EnrollCountExact=$(echo "$EnrollmentDate" | cut -d" " -f1)
    
    EnrollArray+=("['${EnrollMentDateSpecific} ($EnrollCountExact)', $EnrollCountExact],")
done < <(printf '%s\n' "$allEnrollmentDates")


{
echo "function drawChart_chart_divEnroll() {

// Create the data table.
var data = google.visualization.arrayToDataTable([
['Date', 'Quantity'],
"

printf '%s\n' "${EnrollArray[@]}"

echo "
]);

// Set chart options
var options = {chart: {
title: 'Enrollments By Month',
subtitle: 'Number of computers enrolled on each month',
'width':1100,
'height':2100,
},
bars: 'horizontal' // Required for Material Bar Charts.

};

// Instantiate and draw our chart, passing in some options.
var chart = new google.charts.Bar(document.getElementById('chart_divEnroll'));        
chart.draw(data, options);
}"

} >> "$final_report"


}

##################################




function genProcTypes ()
{

## FUNCTION TO GATHER PROCESSOR TYPES

echo "Determining process types..."

## Parse xml file for processor type strings and associated counts
allProcTypes=$(awk -F'>|<' '/<Processor_Type>/{print $3}' "$source_file" | sed '/^$/d' | sort -g | uniq -c | sed 's/^ *//g')

## Loop over results, extracting processor names and counts and placing into an array
while read processor; do
    procType=$(echo "$processor" | cut -d" " -f2-)
    procCount=$(echo "$processor" | awk '{print $1}')
    
    procArray+=("['${procType} (${procCount})', ${procCount}],")
done < <(printf '%s\n' "$allProcTypes")

{
    #print ram header html code
    echo "function drawChart_chart_divProc() {

// Create the data table.
var data = new google.visualization.DataTable();
data.addColumn('string','Ram');
data.addColumn('number','Processors');
data.addRows([
"

printf '%s\n' "${procArray[@]}"

echo "
]);

// Set chart options
var options = {'title':'Processor types',
'legend':'left',
//'width':1000,
//'height':500,
'chartArea.top': 0,
is3D: true
};

// Instantiate and draw our chart, passing in some options.
var chart = new google.visualization.PieChart(document.getElementById('chart_divProc'));
chart.draw(data, options);
}
"

} >> "$final_report"

}


function genRAMSizes ()
{

## FUNCTION TO GATHER MEMORY ALLOCATIONS

echo "Determining RAM values..."

## Parse xml for list of all RAM values and associated counts
allRAMVals=$(awk -F'>|<' '/Total_RAM_MB/{print $3}' "$source_file" | sed '/^$/d' | sed -e '/^$/d;/^[ ]/d' | sort -n | uniq -c | sed 's/^ *//g')

while read RAM; do
    ramKB=$(echo "$RAM" | awk '{print $2}')
    ramCount=$(echo "$RAM" | awk '{print $1}')
    
    ramCalc=$(expr $ramKB / 1024)
    
    if [ $ramCalc -lt 1 ]; then
	ramGB="$ramKB"
	divSize="KB"
	else
	ramGB="$ramCalc"
	divSize="GB"
	fi
    
    ramArray+=("['${ramGB} $divSize (${ramCount})', ${ramCount}],")
done < <(printf '%s\n' "$allRAMVals")


{
#print ram header html code
echo "function drawChart_chart_divRam() {

// Create the data table.
var data = new google.visualization.DataTable();
data.addColumn('string','Ram');
data.addColumn('number','Macs');
data.addRows([
"

printf '%s\n' "${ramArray[@]}"

echo "
]);

// Set chart options
var options = {'title':'Memory distribution',
'legend':'left',
//'width':1000,
//'height':500,
'chartArea.top': 0,
is3D: true
};

// Instantiate and draw our chart, passing in some options.
var chart = new google.visualization.PieChart(document.getElementById('chart_divRam'));
chart.draw(data, options);
}
"

} >> "$final_report"

}

## lit of functions to run
genOSVers
genModelTypes
genModelsFull
genFV2Status
genProcTypes
genRAMSizes
getEnrollmentDate
getManufYear

echo "</script>" >> "$final_report"
echo "Closing Report...."
echo "
<div id=\"chart_yearManf\" style=\"width: 900px; height: 500px;\"></div>
<div id=\"chart_divOsv\" style=\"width: 900px; height: 500px;\"></div>
<div id=\"chart_divMod\" style=\"width: 950px; height: 600px;\"></div>
<div id=\"chart_divMod2\" style=\"width: 1100px; height: 1100px;\"></div>
<div id=\"chart_divFV2\" style=\"width: 1100px; height: 600px;\"></div>
<div id=\"chart_divProc\" style=\"width: 950px; height: 600px;\"></div>
<div id=\"chart_divEnroll\" style=\"width: 950px; height: 1200px;\"></div>
<div id=\"chart_divRam\" style=\"width: 950px; height: 600px;\"></div>

  </body>
</html>
"  >> "$final_report"
echo "$numComps Computers<BR>" >> "$final_report"

timeEnd=$(date +"%s")

echo "Script run time: $(expr $timeEnd - $timeStart) seconds"

todayDateL8r=$(date +"%d-%b-%Y %T")
echo "Reported Generated: $todayDateL8r<br>" >> "$final_report"

cp "$final_report" /Library/WebServer/Documents/report.html
cp "$final_report" /Library/WebServer/Documents/

#echo "Creating PDF report..."
#fileName=$(echo "$final_report" | awk -F'/' '{print $NF}')
#pdfName="${fileName%.*}"
#loggedInUser=$(ls -l /dev/console | awk '{print $3}')
#/usr/local/bin/wkhtmltopdf -s Tabloid "$final_report" /Users/$loggedInUser/Desktop/${pdfName}.pdf 2>&1 > /dev/null

#open /Users/$loggedInUser/Desktop/${pdfName}.pdf
#open "$final_report"

exit 0
