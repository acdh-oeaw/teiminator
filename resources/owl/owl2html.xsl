<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:owl="http://www.w3.org/2002/07/owl#" xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
    <!-- created 2017-07-20 DK = dario.kampkaspar@oeaw.ac.at -->
    <xsl:output method="html" indent="yes"/>
    
    <xsl:param name="about"/>
    
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
                    <style>
                        body {
                        padding-left: 10%;
                        padding-right: 10%;
                        }
                        .list {
                        border: 1px solid;
                        background-color: grey;
                        padding: 1em;
                        }
                        .entry {
                        border: 1px solid;
                        padding: 1em;
                        background-color: lightgrey;
                        }
                        h3 {
                        background-color: white;
                        }
                    </style>
                </head>
                <title>
                    OWL
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
                        <xsl:value-of select="/rdf:RDF/owl:Ontology/@rdf:about"/>
                    </h1>
                    <div>
                        <h2>Status</h2>
                        <xsl:apply-templates select="/rdf:RDF/owl:Ontology/owl:versionInfo"/>
                    </div>
                    <!--<div class="toc">
                    <ul>
                        <xsl:apply-templates select="//comment()" />
                    </ul>
                </div>-->
                    <div>
                        <p>Classes:
                            <xsl:for-each select="//owl:Class">
                                <xsl:sort select="@rdf:about"/>
                                <xsl:apply-templates select="rdfs:label"/>
                                <xsl:if test="not(position() = last())"> | </xsl:if>
                            </xsl:for-each>
                        </p>
                        <p>Datatype properties:
                            <xsl:for-each select="//owl:DatatypeProperty">
                                <xsl:sort select="@rdf:about"/>
                                <xsl:apply-templates select="rdfs:label"/>
                                <xsl:if test="not(position() = last())"> | </xsl:if>
                            </xsl:for-each>
                        </p>
                        <p>Object properties:
                            <xsl:for-each select="//owl:ObjectProperty[contains(@rdf:about, $about)]">
                                <xsl:sort select="@rdf:about"/>
                                <xsl:apply-templates select="rdfs:label"/>
                                <xsl:if test="not(position() = last())"> | </xsl:if>
                            </xsl:for-each>
                        </p>
                    </div>
                    <xsl:for-each-group select="/rdf:RDF/owl:*[not(self::owl:Ontology) and contains(@rdf:about, $about)]" group-by="local-name()">
                        <xsl:sort select="rdfs:label"/>
                        <div>
                            <h2>
                                <xsl:value-of select="current-group()[1]/local-name()"/>
                            </h2>
                            <xsl:apply-templates select="current-group()" mode="group"/>
                        </div>
                    </xsl:for-each-group>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="owl:*" mode="group">
        <xsl:variable name="ab" select="@rdf:about"/>
        <xsl:variable name="id" select="substring-after($ab, ':')"/>
        <div id="{$id}" class="entry">
            <h3>
                <xsl:value-of select="local-name()"/>: <xsl:value-of select="$ab"/>
            </h3>
            <p>
                <xsl:value-of select="$id"/>: <xsl:value-of select="rdfs:label"/>
            </p>
            <xsl:if test="owl:* or rdfs:*[not(self::rdfs:label)]">
                <table>
                    <xsl:apply-templates select="owl:* | rdfs:*[not(self::rdfs:label or self::rdfs:comment)]"/>
                    <xsl:if test="//rdfs:subClassOf[@rdf:resource=$ab]">
                        <tr>
                            <td class="he">Has Subclass</td>
                            <td>
                                <xsl:for-each select="//rdfs:subClassOf[@rdf:resource=$ab]">
                                    <xsl:variable name="pa" select="current()/parent::owl:*"/>
                                    <a>
                                        <xsl:attribute name="href" select="concat('#', substring-after($pa/@rdf:about, ':'))"/>
                                        <xsl:value-of select="$pa/rdfs:label"/>
                                    </a>
                                    <xsl:if test="not(position()=last())">
                                        <xsl:text> | </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </td>
                        </tr>
                    </xsl:if>
                </table>
            </xsl:if>
            <xsl:apply-templates select="rdfs:comment"/>
        </div>
    </xsl:template>
    
    <xsl:template match="owl:* | rdfs:*">
        <tr>
            <td class="he">
                <xsl:value-of select="local-name()"/>
            </td>
            <td>
                <xsl:apply-templates select="@rdf:resource"/>
            </td>
        </tr>
    </xsl:template>
    
    <xsl:template match="@rdf:resource">
        <a>
            <xsl:attribute name="href">
                <xsl:choose>
                    <xsl:when test="starts-with(., 'http')">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('#', translate(substring-after(., ':'), ' ', '_'))"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="starts-with(., 'http')">
                    <xsl:value-of select="tokenize(., '/')[position() = last()]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </a>
    </xsl:template>
    
    <xsl:template match="owl:versionInfo | rdfs:comment">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="rdfs:label">
        <a>
            <xsl:attribute name="href" select="concat('#', substring-after(parent::owl:*/@rdf:about, ':'))"/>
            <xsl:value-of select="."/>
        </a>
    </xsl:template>
    
    <xsl:template match="text()">
        <xsl:analyze-string select="." regex="(http[^\s\)]*)">
            <xsl:matching-substring>
                <a href="{.}">Link</a>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
</xsl:stylesheet>