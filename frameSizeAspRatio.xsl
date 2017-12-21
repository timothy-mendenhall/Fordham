<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        version="2.0">
        <xsl:output method="text"/>
        <xsl:strip-space elements="*"/>
        <xsl:param name="date_created" as="text()"/>
        <xsl:template match="pbcoreCollection">
            <xsl:text>Frame size&#009;Aspect ratio&#xA;</xsl:text>
            <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="pbcoreInstantiationDocument">
            <xsl:for-each select=".">
                <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackFrameSize"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackAspectRatio"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
        </xsl:template>
        <xsl:template match="*"/>
</xsl:stylesheet>