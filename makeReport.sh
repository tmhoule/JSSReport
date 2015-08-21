#!/bin/bash

## Original script created by Todd Houle
## 11June2015

## Ridiculously huge amounts of code contribued by Mike Morales
## 28-July-2015

## Last Update 
## 21-Aug-2015 added enrollment and PO date reports.

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

## Generate the source file from the saved JSS report
## NOTE: This is the primary and only API pull taking place
echo "Getting report $savedSearchName from server....."
curl -H "Accept: application/xml" -sfku "$username:$password" "$server/JSSResource/computerreports/name/$savedSearchName" -X GET | xmllint --format - > /private/tmp/system-data-report.xml

## Set the source file variable
source_file="/private/tmp/system-data-report.xml"

## Pull total # of Macs
numComps=$(awk -F'>|<' '/<Computer_Name>/{print $2}' "$source_file" | wc -l | sed 's/^ *//')

todayDate=$(date +"%d-%b-%Y %T")

echo "Found $numComps Computers"
echo "<html>  <head> <title>$todayDate --  $numComps Computers in $server</title></head><body>" > "$final_report"

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
echo "<script type=\"text/javascript\" src=\"https://www.google.com/jsapi\"></script>
	<script type=\"text/javascript\">
		google.load(\"visualization\", \"1.1\", {packages:[\"bar\"]});
		google.setOnLoadCallback(drawChart);
		function drawChart() {
		var data = google.visualization.arrayToDataTable([
		['Quantity', 'OS X'],
"

printf '%s\n' "${osVersArray[@]}"

echo "	]);

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
	</script>
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
echo "
	<!--Load the AJAX API-->
	<script type=\"text/javascript\" src=\"https://www.google.com/jsapi\"></script>
	<script type=\"text/javascript\">

		// Load the Visualization API and the piechart package.
		google.load('visualization', '1.1', {'packages':['corechart']});

		// Set a callback to run when the Google Visualization API is loaded.
		google.setOnLoadCallback(drawChart);

		// Callback that creates and populates a data table,
		// instantiates the pie chart, passes in the data and
		// draws it.
		function drawChart() {

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
//			'width':1000,
//			'height':500,
			is3D: true,
			};

		// Instantiate and draw our chart, passing in some options.
		var chart = new google.visualization.PieChart(document.getElementById('chart_divFV2'));
		chart.draw(data, options);
		}
	</script>
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
echo "
	<!--Load the AJAX API-->
	<script type=\"text/javascript\" src=\"https://www.google.com/jsapi\"></script>
	<script type=\"text/javascript\">

		// Load the Visualization API and the piechart package.
		google.load('visualization', '1.1', {'packages':['corechart']});

		// Set a callback to run when the Google Visualization API is loaded.
		google.setOnLoadCallback(drawChart);

		// Callback that creates and populates a data table,
		// instantiates the pie chart, passes in the data and
		// draws it.
		function drawChart() {

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
//					'width':1000,
//					'height':500,
					is3D: true
				};

		// Instantiate and draw our chart, passing in some options.
		var chart = new google.visualization.PieChart(document.getElementById('chart_divMod'));        
		chart.draw(data, options);
		}
	</script>
"

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
echo "
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script type="text/javascript">

		// Load the Visualization API and the piechart package.
		google.load('visualization', '1.1', {'packages':['bar']});

		// Set a callback to run when the Google Visualization API is loaded.
		google.setOnLoadCallback(drawChart);

		// Callback that creates and populates a data table,
		// instantiates the pie chart, passes in the data and
		// draws it.
		function drawChart() {

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
	</script>
"

} >> "$final_report"


}

##########
function getMacAge ()
{

## FUNCTION TO GET PURCHASE DATE OF MAC

echo "Determining purchase date of machine..."

## Parse xml file for specific model info, and produce counts
allPODates=$(awk -F'>|<' '/<PO_Date>/{print $3}' "$source_file"|awk -F- '{print $1}'| sed -e '/^$/d;/system_profiler/d' | sort -f | uniq -c | sed 's/^ *//g')

## Loop over results, extracting purchase date and associated counts, placing into final array
while read PODdate; do
	PODateSpecific=$(echo "$PODdate" |  awk '{print $2}'|cut -c1-4)
	POCountExact=$(echo "$PODdate" | cut -d" " -f1)
	
	poArray+=("['${PODateSpecific} ($POCountExact)', $POCountExact],")
done < <(printf '%s\n' "$allPODates")


{
echo "
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script type="text/javascript">

		// Load the Visualization API and the piechart package.
		google.load('visualization', '1.1', {'packages':['bar']});

		// Set a callback to run when the Google Visualization API is loaded.
		google.setOnLoadCallback(drawChart);

		// Callback that creates and populates a data table,
		// instantiates the pie chart, passes in the data and
		// draws it.
		function drawChart() {

		// Create the data table.
		var data = google.visualization.arrayToDataTable([
		['Date', 'Quantity'],
"

printf '%s\n' "${poArray[@]}"

echo "
				]);

		// Set chart options
		var options = {chart: {
				title: 'Purchase Year',
				subtitle: 'Computers purchased by year',
					'width':1100,
					'height':2100,
				},
		bars: 'horizontal' // Required for Material Bar Charts.
		
		};
		
		// Instantiate and draw our chart, passing in some options.
		var chart = new google.charts.Bar(document.getElementById('chart_divPO'));        
		chart.draw(data, options);
		}
	</script>
"

} >> "$final_report"


}

#######


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
echo "
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script type="text/javascript">

		// Load the Visualization API and the piechart package.
		google.load('visualization', '1.1', {'packages':['bar']});

		// Set a callback to run when the Google Visualization API is loaded.
		google.setOnLoadCallback(drawChart);

		// Callback that creates and populates a data table,
		// instantiates the pie chart, passes in the data and
		// draws it.
		function drawChart() {

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
		}
	</script>
"

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
	echo "    <!--Load the AJAX API-->
	<script type=\"text/javascript\" src=\"https://www.google.com/jsapi\"></script>
	<script type=\"text/javascript\">

		// Load the Visualization API and the piechart package.
		google.load('visualization', '1.1', {'packages':['corechart']});

		// Set a callback to run when the Google Visualization API is loaded.
		google.setOnLoadCallback(drawChart);

		// Callback that creates and populates a data table,
		// instantiates the pie chart, passes in the data and
		// draws it.
		function drawChart() {

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
//						'width':1000,
//						'height':500,
						'chartArea.top': 0,
						is3D: true
						};

		// Instantiate and draw our chart, passing in some options.
		var chart = new google.visualization.PieChart(document.getElementById('chart_divProc'));
		chart.draw(data, options);
		}
	</script>
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
	echo "    <!--Load the AJAX API-->
	<script type=\"text/javascript\" src=\"https://www.google.com/jsapi\"></script>
	<script type=\"text/javascript\">

		// Load the Visualization API and the piechart package.
		google.load('visualization', '1.1', {'packages':['corechart']});

		// Set a callback to run when the Google Visualization API is loaded.
		google.setOnLoadCallback(drawChart);

		// Callback that creates and populates a data table,
		// instantiates the pie chart, passes in the data and
		// draws it.
		function drawChart() {

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
//						'width':1000,
//						'height':500,
						'chartArea.top': 0,
						is3D: true
						};

		// Instantiate and draw our chart, passing in some options.
		var chart = new google.visualization.PieChart(document.getElementById('chart_divRam'));
		chart.draw(data, options);
		}
	</script>
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
getMacAge
getEnrollmentDate

echo "Closing Report...."
echo "
	<div id=\"chart_divOsv\" style=\"width: 900px; height: 500px;\"></div>
	<div id=\"chart_divMod\" style=\"width: 950px; height: 600px;\"></div>
	<div id=\"chart_divMod2\" style=\"width: 1100px; height: 1100px;\"></div>
	<div id=\"chart_divFV2\" style=\"width: 1100px; height: 600px;\"></div>
	<div id=\"chart_divProc\" style=\"width: 950px; height: 600px;\"></div>
	<div id=\"chart_divRam\" style=\"width: 950px; height: 600px;\"></div>
	<div id=\"chart_divPO\" style=\"width: 950px; height: 1200px;\"></div>
	<div id=\"chart_divEnroll\" style=\"width: 950px; height: 1200px;\"></div>

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
