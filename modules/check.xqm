xquery version "3.0";

module namespace check = "http://www.digital-archiv.at/ns/teiminator/check";

(: check whether the parameter is a valid URI and whether it points to a file :)
declare function check:checkXML ($file as xs:string) {
	let $avail := if ($file castable as xs:anyURI)
		then
			doc-available($file)
		else
			false()
			
	return if ($avail)
		then validation:jaxp(doc($file), false())
		else false()
};

declare function check:report ($file as xs:string) {
	if (not($file castable as xs:anyURI))
		then
			<div><h1>Invalid URI</h1><p>The string supplied is not a valid URI!</p></div>
		else if (not(doc-available($file)))
			then <div><h1>File not available</h1><p>The URL supplied, {$file}, either returned a 404 or is not a wellformed XML.</p></div>
			else if (not(validation:jaxp(doc($file), false())))
				then <div><h1>Validation error</h1><p>The file {$file} is not valid:<br/>{validation:jaxp-report(doc($file), false())}</p></div>
				else <div><h1>unknown error</h1><p>I have no idea, what happened, but sth. went wrong trying to process {$file}</p></div>
};