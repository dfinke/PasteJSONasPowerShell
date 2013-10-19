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
