<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml"/>
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="@xml:lang">
        <xsl:attribute name="xml:lang">
            <xsl:value-of select="'x-default'"/>
        </xsl:attribute>
    </xsl:template>
    
</xsl:stylesheet>