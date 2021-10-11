# script option parameter
param (
  [string]$option)

# A. Functions #

# get the latest log by filename
function GetLog1 {
    param (
        [string]$log
    )
    $lastwrite = (Get-ChildItem $log).LastWriteTime
    write-host -foregroundcolor Green "--> -- last modified ${lastwrite} --`n"
    # don't show anything if get-content can't find the log. purpose is to clean up output.
    get-content $log -tail 10 -ErrorAction SilentlyContinue
}
# get the latest log within a folder
function GetLog2 {
    param (
        [string]$logpath
    )
    $logfile = Get-ChildItem $logpath | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    $logfile = $logpath + $logfile.Name
    $lastwrite = (get-childitem $logfile).LastWriteTime
    Write-Host -ForegroundColor Green "-> ${logfile}"
    Write-Host -foregroundcolor Green "--> -- last modified ${lastwrite} --`n"
    get-content $logfile -tail 10 -ErrorAction SilentlyContinue
}

# B. Options #

# option to find a specific log file
if ($option -eq "1") {
    Write-Host -foregroundcolor Green "program A specific"
    Write-Host -foregroundcolor Green "-> log filename"
    # define specific log file
    $log = "C:\logfolder\logname.log"
    GetLog1($log)
}
# option to find the latest log in a folder
if ($option -eq "2") {
    Write-Host -foregroundcolor Green "program B specific"
    # define log folder
    $logpath = "C:\logfolder\"
    GetLog2($logpath)
}
# option to search every drive for the latest of a specific log based on output from an external program
if ($option -eq "3") {
    # get drive letters
    $drives = get-psdrive -PSProvider FileSystem | ForEach-Object {$_.Root}
    # parse external program for specific search term in output and remove file extension
    $progs = C:\externalprogram\prog param1 param2 | Where-Object {$_ -match "searchterm"} | 
    ForEach-Object { $_ -replace '\.extension\s+.*','' }
    foreach ($drive in $drives) {
        foreach ($prog in $progs) {
            $logpath = "${drive}logfolder\${prog}\logs\"
            GetLog2($logpath)
        }
    }    
}

# here's what is displayed to the user
if ($option -eq "") {
    write-host "Log Finder`n"
    write-host -backgroundcolor darkgreen -foregroundcolor black "Select an option:"
    write-host 
"[1]  program A specific log
[2]  program B specific log      
[3]  program C specific log`n
Example: logfinder.ps1 1`n"
}
