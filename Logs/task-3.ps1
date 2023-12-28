# Specify the directory containing log files
$logDirectory = "C:\PowerShell_Scripts\CMDFolder"     #there's only one single log file in this directory which is apache_access.logs

# Get all log files in the specified directory
$logFiles = Get-ChildItem -Path $logDirectory -Filter *.logs

# Loop through each log file
foreach ($logFile in $logFiles) {
    Write-Host "Processing log file: $($logFile.FullName)"

    # Read content from the log file
    $logContent = Get-Content -Path $logFile.FullName

    # Define a regular expression pattern to extract information
    $regexPattern1 = '^(\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$'
    $totalRequests = 0
    $urlCounts = @{}
    $responseCodeCounts = @{} 

 
    # Loop through each log entry
    foreach ($logEntry in $logContent) {
        # Check if the log entry matches the pattern
        if ($logEntry -match $regexpattern1) {
            # Extract information from the matched log entry
            $url = $matches[3]
            $responseCode = $matches[4]

        }
        $totalRequests++
        $urlCounts[$url]++
        $responseCodeCounts[$responseCode]++
    }
}

# Generate a report
$report = @"
Web Server Activity Report
--------------------------

Total Requests: $totalRequests

Top Accessed URLs:
$(@($urlCounts.GetEnumerator() | Sort-Object Value -Descending | Select-Object -First 5) | ForEach-Object { "  [$($_.Key)]: $($_.Value) requests" })

Response Code Distribution:
$(@($responseCodeCounts.GetEnumerator() | Sort-Object Key) | ForEach-Object { "  [$($_.Key)]: $($_.Value) requests" })

"@

    # Save the report to a file
    $reportPath = Join-Path $logDirectory "Task3Report.txt"
    $report | Out-File -FilePath $reportPath

    Write-Host "Report generated and saved to: $reportPath"



