# JSSReport

Creates pretty reports from JSS data.
## Written by Todd Houle - Partners Healthcare
## Ridiclously huge amounts of code contributed by Mike Morales. Go Mike!


## Reports included
OSX Major Versions - number of computers at each
General Mac Model type
Specific Mac model list count
Filevault Encryption compliance
Processor type count
Instaled Memory amount
Computers purchased each year
Computers enrolled each month count

## Usage

1. Download the makeReport.sh script
2. Make sure makeReport.sh is executable: `chmod +x makeReport.sh`
3. Edit makeReport.sh to include your username, password, server, and report name.
4. Create an Advanced Computer Search on your JSS
   a) name it whatever you called it in step 3
   b) make search critera all machines you want in the report.  
   c) Under display tag, choose the following
      i) Computer - Last Enrollment
      ii) Hardware - Model
      iii) Hardware - Model Identifier
      iv) Hardware - Processor Type
      v) Hardware - Total RAM MB
      vi) Operating System - Operating System
      vii) Purchasing - PO Date
      viii) Purchasing - Warranty Expiration
      ix) Storage - FileVault 2 Status
5. Run the MakeReport tool    `/path/to/makeReport.sh`
6. Open the report from /Library/WebServer/Documents/report.html

## Note some data requires data from GSX- be sure that data is accurate to get such information
=======
=======

## Usage

1. Download all files to a directory on your computer.
2. Make sure makeReport.sh is executable: `chmod +x makeReport.sh`
3. Edit makeReport.sh to include your username, password, and server.
4. Run the tool: `./makeReport`
5. Open report.html in a browser.
=======

## Screenshots

![alt tag](http://i.imgur.com/kez7gTR.png)

--

![alt tag](http://i.imgur.com/gwLyRMr.png)

=======

=======

