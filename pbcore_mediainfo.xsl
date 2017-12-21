<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
    <!-- 2015-02-27 Written by Timothy Ryan Mendenhall for use on PBCore metadata extracted 
        from digital video files via the application MediaInfo -->
    <!-- MediaInfo spits out several pbcoreInstantiationDocument wrappers, which are essentially separate files
        But MediaInfo puts these in a single file
        To use this xslt you have to create a well-formed xml document using the following steps:
        1) wrap these  pbcoreInstantiationDocument wrappers in a pbcoreCollection element
        2) batch delete the extra xml declarations 
        3) delete any of the following namespaces from the pbcoreInstantiationDocument elements: -->
    <!-- xsi:schemaLocation="http://www.pbcore.org/PBCore/PBCoreNamespace.html http://pbcore.org/xsd/pbcore-2.0.xsd"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns="http://www.pbcore.org/PBCore/PBCoreNamespace.html" -->
    <!-- Once this transform has been applied, use pbcore_mediainfo.tsv on the resulting file to generate
        a tab-delimited dataset -->
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="pbcoreCollection">
        <pbcoreCollection>
            <xsl:apply-templates/>
        </pbcoreCollection>
    </xsl:template>
    <xsl:template match="pbcoreInstantiationDocument">
        <xsl:for-each select=".">
            <xsl:element name="pbcoreInstantiation">
                <xsl:element name="instantiationIdentifier">
                    <xsl:attribute name="source">File name</xsl:attribute>
                    <xsl:value-of select="instantiationIdentifier"/>
                </xsl:element>
                <xsl:variable name="clean_date">
                    <xsl:value-of select="instantiationAnnotation[@annotationType='File_Created_Date']"/>
                </xsl:variable>
                <xsl:element name="instantiationDate">
                    <xsl:attribute name="dateType">created</xsl:attribute>
                    <xsl:analyze-string select="$clean_date"
                        regex="(\d{{4}}-\d{{2}}-\d{{2}})\s(\d{{2}}:\d{{2}}:\d{{2}}\.\d{{3}})">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                            <xsl:text>T</xsl:text>
                            <xsl:value-of select="regex-group(2)"/>
                            <xsl:text>Z</xsl:text>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:element>
                <xsl:apply-templates/>
                <xsl:element name="instantiationAnnotation">
                    <xsl:attribute name="annotationType"
                        >Various Media Info instantiation annotations</xsl:attribute>
                    <xsl:call-template name="variousMediaInfoInstantiationAnnotations"/>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="variousMediaInfoInstantiationAnnotations">
        <xsl:for-each select="instantiationAnnotation[@annotationType!='Format' and @annotationType!='FrameRate' and @annotationType!='Inform' and @annotationType!='File_Created_Date_Local' and @annotationType!='File_Created_Date' and @annotationType!='OtherCount' and @annotationType!='Other_Format_List' and @annotationType!='Other_Format_WithHint_List' and @annotationType!='Comment' and @annotationType!='Other_Language_List' and @annotationType!='Encoded_Application' and @annotationType!='Format' and @annotationType!='IsStreamable' and @annotationType!='Format_Profile' and @annotationType!='Codec/Info' and @annotationType!='Format/Info']">
            <xsl:value-of select="@annotationType"/>
            <xsl:text>: </xsl:text>
            <xsl:choose>
                <xsl:when test="position() != last()">
                    <xsl:value-of select="." separator="; "/>
                    <xsl:text>; </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."></xsl:value-of>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xsl:template
        match="instantiationLocation|instantiationFileSize|instantiationTimeStart|instantiationDuration|instantiationLanguage">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="instantiationDate[@dateType='file modification']">
                <xsl:copy>
                    <xsl:attribute name="dateType">revised</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>        
    </xsl:template>
    <xsl:template match="instantiationDigital">
        <xsl:variable name="extendedFormat">
            <xsl:if test="../instantiationAnnotation[@annotationType='Format']">
                <xsl:value-of select="../instantiationAnnotation[@annotationType='Format']"/>
            </xsl:if>
            <xsl:if test="../instantiationAnnotation[@annotationType='Format_Profile']">
                <xsl:text> (Profile: </xsl:text>
                <xsl:value-of select="../instantiationAnnotation[@annotationType='Format_Profile']"/>
                <xsl:if test="../instantiationAnnotation[@annotationType='Format_Version']">
                    <xsl:text>; Version: </xsl:text>
                    <xsl:value-of select="../instantiationAnnotation[@annotationType='Format_Version']"/>
                </xsl:if>
                <xsl:if test="../instantiationAnnotation[@annotationType='IsStreamable']">
                    <xsl:text>; Streamable: </xsl:text>
                    <xsl:value-of select="../instantiationAnnotation[@annotationType='IsStreamable']"/>
                </xsl:if>
                <xsl:text>)</xsl:text>
            </xsl:if>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test=".='application/x-shockwave-flash'">
                <xsl:element name="instantiationDigital">
                    <xsl:attribute name="annotation">video/x-flv</xsl:attribute>
                    <xsl:attribute name="source">Library of Congress digital format
                        descriptions</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://www.digitalpreservation.gov/formats/fdd/fdd000131.shtml</xsl:attribute>
                    <xsl:text>application/octet-stream</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test=".='video/mp4'">
                <xsl:choose>
                    <xsl:when
                        test="following-sibling::instantiationEssenceTrack[essenceTrackType='Video']/essenceTrackEncoding='AVC'">
                        <xsl:element name="instantiationDigital">
                            <xsl:attribute name="annotation">
                                <xsl:value-of select="$extendedFormat"/>
                            </xsl:attribute>
                            <xsl:attribute name="source">IANA MIME media types</xsl:attribute>
                            <xsl:attribute name="ref"
                                >http://www.iana.org/assignments/media-types/video/H264</xsl:attribute>
                            <xsl:text>H264</xsl:text>
                        </xsl:element>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:element name="instantiationDigital">
                            <xsl:attribute name="annotation">
                                <xsl:value-of select="$extendedFormat"/>
                            </xsl:attribute>
                            <xsl:attribute name="source">IANA MIME media types</xsl:attribute>
                            <xsl:attribute name="ref"
                                >http://www.iana.org/assignments/media-types/video/mp4</xsl:attribute>
                            <xsl:text>mp4</xsl:text>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="instantiationMediaType">
        <xsl:copy-of select="."/>
        <instantiationGenerations source="PBCore instantiationGenerations"
            ref="http://metadataregistry.org/concept/show/id/2237.html">Copy:
            access</instantiationGenerations>
    </xsl:template>
    <xsl:template match="instantiationDataRate">
        <xsl:copy-of select="."/>
        <xsl:variable name="colorCount">
            <xsl:value-of
                select="count(../instantiationEssenceTrack/essenceTrackAnnotation[@annotationType='ColorSpace' or @annotationType='ChromaSubsampling' or @annotationType='colour_description_present' or @annotationType='colour_primaries' or @annotationType='colour_range'])"
            />
        </xsl:variable>
        <xsl:element name="instantiationColors">
            <xsl:attribute name="source">PBCore instantiationColors</xsl:attribute>
            <xsl:attribute name="ref"
                >http://metadataregistry.org/concept/show/id/1481.html</xsl:attribute>
            <xsl:if
                test="../instantiationEssenceTrack/essenceTrackAnnotation[@annotationType='ColorSpace' or @annotationType='ChromaSubsampling' or @annotationType='colour_description_present' or @annotationType='colour_primaries' or @annotationType='colour_range']">
                <xsl:attribute name="annotation">
                    <xsl:for-each
                        select="../instantiationEssenceTrack/essenceTrackAnnotation[@annotationType='ColorSpace' or @annotationType='ChromaSubsampling' or @annotationType='colour_description_present' or @annotationType='colour_primaries' or @annotationType='colour_range']">
                        <xsl:value-of select="@annotationType"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:if test="position() &lt; $colorCount">; </xsl:if>
                    </xsl:for-each>
                </xsl:attribute>
            </xsl:if>
            <xsl:text>Color</xsl:text>
        </xsl:element>
    </xsl:template>
    <xsl:template match="instantiationTracks">
        <xsl:choose>
            <xsl:when test=". = '2'">
                <xsl:copy>1 video track, 1 audio track</xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:element name="instantiationChannelConfiguration">
            <xsl:text>Channels: </xsl:text>
            <xsl:value-of
                select="following-sibling::instantiationEssenceTrack/essenceTrackAnnotation[@annotationType='Channel(s)']"/>
            <xsl:text>; channel configuration: </xsl:text>
            <xsl:value-of
                select="following-sibling::instantiationEssenceTrack/essenceTrackAnnotation[@annotationType='ChannelLayout']"
            />
        </xsl:element>
    </xsl:template>
    <xsl:template match="instantiationEssenceTrack">
        <xsl:copy>
            <xsl:apply-templates/>
            <xsl:element name="essenceTrackAnnotation">
                <xsl:attribute name="annotationType">Various Media Info essence track annotations</xsl:attribute>
                <xsl:for-each
                    select="essenceTrackAnnotation[contains(@annotationType, 'Delay') or contains(@annotationType, 'Format_Settings') or contains(@annotationType, 'Source_') or @annotationType = 'BufferSize' or @annotationType = 'Duration_FirstFrame' or @annotationType = 'FirstPacketOrder' or @annotationType = 'matrix_coefficients' or @annotationType = 'MenuID' or @annotationType = 'MuxingMode' or @annotationType = 'transfer_characteristics']">
                    <xsl:value-of select="@annotationType"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:if test="position() != last()">; </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:copy>
        <xsl:if test="not(essenceTrackStandard)">
            <xsl:call-template name="noStandard"/>
        </xsl:if>
    </xsl:template>
    <xsl:template
        match="essenceTrackType|essenceTrackBitDepth|essenceTrackDataRate|essenceTrackDuration|essenceTrackLanguage">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="essenceTrackStandard">
        <xsl:choose>
            <xsl:when test=". = 'NTSC'">
                <xsl:element name="essenceTrackStandard">
                    <xsl:attribute name="source">PBCore essenceTrack/video</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/3144.html</xsl:attribute>
                    <xsl:text>NTSC</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template name="noStandard">
        <xsl:choose>
            <xsl:when test="essenceTrackEncoding = 'MPEG Audio'">
                <xsl:element name="essenceTrackStandard">
                    <xsl:attribute name="source">PBCore essenceTrack/audio</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/3178.html</xsl:attribute>
                    <xsl:text>MP3</xsl:text>
                </xsl:element>
            </xsl:when>
            <xsl:when test="essenceTrackEncoding = 'AVC'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrack/video</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/3136.html</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="essenceTrackEncoding">
        <xsl:element name="essenceTrackEncoding">
            <xsl:attribute name="annotation">
                <xsl:value-of select="@annotation"/>
                <xsl:if
                    test="../essenceTrackAnnotation[@annotationType='Compression_Mode' or contains(@annotationType, 'Codec') or contains(@annotationType, 'Encoded_Library')]">
                    <xsl:variable name="countAnnotations">
                        <xsl:value-of
                            select="count(../essenceTrackAnnotation[@annotationType='Compression_Mode' or contains(@annotationType, 'Codec') or contains(@annotationType, 'Encoded_Library')])"
                        />
                    </xsl:variable>
                    <xsl:for-each
                        select="../essenceTrackAnnotation[@annotationType='Compression_Mode' or contains(@annotationType, 'Codec') or contains(@annotationType, 'Encoded_Library')]">
                        <xsl:text>; </xsl:text>
                        <xsl:value-of select="@annotationType"/>
                        <xsl:text>: </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:if>
            </xsl:attribute>
            <xsl:if test=". != 'MPEG-4 Visual'">
                <xsl:attribute name="source">PBCore essenceTrackEncoding</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test=". = 'MPEG-4 Visual'">
                    <xsl:attribute name="source">EBU Video Compression Code</xsl:attribute>
                    <xsl:attribute name="ref">3.3.6</xsl:attribute>
                    <xsl:text>MPEG-4 Visual Advanced Simple Profile @ Level 5</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'MPEG Audio'">
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/2924.html</xsl:attribute>
                    <xsl:attribute name="version">Version 1</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:when test=". = 'AVC'">
                    <xsl:variable name="encodedApp">
                        <xsl:value-of
                            select="../../instantiationAnnotation[@annotationType='Encoded_Application']"
                        />
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="contains($encodedApp, 'Sorenson')">
                            <xsl:attribute name="ref"
                                >http://metadataregistry.org/concept/show/id/2893.html</xsl:attribute>
                            <xsl:text>H.264/MPEG-4 AVC: Sorenson AVC Pro codec</xsl:text>
                        </xsl:when>
                        <xsl:when
                            test="essenceTrackAnnotation[@annotationType='Encoded_Library/Name'] = 'x264'">
                            <xsl:attribute name="ref"
                                >http://metadataregistry.org/concept/show/id/2895.html</xsl:attribute>
                            <xsl:text>H.264/MPEG-4 AVC: x264</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="ref"
                                >http://metadataregistry.org/concept/show/id/2888.html</xsl:attribute>
                            <xsl:text>H.264/MPEG-4 AVC</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test=". = 'AAC'">
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/2934.html</xsl:attribute>
                    <xsl:text>MPEG-4: AAC</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'VP6'">
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/3000.html</xsl:attribute>
                    <xsl:text>TrueMotion VP6</xsl:text>
                </xsl:when>
                <xsl:when test=". = 'Sorenson Spark'">
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/2984.html</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    <xsl:template match="essenceTrackSamplingRate">
        <xsl:element name="essenceTrackSamplingRate">
            <xsl:attribute name="unitsOfMeasure">Hz</xsl:attribute>
            <xsl:attribute name="annotation">
                <xsl:text>Sampling count: </xsl:text>
                <xsl:value-of select="../essenceTrackAnnotation[@annotationType='SamplingCount']"/>
            </xsl:attribute>
        </xsl:element>
    </xsl:template>
    <xsl:template match="essenceTrackFrameRate">
        <xsl:copy>
            <xsl:attribute name="unitsOfMeasure">fps</xsl:attribute>
            <xsl:attribute name="annotation">
                <xsl:value-of select="@annotation"/>
                <xsl:for-each
                    select="../essenceTrackAnnotation[@annotationType='FrameCount' or @annotationType='ScanType' or @annotationType='Interlacement' or @annotationType='ScanOrder' or @annotationType='ScanType_StoreMethod' or @annotationType='FrameRate_Maximum' or @annotationType='FrameRate_Minimum']">
                    <xsl:text>; </xsl:text>
                    <xsl:value-of select="@annotationType"/>
                    <xsl:text>: </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:attribute>
            <xsl:value-of select="."/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="essenceTrackFrameSize">
        <xsl:choose>
            <xsl:when test=". = '1280x720'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1466.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=". = '1920x1080'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1465.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=". = '320x240'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1456.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=". = '352x288'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1458.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=". = '640x480'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1459.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=". = '720x480'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1461.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=". = '720x486'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1462.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test=". = '720x576'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackFrameSize</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1463.html</xsl:attribute>
                    <xsl:attribute name="annotation">web</xsl:attribute>
                    <xsl:value-of select="."/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="essenceTrackAspectRatio">
        <xsl:variable name="aspectRatio">
            <xsl:value-of select="substring(.,1,3)"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$aspectRatio = '1.3'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackAspectRatio</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1436.html</xsl:attribute>
                    <xsl:value-of select="."/>
                    <xsl:text> (4:3)</xsl:text>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$aspectRatio = '1.2'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackAspectRatio</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1441.html</xsl:attribute>
                    <xsl:value-of select="."/>
                    <xsl:text> (5:4)</xsl:text>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$aspectRatio = '1.6' and string-length() = 3">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackAspectRatio</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1446.html</xsl:attribute>
                    <xsl:value-of select="."/>
                    <xsl:text> (16:10)</xsl:text>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$aspectRatio = '1.6' and string-length() != 3">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackAspectRatio</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1440.html</xsl:attribute>
                    <xsl:value-of select="."/>
                    <xsl:text> (5:3)</xsl:text>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$aspectRatio = '1.7'">
                <xsl:copy>
                    <xsl:attribute name="source">PBCore essenceTrackAspectRatio</xsl:attribute>
                    <xsl:attribute name="ref"
                        >http://metadataregistry.org/concept/show/id/1444.html</xsl:attribute>
                    <xsl:value-of select="."/>
                    <xsl:text> (16:9)</xsl:text>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*"/>
</xsl:stylesheet>
