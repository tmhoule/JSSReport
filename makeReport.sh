#!/bin/bash
#Todd Houle
#11June2015
#To create a report of hardware info from JSS API

username="User"
password="Passw0rd"
server="https://server.company.org:8443"

#gets list of ID numbers of all computers in the JSS
#allComputers=$(curl -s -u "$username:$password" "$server/JSSResource/computers/match/vascor*" -X GET | xpath '//id' | sed 's*</id>*\'$'\n*g' | sed 's*<id>**g')
allComputers=$(curl -s -u "$username:$password" "$server/JSSResource/computers" -X GET \
    | xpath '//id' \
    | sed 's*</id>*\'$'\n*g' \
    | sed 's*<id>**g')

todayDate=$(date +"%d-%b-%Y")

numComps=0
for oneComputer in $allComputers; do
    ((numComps++))
done

echo "<html>\n  <head>\n <title>$todayDate --  $numComps Computers in $server</title>" > report-temp.html

#clear ram counters for each thousand
x1kram=0;x2kram=0;x3kram=0;x4kram=0;x5kram=0;x6kram=0;x7kram=0;x8kram=0;x9kram=0;x10kram=0
x11kram=0;x12kram=0;x13kram=0;x14kram=0;x15kram=0;x16kram=0;x17kram=0;x18kram=0;x19kram=0;x20kram=0
x21kram=0;x22kram=0;x23kram=0;x24kram=0;x25kram=0;x26kram=0;x27kram=0;x28kram=0;x29kram=0;x30kram=0
x31kram=0;x32kram=0;x33kram=0;x34kram=0;x35kram=0;x36kram=0;x37kram=0;x38kram=0;x39kram=0;x40kram=0
x41kram=0;x42kram=0;x43kram=0;x44kram=0;x45kram=0;x46kram=0;x47kram=0;x48kram=0;x49kram=0;x50kram=0
x51kram=0;x52kram=0;x53kram=0;x54kram=0;x55kram=0;x56kram=0;x57kram=0;x58kram=0;x59kram=0;x60kram=0
x61kram=0;x62kram=0;x63kram=0;x64kram=0;x65kram=0;x66kram=0;x67kram=0;x68kram=0;x69kram=0;x70kram=0
x71kram=0;x72kram=0;x73kram=0;x74kram=0;x75kram=0;x76kram=0;x77kram=0;x78kram=0;x79kram=0;x80kram=0
x81kram=0;x82kram=0;x83kram=0;x84kram=0;x85kram=0;x86kram=0;x87kram=0;x88kram=0;x89kram=0;x90kram=0
x91kram=0;x92kram=0;x93kram=0;x94kram=0;x95kram=0;x96kram=0;x97kram=0;x98kram=0;x99kram=0;x100kram=0

#count ram in each machine and add to counter variable
echo "Counting RAM in each computer...."
for oneComputer in $allComputers; do
    ram=$(curl -s -u "$username:$password" "$server/JSSResource/computers/id/$oneComputer" \
        | xpath '/computer/hardware/total_ram_mb' \
        | sed 's*<total_ram_mb>*\'$'\n*g' \
        | sed 's*</total_ram_mb>*\'$'\n*g' \
        | tail -2 \
        | head -1)
    echo "computer id $oneComputer has $ram RAM."
    case $ram in
         1[0-9][0-9][0-9])
            ((x1kram++));;
        2[0-9][0-9][0-9])
            ((x2kram++));;
        3[0-9][0-9][0-9])
            ((x3kram++));;
        4[0-9][0-9][0-9])
            ((x4kram++));;
        5[0-9][0-9][0-9])
            ((x5kram++));;
        6[0-9][0-9][0-9])
            ((x6kram++));;
        7[0-9][0-9][0-9])
            ((x7kram++));;
        8[0-9][0-9][0-9])
            ((x8kram++));;
        9[0-9][0-9][0-9])
            ((x9kram++));;
        10[0-9][0-9][0-9])
            ((x10kram++));;
        11[0-9][0-9][0-9])
            ((x11kram++));;
        12[0-9][0-9][0-9])
            ((x12kram++));;
        13[0-9][0-9][0-9])
            ((x13kram++));;
        14[0-9][0-9][0-9])
            ((x14kram++));;
        15[0-9][0-9][0-9])
            ((x15kram++));;
        16[0-9][0-9][0-9])
            ((x16kram++));;
        17[0-9][0-9][0-9])
            ((x17kram++));;
        18[0-9][0-9][0-9])
            ((x18kram++));;
        19[0-9][0-9][0-9])
            ((x19kram++));;
        20[0-9][0-9][0-9])
            ((x20kram++));;
        21[0-9][0-9][0-9])
            ((x21kram++));;
        22[0-9][0-9][0-9])
            ((x22kram++));;
        23[0-9][0-9][0-9])
            ((x23kram++));;
        24[0-9][0-9][0-9])
            ((x24kram++));;
        25[0-9][0-9][0-9])
            ((x25kram++));;
        26[0-9][0-9][0-9])
            ((x26kram++));;
        27[0-9][0-9][0-9])
            ((x27kram++));;
        28[0-9][0-9][0-9])
            ((x28kram++));;
        29[0-9][0-9][0-9])
            ((x29kram++));;
        30[0-9][0-9][0-9])
            ((x30kram++));;
        31[0-9][0-9][0-9])
            ((x31kram++));;
        32[0-9][0-9][0-9])
            ((x32kram++));;
        33[0-9][0-9][0-9])
            ((x33kram++));;
        34[0-9][0-9][0-9])
            ((x34kram++));;
        35[0-9][0-9][0-9])
            ((x35kram++));;
        36[0-9][0-9][0-9])
            ((x36kram++));;
        37[0-9][0-9][0-9])
            ((x37kram++));;
        38[0-9][0-9][0-9])
            ((x38kram++));;
        39[0-9][0-9][0-9])
            ((x39kram++));;
        40[0-9][0-9][0-9])
            ((x40kram++));;
        41[0-9][0-9][0-9])
            ((x41kram++));;
        42[0-9][0-9][0-9])
            ((x42kram++));;
        43[0-9][0-9][0-9])
            ((x43kram++));;
        44[0-9][0-9][0-9])
            ((x44kram++));;
        45[0-9][0-9][0-9])
            ((x45kram++));;
        46[0-9][0-9][0-9])
            ((x46kram++));;
        47[0-9][0-9][0-9])
            ((x47kram++));;
        48[0-9][0-9][0-9])
            ((x48kram++));;
        49[0-9][0-9][0-9])
            ((x49kram++));;
        50[0-9][0-9][0-9])
            ((x50kram++));;
        51[0-9][0-9][0-9])
            ((x51kram++));;
        52[0-9][0-9][0-9])
            ((x52kram++));;
        53[0-9][0-9][0-9])
            ((x53kram++));;
        54[0-9][0-9][0-9])
            ((x54kram++));;
        55[0-9][0-9][0-9])
            ((x55kram++));;
        56[0-9][0-9][0-9])
            ((x56kram++));;
        57[0-9][0-9][0-9])
            ((x57kram++));;
        58[0-9][0-9][0-9])
            ((x58kram++));;
        59[0-9][0-9][0-9])
            ((x59kram++));;
        60[0-9][0-9][0-9])
            ((x60kram++));;
        61[0-9][0-9][0-9])
            ((x61kram++));;
        62[0-9][0-9][0-9])
            ((x62kram++));;
        63[0-9][0-9][0-9])
            ((x63kram++));;
        64[0-9][0-9][0-9])
            ((x64kram++));;
        65[0-9][0-9][0-9])
            ((x65kram++));;
        66[0-9][0-9][0-9])
            ((x66kram++));;
        67[0-9][0-9][0-9])
            ((x67kram++));;
        68[0-9][0-9][0-9])
            ((x68kram++));;
        69[0-9][0-9][0-9])
            ((x69kram++));;
        70[0-9][0-9][0-9])
            ((x70kram++));;
        71[0-9][0-9][0-9])
            ((x71kram++));;
        72[0-9][0-9][0-9])
            ((x72kram++));;
        73[0-9][0-9][0-9])
            ((x73kram++));;
        74[0-9][0-9][0-9])
            ((x74kram++));;
        75[0-9][0-9][0-9])
            ((x75kram++));;
        76[0-9][0-9][0-9])
            ((x76kram++));;
        77[0-9][0-9][0-9])
            ((x77kram++));;
        78[0-9][0-9][0-9])
            ((x78kram++));;
        79[0-9][0-9][0-9])
            ((x79kram++));;
        80[0-9][0-9][0-9])
            ((x80kram++));;
        81[0-9][0-9][0-9])
            ((x81kram++));;
        82[0-9][0-9][0-9])
            ((x82kram++));;
        83[0-9][0-9][0-9])
            ((x83kram++));;
        84[0-9][0-9][0-9])
            ((x84kram++));;
        85[0-9][0-9][0-9])
            ((x85kram++));;
        86[0-9][0-9][0-9])
            ((x86kram++));;
        87[0-9][0-9][0-9])
            ((x87kram++));;
        88[0-9][0-9][0-9])
            ((x88kram++));;
        89[0-9][0-9][0-9])
            ((x89kram++));;
        90[0-9][0-9][0-9])
            ((x90kram++));;
        91[0-9][0-9][0-9])
            ((x91kram++));;
        92[0-9][0-9][0-9])
            ((x92kram++));;
        93[0-9][0-9][0-9])
            ((x93kram++));;
        94[0-9][0-9][0-9])
            ((x94kram++));;
        95[0-9][0-9][0-9])
            ((x95kram++));;
        96[0-9][0-9][0-9])
            ((x96kram++));;
        97[0-9][0-9][0-9])
            ((x97kram++));;
        98[0-9][0-9][0-9])
            ((x98kram++));;
        99[0-9][0-9][0-9])
            ((x99kram++));;
    esac
