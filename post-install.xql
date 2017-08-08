xquery version "3.0";
import module namespace config="http://www.digital-archiv.at/ns/teiminator/config" at "modules/config.xqm";
import module namespace xmldb="http://exist-db.org/xquery/xmldb";

(: grant 'read' and 'execute' permissions on restxq endpoint module to editors and annotators :)
sm:chmod(xs:anyURI($config:app-root||"/modules/api.xql"), "rwxrwxr-x"),
sm:chmod(xs:anyURI($config:app-root||"/modules/config.xqm"), "rwxrwxr-x"),
sm:chmod(xs:anyURI($config:app-root||"/modules/app.xql"), "rwxrwxr-x"),

for $resource in xmldb:get-child-resources(xs:anyURI($config:app-root||"/services/"))
    return
        sm:chmod(xs:anyURI($config:app-root||"/services/"||$resource), "rwxrwxr-x")