xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/teiminator/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";

let $fallback := doc('../resources/owl/fallback.xml')

let $owl := request:get-parameter("owl", "")
let $xml := doc($owl)
let $xsl := doc('../resources/owl/owl2html.xsl')
let $params := 
<parameters>
   {for $p in request:get-parameter-names()
    let $val := request:get-parameter($p,())
   (: where  not($p = ("document","directory","stylesheet")):)
    return
       <param name="{$p}"  value="{$val}"/>
   }
</parameters>
let $return := if ($owl eq "") 
    then $fallback
    else transform:transform($xml, $xsl, $params)
return 
    $return