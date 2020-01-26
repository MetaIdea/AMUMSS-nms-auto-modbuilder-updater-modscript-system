
$scriptDirectory = Split-Path $MyInvocation.MyCommand.Path 
function Get-RootPath {    
    return Join-Path $scriptDirectory ".." -Resolve
}

$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Filter = "*.lua"
$watcher.Path = Join-Path (Get-RootPath) "ModScript"
$watcher.IncludeSubdirectories = $true
$watcher.EnableRaisingEvents = $true

$global:cachedLastWriteTime = [long]([DateTime]::MinValue.Ticks)
$global:batPath = Join-Path (Get-RootPath) "BuildMod.bat"
$action = {  
    param ($watcher, $eventArgs)
    $path = $eventArgs.FullPath
    $lastWriteTime = [long](Get-ItemProperty -Path $path -Name LastWriteTime).LastWriteTime.Ticks
    if (($lastWriteTime - $cachedLastWriteTime ) -gt 100000) { 
        $changeType = $Event.SourceEventArgs.ChangeType
        $fileName = Split-Path $path -leaf
        write-host "`n$changeType $fileName [$(Get-Date -Format HH:mm:ss)]" 
        $cachedLastWriteTime = $lastWriteTime        
        Start-Process $batPath
    }     
}

$handlers = . {
    Register-ObjectEvent -InputObject $watcher -EventName Changed -Action $Action -SourceIdentifier FSChange
    # Register-ObjectEvent -InputObject $watcher -EventName Created -Action $Action -SourceIdentifier FSCreate
    # Register-ObjectEvent -InputObject $watcher -EventName Deleted -Action $Action -SourceIdentifier FSDelete
    # Register-ObjectEvent -InputObject $watcher -EventName Renamed -Action $Action -SourceIdentifier FSRename
}

Write-Host "Watching for changes in '$($watcher.Path)'"
try {
    do {
        Wait-Event -Timeout 1       
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
}
