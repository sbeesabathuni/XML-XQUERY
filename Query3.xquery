(:CSE532 -- Project 3:)
(:File name: Query3.xquery:)
(:Author: Sravya Beesabathuni  (111327265 ):)
(:Brief description: Query 3:)
(:I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.:)
xquery version "3.1";
for $c in doc("WOCO.xml")//Company
let $cName := $c/Name
for $b in $c/BoardMember
for $p in doc("WOCO.xml")//Person
let $pName := $p/Name
for $co in $p/OwnsCompany
where $b = $p/Id and $co/CId = $c/Id and $co/SharesOwned > 0
group by $cName
order by $cName
return <result Company="{$cName}"
              Person="{$pName}"/>
