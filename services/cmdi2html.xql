xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/teiminator/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";
(: e.g. http://127.0.0.1:8080/exist/apps/teiminator/analyze/visPlace.xql?notBefore=1910-10-10&notAfter=1910-12-01:)

let $fallback := doc('../resources/cmdi/fallback.xml')

let $cmdi := request:get-parameter("cmdi", "")
let $xml := doc($cmdi)
let $xsl := doc('../resources/cmdi/cmdi2html.xsl')
let $params := 
<parameters>
   {for $p in request:get-parameter-names()
    let $val := request:get-parameter($p,())
   (: where  not($p = ("document","directory","stylesheet")):)
    return
       <param name="{$p}"  value="{$val}"/>
   }
</parameters>
let $return := if ($cmdi eq "") 
    then $fallback
    else transform:transform($xml, $xsl, $params)
return 
    $return