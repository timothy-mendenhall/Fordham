<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="date_created" as="text()"/>
    <xsl:template match="pbcoreCollection">
        <xsl:text>File name&#009;Date-digital&#009;Digital format&#009;Digital format note&#009;Content type&#009;</xsl:text>
        <xsl:text>File path&#009;File size&#009;Duration&#009;Overall data rate&#009;Video data rate&#009;Audio data rate&#009;</xsl:text>
        <xsl:text>Colorspace&#009;Color notes&#009;Tracks&#009;Channels&#009;Video standard&#009;Video encoding&#009;Audio encoding&#009;</xsl:text>
        <xsl:text>Frame rate&#009;Frame rate note&#009;Audio sampling rate&#009;Bit depth&#009;Frame size&#009;</xsl:text>
        <xsl:text>Aspect ratio&#009;General note&#009;Video note&#009;Audio note&#xA;</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="pbcoreInstantiation">
        <xsl:for-each select=".">
            <xsl:value-of select="instantiationIdentifier"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationDate[@dateType='created']"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationDigital"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationDigital/@annotation"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationMediaType"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationLocation"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationFileSize"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="instantiationFileSize/@unitsOfMeasure"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationDuration"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationDataRate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="instantiationDataRate/@unitsOfMeasure"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackDataRate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackDataRate/@unitsOfMeasure"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Audio']/essenceTrackDataRate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Audio']/essenceTrackDataRate/@unitsOfMeasure"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationColors"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationColors/@annotation"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationTracks"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationChannelConfiguration"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackStandard"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackEncoding"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Audio']/essenceTrackEncoding"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackFrameRate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackFrameRate/@unitsOfMeasure"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackFrameRate/@annotation"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Audio']/essenceTrackSamplingRate"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Audio']/essenceTrackSamplingRate/@unitsOfMeasure"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackBitDepth"/>
            <xsl:text> bit</xsl:text>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackFrameSize"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackAspectRatio"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationAnnotation"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Video']/essenceTrackAnnotation"/>
            <xsl:text>&#009;</xsl:text>
            <xsl:value-of select="instantiationEssenceTrack[essenceTrackType = 'Audio']/essenceTrackAnnotation"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
    </xsl:template>
   <!-- 
       <xsl:template match="instantiationAnnotation[@annotationType='File_Created_Date']">
       <xsl:value-of select="."/>
       <xsl:text>&#009;</xsl:text>
       </xsl:template>
       <xsl:template match="instantiationDigital">
       <xsl:value-of select="./@annotation"/>
       <xsl:text>&#009;</xsl:text>
       </xsl:template>
   -->
    <xsl:template match="*"/>
</xsl:stylesheet>