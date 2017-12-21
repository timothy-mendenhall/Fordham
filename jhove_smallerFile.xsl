<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xpath-default-namespace="http://hul.harvard.edu/ois/xml/ns/jhove"
   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
   xmlns="http://hul.harvard.edu/ois/xml/ns/jhove" 
    version="2.0">
    <xsl:output method="xml" indent="yes"/>
    <xsl:strip-space elements="*"/>
    <xsl:template match="jhove">
        <xsl:copy>
            <xsl:for-each select="./@*">
                <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
            </xsl:for-each>
            <xsl:copy-of select="date" />
            <xsl:apply-templates />
            
        </xsl:copy>
    </xsl:template>
    <xsl:template match="repInfo">
        <xsl:for-each select=".">
            <xsl:element name="repInfo">
                <xsl:for-each select="./@*">
                    <xsl:attribute name="{name(.)}"><xsl:value-of select="."/></xsl:attribute>
                </xsl:for-each>
                <xsl:apply-templates/>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="reportingModule | lastModified | size  | format | version | status | sigMatch | module | mimeType | profiles">
        <xsl:copy-of select="."/>
    </xsl:template>
    <xsl:template match="properties">
        <xsl:element name="properties">
            <xsl:for-each select="property">
                <xsl:choose>
                    <xsl:when test=".[name/text() = 'TIFFMetadata']">
                        <xsl:element name="property">
                            <xsl:element name="name">TIFFMetadata</xsl:element>
                            <xsl:element name="values">
                                <xsl:attribute name="arity">List</xsl:attribute>
                                <xsl:attribute name="type">Property</xsl:attribute>
                                <xsl:for-each select="./values/property">
                                    <xsl:choose>
                                        <xsl:when test="./name[text() = 'IFDs']">
                                            <xsl:element name="property">
                                                <xsl:element name="name">IFDs</xsl:element>
                                                <xsl:element name="values">
                                                    <xsl:attribute name="arity">List</xsl:attribute>
                                                    <xsl:attribute name="type">Property</xsl:attribute>
                                                    <xsl:for-each select="values/property">
                                                        <xsl:choose>
                                                            <xsl:when test=".[name/text() = 'IFD']">
                                                                <xsl:element name="property">
                                                                    <xsl:element name="name">IFD</xsl:element>
                                                                    <xsl:element name="values">
                                                                        <xsl:attribute name="arity">Array</xsl:attribute>
                                                                        <xsl:attribute name="type">Property</xsl:attribute>
                                                                        <xsl:for-each select="values/property">
                                                                            <xsl:choose>
                                                                                <xsl:when test=".[name/text() = 'Entries']">
                                                                                    <xsl:element name="property">
                                                                                        <xsl:element name="name">Entries</xsl:element>
                                                                                        <xsl:element name="values">
                                                                                            <xsl:attribute name="arity">Array</xsl:attribute>
                                                                                            <xsl:attribute name="type">Property</xsl:attribute>
                                                                                            <xsl:for-each select="values/property">
                                                                                                <xsl:choose>
                                                                                                    <xsl:when test=".[name/text() = 'PhotoshopProperties']"/>
                                                                                                    <xsl:when test=".[name/text() = 'TIFFEPProperties']">
                                                                                                        <xsl:element name="property">
                                                                                                            <xsl:element name="name">TIFFEPProperties</xsl:element>
                                                                                                            <xsl:element name="values">
                                                                                                                <xsl:attribute name="arity">List</xsl:attribute>
                                                                                                                <xsl:attribute name="type">Property</xsl:attribute>
                                                                                                                <xsl:for-each select="values/property">
                                                                                                                    <xsl:call-template name="strip_IPTCNAA"/>
                                                                                                                    <!-- 
                                                                                                                        <xsl:choose>
                                                                                                                        <xsl:when test=".[name/text() = 'IPTCNAA']"/>
                                                                                                                        <xsl:otherwise>
                                                                                                                        <xsl:copy-of select="."/>
                                                                                                                        </xsl:otherwise>
                                                                                                                        </xsl:choose>
                                                                                                                    -->
                                                                                                                    
                                                                                                                </xsl:for-each>
                                                                                                            </xsl:element>
                                                                                                        </xsl:element>
                                                                                                    </xsl:when>
                                                                                                    <xsl:otherwise>
                                                                                                        <xsl:copy-of select="."></xsl:copy-of>
                                                                                                    </xsl:otherwise>
                                                                                                </xsl:choose>
                                                                                            </xsl:for-each>
                                                                                        </xsl:element>
                                                                                    </xsl:element>
                                                                                </xsl:when>
                                                                                <xsl:otherwise>
                                                                                    <xsl:copy-of select="."/>
                                                                                </xsl:otherwise>
                                                                            </xsl:choose>
                                                                        </xsl:for-each>
                                                                    </xsl:element>
                                                                </xsl:element>
                                                            </xsl:when>
                                                            <xsl:otherwise>
                                                                <xsl:copy-of select="."/>
                                                            </xsl:otherwise>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </xsl:element>
                                            </xsl:element>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:copy-of select="."/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:element>
                        </xsl:element>
                        
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
    <xsl:template name="strip_IPTCNAA">
        <xsl:choose>
            <xsl:when test=".[name/text() = 'IPTCNAA']"/>
            <xsl:otherwise>
                <xsl:copy-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="*"/>
    </xsl:stylesheet>