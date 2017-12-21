<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
    exclude-result-prefixes="xs"
    version="2.0">
    <!-- Created 2016-12-16 by Timothy Ryan Mendenhall -->
    <!-- Would be interesting to talk to SIRSI and see if we could customize report to grab lcnaf / lcsh numbers from authority tables -->
    <!-- Used with SIRSI List Call Number report to generate MARCxml uniting bibliographic data (SIRSI Title), 
       call number and basic holdings data (SIRSI call number, analogous to MARC 852 in most systems), local authority record numbers
        (exported with the bib/title data - appended as subfield = in 1XX, 6XX, 7XX, 8XX), and item information (SIRSI copy).
        Could be expanded to include more info for serials holdings (SIRSI holdings), and more info from call number and item tables.
       MARC fields generated are entirely contingent on the fields exported from SIRSI when running the report.
    -->
    <xsl:output method="xml" indent="yes"></xsl:output>
    <!-- Template matches root node to generate the wrapper element marc:collection for the group of exported files -->
    <xsl:template match="/">
        <xsl:element name="marc:collection" inherit-namespaces="yes">
            <xsl:apply-templates select="./report" />
        </xsl:element>
    </xsl:template>
    <!-- Template matches each record output to generate individual marc:record elements -->
    <xsl:template name="records" match="report">
        <!-- loop through each exported record and generate wrapper marc:record element -->
        <xsl:for-each select="./catalog/marc">
            <xsl:element name="marc:record">
                <!-- within each exported MARC record, loop through all exported fields to generate marc:controlfield or 
                marc:datafield elements -->
                <xsl:for-each select="./marcEntry">
                    <xsl:choose>
                        <!-- generate marc:controlfield from exported elements whose tages begin with '00' -->
                        <xsl:when test="starts-with(./@tag, '00')">
                            <xsl:element name="marc:controlfield">
                                <!-- generate tag attribute -->
                                <xsl:attribute name="tag">
                                    <xsl:choose>
                                        <xsl:when test="./@tag='000'">
                                            <xsl:text>LDR</xsl:text>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="./@tag"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:attribute>
                                <!-- weed out relevant content and populate field -->
                                <xsl:analyze-string select="." regex="\|[a-z](.+)">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:element>
                        </xsl:when>
                        <!-- generate marc:datafield elements from everything that does not meet the marc:controlfield criteria -->
                        <xsl:otherwise>
                            <xsl:element name="marc:datafield">
                                <!-- generate tag attribute -->
                                <xsl:attribute name="tag">
                                    <xsl:value-of select="./@tag"/>
                                </xsl:attribute>
                                <!-- generate indicator attributes -->
                                <xsl:attribute name="ind1">
                                    <xsl:analyze-string select="./@ind" regex="([\s\d])([\s\d])">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(1)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:attribute>
                                <xsl:attribute name="ind2">
                                    <xsl:analyze-string select="./@ind" regex="([\s\d])([\s\d])">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(2)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:attribute>
                                <!-- analyze field contents with regex and generate marc:subfield elements,
                                with appropriate code attributes and contents -->
                                <xsl:analyze-string select="." regex="\|([a-z=0-9])([^|]+)">
                                    <xsl:matching-substring>
                                        <xsl:element name="marc:subfield">
                                            <xsl:choose>
                                                <xsl:when test="regex-group(1)='='">
                                                    <xsl:attribute name="code">
                                                        <xsl:value-of select="replace(regex-group(1), '=','0')"/>
                                                    </xsl:attribute>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:attribute name="code">
                                                        <xsl:value-of select="regex-group(1)"/>
                                                    </xsl:attribute>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <xsl:value-of select="regex-group(2)"/>
                                        </xsl:element>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
                <!-- Grab local call number, item, and holdings info from Sirsi Call Number data -->
                
                <xsl:for-each select="../call">
                    <xsl:element name="marc:datafield">
                        <xsl:attribute name="tag">852</xsl:attribute>
                        <xsl:attribute name="ind1">4</xsl:attribute>
                        <xsl:attribute name="ind2"> </xsl:attribute>
                        <xsl:element name="marc:subfield">
                            <xsl:attribute name="code">a</xsl:attribute>
                            <xsl:value-of select="./library"/>
                        </xsl:element>
                        <xsl:element name="marc:subfield">
                            <xsl:attribute name="code">b</xsl:attribute>
                            <xsl:value-of select="./item/location"/>
                        </xsl:element>
                        <xsl:element name="marc:subfield">
                            <xsl:attribute name="code">j</xsl:attribute>
                            <xsl:value-of select="./callNumber"/>
                        </xsl:element>
                        <xsl:element name="marc:subfield">
                            <xsl:attribute name="code">p</xsl:attribute>
                            <xsl:value-of select="./item/itemID"/>
                        </xsl:element>
                        <xsl:element name="marc:subfield">
                            <xsl:attribute name="code">t</xsl:attribute>
                            <xsl:value-of select="./item/copyNumber"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:for-each>
                
                <!-- grab catalog control key and add it to the MARC record in a 949 tag -->
                <xsl:element name="marc:datafield">
                    <xsl:attribute name="tag">949</xsl:attribute>
                    <xsl:attribute name="ind1"> </xsl:attribute>
                    <xsl:attribute name="ind2"> </xsl:attribute>
                    <xsl:element name="marc:subfield">
                        <xsl:attribute name="code">a</xsl:attribute>
                        <xsl:value-of select="../catalogKey"/>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>