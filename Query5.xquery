(:CSE532 -- Project 3:)
(:File name: Query5.xquery:)
(:Author: Sravya Beesabathuni  (111327265 ):)
(:Brief description: Query 5:)
(:I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.:)
xquery version "3.1";
declare function local:PersonDirectlyOwns($personName as xs:string) 
{
   for $p in doc("WOCO.xml")//Person
   let $pName := $p/Name
   for $c in doc("WOCO.xml")//Company
   let $cName := $c/Name
   let $totalnum := $c/SharesIssued
   for $co in $p/OwnsCompany
    let $shares := $co/SharesOwned
    let $shareP := xs:double($shares div $totalnum)
    where $co/CId = $c/Id  and $pName = $personName and  $shares > 0
    return <result Person="{$pName}" Company="{$cName}" PersonShare="{$shareP}"/>
};

declare function local:CompanyDirectlyOwns($comp as xs:string)
{
    for $c1 in doc("WOCO.xml")//Company
    let $c1Name := $c1/Name
    for $c2 in doc("WOCO.xml")//Company
    let $c2Name := $c2/Name 
    let $totalnum := $c2/SharesIssued
    for $co in $c1/OwnsCompany
    let $shares := $co/SharesOwned
    let $shareP := xs:double($shares div $totalnum)
    where $co/CId = $c2/Id and $comp = $c1Name and  $shares > 0
    return <result Company1="{$c1Name}" Company2="{$c2Name}" CompShare="{$shareP}" />
};

declare function local:CompanyInDirectlyOwns($company as xs:string, $visited as xs:string) as element()*
{
    let $comp := local:CompanyDirectlyOwns($company)
    for $c in $comp
    let $comp1 := $c/@Company1
    let $comp2 := $c/@Company2
    return 
        if (contains($visited, $comp2))
        then ()
        else (
            let $ret := (
                let $indirectComp := local:CompanyInDirectlyOwns($comp2, concat($visited,concat(",",$comp2)))
                for $i in $indirectComp
                let $c1Name := $i/@Company1
                let $c2Name := $i/@Company2
                let $share1 := $i/@CompShare
                let $share2 := $c/@CompShare
                let $share := $share1*$share2
                where $comp2 = $c1Name
                return 
                    <result Company1="{$comp1}" Company2="{$c2Name}"
                              CompShare="{$share}"/> 
                )
                return $ret union $comp
            )

};

declare function local:PersonIndirectlyOwns($personName as xs:string) {
    let $per := local:PersonDirectlyOwns($personName)
    for $p in $per
    let $pName := $p/@Person
    let $pCompany := $p/@Company
    let $indirect := local:CompanyInDirectlyOwns($pCompany, $pCompany)
    for $i in $indirect
    let $c1Name := $i/@Company1
    let $c2Name := $i/@Company2
    let $share := $i/@CompShare*$p/@PersonShare
    where $p/@Company = $c1Name 
    return 
       <result Person="{$pName}" Company="{$c2Name}"
                  PersonShare="{$share}"/> union $per
};
declare function local:remove-duplicates ($elements as element()*) as element()*
{
    for $e in (1 to count($elements))
		let $element := $elements[$e]
		let $rest := subsequence($elements, $e + 1)
		return if (some $other in $rest satisfies (deep-equal($other, $element)))
				then ( )
			else $element
};

for $p in doc("WOCO.xml")//Person
let $pIndirect := local:remove-duplicates(local:PersonIndirectlyOwns($p/Name))
for $r in $pIndirect
let $person := $r/@Person
let $company := $r/@Company
group by $person, $company
order by $person, $company
let $x := sum($r/@PersonShare) * 100
where $x > 10
return <result Person="{$person}" Company="{$company}" Percentage="{$x}"/>