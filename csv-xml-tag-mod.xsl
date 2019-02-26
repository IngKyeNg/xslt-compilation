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

<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csv="http://xmlns.babelway.com/2007/message-format/csv"
  xmlns:functx="http://www.functx.com"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs csv functx" >
  <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
  
  <xsl:function name="functx:header-extraction" as="xs:string?">
    <xsl:param name="headerList"/>
    <xsl:param name="pos"/>
    
    <xsl:value-of select="tokenize($headerList, ' ')[$pos]"/>

  </xsl:function>
  
  <!--Identity template, provides default behavior that copies all content into the output -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!--Standardized CSV columns to 36 (add column if not 36) -->
  <xsl:template match="csv:line">
    <xsl:variable name="headerName">
      <xsl:value-of select="../csv:headers/csv:header"/>
    </xsl:variable>

    <xsl:copy>
      <!--Copy the attributes -->
      <xsl:apply-templates select="@*"/> 

      <xsl:for-each select="csv:field">
        <xsl:element name="{functx:header-extraction($headerName,position())}">
          <xsl:value-of select="."/>
        </xsl:element>
      </xsl:for-each>
    </xsl:copy>
    
  </xsl:template>
</xsl:stylesheet>
