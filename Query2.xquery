(:CSE532 -- Project 3:)
(:File name: Query2.xquery:)
(:Author: Sravya Beesabathuni  (111327265 ):)
(:Brief description: Query 2:)
(:I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.:)
xquery version "3.1";
for $p in doc("WOCO.xml")//Person
let $pName := $p/Name
for $c in doc("WOCO.xml")//Company
let $num := $c/SharePrice
for $co in $p/OwnsCompany
let $shares := $co/SharesOwned
let $Prodshares := $shares * $num
where $co/CId = $c/Id and $shares > 0
group by $pName
order by $pName
let $networth := xs:decimal(sum($Prodshares))
return <result Person="{$pName}"
              Networth="{$networth}"/>
