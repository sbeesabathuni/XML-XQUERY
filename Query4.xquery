(:CSE532 -- Project 3:)
(:File name: Query4.xquery:)
(:Author: Sravya Beesabathuni  (111327265 ):)
(:Brief description: Query 4:)
(:I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.:)
xquery version "3.1";
for $c1 in doc("WOCO.xml")//Company
let $c1Name := $c1/Name
let $id1 := $c1/Id
for $i1 in $c1/Industry
for $c2 in doc("WOCO.xml")//Company
for $i2 in $c2/Industry
let $c2Name := $c2/Name
let $id2 := $c2/Id
let $per := doc("WOCO.xml")//Person
let $bm1 := (
    for $b in $c1/BoardMember
    return $b
)
let $bm2 := (
    for $b in $c2/BoardMember
    return $b
)
let $bmList1 := (
    for $b in $c1/BoardMember, $p1 in $per
    let $list := $p1/OwnsCompany
    where $p1/Id = $b
    return $list
)
let $bmList2 := (
    for $b in $c2/BoardMember, $p2 in $per 
    let $list := $p2/OwnsCompany
    where $p2/Id = $b
    return $list
)
where 
every $b2 in $bm2
satisfies 
(
    exists( 
        for $b1 in $bm1
        where every $bm2 in $bmList2
        satisfies (
            exists(
                for $bm1 in $bmList1 
                where $bm1/CId = $bm2/CId and xs:integer($bm1/SharesOwned) >= xs:integer($bm2/SharesOwned)  
                return $bm1
                )
        )
        return $bm1    
    )
)
   and $i1 = $i2 and  $id1 != $id2
   order by $c1Name,$c2Name
    
return<result Company1="{$c1Name}"
              Company2="{$c2Name}"/>