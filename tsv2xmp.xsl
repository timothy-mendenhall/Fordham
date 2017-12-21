<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oclcterms="http://purl.org/oclc/terms/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:template match="collection">
        <xsl:text>Identifier</xsl:text>
        <xsl:text>&#xa;</xsl:text>
        <xsl:for-each select="./x:xmpmeta">
            <xsl:variable name="fileName">
                <xsl:value-of select=".//dc:title/rdf:Alt/rdf:li"/>
            </xsl:variable>
            <xsl:result-document encoding="UTF-8" method="xml" href="{concat($fileName, '.xmp')}" indent="yes">
                <xsl:copy-of select="."/>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>