done

{
    cat ./ram-header.html
    echo "['1G', $x1kram],"
    echo "['2G', $x2kram],"
    echo "['3G', $x3kram],"
    echo "['4G', $x4kram],"
    echo "['5G', $x5kram],"
    echo "['6G', $x6kram],"
    echo "['7G', $x7kram],"
    echo "['8G', $x8kram],"
    echo "['9G', $x9kram],"
    echo "['10G', $x10kram],"
    echo "['11G', $x11kram],"
    echo "['12G', $x12kram],"
    echo "['13G', $x13kram],"
    echo "['14G', $x14kram],"
    echo "['15G', $x15kram],"
    echo "['16G', $x16kram],"
    echo "['17G', $x17kram],"
    echo "['18G', $x18kram],"
    echo "['19G', $x19kram],"
    echo "['20G', $x20kram],"
    echo "['21G', $x21kram],"
    echo "['22G', $x22kram],"
    echo "['23G', $x23kram],"
    echo "['24G', $x24kram],"
    echo "['25G', $x25kram],"
    echo "['26G', $x26kram],"
    echo "['27G', $x27kram],"
    echo "['28G', $x28kram],"
    echo "['29G', $x29kram],"
    echo "['30G', $x30kram],"
    echo "['31G', $x31kram],"
    echo "['32G', $x32kram],"
    echo "['33G', $x33kram],"
    echo "['34G', $x34kram],"
    echo "['35G', $x35kram],"
    echo "['36G', $x36kram],"
    echo "['37G', $x37kram],"
    echo "['38G', $x38kram],"
    echo "['39G', $x39kram],"
    echo "['40G', $x40kram],"
    echo "['41G', $x41kram],"
    echo "['42G', $x42kram],"
    echo "['43G', $x43kram],"
    echo "['44G', $x44kram],"
    echo "['45G', $x45kram],"
    echo "['46G', $x46kram],"
    echo "['47G', $x47kram],"
    echo "['48G', $x48kram],"
    echo "['49G', $x49kram],"
    echo "['50G', $x50kram],"
    echo "['51G', $x51kram],"
    echo "['52G', $x52kram],"
    echo "['53G', $x53kram],"
    echo "['54G', $x54kram],"
    echo "['55G', $x55kram],"
    echo "['56G', $x56kram],"
    echo "['57G', $x57kram],"
    echo "['58G', $x58kram],"
    echo "['59G', $x59kram],"
    echo "['60G', $x60kram],"
    echo "['61G', $x61kram],"
    echo "['62G', $x62kram],"
    echo "['63G', $x63kram],"
    echo "['64G', $x64kram],"
    echo "['65G', $x65kram],"
    echo "['66G', $x66kram],"
    echo "['67G', $x67kram],"
    echo "['68G', $x68kram],"
    echo "['69G', $x69kram],"
    echo "['70G', $x70kram],"
    echo "['71G', $x71kram],"
    echo "['72G', $x72kram],"
    echo "['73G', $x73kram],"
    echo "['74G', $x74kram],"
    echo "['75G', $x75kram],"
    echo "['76G', $x76kram],"
    echo "['77G', $x77kram],"
    echo "['78G', $x78kram],"
    echo "['79G', $x79kram],"
    echo "['80G', $x80kram],"
    echo "['81G', $x81kram],"
    echo "['82G', $x82kram],"
    echo "['83G', $x83kram],"
    echo "['84G', $x84kram],"
    echo "['85G', $x85kram],"
    echo "['86G', $x86kram],"
    echo "['87G', $x87kram],"
    echo "['88G', $x88kram],"
    echo "['89G', $x89kram],"
    echo "['90G', $x90kram],"
    echo "['91G', $x91kram],"
    echo "['92G', $x92kram],"
    echo "['93G', $x93kram],"
    echo "['94G', $x94kram],"
    echo "['95G', $x95kram],"
    echo "['96G', $x96kram],"
    echo "['97G', $x97kram],"
    echo "['98G', $x98kram],"
    echo "['99G', $x90kram],"
    echo "['100G', $x100kram],"
    cat ./ram-footer.html
} >> report-temp.html

