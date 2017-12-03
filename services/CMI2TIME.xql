xquery version "3.1";
declare namespace functx = "http://www.functx.com";
import module namespace tei-module="http://www.digital-archiv.at/ns/tei-module" at "../modules/tei-module.xql";
declare namespace tei = "http://www.tei-c.org/ns/1.0";
declare option exist:serialize "method=json media-type=text/javascript";

let $fetchedUrl := request:get-parameter("CMI", "")
let $CMI := doc($fetchedUrl)
let $data := <data>{
    for $x at $pos in $CMI//tei:correspDesc[(.//@when[1] castable as xs:date)]
    let $sender := string-join($x//tei:correspAction[@type='sent']/tei:persName/text(), ' ')
    let $backlink :=data($x/@ref)
    let $receiver := string-join($x//tei:correspAction[@type='received']/tei:persName/text(), ' ')
    let $content := if ($receiver) 
        then $sender||' wrote to '||$receiver
        else $sender
    let $date := data($x//@when[1])
    let $year := year-from-date(xs:date($date))
    let $month := month-from-date(xs:date($date))
    let $day := day-from-date(xs:date($date))
    return 
        <item>
            <event_id>{$pos}</event_id>
            <sender>{$sender}</sender>
            {if ($receiver) then <receiver>{$receiver}</receiver> else ()}
            <content>{$content}</content>
            <backlink>{$backlink}</backlink>
            <start>{data($x//@when[1])}</start>
            <date>({$year},{$month},{$day})</date>
        </item>
}</data>

let $return := if ($fetchedUrl eq "") 
    then 
        <result>
            <hint>set a 'CMI' param to a URL providing a valid CMI-Document</hint>
            <example>?CMI=http://diglib.hab.de/edoc/ed000213/download/cmi.xml</example>
        </result> else $data
return 
    $return