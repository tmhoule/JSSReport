# JSSReport

Creates pretty reports from JSS data.
## Written by Todd Houle - Partners Healthcare
# Ridiclously huge amounts of code contributed by Mike Morales. Go Mike!


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
Download the makeReport.sh script

Make sure makeReport.sh is executable: `chmod +x makeReport.sh`

Edit makeReport.sh to include your username, password, server, and report name.

Create an Advanced Computer Search on your JSS - name it whatever you called it in step 3

make search critera set to all machines you want in the report.  

Under display tag, choose the following

  -- Computer - Last Enrollment

 --   Hardware - Model

  -- Hardware - Model Identifier

   -- Hardware - Processor Type

   -- Hardware - Total RAM MB

   -- Operating System - Operating System

   -- Purchasing - PO Date

   -- Purchasing - Warranty Expiration

   -- Storage - FileVault 2 Status

Run the MakeReport tool    `/path/to/makeReport.sh`

Open the report from /Library/WebServer/Documents/report.html

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

