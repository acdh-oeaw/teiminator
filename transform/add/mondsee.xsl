<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">
	
	<xsl:output indent="yes"/>
	
	<xsl:template match="tei:table">
		<xsl:apply-templates select="tei:row"/>
	</xsl:template>
	
	<xsl:template match="tei:row[not(preceding-sibling::tei:row)]"/>
	<xsl:template match="tei:row[preceding-sibling::tei:row]">
		<div type="fragment-entry">
			<xsl:apply-templates select="tei:cell"/>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:cell[position()=1 and text()]">
		<head>
            <xsl:apply-templates/>
        </head>
	</xsl:template>
	<xsl:template match="tei:cell[text() and position() &gt; 1]">
		<xsl:variable name="pos" select="count(preceding-sibling::tei:cell) + 1"/>
		<p>
			<label>
                <xsl:value-of select="ancestor::tei:table/tei:row[1]/tei:cell[$pos]"/>
            </label>
			<xsl:apply-templates/>
		</p>
	</xsl:template>
	<xsl:template match="tei:cell[not(text())]"/>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>