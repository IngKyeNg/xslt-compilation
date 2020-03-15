<?xml version="1.0" encoding="utf-8"?>
<!-- 
Author     : ikng
Company    : Tradeshift
Team       : Supplier Integration Engineer
Description: This XSLT is to transform invoice to credit note if credit note flag is turn on
-->
<xsl:stylesheet version="2.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:bbw="java:com.babelway.messaging.transformation.xslt.function.BabelwayFunctions" 
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" 
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" exclude-result-prefixes="bbw">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>

    <!-- identity transform -->
    <xsl:template match="@*|node()">
        <xsl:copy copy-namespaces="no">
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>

    <!-- modified credit note transform -->
    <xsl:template match="/*">
        <xsl:choose>
            <xsl:when test="cbc:InvoiceTypeCode/text()='380' or  cbc:InvoiceTypeCode/text()='325' or cbc:InvoiceTypeCode/text()='386'">
                <xsl:element name="Invoice" namespace="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2">
                    <xsl:namespace name="cac">urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2</xsl:namespace>
                    <xsl:namespace name="cbc">urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2</xsl:namespace>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:element>
            </xsl:when>
            <xsl:when test="cbc:InvoiceTypeCode/text()='381'">
                <xsl:element name="CreditNote" namespace="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2">
                    <xsl:namespace name="cac">urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2</xsl:namespace>
                    <xsl:namespace name="cbc">urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2</xsl:namespace>
                    <xsl:apply-templates select="@* | node()" />
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="bbw:fail('Document Type Code Not Defined')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="cac:InvoiceLine">
        <xsl:choose>
            <xsl:when test="../cbc:InvoiceTypeCode/text()='380' or  ../cbc:InvoiceTypeCode/text()='325' or ../cbc:InvoiceTypeCode/text()='386'">
                <xsl:element name="cac:InvoiceLine">
                    <xsl:apply-templates select="@* | node()" />
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="cac:CreditNoteLine">
                    <xsl:apply-templates select="@* | node()" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/*[name()='Invoice' and not(cbc:InvoiceTypeCode/text()='380')]/cac:PaymentMeans"/>
    
    <xsl:template match="/*[name()='Invoice' and not(cbc:InvoiceTypeCode/text()='380')]/cac:PaymentTerms"/>
    
    <xsl:template match="/*[name()='Invoice' and not(cbc:InvoiceTypeCode/text()='380')]/cac:Delivery"/>
    
    <xsl:template match="/*[name()='Invoice' and not(cbc:InvoiceTypeCode/text()='380')]/cac:InvoiceLine/cac:AllowanceCharge"/>

    <xsl:template match="cac:InvoiceLine/cbc:InvoicedQuantity">
        <xsl:choose>
            <xsl:when test="../../cbc:InvoiceTypeCode/text()='380' or  ../../cbc:InvoiceTypeCode/text()='325' or ../../cbc:InvoiceTypeCode/text()='386'">
                <xsl:element name="cbc:InvoicedQuantity">
                    <xsl:apply-templates select="@* | node()" />
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="cbc:CreditedQuantity">
                    <xsl:apply-templates select="@* | node()" />
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="/*[not(cbc:InvoiceTypeCode/text()='380')]/cac:InvoiceLine/cac:OrderLineReference">
        <xsl:variable name="POLineID" select="cbc:LineID"/>
        <xsl:variable name="POID" select="cac:OrderReference/cbc:ID"/>
        
        <cac:DocumentReference>
            <cbc:ID>
                <xsl:value-of select="$POID"/>
            </cbc:ID>
            <cbc:DocumentTypeCode><xsl:attribute name="listID">urn:tradeshift.com:api:1.0:documenttypecode</xsl:attribute>Order ID</cbc:DocumentTypeCode>
        </cac:DocumentReference>
        
        <cac:DocumentReference>
            <cbc:ID>
                <xsl:value-of select="$POLineID"/>
            </cbc:ID>
            <cbc:DocumentTypeCode><xsl:attribute name="listID">urn:tradeshift.com:api:1.0:documenttypecode</xsl:attribute>Order Line ID</cbc:DocumentTypeCode>
        </cac:DocumentReference>
        
    </xsl:template>
</xsl:stylesheet>
