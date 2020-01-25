$letters = Get-Content -Path "OPTIONS.txt"
arguments=''
$item in Get-Content -Path | ForEach-Object -Begin {$args=""} -End {$gargsuments=$args}


Write-Host $argsuments