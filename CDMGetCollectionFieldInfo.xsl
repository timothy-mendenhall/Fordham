<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">

    <!-- Written 2017-12-20 by T.R. Mendenhall, Metadata Librarian, Fordham University, Walsh Library -->
    <!-- Use to convert data gathered from a DMGetCollectionFieldInfo API call into from xml into a tsv -->
    <!-- DMGetCollectionFieldInfo returns the metadata profile from a collection -->
    
        <xsl:output method="text"/>
        <xsl:strip-space elements="*"/>
    <xsl:template match="fields">
            <xsl:text>Field name&#009;Nickname&#009;Data type&#009;Large field&#009;Find alias&#009;</xsl:text>
            <xsl:text>Cardinality&#009;Searchable&#009;Hidden&#009;Vocabulary source&#009;Vocab Y/N&#009;Dublin Core Map&#009;</xsl:text>
            <xsl:text>Admin&#009;Read only&#xA;</xsl:text>
            <xsl:apply-templates/>
        </xsl:template>
        <xsl:template match="field">
            <xsl:for-each select=".">
                <xsl:value-of select="name"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="nick"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="type"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="size"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="find"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="req"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="search"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="hide"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="vocdb"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="vocab"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="dc"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="admin"/>
                <xsl:text>&#009;</xsl:text>
                <xsl:value-of select="readonly"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
        </xsl:template>
        <xsl:template match="*"/>
    </xsl:stylesheet>