#find age of computers
#initiliaze variables
today=$(date +%s)
sixMonthsAgo=$((today-15768000))
oneYearAgo=$((today-31536000))
twoYearsAgo=$((today-63072000))
threeYearsAgo=$((today-94608000))
fourYearsAgo=$((today-126144000))
fiveYearsAgo=$((today-157680000))
sixYearsAgo=$((today-189216000))
sevYearsAgo=$((today-220752000))
eightYearsAgo=$((today-252288000))
nineYearsAgo=$((today-283824000))
tenYearsAgo=$((today-315360000))
elevYearsAgo=$((today-346896000))
twelvYearsAgo=$((today-378432000))
thitnYearsAgo=$((today-409968000))
fourteenYearsAgo=$((today-441504000))
fifTeenYearsAgo=$((today-473040000))

xnewCompAge=0
xSMyoCompAge=0
x1yoCompAge=0
x2yoCompAge=0
x3yoCompAge=0
x4yoCompAge=0
x5yoCompAge=0
x6yoCompAge=0
x7yoCompAge=0
x8yoCompAge=0
x9yoCompAge=0
x10yoCompAge=0
x11yoCompAge=0
x12yoCompAge=0
x13yoCompAge=0
x13yoCompAge=0
x14yoCompAge=0
x15yoCompAge=0

