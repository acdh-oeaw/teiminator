xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/teiminator/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/teiminator/templates" at "../modules/app.xql";
import module namespace tei-module="http://www.digital-archiv.at/ns/tei-module" at "../modules/tei-module.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

(: e.g. http://127.0.0.1:8080/exist/apps/teiminator/analyze/visPlace.xql?notBefore=1910-10-10&notAfter=1910-12-01:)
let $fetchedUrl := request:get-parameter("listPlace", "")
let $listPlace := doc($fetchedUrl)
let $return := if ($fetchedUrl eq "") 
    then 
        <result>
            <hint>set a 'listPLace' param to a URL providing a valid TEI-Document containg a listPlace element</hint>
            <example>?listPlace=https://teihencer.acdh.oeaw.ac.at/entities/place/list/export-as-tei</example>
        </result> else tei-module:listPlace2geoJSON($listPlace, ' ', false())
return 
    $return