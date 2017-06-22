xquery version "3.0";
declare namespace functx = "http://www.functx.com";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";
import module namespace config="http://www.digital-archiv.at/ns/teiminator/config" at "../modules/config.xqm";
declare namespace tei = "http://www.tei-c.org/ns/1.0";

declare function functx:capitalize-first
  ( $arg as xs:string? )  as xs:string? {

   concat(upper-case(substring($arg,1,1)),
             substring($arg,2))
 } ;

declare function local:slugify_refs( $arg as xs:string)  as xs:string {
   let $arg := lower-case(replace($arg, '[\[\]\(\)#/\?]', ""))
   let $arg := replace($arg, "[\]_\s*“„,;\.:]", "-")
   let $arg := replace($arg, "['`´]", "-")
   let $arg := replace($arg, "--*", "-")
   return $arg
 } ;

let $intermdediate := <list>{
for $place in collection(concat($config:app-root, '/data/editions/'))//tei:placeName
    let $key := if (exists(data($place/@key)[1])) 
        then local:slugify_refs(data($place/@key)[1])
        else local:slugify_refs($place)
    let $orig_text := $place/text()
    
    return
        <place>
            <id>{$key}</id>
            <placeName>{$orig_text}</placeName>
        </place>
}
</list>

let $root_doc := doc(concat($config:app-root, '/data/indices/listplace.xml'))

let $placelist := <tei:listPlace>
        {
        for $x in distinct-values($intermdediate//id/text())
            let $orig_names := collection(concat($config:app-root, '/data/editions/'))//tei:placeName[@key=$x]/text()
            return 
                <place xml:id="{$x}">
                    <placeName type="pref">{functx:capitalize-first($x)}</placeName>
                    {for $name in distinct-values($orig_names) return 
                        <placeName type="alt">{$name}</placeName>}
                </place>
        }
    </tei:listPlace>

let $updated := update replace $root_doc//tei:listPlace with $placelist

return $updated