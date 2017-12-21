<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="node() | @*">
        <xsl:if test="normalize-space(string(.)) != ''"><xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy></xsl:if>
    </xsl:template>    
    <xsl:template match="structure"/>
</xsl:stylesheet>