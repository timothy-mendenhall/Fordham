<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xpath-default-namespace="http://hul.harvard.edu/ois/xml/ns/jhove"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns="http://hul.harvard.edu/ois/xml/ns/jhove" xmlns:mix="http://www.loc.gov/mix/v20"
    exclude-result-prefixes="mix" version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template name="mix_docs" match="jhove">
        <xsl:for-each
            select="repInfo/properties/property[name/text() = 'TIFFMetadata']/values/property[name/text() = 'IFDs']
            /values/property[name/text() = 'IFD']/values/property[name/text() = 'Entries']/values
            /property[name/text() = 'NisoImageMetadata']/values/value/mix:mix">
            <xsl:variable name="tiffName">
                <xsl:value-of select="ancestor::repInfo/@uri"/>
            </xsl:variable>
            <xsl:variable name="mixNameInit">
                <xsl:value-of select="substring-after($tiffName, '%5Cful_')"/>
            </xsl:variable>
            <xsl:variable name="mixName">
                <xsl:value-of select="substring-before($mixNameInit, '.tif')"/>
            </xsl:variable>
            <xsl:result-document method="xml" href="{concat($mixName, '_mix.xml')}">
                <!-- <xsl:copy-of select="."/> -->
                <xsl:copy>
                    <xsl:for-each select="./@*">
                        <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
                    </xsl:for-each>
                    <xsl:for-each select="mix:BasicDigitalObjectInformation">
                        <xsl:copy>
                            <xsl:element name="mix:ObjectIdentifier">
                                <xsl:element name="mix:objectIdentifierType">
                                    <xsl:text>File name</xsl:text>
                                </xsl:element>
                                <xsl:element name="mix:objectIdentifierValue">
                                    <xsl:value-of select="$mixNameInit"/>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="mix:ObjectIdentifier">
                                <xsl:element name="mix:objectIdentifierType">
                                    <xsl:text>Fordham University handle</xsl:text>
                                </xsl:element>
                                <xsl:element name="mix:objectIdentifierValue">
                                    <xsl:value-of select="$mixName"/>
                                </xsl:element>
                            </xsl:element>
                            <xsl:for-each select="mix:ObjectIdentifier | mix:byteOrder | mix:Compression">
                                <xsl:copy-of select="."/>
                            </xsl:for-each>
                        </xsl:copy>
                    </xsl:for-each>
                    <xsl:for-each select="mix:BasicImageInformation | mix:ImageAssessmentMetadata | mix:ImageCaptureMetadata">
                        <xsl:copy-of select="."/>
                    </xsl:for-each>
                </xsl:copy>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="*"/>
</xsl:stylesheet>
