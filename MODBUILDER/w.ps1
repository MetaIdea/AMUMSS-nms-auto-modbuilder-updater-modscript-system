
function Get-CurrentDirectory {    
    return Split-Path $MyInvocation.ScriptName
}
$global:tempVar=[string]::Empty 
foreach ($item in Get-Content -Path "OPTIONS.txt") {
    $list=$item.Split("=")
    $global:tempVar+="-$($list[0]) $($list[1]) "
}
$args=$tempVar
Remove-Variable tempVar -Scope Global
# set the arguments to be passed to the builder
# $args = "-copy", "-recreateMapFileTrees" 
$pathToMonitor = Join-Path (Get-CurrentDirectory) "ModScript"
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Filter = "*.lua"
$watcher.Path = $pathToMonitor
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$cachedLastWriteTime = [long]([DateTime]::MinValue.Ticks)

$action = {  
    $path = $Event.SourceEventArgs.FullPath
    $lastWriteTime = [long](Get-ItemProperty -Path $path -Name LastWriteTime).LastWriteTime.Ticks
    if (($lastWriteTime - $cachedLastWriteTime ) -gt 100000) { 
        $changeType = $Event.SourceEventArgs.ChangeType   
        write-host "`n$(Get-Date -Format HH:mm:ss), $changeType, $path" 
        $cachedLastWriteTime = $lastWriteTime
        Start-Process BuildMod.bat -ArgumentList $args
    }
     
}
$handlers = . {
    Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $Action -SourceIdentifier FSChange
    # Register-ObjectEvent -InputObject $watcher -EventName Created -Action $Action -SourceIdentifier FSCreate
    # Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $Action -SourceIdentifier FSDelete
    # Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $Action -SourceIdentifier FSRename
}

Write-Host "Watching for changes in /ModScript"

try {
    do {
        Wait-Event -Timeout 1
        Write-Host "." -NoNewline
        
    } while ($true)
}
finally {
    Unregister-Event -SourceIdentifier FSChange
    # Unregister-Event -SourceIdentifier FSCreate
    # Unregister-Event -SourceIdentifier FSDelete
    # Unregister-Event -SourceIdentifier FSRename
    $handlers | Remove-Job    
    $watcher.EnableRaisingEvents = $false
    $watcher.Dispose()
    Remove-Variable options -Scope Global
}
