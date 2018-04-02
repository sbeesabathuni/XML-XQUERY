(:CSE532 -- Project 3:)
(:File name: Query1.xquery:)
(:Author: Sravya Beesabathuni  (111327265 ):)
(:Brief description: Query 3:)
(:I pledge my honor that all parts of this project were done by me alone and
without collaboration with anybody else.:)
xquery version "3.1";
for $c in doc("WOCO.xml")//Company
for $p in doc("WOCO.xml")//Person
for $b in $c/BoardMember
for $co in $p/OwnsCompany
where $b = $p/Id and $c/Id = $co/CId and $co/SharesOwned > 0
order by $c/Name
return <result Name="{$c/Name}" />