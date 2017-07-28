xquery version "3.0";

module namespace check = "http://www.digital-archiv.at/ns/teiminator/check";

(: check whether the parameter is a valid URI and whether it points to a file :)
declare function check:checkAvailable ($file as xs:string) {
	if ($file castable as xs:anyURI)
		then
			doc-available($file)
		else
			false()
};