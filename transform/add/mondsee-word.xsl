<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:w="http://schemas.microsoft.com/office/word/2003/wordml" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pkg="http://schemas.microsoft.com/office/2006/xmlPackage" exclude-result-prefixes="xs" version="2.0">
	
	<xsl:template match="/">
		<w:wordDocument>
			<w:body>
				<xsl:apply-templates select="//tei:row"/>
			</w:body>
		</w:wordDocument>
	</xsl:template>
	
	<xsl:template match="tei:row[not(count(preceding-sibling::tei:row) &gt; 2)]"/>
	<xsl:template match="tei:row[count(preceding-sibling::tei:row) &gt; 2]">
		<w:p>
			<xsl:apply-templates select="tei:cell"/>
		</w:p>
	</xsl:template>
	
	<xsl:template match="tei:cell[position()=1 and text()]">
		<w:r>
			<w:rPr>
				<w:b/>
				<w:sz w:val="26"/>
			</w:rPr>
			<w:t>
                <xsl:apply-templates/>
            </w:t>
		</w:r>
		<w:r>
            <w:br/>
        </w:r>
	</xsl:template>
	<xsl:template match="tei:cell[text() and position() &gt; 1]">
		<xsl:variable name="pos" select="count(preceding-sibling::tei:cell) + 1"/>
		<xsl:if test="ancestor::tei:table/tei:row[1]/tei:cell[$pos]/text()">
			<xsl:choose>
				<xsl:when test="ancestor::tei:table/tei:row[1]/tei:cell[$pos + 1]/text()">
					<w:r>
						<w:rPr>
							<w:b/>
						</w:rPr>
						<w:t xml:space="preserve"><xsl:value-of select="normalize-space(ancestor::tei:table/tei:row[1]/tei:cell[$pos])"/><xsl:text>: </xsl:text></w:t>
					</w:r>
					<w:r>
						<w:t>
                            <xsl:value-of select="normalize-space()"/>
                        </w:t>
					</w:r>
					<w:r>
						<w:br/>
					</w:r>
				</xsl:when>
				<xsl:otherwise>
					<w:r>
						<w:rPr>
							<w:b/>
						</w:rPr>
						<w:t xml:space="preserve"><xsl:value-of select="normalize-space(ancestor::tei:table/tei:row[1]/tei:cell[$pos])"/><xsl:text>: </xsl:text></w:t>
					</w:r>
					<w:r>
						<w:t xml:space="preserve"><xsl:value-of select="normalize-space()"/><xsl:text> – </xsl:text><xsl:value-of select="normalize-space(following-sibling::tei:cell[1])"/></w:t>
					</w:r>
					<w:r>
						<w:br/>
					</w:r>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
	</xsl:template>
	<xsl:template match="tei:cell[not(text())]"/>
	
	<xsl:template match="@*|node()">
		<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>