#get hardware age for computer
echo "Calculating age of each computer...."
for oneComputer in $allComputers; do
    ageEpochlong=$(curl -s -u "$username:$password" "$server/JSSResource/computers/id/$oneComputer" \
        | xpath '/computer/purchasing/po_date_epoch' \
        | sed 's*<po_date_epoch>*\'$'\n*g' \
        | sed 's*</po_date_epoch>*\'$'\n*g' \
        | tail -2 \
        | head -1)
    ageEpoch=$((ageEpochlong/1000))
    echo "ID $oneComputer is $ageEpoch seconds old"
    if ((ageEpoch >= sixMonthsAgo)); then
        ((xnewCompAge++))
        echo "$oneComputer is less than 6 months old"
    elif ((ageEpoch <= sixMonthsAgo && ageEpoch >= oneYearAgo)); then
        ((xSMyoCompAge++))
    elif ((ageEpoch <= oneYearAgo && ageEpoch >= twoYearsAgo)); then
        ((x1yoCompAge++))
    elif ((ageEpoch <= twoYearsAgo && ageEpoch >= threeYearsAgo)); then
        ((x2yoCompAge++))
    elif ((ageEpoch <= threeYearsAgo && ageEpoch >= fourYearsAgo)); then
        ((x3yoCompAge++))
    elif ((ageEpoch <= fourYearsAgo && ageEpoch >= fiveYearsAgo)); then
        ((x4yoCompAge++))
    elif ((ageEpoch <= fiveYearsAgo && ageEpoch >= sixYearsAgo)); then
        ((x5yoCompAge++))
    elif ((ageEpoch <= sixYearsAgo && ageEpoch >= sevYearsAgo)); then
        ((x6yoCompAge++))
    elif ((ageEpoch <= sevYearsAgo && ageEpoch >= eightYearsAgo)); then
        ((x7yoCompAge++))
    elif ((ageEpoch <= eightYearsAgo && ageEpoch >= nineYearsAgo)); then
        ((x8yoCompAge++))
    elif ((ageEpoch <= nineYearsAgo && ageEpoch >= tenYearsAgo)); then
        ((x9yoCompAge++))
    elif ((ageEpoch <= tenYearsAgo && ageEpoch >= elevYearsAgo)); then
        ((x10yoCompAge++))
    elif ((ageEpoch <= elevYearsAgo && ageEpoch >= twelvYearsAgo)); then
        ((x11yoCompAge++))
    elif ((ageEpoch <= twelvYearsAgo && ageEpoch >= thitnYearsAgo)); then
        ((x12yoCompAge++))
    elif ((ageEpoch <= thitnYearsAgo && ageEpoch >= fourteenYearsAgo)); then
        ((x13yoCompAge++))
    elif ((ageEpoch <= fourteenYearsAgo && ageEpoch >= fifTeenYearsAgo)); then
        ((x14yoCompAge++))
    else
        ((x15yoCompAge++))
    fi

done

{
    cat age-header.html
    echo "['Less than 6 months', $xnewCompAge],"
    echo "['6 months old', $xSMyoCompAge],"
    echo "['1 year old', $x1yoCompAge],"
    echo "['2 years old', $x2yoCompAge],"
    echo "['3 years old', $x3yoCompAge],"
    echo "['4 years old', $x4yoCompAge],"
    echo "['5 years old', $x5yoCompAge],"
    echo "['6 years old', $x6yoCompAge],"
    echo "['7 years old', $x7yoCompAge],"
    echo "['8 years old', $x8yoCompAge],"
    echo "['9 years old', $x9yoCompAge],"
    echo "['10 years old', $x10yoCompAge],"
    echo "['11 years old', $x11yoCompAge],"
    echo "['12 years old', $x12yoCompAge],"
    echo "['13 years old', $x13yoCompAge],"
    echo "['14 years old', $x14yoCompAge],"
    echo "['No Date Available', $x15yoCompAge],"
    cat age-footer.html
} >> report-temp.html

#OS VERSIONS
echo "Determining OS Versions..."
x1011=0
x1010=0
x109=0
x108=0
x107=0
x106=0
x105=0
x104=0
x103=0
x102=0
x101=0
unknownOS=0

for oneComputer in $allComputers; do
    osMajKey=$(curl -s -u "$username:$password" "$server/JSSResource/computers/id/$oneComputer" \
        | xpath '/computer/hardware/os_version' \
        | sed 's*<os_version>*\'$'\n*g' \
        | sed 's*</os_version>*\'$'\n*g' \
        | tail -2 \
        | head -1 \
        | awk -F. '{print $2}')
    echo "computer id $oneComputer has Mac OS 10 $osMajKey"
    if [ "$osMajKey" -eq 11 ]; then
        ((x1011++))
    elif [ "$osMajKey" -eq 10 ]; then
        ((x1010++))
    elif [ "$osMajKey" -eq 9 ]; then
        ((x109++))
    elif [ "$osMajKey" -eq 8 ]; then
        ((x108++))
    elif [ "$osMajKey" -eq 7 ]; then
        ((x107++))
    elif [ "$osMajKey" -eq 6 ]; then
        ((x106++))
    elif [ "$osMajKey" -eq 5 ]; then
        ((x105++))
    elif [ "$osMajKey" -eq 4 ]; then
        ((x104++))
    elif [ "$osMajKey" -eq 3 ]; then
        ((x103++))
    elif [ "$osMajKey" -eq 2 ]; then
        ((x102++))
    elif [ "$osMajKey" -eq 1 ]; then
        ((x101++))
    else
        ((unknownOS++))
    fi
done

{
    cat osVers-header.html
    echo "['OS 11 El Capitan', $x1011],"
    echo "['OS 10 Yosemite', $x1010],"
    echo "['OS 9 Mavericks', $x109],"
    echo "['OS 8 Mountain Lion', $x108],"
    echo "['OS 7 Lion', $x107],"
    echo "['OS 6 Snow Leopard', $x106],"
    echo "['OS 5 Leopard', $x105],"
    echo "['OS 4 Tiger', $x104],"
    echo "['OS 3 Panther', $x103],"
    echo "['Unknown OS', $unknownOS]"
    cat osVers-footer.html
} >> report-temp.html

#Hardware Type
echo "Determining Hardware Type"

Mini=0
MacBook=0
MacBookPro=0
MacBookAir=0
MacPro=0
G5=0
Vmware=0
iMac=0

for oneComputer in $allComputers; do
    hardwareModel=$(curl -s -u "$username:$password" "$server/JSSResource/computers/id/$oneComputer" \
        | xpath '/computer/hardware/model' \
        | sed 's*<model>*\'$'\n*g' \
        | sed 's*</model>*\'$'\n*g' \
        | tail -2 \
        | head -1 \
        | awk -F\( '{print $1}')
    echo "computer $oneComputer has model $hardwareModel"

    model=$(echo "$hardwareModel" | grep -i mini)
    if [ ! -z "$model" ]; then
        ((Mini++))
    fi

    model=$(echo "$hardwareModel" | grep -i Macbook | grep -i Pro)
    if [ ! -z "$model" ]; then
        ((MacBookPro++))
    fi

    model=$(echo "$hardwareModel" | grep -i Air)
    if [ ! -z "$model" ]; then
        ((MacBookAir++))
    fi

    model=$(echo "$hardwareModel" | grep -i Macbook | grep -v Pro | grep -v Air)
    if [ ! -z "$model" ]; then
        ((MacBook++))
    fi

    model=$(echo "$hardwareModel" | grep -i G5)
    if [ ! -z "$model" ]; then
        ((G5++))
    fi

    model=$(echo "$hardwareModel" | grep -i vmware)
    if [ ! -z "$model" ]; then
        ((Vmware++))
    fi

    model=$(echo "$hardwareModel" | grep -i iMac)
    if [ ! -z "$model" ]; then
        ((iMac++))
    fi

    model=$(echo "$hardwareModel" | grep -i MacPro)
    if [ ! -z "$model" ]; then
        ((MacPro++))
    fi

done

{
    cat model-header.html
    echo "['Mac Mini', $Mini],"
    echo "['MacBookPro', $MacBookPro],"
    echo "['MacBookAir', $MacBookAir],"
    echo "['MacBook', $MacBook],"
    echo "['G5', $G5],"
    echo "['VMWare', $Vmware],"
    echo "['iMac', $iMac],"
    echo "['MacPro', $MacPro],"
    cat model-footer.html
} >> report-temp.html

echo "Closing Report...."
##End - close the report file
cat footer.html >> report-temp.html
mv report-temp.html report.html

exit 0
