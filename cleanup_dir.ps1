function M4Temp_cleanup($path) {
	$old = 5
	$now = Get-Date
    Get-ChildItem $path -Recurse | Where-Object {-not $_.PSIsContainer -and $now.Subtract($_.LastWriteTime).Days -gt $old } | Remove-Item 
}