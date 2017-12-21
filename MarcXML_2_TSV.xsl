<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0"
    xmlns:marc="http://www.loc.gov/MARC21/slim">
    <xsl:output method="text" normalization-form="NFC"/>
    <xsl:strip-space elements="*"/>
    
    <!-- Fix Italian MARC characters.  Haven't been able to figure this out -->
    
   <!-- 
    <xsl:value-of select="replace(./text(), 'à', '&#x00e1;')" />
        <xsl:value-of select="replace(., 'À', '&#x00c1;')" />
        <xsl:value-of select="replace(., 'è', '&#x00e8;')" />
        <xsl:value-of select="replace(., 'È', '&#x00c8;')" />
        <xsl:value-of select="replace(., 'ì', '&#x00ec;')" />
        <xsl:value-of select="replace(., 'Ì', '&#x00cc;')" />
        <xsl:value-of select="replace(., 'ò', '&#x00f2;')" />
        <xsl:value-of select="replace(., 'Ò', '&#x00d2;')" />
        <xsl:value-of select="replace(., 'ù', '&#x00f9;')" />
        <xsl:value-of select="replace(., 'Ù', '&#x00d9;')" />
   -->
    
    <!-- Main template -->

    <xsl:template match="marc:collection">

        <!-- Header row -->

        <xsl:text>CDM_LVL&#009;CDM_LVL_NAME&#009;Title&#009;Other title&#009;Creator-Person&#009;Creator-Organization&#009;</xsl:text>
        <xsl:text>Contributors-Persons&#009;Contributors-Organizations&#009;Subject-Topical&#009;Subject-Geographic&#009;Subject-Person&#009;Subject-Organization&#009;</xsl:text>
        <xsl:text>Notes&#009;Publisher&#009;Publisher location&#009;Edition statement&#009;Date&#009;Copyright date&#009;Extent&#009;</xsl:text>
        <xsl:text>Library of Congress classification&#009;Print copy at Fordham&#009;Print copy in WorldCat&#009;Table of contents&#009;Bibliography and index&#009;</xsl:text>
        <xsl:text>Identifier&#009;Digitization Equipment&#009;Digitization Technician&#009;Date digitized&#009;Language&#009;Related items&#009;Is version of&#009;Is part of&#009;</xsl:text>
        <xsl:text>Has part&#009;Is referenced in&#009;References&#009;File name&#xA;</xsl:text>
        <xsl:for-each select="marc:record">

            <!-- Title (245) variables -->

            <xsl:variable name="title">
                <xsl:value-of select="./marc:datafield[@tag = '245']/marc:subfield[@code = 'a']"/>
            </xsl:variable>

            <xsl:variable name="subtitle">
                <xsl:value-of select="./marc:datafield[@tag = '245']/marc:subfield[@code = 'b']"/>
            </xsl:variable>

            <xsl:variable name="subtitle_noDot">
                <xsl:analyze-string select="$subtitle" regex="(^.+)\.$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <xsl:variable name="sor">
                <xsl:value-of select="./marc:datafield[@tag = '245']/marc:subfield[@code = 'c']"/>
            </xsl:variable>

            <xsl:variable name="sor_noDot">
                <xsl:analyze-string select="$sor" regex="(^.+)\.$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <xsl:variable name="LVL_NAME">
                <xsl:value-of select="substring-before($title, ' :')"/>
            </xsl:variable>

            <xsl:variable name="LVL_NAME_SOR">
                <xsl:value-of select="substring-before($title, ' /')"/>
            </xsl:variable>

            <xsl:variable name="LVL_NAME_noSOR-SUB">
                <xsl:analyze-string
                    select="./marc:datafield[@tag = '245']/marc:subfield[@code = 'a']"
                    regex="(^.+)\.$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <!-- Other title (246) variables -->

            <xsl:variable name="alt_title">
                <xsl:value-of select="./marc:datafield[@tag = '246']/marc:subfield[@code = 'a']"/>
            </xsl:variable>

            <xsl:variable name="alt_title_sub">
                <xsl:value-of select="./marc:datafield[@tag = '246']/marc:subfield[@code = 'b']"/>
            </xsl:variable>

            <!-- CDM_LEVEL field -->

            <xsl:text>&#009;</xsl:text>

            <!-- CDM_LEVEL_NAME and Title -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '245']/marc:subfield[@code = 'b']">
                    <xsl:choose>
                        <xsl:when test="./marc:datafield[@tag = '245']/marc:subfield[@code = 'c']">
                            <xsl:value-of select="$LVL_NAME"/>
                            <xsl:text>&#009;</xsl:text>
                            <xsl:value-of select="concat($title, ' ', $subtitle, ' ', $sor_noDot)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$LVL_NAME"/>
                            <xsl:text>&#009;</xsl:text>
                            <xsl:value-of select="concat($title, ' ', $subtitle_noDot)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="./marc:datafield[@tag = '245']/marc:subfield[@code = 'c']">
                            <xsl:value-of select="$LVL_NAME_SOR"/>
                            <xsl:text>&#009;</xsl:text>
                            <xsl:value-of select="concat($title, ' ', $sor_noDot)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$LVL_NAME_noSOR-SUB"/>
                            <xsl:text>&#009;</xsl:text>
                            <xsl:value-of select="$LVL_NAME_noSOR-SUB"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:text>&#009;</xsl:text>

            <!-- Other title -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '246']/marc:subfield[@code = 'b']">
                    <xsl:value-of select="concat($alt_title, ' ', $alt_title_sub)"/>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="./marc:datafield[@tag = '246']">
                            <xsl:value-of select="$alt_title"/>
                            <xsl:text>&#009;</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>&#009;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Creator-Person  -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '100']">
                    <xsl:call-template name="creator_Person"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Creator-Organization  -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '110']">
                    <xsl:call-template name="creator_Organization"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Contributors-Persons  -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '700']">
                    <xsl:for-each select="./marc:datafield[@tag = '700']">
                        <xsl:call-template name="contributors"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Contributors-Organizations  -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '710']">
                    <xsl:for-each select="./marc:datafield[@tag = '710']">
                        <xsl:call-template name="contributors"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Subject-Topical -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '650']">
                    <xsl:for-each
                        select="./marc:datafield[@tag = '650' and (@ind2 = '0' or @ind2 = '4')]">
                        <xsl:call-template name="subjects"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Subject-Geographic -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '651' and (@ind2 = '0' or @ind2 = '4')]">
                    <xsl:for-each
                        select="./marc:datafield[@tag = '651' and (@ind2 = '0' or @ind2 = '4')]">
                        <xsl:call-template name="subjects"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Subject-Person  -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '600']">
                    <xsl:for-each
                        select="./marc:datafield[@tag = '600' and (@ind2 = '0' or @ind2 = '4')]">
                        <xsl:call-template name="subjects_600_610"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Subject-Organization -->
            <!-- Note: some issues with spacing in output, would be awfully tedious to fix -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag = '610']">
                    <xsl:for-each
                        select="./marc:datafield[@tag = '610' and (@ind2 = '0' or @ind2 = '4')]">
                        <xsl:call-template name="subjects_600_610"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="./marc:datafield[@tag = '611']">
                    <xsl:for-each
                        select="./marc:datafield[@tag = '611' and (@ind2 = '0' or @ind2 = '4')]">
                        <xsl:call-template name="subjects_600_610"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:when test="./marc:datafield[@tag = '630']">
                    <xsl:for-each
                        select="./marc:datafield[@tag = '630' and (@ind2 = '0' or @ind2 = '4')]">
                        <xsl:call-template name="subjects_600_610"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Notes.  504, 505, 510, 546 crosswalked to other fields, not present in this template. 
                Fields 507, 521, 526, 536, 541, 542, 552, 561, 565, 581 not addressed in this stylesheet -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='500' or '501' or '508' or '511' or '513' or '515' or '516' or '520' or '522' or '524' or '525' or '545' or '547' or '550' or '556' or '563' or '567' or '580' or '585' or '586']">
                    <xsl:for-each select="./marc:datafield[@tag='500' or @tag='501' or @tag='508' or @tag='511' or @tag='513' or @tag='515' or @tag='516' or @tag='520' or @tag='522' or @tag='524' or @tag='525' or @tag='545' or @tag='547' or @tag='550' or @tag='556' or @tag='563' or @tag='567' or @tag='580' or @tag='585' or @tag='586' or @tag='502' or @tag='505' or @tag='506' or @tag='510' or @tag='514' or @tag='518' or @tag='530' or @tag='533' or @tag='534' or @tag='535' or @tag='538' or @tag='540' or @tag='544' or @tag='555' or @tag='562' or @tag='584']">
                        <xsl:choose>
                            <xsl:when test="@tag='500' or @tag='501' or @tag='508' or @tag='511' or @tag='513' or @tag='515' or @tag='516' or @tag='520' or @tag='522' or @tag='524' or @tag='525' or @tag='545' or @tag='547' or @tag='550' or @tag='556' or @tag='563' or @tag='567' or @tag='580' or @tag='585' or @tag='586'">
                                <xsl:choose>
                                    <xsl:when test="ends-with(./marc:subfield[@code='a'], '.')">
                                        <xsl:analyze-string select="./marc:subfield[@code='a']" regex="(^.+)\.$">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="./marc:subfield[@code='a']"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:when test="@tag='502' or @tag='505' or @tag='506' or @tag='514' or @tag='518' or @tag='530' or @tag='533' or @tag='534' or @tag='535' or @tag='538' or @tag='540' or @tag='544' or @tag='555' or @tag='562' or @tag='584'">
                                <xsl:for-each select="./marc:subfield">
                                    <xsl:choose>
                                        <xsl:when test="position()=last()">
                                            <xsl:choose>
                                                <xsl:when test="ends-with(., '.')">
                                                    <xsl:analyze-string select="." regex="(^.+)\.$">
                                                        <xsl:matching-substring>
                                                            <xsl:value-of select="regex-group(1)"/>
                                                        </xsl:matching-substring>
                                                    </xsl:analyze-string>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="."/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="."/>
                                            <xsl:text> </xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="position()!=last()">
                                <xsl:text>; </xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose> 
            
            <!-- Publisher  -->
                
                <xsl:choose>
                    <xsl:when test="./marc:datafield[@tag='260' or '264']/marc:subfield[@code='b']">
                        <xsl:for-each select="./marc:datafield[@tag='260']/marc:subfield[@code='b']">
                            <xsl:choose>
                                <xsl:when test="position()=last()">
                                    <xsl:analyze-string select="." regex="(^.+)[,\.]$">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(1)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:analyze-string select="." regex="(^.+)[,\.]$">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(1)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                    <xsl:text>; </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        <xsl:for-each select="./marc:datafield[@tag='264']/marc:subfield[@code='b']">
                            <xsl:choose>
                                <xsl:when test="position()=last()">
                                    <xsl:analyze-string select="." regex="(^.+)[,\.]$">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(1)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:analyze-string select="." regex="(^.+)[,\.]$">
                                        <xsl:matching-substring>
                                            <xsl:value-of select="regex-group(1)"/>
                                        </xsl:matching-substring>
                                    </xsl:analyze-string>
                                    <xsl:text>; </xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                        <xsl:text>&#009;</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>&#009;</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            
            <!-- Publisher location -->
                
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='260' or '264']/marc:subfield[@code='a']">
                    <xsl:for-each select="./marc:datafield[@tag='260']/marc:subfield[@code='a']">
                        <xsl:choose>
                            <xsl:when test="position()=last()">
                                <xsl:analyze-string select="." regex="(^.+):$">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:analyze-string select="." regex="(^.+):$">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                                <xsl:text>; </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="./marc:datafield[@tag='264']/marc:subfield[@code='a']">
                        <xsl:choose>
                            <xsl:when test="position()=last()">
                                <xsl:analyze-string select="." regex="(^.+):$">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:analyze-string select="." regex="(^.+):$">
                                    <xsl:matching-substring>
                                        <xsl:value-of select="regex-group(1)"/>
                                    </xsl:matching-substring>
                                </xsl:analyze-string>
                                <xsl:text>; </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Edition statement -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='250']">
                    <xsl:analyze-string select="./marc:datafield[@tag='250']/marc:subfield[@code='a']" regex="(^.+)\.$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Date -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='264' and @ind2='1']/marc:subfield[@code='c']">
                    <xsl:analyze-string select="./marc:datafield[@tag='264']/marc:subfield[@code='c']" regex="(^.+)[\.\]]$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:when test="./marc:datafield[@tag='260']/marc:subfield[@code='c']">
                    <xsl:analyze-string select="./marc:datafield[@tag='260']/marc:subfield[@code='c']" regex="(^.+)[\.\]]$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(./marc:controlfield[@tag='008'], 8, 4)"/>
                    <xsl:if test="substring(./marc:controlfield[@tag='008'], 12, 4)!='    '">
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="substring(./marc:controlfield[@tag='008'], 12, 4)"/>
                    </xsl:if>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Copyright date -->

            <xsl:text>&#009;</xsl:text>

            <!-- Extent -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='300']">
                    <xsl:for-each select="./marc:datafield[@tag='300']/marc:subfield">
                        <xsl:choose>
                            <xsl:when test="position() = last()">
                                <xsl:choose>
                                    <xsl:when test="ends-with(.,'.')">
                                        <xsl:analyze-string select="." regex="(^.+)\.$">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                                <xsl:text> </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Library of Congress classification -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='050']">
                    <xsl:for-each select="./marc:datafield[@tag='050']/marc:subfield">
                        <xsl:choose>
                            <xsl:when test="position()=last()">
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                                <xsl:text> </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Print copy at Fordham -->

            <xsl:text>&#009;</xsl:text>

            <!-- Print copy in WorldCat -->
            
            <xsl:choose>
                <xsl:when test="./marc:controlfield[@tag='001']">
                    <xsl:variable name="oclcNumber">
                        <xsl:analyze-string select="./marc:controlfield[@tag='001']" regex="[a-z]{{3}}(\d{{1,}})">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <xsl:value-of select="concat('http://www.worldcat.org/oclc/', $oclcNumber)"/>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Table of contents -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='505']">
                    <xsl:choose>
                        <xsl:when test="./marc:datafield[@tag='505' and @ind2='0']">
                            <xsl:for-each select="./marc:datafield[@tag='505' and @ind2='0']/marc:subfield">
                                <xsl:choose>
                                    <xsl:when test="position()=last()">
                                        <xsl:analyze-string select="." regex="(^.+)\.$">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="."/>
                                        <xsl:text> </xsl:text>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:analyze-string select="./marc:datafield[@tag='505']/marc:subfield[@code='a']" regex="(^.+)\.$">
                                <xsl:matching-substring>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Bibliography and index -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='504']">
                    <xsl:analyze-string select="./marc:datafield[@tag='504']/marc:subfield[@code='a']" regex="(^.+)\.$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Identifier -->

            <xsl:text>&#009;</xsl:text>

            <!-- Digitization Equipment -->

            <xsl:text>&#009;</xsl:text>

            <!-- Digitization Technician -->

            <xsl:text>&#009;</xsl:text>

            <!-- Date digitized -->

            <xsl:text>&#009;</xsl:text>

            <!-- Language -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='546']">
                    <xsl:analyze-string select="./marc:datafield[@tag='546']/marc:subfield[@code='a']" regex="(^.+)\.$">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring(./marc:controlfield[@tag='008'], 36, 3)"/>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Related items (MARC 740, 765, 767, 775, 787) -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='740' or @tag='765' or @tag='767' or @tag='787']">
                    <xsl:for-each select="./marc:datafield[@tag='740' or @tag='765' or @tag='767' or @tag='787']">
                        <xsl:choose>
                            <xsl:when test="./@tag='740'">
                                <xsl:text>Related title: </xsl:text>
                                <xsl:for-each select="./marc:subfield">
                                    <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="./@tag='765'">
                                <xsl:text>Translation of: </xsl:text>
                                <xsl:for-each select="./marc:subfield">
                                    <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="./@tag='767'">
                                <xsl:text>Translation: </xsl:text>
                                <xsl:for-each select="./marc:subfield">
                                    <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="./@tag='787'">
                                <xsl:for-each select="./marc:subfield">
                                    <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Is version of (MARC 775) -->

            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='775']">
                    <xsl:for-each select="./marc:datafield[@tag='775']">
                        <xsl:for-each select="./marc:subfield">
                            <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                        </xsl:for-each>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
            <!-- Is part of (MARC 830, 773) -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='773' or @tag='830']">
                    <xsl:for-each select="./marc:datafield[@tag='773' or @tag='830']">
                        <xsl:choose>
                            <xsl:when test="./@tag='773'">
                                <xsl:for-each select=".">
                                    <xsl:text>Parent item: </xsl:text>
                                    <xsl:for-each select="./marc:subfield">
                                        <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="./@tag='830'">
                                <xsl:for-each select=".">
                                    <xsl:text>Series: </xsl:text>
                                    <xsl:for-each select="./marc:subfield">
                                        <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Has part (MARC 774) -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='774']">
                    <xsl:for-each select="./marc:datafield[@tag='774']">
                        <xsl:for-each select="./marc:subfield">
                            <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                        </xsl:for-each>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- Is referenced in (MARC 510) -->
            
            <xsl:choose>
                <xsl:when test="./marc:datafield[@tag='510']">
                    <xsl:for-each select="./marc:datafield[@tag='510']">
                        <xsl:for-each select="./marc:subfield">
                            <xsl:call-template name="remove_end_punctuation_76X-78X"/>
                        </xsl:for-each>
                        <xsl:if test="position()!=last()">
                            <xsl:text>; </xsl:text>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:text>&#009;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>&#009;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>

            <!-- References -->

            <xsl:text>&#009;</xsl:text>
        
            <!-- File name -->

            <xsl:text>&#009;</xsl:text>

            <!-- End of line -->
            
            <xsl:text>&#xA;</xsl:text>
            
        </xsl:for-each>
    </xsl:template>

            <!-- Re-usable templates -->

    <xsl:template name="creator_Person">
        <xsl:choose>
            <xsl:when test="./marc:datafield[@tag = '100']/marc:subfield[@code = 'e']">
                <xsl:for-each select="./marc:datafield[@tag = '100']/marc:subfield">
                    <xsl:call-template name="remove_end_punctuation_RDA"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="./marc:datafield[@tag = '100']/marc:subfield">
                    <xsl:call-template name="remove_end_punctuation_AACR2"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#009;</xsl:text>
    </xsl:template>

    <xsl:template name="creator_Organization">
        <xsl:choose>
            <xsl:when test="./marc:datafield[@tag = '110']/marc:subfield[@code = 'e']">
                <xsl:for-each select="./marc:datafield[@tag = '110']/marc:subfield">
                    <xsl:call-template name="remove_end_punctuation_RDA"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="./marc:datafield[@tag = '110']/marc:subfield">
                    <xsl:call-template name="remove_end_punctuation_AACR2"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>&#009;</xsl:text>
    </xsl:template>

    <xsl:template name="contributors">
        <xsl:choose>
            <xsl:when test="./marc:subfield[@code = 'e']">
                <xsl:for-each select="./marc:subfield">
                    <xsl:call-template name="remove_end_punctuation_RDA"/>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="./marc:subfield">
                    <xsl:call-template name="remove_end_punctuation_AACR2"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#009;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="subjects">
        <xsl:for-each select="./marc:subfield">
            <xsl:call-template name="remove_end_punctuation_6XX"/>
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#009;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="subjects_600_610">
        <xsl:for-each select="./marc:subfield">
            <xsl:choose>
                <xsl:when test="@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z'">
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <xsl:analyze-string select="." regex="(^.+)\.$">
                                <xsl:matching-substring>
                                    <xsl:text>--</xsl:text>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>--</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@code = 'a'">
                    <xsl:call-template name="remove_end_punctuation_AACR2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="position() = last()">
                            <xsl:analyze-string select="." regex="(^.+)\.$">
                                <xsl:matching-substring>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                        <xsl:when test="position() = 2">
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
        <xsl:choose>
            <xsl:when test="position() != last()">
                <xsl:text>; </xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>&#009;</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Following two templates reformat spacing and punctuation of complex fields (1XX, 6XX, 7XX) -->

    <xsl:template name="remove_end_punctuation_RDA">

        <xsl:choose>
            <xsl:when test="position() = last()">
                <xsl:analyze-string select="." regex="(^.+)\.$">
                    <xsl:matching-substring>
                        <xsl:text>--</xsl:text>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="position() = last() - 1">
                <xsl:analyze-string select="." regex="(^.+)[\.,:;]$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="remove_end_punctuation_AACR2">

        <xsl:choose>
            <xsl:when test="position() = last()">
                <xsl:analyze-string select="." regex="(^.+)[\.,:;]$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="remove_end_punctuation_6XX">

        <xsl:choose>
            <xsl:when test="position() = last()">
                <xsl:analyze-string select="." regex="(^.+)[\.,:;]$">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
                <xsl:text>--</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="remove_end_punctuation_76X-78X">
        <xsl:choose>
            <xsl:when test="position() = last()">
                <xsl:choose>
                    <xsl:when test="ends-with(., '.')">
                        <xsl:analyze-string select="." regex="(^.+)\.$">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Remove unwanted fields -->

    <xsl:template match="*"/>

</xsl:stylesheet>
