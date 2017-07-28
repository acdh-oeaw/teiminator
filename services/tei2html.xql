xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace httpclient="http://exist-db.org/xquery/httpclient";
import module namespace util="http://exist-db.org/xquery/util";
import module namespace config="http://www.digital-archiv.at/ns/teiminator/config" at "../modules/config.xqm";
import module namespace check = "http://www.digital-archiv.at/ns/teiminator/check" at "../modules/check.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare option exist:serialize "method=xhtml media-type=text/html omit-xml-declaration=yes indent=yes";
(: e.g. http://127.0.0.1:8080/exist/apps/teiminator/analyze/visPlace.xql?notBefore=1910-10-10&notAfter=1910-12-01:)

let $fallbackXSL := '../resources/xslt/fallbackXSL.xsl'
let $fallbackTEI := '../resources/xml/fallbackTEI.xml'

let $tei := request:get-parameter("tei", $fallbackTEI)
let $xsl := request:get-parameter("xsl", $fallbackXSL)

let $teiAvail := check:checkAvailable($tei)
let $xslAvail := check:checkAvailable($xsl)

return 
if (not($teiAvail) or not($xslAvail))
	then <error>Either {$xsl} or {$tei} is not a valid URL, returned a 404 or is not a well formed XML: xsl: {$xslAvail}; tei: {$teiAvail}</error>
	else
		let $teiFile := doc($tei)
		let $xslFile := doc($xsl)
		

let $params := 
<parameters>
   {for $p in request:get-parameter-names()
    let $val := request:get-parameter($p,())
   (: where  not($p = ("document","directory","stylesheet")):)
    return
       <param name="{$p}"  value="{$val}"/>
   }
</parameters>

return 
(:    doc($fallbackXSL):)
    transform:transform($tei, $xsl, $params)