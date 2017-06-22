xquery version "3.0";
module namespace tei-module="http://www.digital-archiv.at/ns/tei-module";
declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace functx = 'http://www.functx.com';
import module namespace kwic = "http://exist-db.org/xquery/kwic" at "resource:org/exist/xquery/lib/kwic.xql";
 
 (:~
 : serializes one tei:place element or a sequence of them into a geoJOSN likish element 
 : 
 : @param $place a tei:listPlace node containing 1 to n tei:place nodes, needs to contain a geo field with coordinates orded lat lng
 : @param $separator a string used to separate the coordinates
 : @param $keepOrder a boolean, if true() then the order of lat/lng of the processed will be kept, if false, the order will be changed
 : 
 :)
declare function tei-module:places2geoJSON($places as node()*, $separator as xs:string, $keepOrder as xs:boolean){
    let $geojson := 
        <geojson>
            <type>FeatureCollection</type>{
    
    for $place in $places[exists(.//tei:geo/text())]
        let $lat := if ($keepOrder) then substring-before($place//tei:geo, $separator) else substring-after($place//tei:geo, $separator)
        let $lng := if ($keepOrder) then substring-after($place//tei:geo, $separator) else substring-before($place//tei:geo, $separator)
        where $lat castable as xs:float
        return
                    <features>
                        <type>Feature</type>
                        <geometry>
                            <type>Point</type>
                            <coordinates>{$lat}</coordinates>
                            <coordinates>{$lng}</coordinates>
                        </geometry>
                        <properties>
                            <internalID>{data($place/@xml:id)}</internalID>
                            <idno>{$place/tei:idno/text()}</idno>
                            <placename>{for $x in $place/tei:placeName/text() return $x}</placename>
                        </properties>
                    </features>
        }
            </geojson>
    return $geojson 
}; 

 (:~
 : serializes a tei:listPlace element into a geoJOSN likish element 
 : 
 : @param $place a tei:listPlace node containing 1 to n tei:place nodes, needs to contain a geo field with coordinates orded lat lng
 : @param $separator a string used to separate the coordinates
 : @param $keepOrder a boolean, if true() then the order of lat/lng of the processed will be kept, if false, the order will be changed
 : 
 :)
declare function tei-module:listPlace2geoJSON($listPlace as node(), $separator as xs:string, $keepOrder as xs:boolean){
    let $geojson := 
    <geojson>
        <type>FeatureCollection</type>{
    for $place in $listPlace//tei:place[.//tei:geo/text()]
        let $lat := if ($keepOrder) then substring-before($place//tei:geo, $separator) else substring-after($place//tei:geo, $separator)
        let $lng := if ($keepOrder) then substring-after($place//tei:geo, $separator) else substring-before($place//tei:geo, $separator)
        where $lat castable as xs:float
        return
                    <features>
                        <type>Feature</type>
                        <geometry>
                            <type>Point</type>
                            <coordinates>{$lat}</coordinates>
                            <coordinates>{$lng}</coordinates>
                        </geometry>
                        <properties>
                            <internalID>{data($place/@xml:id)}</internalID>
                            <idno>{$place/tei:idno/text()}</idno>
                            <placename>{for $x in $place/tei:placeName/text() return $x}</placename>
                        </properties>
                    </features>
        }
            </geojson>
    return $geojson 
};