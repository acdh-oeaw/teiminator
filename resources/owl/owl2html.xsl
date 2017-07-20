<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:dct="http://purl.org/dc/terms/" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:dc="http://purl.org/dc/elements/1.1/" version="2.0">
    
    <!--   taken from  https://gist.github.com/stain/4657155-->
    
    <xsl:template match="/">
        <html>
            <head>
                <head>
                    <meta charset="utf-8"/>
                    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                    <meta name="viewport" content="width=device-width, initial-scale=1"/>
                    <!-- The above 3 meta tags *must* come first in the head -->   
                    <meta name="description" content=""/>
                    <meta name="author" content=""/>
                    <link rel="icon" href="favicon.ico"/>
                    <title>
                        <!-- <xsl:value-of select="cmd:Components/cmd:FrequencyListProfile/cmd:GeneralInfo/cmd:ResourceName"/> -->
                        CMDI2HTML by ÖAW-ACDH
                    </title>
                    <!-- Bootstrap core CSS -->
                    <link rel="stylesheet" type="text/css" href="../resources/css/bootstrap-3.0.3.min.css"/>
                    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
                    <link rel="stylesheet" type="text/css" href="../resources/cmdi/css/ie10-viewport-bug-workaround.css"/>
                    <!-- Custom styles for this template -->
                    <link rel="stylesheet" type="text/css" href="../resources/cmdi/css/style.css"/>
                </head>
                <title>
                    <xsl:value-of select="rdf:RDF/owl:Ontology/dct:title"/>
                </title>
            </head>
            <body>
                <div class="container">
                    <div class="header clearfix">
                        <h3 class="service-name">OWL2HTML</h3>
                        <a class="navbar-brand" target="_blank" href="https://www.oeaw.ac.at/acdh">
                            <img src="../resources/img/acdh_logo2clean_40-84_text_blue.png"/>
                        </a>
                    </div>
                    <h1>
                        <xsl:value-of select="rdf:RDF/owl:Ontology/dct:title"/>
                    </h1>
                    <h2>OWL ontology</h2>
                    <dl>
                        <dt>Ontology IRI</dt>
                        <dd>
                            <xsl:value-of select="rdf:RDF/owl:Ontology/@rdf:about"/>
                        </dd>
                        
                        <dt>Version IRI</dt>
                        <dd>
                            <xsl:value-of select="rdf:RDF/owl:Ontology/owl:versionIRI/@rdf:resource"/>
                        </dd>
                        
                        <dt>Creator</dt>
                        <xsl:for-each select="//dc:creator">
                            <dd>
                                <xsl:value-of select="."/>
                            </dd>
                        </xsl:for-each>
                        
                        <dt>Contributors</dt>
                        <xsl:for-each select="//dc:contributor">
                            <dd>
                                <xsl:value-of select="."/>
                            </dd>
                        </xsl:for-each>
                        
                        <dt>Issued</dt>
                        <xsl:for-each select="//dct:issued">
                            <dd>
                                <xsl:value-of select="."/>
                            </dd>
                        </xsl:for-each>
                        
                        <dt>Last modified</dt>
                        <xsl:for-each select="//dct:modified">
                            <dd>
                                <xsl:value-of select="."/>
                            </dd>
                        </xsl:for-each>    
                        
                    </dl>
                    <p>Please see the <a href="documentation.html">documentation for 
                        <xsl:value-of select="rdf:RDF/owl:Ontology/dct:title"/>
                    </a>.</p>
                    
                    <p>This HTML is meant to show a simple browser introduction to the ontology and has been 
                        automatically created using XSLT. To see the
                        source OWL as RDF/XML, either use "Save As" or "View Source".
                    </p>
                    
                    
                    
                    <h3>Defined object properties</h3>
                    <dl>
                        <xsl:for-each select="//owl:ObjectProperty">
                            <dt>
                                <em>
                                    <xsl:value-of select="rdfs:label"/>
                                </em>
                                &#160;
                                <code>
                                    <xsl:value-of select="@rdf:about"/>
                                </code>
                            </dt>
                            <dd>
                                <small>
                                    <xsl:value-of select="rdfs:comment"/>
                                </small>
                            </dd>
                        </xsl:for-each>
                    </dl>
                    
                    
                    <h3>Defined data type properties</h3>
                    <dl>
                        <xsl:for-each select="//owl:DatatypeProperty">
                            <dt>
                                <code>
                                    <xsl:value-of select="@rdf:about"/>
                                </code> 
                                &#160;
                                <em>
                                    <xsl:value-of select="rdfs:label"/>
                                </em>
                            </dt>
                            <dd>
                                <small>
                                    <xsl:value-of select="rdfs:comment"/>
                                </small>
                            </dd>
                        </xsl:for-each>
                    </dl>
                </div>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>