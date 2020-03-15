<?xml version="1.0" encoding="utf-8"?>

<!--
******************************************************************************************************************
        TSUBL Stylesheet	
        title= csv-xml-tag-mod
        publisher= "Tradeshift"
        creator= "IngKye Ng, Tradeshift"
        created= 2019-02-26
        modified= 2019-02-26
        issued= 2019-02-26
        
******************************************************************************************************************
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csv="http://xmlns.babelway.com/2007/message-format/csv" xmlns:functx="http://www.functx.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs csv functx">
  <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="yes"/>

  <xsl:function name="functx:header-extraction" as="xs:string?">
    <xsl:param name="headerList"/>
    <xsl:param name="pos"/>

    <xsl:value-of select="tokenize($headerList, ' ')[$pos]"/>

  </xsl:function>

  <!-- template to copy attributes -->
  <xsl:template match="@*">
    <xsl:attribute name="{local-name()}">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- template to copy elements -->
  <xsl:template match="*">
    <xsl:element name="{local-name()}">
      <xsl:apply-templates select="@* | node()"/>
    </xsl:element>
  </xsl:template>

  <!-- template to modify line elements tag -->
  <xsl:template match="csv:line">
    <xsl:variable name="headerName">
      <xsl:value-of select="../csv:headers/csv:header/text()/replace(., '[ /.]', '')"/>
    </xsl:variable>

    <line>
      <xsl:for-each select="csv:field">
        <xsl:element name="{functx:header-extraction($headerName,position())}">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </line>
  </xsl:template>

  <!-- template to remove headers tag -->
  <xsl:template match="csv:headers"/>

</xsl:stylesheet>
