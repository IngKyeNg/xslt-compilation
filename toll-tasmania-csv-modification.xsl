<?xml version="1.0" encoding="utf-8"?>

<!--
Author = ikng
Company = Tradeshift
Description = This is intended to remove the empty lines in the CSV file and standardized the columns-->
<xsl:stylesheet version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:csv="http://xmlns.babelway.com/2007/message-format/csv"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs csv" >
  <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
  
  <!--Identity template, provides default behavior that copies all content into the output -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!--Remove lines if no value found from the XML -->
  <xsl:template match="csv:line[csv:field[1]='']"/>
  <xsl:template match="csv:line[not(csv:field[1])]"/>
  
  <!--Standardized CSV columns to 36 (add column if not 36) -->
  <xsl:template match="csv:line">
    <xsl:choose>
      <xsl:when test="count(csv:field)=36">
        <xsl:copy>
          <xsl:apply-templates select="csv:field"/>
        </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy>
          <!--Copy the attributes -->
          <xsl:apply-templates select="@*"/> 
          
          <!-- Copy the 1-31 elements -->
          <xsl:apply-templates select="csv:field[1]"/>
          <xsl:apply-templates select="csv:field[2]"/>
          <xsl:apply-templates select="csv:field[3]"/>
          <xsl:apply-templates select="csv:field[4]"/>
          <xsl:apply-templates select="csv:field[5]"/>
          <xsl:apply-templates select="csv:field[6]"/>
          <xsl:apply-templates select="csv:field[7]"/>
          <xsl:apply-templates select="csv:field[8]"/>
          <xsl:apply-templates select="csv:field[9]"/>
          <xsl:apply-templates select="csv:field[10]"/>
          <xsl:apply-templates select="csv:field[11]"/>
          <xsl:apply-templates select="csv:field[12]"/>
          <xsl:apply-templates select="csv:field[13]"/>
          <xsl:apply-templates select="csv:field[14]"/>
          <xsl:apply-templates select="csv:field[15]"/>
          <xsl:apply-templates select="csv:field[16]"/>
          <xsl:apply-templates select="csv:field[17]"/>
          <xsl:apply-templates select="csv:field[18]"/>
          <xsl:apply-templates select="csv:field[19]"/>
          <xsl:apply-templates select="csv:field[20]"/>
          <xsl:apply-templates select="csv:field[21]"/>
          <xsl:apply-templates select="csv:field[22]"/>
          <xsl:apply-templates select="csv:field[23]"/>
          <xsl:apply-templates select="csv:field[24]"/>
          <xsl:apply-templates select="csv:field[25]"/>
          <xsl:apply-templates select="csv:field[26]"/>
          <xsl:apply-templates select="csv:field[27]"/>
          <xsl:apply-templates select="csv:field[28]"/>
          <xsl:apply-templates select="csv:field[29]"/>
          <xsl:apply-templates select="csv:field[30]"/>
          <xsl:apply-templates select="csv:field[31]"/>
          
          <!-- Insert extra field -->
          <xsl:element name="csv:field">0.00</xsl:element>
          
          <!-- Copy the 32-36 elements -->
          <xsl:apply-templates select="csv:field[32]"/>
          <xsl:apply-templates select="csv:field[33]"/>
          <xsl:apply-templates select="csv:field[34]"/>
          <xsl:apply-templates select="csv:field[35]"/>
          <xsl:apply-templates select="csv:field[36]"/>
        </xsl:copy>
      </xsl:otherwise>
      
    </xsl:choose>
    
  </xsl:template>
</xsl:stylesheet>
