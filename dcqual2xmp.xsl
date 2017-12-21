<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:oclcterms="http://purl.org/oclc/terms/" xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:dcmitype="http://purl.org/dc/dcmitype/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:x="adobe:ns:meta/" x:xmptk="Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        "
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" encoding="UTF-8"/>
    <xsl:strip-space elements="*"/>
    
    <xsl:template match="dctermset">
        <xsl:for-each select="./oclcdcq">
            <xsl:variable name="oclcID">
                <xsl:value-of select="./oclcterms:recordIdentifier"/>
            </xsl:variable>
            <xsl:result-document encoding="UTF-8" method="xml" href="{concat($oclcID, '.xmp')}" indent="yes">
                <xsl:element name="x:xmpmeta" xmlns:x="adobe:ns:meta/">
                    <xsl:attribute name="x:xmptk">Adobe XMP Core 5.3-c011 66.145661, 2012/02/06-14:56:27        </xsl:attribute>
                    <xsl:element name="rdf:RDF" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
                        <xsl:element name="rdf:Description" 
                            rdf:about=""
                            xmlns:dc="http://purl.org/dc/elements/1.1/"
                            xmlns:photoshop="http://ns.adobe.com/photoshop/1.0/"
                            xmlns:xmpRights="http://ns.adobe.com/xap/1.0/rights/"
                            xmlns:Iptc4xmpExt="http://iptc.org/std/Iptc4xmpExt/2008-02-29/">
                            <xsl:attribute name="photoshop:Headline">
                                <xsl:choose>
                                    <xsl:when test="ends-with(./dc:title, '.')">
                                        <xsl:analyze-string select="normalize-space(normalize-unicode(./dc:title))" regex="(^.+)\.$">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="./dc:title"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:attribute>
                            <xsl:attribute name="photoshop:Credit">
                                <xsl:text>Italian Pamphlet Collection, call number BX1545 .I8, Box XX, Item XX; Fordham University Libraries</xsl:text>
                            </xsl:attribute>
                            <xsl:attribute name="xmpRights:Marked">
                                <xsl:text>False</xsl:text>
                            </xsl:attribute>
                            <xsl:element name="dc:creator">
                                <xsl:element name="rdf:Seq">
                                    <xsl:element name="rdf:li">
                                        <xsl:text>Fordham University. Libraries</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="dc:subject">
                                <xsl:element name="rdf:Bag">
                                    <xsl:for-each select="./dc:creator">
                                        <xsl:element name="rdf:li">
                                            <xsl:variable name="creator">
                                                <xsl:analyze-string select="normalize-space(normalize-unicode(.))" regex="(^.+)[,\.]$">
                                                    <xsl:matching-substring>
                                                        <xsl:value-of select="regex-group(1)"/>
                                                    </xsl:matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:variable>
                                            <xsl:value-of select="concat($creator, '--author')"/>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="./dc:subject[@xsi:type='http://purl.org/dc/terms/LCSH']">
                                        <xsl:element name="rdf:li">
                                            <xsl:analyze-string select="normalize-space(normalize-unicode(.))" regex="(^.+)[,\.]$">
                                                <xsl:matching-substring>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </xsl:matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="./dc:contributor">
                                        <xsl:element name="rdf:li">
                                            <xsl:variable name="contributor">
                                                <xsl:analyze-string select="normalize-space(normalize-unicode(.))" regex="(^.+)[,\.]$">
                                                    <xsl:matching-substring>
                                                        <xsl:value-of select="regex-group(1)"/>
                                                    </xsl:matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:variable>
                                            <xsl:value-of select="concat($contributor, '--contributor')"/>
                                        </xsl:element>
                                    </xsl:for-each>
                                    <xsl:for-each select="./dc:publisher">
                                        <xsl:element name="rdf:li">
                                            <xsl:variable name="publisher">
                                                <xsl:choose>
                                                    <xsl:when test="ends-with(., ',')">
                                                        <xsl:analyze-string select="normalize-space(normalize-unicode(.))" regex="(^.+)[,\.]$">
                                                            <xsl:matching-substring>
                                                                <xsl:value-of select="regex-group(1)"/>
                                                            </xsl:matching-substring>
                                                        </xsl:analyze-string>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="."/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:variable>
                                            <xsl:value-of select="concat($publisher, '--issuing body')"/>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="dc:title">
                                <xsl:element name="rdf:Alt">
                                    <xsl:element name="rdf:li">
                                        <xsl:attribute name="xml:lang">eng</xsl:attribute>
                                        <xsl:text>ful_bx1545i8_boxXX_itemXX</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="xmpRights:UsageTerms">
                                <xsl:element name="rdf:Alt">
                                    <xsl:element name="rdf:li">
                                        <xsl:attribute name="xml:lang">
                                            <xsl:text>eng</xsl:text>
                                        </xsl:attribute>
                                        <xsl:text>Please contact Fordham University Libraries to use this item for any commercial purposes, including, but not limited to, reproduction, broadcast, rehosting, and publication; non-commercial uses are covered by fair use.</xsl:text>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                            <xsl:element name="Iptc4xmpExt:ArtworkOrObject">
                                <xsl:element name="rdf:Bag">
                                    <xsl:element name="rdf:li">
                                        <xsl:attribute name="rdf:parseType">
                                            <xsl:text>Resource</xsl:text>
                                        </xsl:attribute>
                                        <xsl:element name="Iptc4xmpExt:AODateCreated">
                                            <xsl:value-of select="substring-before(./dcterms:created, '.')"/>
                                        </xsl:element>
                                        <xsl:element name="Iptc4xmpExt:AOTitle">
                                            <xsl:element name="rdf:Alt">
                                                <xsl:element name="rdf:li">
                                                    <xsl:attribute name="xml:lang">
                                                        <xsl:value-of select="./dc:language[@xsi:type='http://purl.org/dc/terms/ISO639-2']"/>
                                                    </xsl:attribute>
                                                    <xsl:choose>
                                                        <xsl:when test="ends-with(./dc:title, '.')">
                                                            <xsl:analyze-string select="normalize-space(normalize-unicode(./dc:title))" regex="(^.+)\.$">
                                                                <xsl:matching-substring>
                                                                    <xsl:value-of select="regex-group(1)"/>
                                                                </xsl:matching-substring>
                                                            </xsl:analyze-string>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                            <xsl:value-of select="./dc:title"/>
                                                        </xsl:otherwise>
                                                    </xsl:choose>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                        <xsl:element name="Iptc4xmpExt:AOCreator">
                                            <xsl:element name="rdf:Seq">
                                                <xsl:element name="rdf:li">
                                                    <xsl:analyze-string select="normalize-space(normalize-unicode(./dc:creator))" regex="(^.+)[,\.]$">
                                                        <xsl:matching-substring>
                                                            <xsl:value-of select="regex-group(1)"/>
                                                        </xsl:matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:result-document>
            
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>