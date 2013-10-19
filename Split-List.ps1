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
