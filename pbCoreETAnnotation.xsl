<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    <!-- 2015-03-10 Written by Timothy Ryan Mendenhall to analyze PBCore annotation metadata extracted 
        from digital video files via the application MediaInfo -->
    <xsl:output method="text" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="pbcoreCollection">
        <xsl:text>File name&#009;instAnnotType&#009;instAnnotValue&#xA;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="pbcoreInstantiationDocument">
        <xsl:variable name="filename">
            <xsl:value-of select="instantiationIdentifier"></xsl:value-of>
        </xsl:variable>
        <xsl:for-each select="instantiationIdentifier">
            <xsl:value-of select="."/>
            <xsl:text>&#009;</xsl:text>
        </xsl:for-each>
        <xsl:for-each select="instantiationEssenceTrack/essenceTrackAnnotation">
            <xsl:value-of select="./@annotationType"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:choose>
                <xsl:when  test="position() != last()">
                    <xsl:value-of select="$filename"/>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="*"/>
</xsl:stylesheet>