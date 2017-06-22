xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/teiminator/config" at "../modules/config.xqm";
import module namespace app="http://www.digital-archiv.at/ns/teiminator/templates" at "../modules/app.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

let $letters := <letter>{
    for $doc in collection($app:editions)//tei:TEI
        where contains(base-uri($doc), '-an-')
        return
            $doc
    
    }</letter>
return "hansi"
