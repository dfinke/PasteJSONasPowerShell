function Invoke-GenerateTree ($target, $currentObjectName, $hash) {
     
    if($target -eq $null) {return}

    $list = $target | Get-Member -MemberType *Property
    
    $objects, $properties = Split-List $list { $args[0].definition -match  "pscustomobject" }
           
    $hash.$currentObjectName = @($objects.name)+@($properties.name) | Where {$_ -ne $null}

    $objects.name | 
        ForEach { Invoke-GenerateTree $target.$_ $_ $hash}
}
