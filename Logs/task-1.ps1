# Specify the directory containing log files
$logDirectory = "C:\PowerShell_Scripts\Logs"

# Get all log files in the specified directory
$logFiles = Get-ChildItem -Path $logDirectory -Filter *.logs

# Loop through each log file
foreach ($logFile in $logFiles) {
    Write-Host "Processing log file: $($logFile.FullName)"

    # Read content from the log file
    $logContent = Get-Content -Path $logFile.FullName
    

 
    # Loop through each log entry
    foreach ($logEntry in $logContent) {
        # Check if the log entry matches the regex pattern
        if ($logEntry -match '^(\S+) - - \[([^\]]+)\] "(.+)" (\d+) (\d+) "(.+)" "(.+)"$') {
            # Action to perform if the condition is true
            $timestamp = $matches[2]
            $url = $matches[3]
            $responseCode = $matches[4]

            Write-Host "Timestamp: $timestamp, URL: $url, Response Code: $responseCode"


        }elseif ($logEntry -match '^\[([^\]]+)\] \[([^\]]+)\] \[pid (\d+)\] (.+)$') {
            # Action to perform if the condition is true
            $timestamp = $matches[1]
            $PrId = $matches[3]
            $LogMsg = $matches[4]

            Write-Host "Timestamp: $timestamp, ProcessID: $PrId, LogMessage: $LogMsg"
            
            
        }elseif ($logEntry -match '^(\w{3} \d{2} \d{2}:\d{2}:\d{2}) (\S+) (\w+)\[(\d+)\]: \((\S+)\) CMD \((.+)\)$') {
            # Action to perform if the condition is true
            $timestamp = $matches[1]
            $hostname = $matches[2]
            $PrId = $matches[4]

            Write-Host "Timestamp: $timestamp, HostName: $hostname, ProcessID: $PrId"
            
        }
    }
}

Write-Host "Log file processing completed."




