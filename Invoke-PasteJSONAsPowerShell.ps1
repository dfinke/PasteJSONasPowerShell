function Invoke-PasteJSONAsPowerShell {

function New-ParamStmt {
        param($tokens)
        
        $newList = $tokens| ForEach {"`t`t`${0}" -f $_}
@"
`tparam(
$($newList -join ",`r`n")
`t)


"@
    }

function New-PSCustomObject {
        param($tokens)

        $newList = $tokens| ForEach { "`t`t{0} = `${0}" -f $_ }

@"
`t[PSCustomObject]@{
$($newList -join "`r`n")
`t}


"@
    }

function Split-List($list, [scriptblock]$scriptblock) {             
                
    if(!$scriptblock) {return $list}             
            
    $criteriaMet   = @()             
    $criteriaNotMet= @()                             
                
    foreach($item in $list) {                     
        if(&$scriptblock $item) {             
            $criteriaMet+=$item                 
        } else {             
            $criteriaNotMet+=$item                 
        }             
    }             
            
    $criteriaMet, $criteriaNotMet             
}

function Invoke-PrettyPrint ($target, $level) {
    
    if($target -eq $null) {return}

    $list = $target | Get-Member -MemberType *Property
    
    $objects, $properties = Split-List $list { $args[0].definition -match  "pscustomobject" }

    $map={"{0}{1}" -f ("`t"*$level),$_.name}    

    $properties | ForEach $map
    $objects    | ForEach $map

    $objects.name | ForEach {            
        Invoke-PrettyPrint $target.$_ ($level+=1)
    }
}

function Invoke-GenerateTree ($target, $currentObjectName, $hash) {
     
    if($target -eq $null) {return}

    $list = $target | Get-Member -MemberType *Property
    
    $objects, $properties = Split-List $list { $args[0].definition -match  "pscustomobject" }
           
    $hash.$currentObjectName = @($objects.name)+@($properties.name) | Where {$_ -ne $null}

    $objects.name | 
        ForEach { Invoke-GenerateTree $target.$_ $_ $hash}
}

function Invoke-CodeGen ($target) {    

    Invoke-GenerateTree $target Root ($tree=[ordered]@{})

$tree.GetEnumerator()  | %{
@"
function New-$($_.Key) {
$(New-ParamStmt $_.value)
$(New-PSCustomObject $_.value)
}


"@
}
 
}   

    Clear-Host
    $Error.Clear()    
    try {     
        $text = [System.Windows.Forms.Clipboard]::GetText() | ConvertFrom-Json
        
        $psISE.CurrentFile.Editor.InsertText((Invoke-CodeGen $text))
    } catch {
        
        Write-Error $Error[0].Exception
    }    
}

function Add-MenuItem {
    param([string]$DisplayName, $SB, $ShortCut)

    $menu=$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus | Where {$_.DisplayName -Match $DisplayName}

    if($menu) {
        [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Remove($menu)
    }

    [void]$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Add($DisplayName, $SB, $ShortCut)
}

Add-MenuItem "Paste JSON As PowerShell" ([scriptblock]::Create((Get-Command Invoke-PasteJSONAsPowerShell).Definition)) 