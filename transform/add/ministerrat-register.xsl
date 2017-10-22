<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0" xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage" exclude-result-prefixes="#all" version="3.0">
	<!-- neu 2016-07-28 Dario Kampkaspar (DK) – kampkaspar@hab.de -->
	
	<xsl:output indent="yes"/>
	
	<xsl:template match="/">
		<teiCorpus>
			<xsl:apply-templates select="//w:body"/>
		</teiCorpus>
	</xsl:template>
	
	<xsl:template match="w:body">
		<xsl:call-template name="loop"/>
	</xsl:template>
	
	<xsl:template name="loop">
		<xsl:variable name="temp">
			<xsl:apply-templates select="w:p[position() &gt; 2]"/>
		</xsl:variable>
		<TEI>
			<teiHeader>
				<fileDesc>
					<titleStmt>
						<title type="short">listplace</title>
					</titleStmt>
					<publicationStmt>
						<p/>
					</publicationStmt>
					<sourceDesc>
						<p/>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<text>
				<body>
					<listPlace>
						<xsl:apply-templates select="$temp/*:place"/>
					</listPlace>
				</body>
			</text>
		</TEI>
		<TEI>
			<teiHeader>
				<fileDesc>
					<titleStmt>
						<title type="short">listperson</title>
					</titleStmt>
					<publicationStmt>
						<p/>
					</publicationStmt>
					<sourceDesc>
						<p/>
					</sourceDesc>
				</fileDesc>
			</teiHeader>
			<text>
				<body>
					<listPerson>
						<xsl:apply-templates select="$temp/*:person"/>
					</listPerson>
				</body>
			</text>
		</TEI>
	</xsl:template>
	
	<xsl:template match="tei:person">
		<person>
			<xsl:attribute name="xml:id" select="generate-id(.)"/>
			<persName>
				<surname>
					<xsl:value-of select="substring-before(., ',')"/>
				</surname>
				<xsl:variable name="fore" select="normalize-space(substring-after(., ', '))"/>
				<xsl:analyze-string select="$fore" regex="(Freiherr|Fürst|Ritter|Edler|Graf|Reichs-).*">
					<xsl:matching-substring>
						<roleName>
							<xsl:value-of select="."/>
						</roleName>
					</xsl:matching-substring>
					<xsl:non-matching-substring>
						<forename>
							<xsl:value-of select="normalize-space()"/>
						</forename>
					</xsl:non-matching-substring>
				</xsl:analyze-string>
			</persName>
		</person>
	</xsl:template>
	
	<xsl:template match="tei:place">
		<place>
			<xsl:choose>
				<xsl:when test="contains(., 'siehe')">
					<xsl:attribute name="xml:id" select="generate-id(.)"/>
					<placeName>
						<xsl:value-of select="normalize-space(substring-before(., 'siehe'))"/>
					</placeName>
					<placeName type="ref">
						<xsl:value-of select="normalize-space(substring-after(., 'siehe'))"/>
					</placeName>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="xml:id" select="generate-id(.)"/>
					<xsl:analyze-string regex="\(.*\)" select=".">
						<xsl:matching-substring>
							<placeName type="orig">
								<xsl:value-of select="substring(normalize-space(), 2, string-length() - 2)"/>
							</placeName>
						</xsl:matching-substring>
						<xsl:non-matching-substring>
							<placeName>
								<xsl:value-of select="normalize-space()"/>
							</placeName>
						</xsl:non-matching-substring>
					</xsl:analyze-string>
				</xsl:otherwise>
			</xsl:choose>
		</place>
	</xsl:template>
	
	<xsl:template match="w:p">
		<xsl:variable name="elem">
			<xsl:choose>
				<xsl:when test="contains(string-join(descendant::w:t, ''), ',')">
					<xsl:text>person</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text>place</xsl:text>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:element name="{$elem}">
			<xsl:apply-templates select="w:r//w:t"/>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>