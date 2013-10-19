param([string]$InstallDirectory)

$fileList = @(
	'Add-MenuItem.ps1',
	'Invoke-CodeGen.ps1',
	'Invoke-GenerateTree.ps1',
	'Invoke-PasteJSONAsPowerShell.ps1',
	'Invoke-PrettyPrint.ps1',
	'New-ParamStmt.ps1',
	'New-PSCustomObject.ps1',
	'PasteJSONAsPowerShell.psm1',
	'Split-List.ps1'
)

if ('' -eq $InstallDirectory)
{
    $personalModules = Join-Path -Path ([Environment]::GetFolderPath('MyDocuments')) -ChildPath WindowsPowerShell\Modules
    if (($env:PSModulePath -split ';') -notcontains $personalModules)
    {
        Write-Warning "$personalModules is not in `$env:PSModulePath"
    }

    if (!(Test-Path $personalModules))
    {
        Write-Error "$personalModules does not exist"
    }

    $InstallDirectory = Join-Path -Path $personalModules -ChildPath PasteJSONAsPowerShell
}

if (!(Test-Path $InstallDirectory))
{
    $null = mkdir $InstallDirectory    
}

$wc = New-Object System.Net.WebClient
$fileList |     
    ForEach-Object {
        $wc.DownloadFile("https://raw.github.com/dfinke/PasteJSONasPowerShell/master/$_","$installDirectory\$_")
    }