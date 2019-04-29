<?xml version="1.0" encoding="UTF-8"?>

<!--
******************************************************************************************************************
		TSUBL Stylesheet
		title= bbw_X12-810-4010_2_TSUBL_INV_v01p01
		publisher= "Tradeshift"
		creator= "IngKye Ng, Tradeshift"
		created= 2019-04-09
		modified= 2019-04-10
		issued= 2019-04-09
******************************************************************************************************************
-->


<xsl:stylesheet version="2.0"
	xmlns:xsl  = "http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi  = "http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xs   = "http://www.w3.org/2001/XMLSchema"
	xmlns      = "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
	xmlns:cac  = "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc  = "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:metadata-util="java:com.babelway.messaging.transformation.xslt.function.MetadataUtil"
	xmlns:bbw="java:com.babelway.messaging.transformation.xslt.function.BabelwayFunctions"
	xmlns:bbwx="http://xmlns.babelway.com/com.babelway.messaging.transformation.xslt.function.BBWXContextFactory"
	exclude-result-prefixes="xs metadata-util bbw bbwx">
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*" />
	<xsl:param name="MSG"/>

    <xsl:template match="/">
		<xsl:apply-templates/>
    </xsl:template>

	<xsl:template match="*">
		<Error>
			<Errortext>Fatal error: Unsupported documenttype! This stylesheet only supports conversion of a X12 810.</Errortext>
			<Input><xsl:value-of select="."/></Input>
		</Error>
	</xsl:template>

	<xsl:template match="/X12">

		<!-- Parameters (please assign before using this stylesheet) -->

		<!-- End parameters -->
		
		<xsl:variable name="M810" select="MESSAGES/M810"/>

		<!-- Global Headerfields -->

		<xsl:variable name="UBLVersionID" select="'2.0'"/>

		<xsl:variable name="CustomizationID" select="'urn:tradeshift.com:ubl-2.0-customizations:2010-06'"/>

		<xsl:variable name="ProfileID" select="'urn:www.cenbii.eu:profile:bii04:ver1.0'"/>

		<xsl:variable name="ProfileID_schemeID" select="'CWA 16073:2010'"/>

		<xsl:variable name="ProfileID_schemeAgencyID" select="'CEN/ISSS WS/BII'"/>

		<xsl:variable name="DocID" select="$M810/BIG/BIG02"/>

		<xsl:variable name="DocDate" select="$M810/BIG/BIG01"/>

		<xsl:variable name="TaxDate" select="''"/>

		<xsl:variable name="Note" select="''"/>

		<xsl:variable name="InvoiceTypeCode" select="$M810/BIG/BIG07"/>

		<xsl:variable name="CurrencyCode" select="$M810/CUR/CUR02"/>

		<xsl:variable name="AccCost" select="$M810/REF[REF01 = '79']/REF02"/>

		<xsl:variable name="RefID" select="$M810/REF[REF01 = 'PO']/REF02"/>

		<xsl:variable name="RefDate" select="''"/>

		<xsl:variable name="InvoiceContractReferenceID" select="$M810/REF[REF01 = 'CT']/REF02"/>

		<xsl:variable name="InvoiceBOLReferenceID" select="$M810/REF[REF01 = 'BM']/REF02"/>

		<xsl:variable name="InvoiceFileReferenceID" select="$M810/REF[REF01 = 'CR']/REF02"/>
		
		<xsl:variable name="InvoiceVehicleNumber" select="$M810/REF[REF01 = 'VT']/REF02"/>


		<xsl:variable name="Se_id">
			<xsl:choose>
				<xsl:when test="$M810/SG10070/N1/N101 = 'SU'"><xsl:value-of select="'SU'"/></xsl:when>
				<xsl:when test="$M810/SG10070/N1/N101 = 'RI'"><xsl:value-of select="'RI'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="SeEndpointID" select="bbw:trim(ISA/ISA06)"/>

		<xsl:variable name="SeEndpointIDscheme" select="ISA/ISA05"/>

		<xsl:variable name="SePartySenderAssigned" select="$M810/SG10070[N1/N101 = $Se_id]/REF[REF01 = 'VR']/REF02"/>

		<xsl:variable name="SePartyGLN" select="''"/>

		<xsl:variable name="SePartyLEGAL" select="$M810/SG10070/N1[N101 = $Se_id and N103 = 'FI']/N104"/>

		<xsl:variable name="SePartyLEGALscheme" select="''"/>

		<xsl:variable name="SePartyTAX" select="$M810/SG10070/N1[N101 = $Se_id and N103 = 'TA']/N104"/>

		<xsl:variable name="SePartyTAXscheme" select="''"/>

		<xsl:variable name="SeName" select="$M810/SG10070/N1[N101 = $Se_id]/N102"/>

		<xsl:variable name="SeStreet1" select="$M810/SG10070[N1/N101 = $Se_id]/N3/N301"/>

		<xsl:variable name="SeStreet2" select="$M810/SG10070[N1/N101 = $Se_id]/N3/N302"/>

		<xsl:variable name="SeCity" select="$M810/SG10070[N1/N101 = $Se_id]/N4/N401"/>

		<xsl:variable name="SeZip" select="$M810/SG10070[N1/N101 = $Se_id]/N4/N403"/>

		<xsl:variable name="SeState" select="$M810/SG10070[N1/N101 = $Se_id]/N4/N402"/>

		<xsl:variable name="SeCountry" select="$M810/SG10070[N1/N101 = $Se_id]/N4/N404"/>

		<xsl:variable name="SeRef" select="''"/>

		<xsl:variable name="SeRefName" select="''"/>

		<xsl:variable name="SeRefTlf" select="''"/>

		<xsl:variable name="SeRefMail" select="''"/>


		<xsl:variable name="Ip_id">
			<xsl:choose>
				<xsl:when test="$M810/SG10070/N1/N101 = 'BY'"><xsl:value-of select="'BY'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="IpCustomerAssignedAccountID" select="$M810/REF[REF01 = '11']/REF02"/>

		<xsl:variable name="IpEndpointID" select="bbw:trim(ISA/ISA08)"/>

		<xsl:variable name="IpEndpointIDscheme" select="ISA/ISA07"/>

		<xsl:variable name="IpPartyTSGLI" select="$M810/SG10070[N1/N101 = $Ip_id]/REF[REF01 = '8N']/REF02"/>

		<xsl:variable name="IpPartySenderAssigned" select="$M810/SG10070[N1/N101 = $Ip_id]/REF[REF01 = 'VR']/REF02"/>

		<xsl:variable name="IpPartyTSLEID" select="$M810/SG10070[N1/N101 = $Ip_id]/REF[REF01 = '23']/REF02"/>

		<xsl:variable name="IpPartyGLN" select="''"/>

		<xsl:variable name="IpPartyLEGAL" select="$M810/SG10070/N1[N101 = $Ip_id and N103 = 'FI']/N104"/>

		<xsl:variable name="IpPartyLEGALscheme" select="''"/>

		<xsl:variable name="IpPartyTAX" select="$M810/SG10070/N1[N101 = $Ip_id and N103 = 'TA']/N104"/>

		<xsl:variable name="IpPartyTAXscheme" select="''"/>

		<xsl:variable name="IpName" select="$M810/SG10070/N1[N101 = $Ip_id]/N102"/>

		<xsl:variable name="IpStreet1" select="$M810/SG10070[N1/N101 = $Ip_id]/N3/N301"/>

		<xsl:variable name="IpStreet2" select="$M810/SG10070[N1/N101 = $Ip_id]/N3/N302"/>

		<xsl:variable name="IpCity" select="$M810/SG10070[N1/N101 = $Ip_id]/N4/N401"/>

		<xsl:variable name="IpZip" select="$M810/SG10070[N1/N101 = $Ip_id]/N4/N403"/>

		<xsl:variable name="IpState" select="$M810/SG10070[N1/N101 = $Ip_id]/N4/N402"/>

		<xsl:variable name="IpCountry" select="$M810/SG10070[N1/N101 = $Ip_id]/N4/N404"/>

		<xsl:variable name="IpRef" select="$M810/REF[REF01 = 'IT']/REF02"/>

		<xsl:variable name="IpRefName" select="''"/>

		<xsl:variable name="IpRefTlf" select="''"/>

		<xsl:variable name="IpRefMail" select="''"/>


		<xsl:variable name="Del_id">
			<xsl:choose>
				<xsl:when test="$M810/SG10070/N1/N101 = 'ST'"><xsl:value-of select="'ST'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="DelDate" select="$M810/DTM[DTM01='011']/DTM02"/>

		<xsl:variable name="DelIDtype" select="'GLN'"/>

		<xsl:variable name="DelID" select="''"/>

		<xsl:variable name="DelName" select="$M810/SG10070/N1[N101 = $Del_id]/N102"/>

		<xsl:variable name="DelDescription" select="$M810/SG10070[N1/N101 = $Del_id]/N2/N201"/>

		<xsl:variable name="DelStreet1" select="$M810/SG10070[N1/N101 = $Del_id]/N3/N301"/>

		<xsl:variable name="DelStreet2" select="$M810/SG10070[N1/N101 = $Del_id]/N3/N302"/>

		<xsl:variable name="DelCity" select="$M810/SG10070[N1/N101 = $Del_id]/N4/N401"/>

		<xsl:variable name="DelZip" select="$M810/SG10070[N1/N101 = $Del_id]/N4/N403"/>

		<xsl:variable name="DelState" select="$M810/SG10070[N1/N101 = $Del_id]/N4/N402"/>

		<xsl:variable name="DelCountry" select="$M810/SG10070[N1/N101 = $Del_id]/N4/N404"/>


		<xsl:variable name="PayType" select="''"/>

		<xsl:variable name="PayDate" select="$M810/ITD/ITD06"/>

		<xsl:variable name="Kontonr" select="''"/>

		<xsl:variable name="PayNote" select="''"/>

		<xsl:variable name="Regnr" select="''"/>

		<xsl:variable name="BetalingsID" select="''"/>

		<xsl:variable name="Kreditornr" select="''"/>

		<xsl:variable name="PayTerms" select="''"/>


		<xsl:variable name="AllowanceAmount" select="string(sum($M810/SAC[SAC01 = 'A']/SAC05) div 100)"/>

		<xsl:variable name="AllowanceReason" select="''"/>

		<xsl:variable name="ChargeAmount" select="string(sum($M810/SAC[SAC01 = 'C']/SAC05) div 100)"/>

		<xsl:variable name="ChargeReason" select="''"/>

		<xsl:variable name="ChargeVatCat" select="''"/>


		<xsl:variable name="TaxRate" select="$M810/TXI/TXI03"/>

		<xsl:variable name="TaxRateCode" select="$M810/TXI/TXI06"/>

		<xsl:variable name="TaxExemptReason" select="$M810/TXI/TXI10"/>

		<xsl:variable name="TaxSchemeID" select="$M810/TXI/TXI01"/>

		<xsl:variable name="TaxSchemeName" select="$M810/TXI/TXI01"/>

		<xsl:variable name="TaxAmount" select="$M810/AMT[AMT01 = '3']/AMT02"/>

		<xsl:variable name="TaxableAmount" select="$M810/AMT[AMT01 = '2']/AMT02"/>

		<xsl:variable name="LineTotal" select="$M810/AMT[AMT01 = '1']/AMT02"/>

		<xsl:variable name="InvTotal" select="string($M810/TDS/TDS01 div 100)"/>


		<!-- Global conversions etc. -->

		<xsl:variable name="fIpAddressFlag">
			<xsl:choose>
				<xsl:when test="string($IpStreet1) or string($IpStreet2) or string($IpCity) or string($IpZip) or string($IpCountry)"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSeAddressFlag">
			<xsl:choose>
				<xsl:when test="string($SeStreet1) or string($SeStreet2) or string($SeCity) or string($SeZip) or string($SeCountry)"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fPaymentFlag">
			<xsl:choose>
				<xsl:when test="string($PayType) or string($PayDate)"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fInvoiceTypeCode">
			<xsl:choose>
				<xsl:when test="$InvoiceTypeCode = 'VJ'"><xsl:value-of select="'380'"/></xsl:when>
				<xsl:when test="$InvoiceTypeCode = 'PP'"><xsl:value-of select="'386'"/></xsl:when>
				<xsl:when test="$InvoiceTypeCode = 'P1'"><xsl:value-of select="'325'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'380'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h4" select="format-number(number(translate($LineTotal,',', '.')),'##.00')"/>
		<xsl:variable name="fLineTotal">
			<xsl:choose>
				<xsl:when test="$h4 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h4"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h2" select="format-number(number(translate($TaxAmount,',', '.')),'#0.00')"/>
		<xsl:variable name="fTaxAmount">
			<xsl:choose>
				<xsl:when test="$h2 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h2"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h1" select="format-number(number(translate($TaxableAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxableAmount">
			<xsl:choose>
				<xsl:when test="$h1 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h1"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxRate">
			<xsl:choose>
				<xsl:when test="string($TaxRate)"><xsl:value-of select="$TaxRate"/></xsl:when>
				<xsl:when test="$fTaxAmount = 0 or $fTaxableAmount = 0">00</xsl:when>
				<xsl:otherwise><xsl:value-of select="format-number(($fTaxAmount div $fTaxableAmount) * 100,'##')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="noTaxPercent">
			<xsl:choose>
				<xsl:when test="string($TaxRate)">false</xsl:when>
				<xsl:when test="$fTaxAmount = 0 or $fTaxableAmount = 0">false</xsl:when>
				<xsl:when test="Sum/TXI and not(string($TaxRate))">true</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxSchemeID">
			<xsl:call-template name="TaxSchemeIDLocal">
				<xsl:with-param name="p1" select="$TaxSchemeID"/>
			</xsl:call-template>								
		</xsl:variable>

		<xsl:variable name="fTaxSchemeName">
			<xsl:call-template name="TaxSchemeName">
				<xsl:with-param name="p1" select="$TaxSchemeName"/>
			</xsl:call-template>								
		</xsl:variable>

		<xsl:variable name="h3" select="format-number(number(translate($InvTotal,',', '.')),'##.00')"/>
		<xsl:variable name="fInvTotal">
			<xsl:choose>
				<xsl:when test="$h3 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h3"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h8" select="format-number(number(translate($AllowanceAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fAllowanceAmount">
			<xsl:choose>
				<xsl:when test="$h8 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h8"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h9" select="format-number(number(translate($ChargeAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fChargeAmount">
			<xsl:choose>
				<xsl:when test="$h9 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h9"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSeEndpointIDscheme">
			<xsl:choose>
				<xsl:when test="$SeEndpointIDscheme = '01'"><xsl:value-of select="'DUNS'"/></xsl:when>
				<xsl:when test="$SeEndpointIDscheme = '02'"><xsl:value-of select="'SCAC'"/></xsl:when>
				<xsl:when test="$SeEndpointIDscheme = '12'"><xsl:value-of select="'PHONE'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'ZZ'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpEndpointIDscheme">
			<xsl:choose>
				<xsl:when test="$IpEndpointIDscheme = '01'"><xsl:value-of select="'DUNS'"/></xsl:when>
				<xsl:when test="$IpEndpointIDscheme = '02'"><xsl:value-of select="'SCAC'"/></xsl:when>
				<xsl:when test="$IpEndpointIDscheme = '12'"><xsl:value-of select="'PHONE'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'ZZ'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSePartyTAXscheme">
			<xsl:choose>
				<xsl:when test="string($SePartyTAXscheme)">
					<xsl:value-of select="$SePartyTAXscheme"/>
				</xsl:when>
				<xsl:when test="$SeCountry = 'MY' and (string-length($SePartyTAX) = 12 or string-length($SePartyTAX) = 16)">
					<xsl:value-of select="'MY:GST'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(bbw:lookupTableValue('PartyTAXscheme', 'CountryCode', 'PartyTAXscheme', $SeCountry, 'TS:VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>								
		</xsl:variable>

		<xsl:variable name="SeP1">
			<xsl:choose>
				<xsl:when test="$SeCountry = 'US' and string-length($SePartyLEGAL) = 11"><xsl:value-of select="'US:SSN'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$SePartyLEGALscheme"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fSePartyLEGALscheme">
			<xsl:choose>
				<xsl:when test="string($SePartyLEGALscheme)">
					<xsl:value-of select="$SePartyLEGALscheme"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(bbw:lookupTableValue('PartyLEGALscheme', 'CountryCode', 'PartyLEGALscheme', $SeCountry, 'VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>								
		</xsl:variable>

		<xsl:variable name="fIpPartyTAXscheme">
			<xsl:choose>
				<xsl:when test="string($IpPartyTAXscheme)">
					<xsl:value-of select="$IpPartyTAXscheme"/>
				</xsl:when>
				<xsl:when test="$IpCountry = 'MY' and (string-length($IpPartyTAX) = 12 or string-length($IpPartyTAX) = 16)">
					<xsl:value-of select="'MY:GST'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(bbw:lookupTableValue('PartyTAXscheme', 'CountryCode', 'PartyTAXscheme', $IpCountry, 'TS:VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="IpP1">
			<xsl:choose>
				<xsl:when test="$IpCountry = 'US' and string-length($IpPartyLEGAL) = 11"><xsl:value-of select="'US:SSN'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$IpPartyLEGALscheme"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fIpPartyLEGALscheme">
			<xsl:choose>
				<xsl:when test="string($IpPartyLEGALscheme)">
					<xsl:value-of select="$IpPartyLEGALscheme"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="(bbw:lookupTableValue('PartyLEGALscheme', 'CountryCode', 'PartyLEGALscheme', $IpCountry, 'VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h15" select="$DocDate"/>
		<xsl:variable name="fDocDate">
			<xsl:choose>
				<xsl:when test="string-length($h15) = 10"><xsl:value-of select="$h15"/></xsl:when>
				<xsl:when test="string-length($h15) = 8"><xsl:value-of select="concat(substring($h15, 1, 4), '-', substring($h15, 5, 2), '-', substring($h15, 7, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h15"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h16" select="$RefDate"/>
		<xsl:variable name="fRefDate">
			<xsl:choose>
				<xsl:when test="string-length($h16) = 10"><xsl:value-of select="$h16"/></xsl:when>
				<xsl:when test="string-length($h16) = 8"><xsl:value-of select="concat(substring($h16, 1, 4), '-', substring($h16, 5, 2), '-', substring($h16, 7, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h16"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h17" select="$DelDate"/>
		<xsl:variable name="fDelDate">
			<xsl:choose>
				<xsl:when test="string-length($h17) = 10"><xsl:value-of select="$h17"/></xsl:when>
				<xsl:when test="string-length($h17) = 8"><xsl:value-of select="concat(substring($h17, 1, 4), '-', substring($h17, 5, 2), '-', substring($h17, 7, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h17"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h18" select="$PayDate"/>
		<xsl:variable name="fPayDate">
			<xsl:choose>
				<xsl:when test="string-length($h18) = 10"><xsl:value-of select="$h18"/></xsl:when>
				<xsl:when test="string-length($h18) = 8"><xsl:value-of select="concat(substring($h18, 1, 4), '-', substring($h18, 5, 2), '-', substring($h18, 7, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h18"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h19" select="$TaxDate"/>
		<xsl:variable name="fTaxDate">
			<xsl:choose>
				<xsl:when test="string-length($h19) = 10"><xsl:value-of select="$h19"/></xsl:when>
				<xsl:when test="string-length($h19) = 8"><xsl:value-of select="concat(substring($h19, 1, 4), '-', substring($h19, 5, 2), '-', substring($h19, 7, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h19"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:if test="$MSG">
			<xsl:value-of select="metadata-util:put($MSG, 'com_babelway_messaging_context_message_reference', string(concat('INV', $DocID, '_', $SeCountry)))"/>
		</xsl:if>

		<!-- Start of Invoice -->
		<Invoice>
			<xsl:attribute name="xsi:schemaLocation">urn:oasis:names:specification:ubl:schema:xsd:Invoice-2 UBL-Invoice-2.0.xsd</xsl:attribute>

			<cbc:UBLVersionID><xsl:value-of select="$UBLVersionID"/></cbc:UBLVersionID>

			<cbc:CustomizationID><xsl:value-of select="$CustomizationID"/></cbc:CustomizationID>

			<cbc:ProfileID schemeAgencyID="{$ProfileID_schemeAgencyID}" schemeID="{$ProfileID_schemeID}"><xsl:value-of select="$ProfileID"/></cbc:ProfileID>

			<cbc:ID><xsl:value-of select="$DocID"/></cbc:ID>

			<cbc:IssueDate><xsl:value-of select="$fDocDate"/></cbc:IssueDate>

			<cbc:InvoiceTypeCode listAgencyID="6" listID="UN/ECE 1001 Subset"><xsl:value-of select="$fInvoiceTypeCode"/></cbc:InvoiceTypeCode>

			<xsl:choose>
				<xsl:when test="$M810/MSG[string(.)]">
					<xsl:for-each select="$M810/MSG[string(.)]">
						<cbc:Note><xsl:value-of select="./MSG01"/></cbc:Note>
					</xsl:for-each>
				</xsl:when>
				<xsl:when test="$M810/NTE[string(.)]">
					<xsl:for-each select="$M810/NTE[string(.)]">
						<cbc:Note><xsl:value-of select="./NTE02"/></cbc:Note>
					</xsl:for-each>
				</xsl:when>
			</xsl:choose>

			<xsl:if test="string($TaxDate)"><cbc:TaxPointDate><xsl:value-of select="$fTaxDate"/></cbc:TaxPointDate></xsl:if>

			<cbc:DocumentCurrencyCode><xsl:value-of select="$CurrencyCode"/></cbc:DocumentCurrencyCode>

			<xsl:if test="string($AccCost)"><cbc:AccountingCost><xsl:value-of select="$AccCost"/></cbc:AccountingCost></xsl:if>

			<xsl:if test="string($RefID)">
				<cac:OrderReference>
					<cbc:ID><xsl:value-of select="$RefID"/></cbc:ID>
					<xsl:if test="string($fRefDate)"><cbc:IssueDate><xsl:value-of select="$fRefDate"/></cbc:IssueDate></xsl:if>
				</cac:OrderReference>
			</xsl:if>

			<xsl:if test="string($InvoiceContractReferenceID)">
				<cac:ContractDocumentReference>
					<cbc:ID><xsl:value-of select="$InvoiceContractReferenceID"/></cbc:ID>
				</cac:ContractDocumentReference>
			</xsl:if>

			<xsl:if test="string($InvoiceFileReferenceID)">
				<cac:AdditionalDocumentReference>
					<cbc:ID><xsl:value-of select="$InvoiceFileReferenceID"/></cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">File ID</cbc:DocumentTypeCode>
				</cac:AdditionalDocumentReference>
			</xsl:if>

			<xsl:if test="string($InvoiceBOLReferenceID)">
				<cac:AdditionalDocumentReference>
					<cbc:ID><xsl:value-of select="$InvoiceBOLReferenceID"/></cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">BOL ID</cbc:DocumentTypeCode>
				</cac:AdditionalDocumentReference>
			</xsl:if>
			
			<xsl:if test="string($InvoiceVehicleNumber)">
				<cac:AdditionalDocumentReference>
					<cbc:ID><xsl:value-of select="$InvoiceVehicleNumber"/></cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">VN ID</cbc:DocumentTypeCode>
				</cac:AdditionalDocumentReference>
			</xsl:if>
			
			<xsl:if test="bbw:metadata('inFile') != ''">
				<cac:AdditionalDocumentReference>
					<cbc:ID>1</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">sourcedocument</cbc:DocumentTypeCode>
					<cac:Attachment>
						<cbc:EmbeddedDocumentBinaryObject encodingCode="Base64" filename="sourcedocument" mimeCode="application/EDI-X12">
							<xsl:value-of select="bbw:metadataBase64('inFile')" disable-output-escaping="no"/>
						</cbc:EmbeddedDocumentBinaryObject>
					</cac:Attachment>
				</cac:AdditionalDocumentReference>
			</xsl:if>
			
			<xsl:if test="bbw:metadata('attachment') != ''">
				<cac:AdditionalDocumentReference>
					<cbc:ID>1</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">attachment</cbc:DocumentTypeCode>
					<cac:Attachment>
						<cbc:EmbeddedDocumentBinaryObject encodingCode="Base64" filename="sourcedocument" mimeCode="bbw:metadata('mimeCode')">
							<xsl:value-of select="bbw:metadataBase64('attachment')" disable-output-escaping="no"/>
						</cbc:EmbeddedDocumentBinaryObject>
					</cac:Attachment>
				</cac:AdditionalDocumentReference>
			</xsl:if>

			<cac:AccountingSupplierParty>
				<cac:Party>
					<xsl:if test="string($SeEndpointID)">
						<cbc:EndpointID schemeID="{$fSeEndpointIDscheme}"><xsl:value-of select="$SeEndpointID"/></cbc:EndpointID>
					</xsl:if>
					<xsl:if test="string($SePartySenderAssigned)">
						<cac:PartyIdentification>
  							<cbc:ID schemeID="SenderAssigned"><xsl:value-of select="$SePartySenderAssigned"/></cbc:ID>
  						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartyGLN)">
						<cac:PartyIdentification>
							<cbc:ID schemeAgencyID="9" schemeID="GLN"><xsl:value-of select="$SePartyGLN"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartyTAX)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fSePartyTAXscheme}"><xsl:value-of select="$SePartyTAX"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartyLEGAL)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fSePartyLEGALscheme}"><xsl:value-of select="$SePartyLEGAL"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<cac:PartyName>
						<cbc:Name><xsl:value-of select="$SeName"/></cbc:Name>
					</cac:PartyName>
					<xsl:if test="$fSeAddressFlag = 'true'">
						<cac:PostalAddress>
							<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
							<cbc:StreetName><xsl:value-of select="$SeStreet1"/></cbc:StreetName>
							<xsl:if test="string($SeStreet2)"><cbc:AdditionalStreetName><xsl:value-of select="$SeStreet2"/></cbc:AdditionalStreetName></xsl:if>
							<xsl:if test="string($SeCity)"><cbc:CityName><xsl:value-of select="$SeCity"/></cbc:CityName></xsl:if>
							<xsl:if test="string($SeZip)"><cbc:PostalZone><xsl:value-of select="$SeZip"/></cbc:PostalZone></xsl:if>
							<xsl:if test="string($SeState)"><cbc:CountrySubentity><xsl:value-of select="$SeState"/></cbc:CountrySubentity></xsl:if>
							<xsl:if test="string($SeCountry)">
								<cac:Country>
									<cbc:IdentificationCode><xsl:value-of select="$SeCountry"/></cbc:IdentificationCode>
								</cac:Country>
							</xsl:if>
						</cac:PostalAddress>
					</xsl:if>
					<xsl:if test="string($SePartyTAX)">
						<cac:PartyTaxScheme>
							<cbc:CompanyID schemeID="{$fSePartyTAXscheme}"><xsl:value-of select="$SePartyTAX"/></cbc:CompanyID>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
								<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
					</xsl:if>
					<xsl:if test="string($SePartyLEGAL)">
						<cac:PartyLegalEntity>
							<cbc:RegistrationName><xsl:value-of select="$SeName"/></cbc:RegistrationName>
							<cbc:CompanyID schemeID="{$fSePartyLEGALscheme}"><xsl:value-of select="$SePartyLEGAL"/></cbc:CompanyID>
						</cac:PartyLegalEntity>
					</xsl:if>
					<xsl:if test="string($SeRef) or string($SeRefName) or string($SeRefTlf) or string($SeRefMail)">
						<cac:Contact>
							<xsl:if test="string($SeRef)"><cbc:ID><xsl:value-of select="$SeRef"/></cbc:ID></xsl:if>
							<xsl:if test="string($SeRefName)"><cbc:Name><xsl:value-of select="$SeRefName"/></cbc:Name></xsl:if>
							<xsl:if test="string($SeRefTlf)"><cbc:Telephone><xsl:value-of select="$SeRefTlf"/></cbc:Telephone></xsl:if>
							<xsl:if test="string($SeRefMail)"><cbc:ElectronicMail><xsl:value-of select="$SeRefMail"/></cbc:ElectronicMail></xsl:if>
						</cac:Contact>
					</xsl:if>
				</cac:Party>
			</cac:AccountingSupplierParty>

			<cac:AccountingCustomerParty>
				<xsl:if test="string($IpCustomerAssignedAccountID)"><cbc:CustomerAssignedAccountID><xsl:value-of select="$IpCustomerAssignedAccountID"/></cbc:CustomerAssignedAccountID></xsl:if>
				<cac:Party>
					<xsl:if test="string($IpEndpointID)">
						<cbc:EndpointID schemeID="{$fIpEndpointIDscheme}"><xsl:value-of select="$IpEndpointID"/></cbc:EndpointID>
					</xsl:if>
					<xsl:if test="string($IpPartySenderAssigned)">
						<xsl:variable name="SAtag1" select="substring-before($IpPartySenderAssigned, '$')"/>
						<xsl:variable name="h22" select="substring-after($IpPartySenderAssigned, '$')"/>
						<xsl:variable name="SAtag2" select="substring-before($h22, '$')"/>
						<xsl:variable name="h23" select="substring-after($h22, '$')"/>
						<xsl:variable name="SAtag3">
							<xsl:choose>
								<xsl:when test="contains($h23, '$')"><xsl:value-of select="substring-before($h23, '$')"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$h23"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="h24" select="substring-after($h23, '$')"/>
						<xsl:variable name="SAtag4" select="substring-before($h24, '$')"/>
						<xsl:variable name="SAtag5" select="substring-after($h24, '$')"/>
						<xsl:variable name="SAtype">
							<xsl:choose>
								<xsl:when test="string($SAtag4) and string($SAtag5)"><xsl:value-of select="'4'"/></xsl:when>
								<xsl:when test="string($SAtag3) and string($SAtag1)"><xsl:value-of select="'3'"/></xsl:when>
								<xsl:when test="string($SAtag3)"><xsl:value-of select="'2'"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="'1'"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
								<xsl:when test="$SAtype = '1'">
									<cac:PartyIdentification>
  										<cbc:ID schemeID="SenderAssigned"><xsl:value-of select="$IpPartySenderAssigned"/></cbc:ID>
  									</cac:PartyIdentification>
								</xsl:when>
								<xsl:when test="$SAtype = '2'">
									<cac:PartyIdentification>
  										<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag2}"><xsl:value-of select="$SAtag3"/></cbc:ID>
  									</cac:PartyIdentification>
								</xsl:when>
								<xsl:when test="$SAtype = '3'">
									<cac:PartyIdentification>
  										<cbc:ID schemeID="SenderAssigned"><xsl:value-of select="$SAtag1"/></cbc:ID>
  									</cac:PartyIdentification>
									<cac:PartyIdentification>
  										<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag2}"><xsl:value-of select="$SAtag3"/></cbc:ID>
  									</cac:PartyIdentification>
								</xsl:when>
								<xsl:when test="$SAtype = '4'">
									<cac:PartyIdentification>
  										<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag2}"><xsl:value-of select="$SAtag3"/></cbc:ID>
  									</cac:PartyIdentification>
									<cac:PartyIdentification>
  										<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag4}"><xsl:value-of select="$SAtag5"/></cbc:ID>
  									</cac:PartyIdentification>
								</xsl:when>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="string($IpPartyTSGLI)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="TS:GLI"><xsl:value-of select="$IpPartyTSGLI"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartyTSLEID)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="TS:LEID">
								<xsl:value-of select="$IpPartyTSLEID"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartyGLN)">
						<cac:PartyIdentification>
							<cbc:ID schemeAgencyID="9" schemeID="GLN"><xsl:value-of select="$IpPartyGLN"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartyTAX)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fIpPartyTAXscheme}"><xsl:value-of select="$IpPartyTAX"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartyLEGAL)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fIpPartyLEGALscheme}"><xsl:value-of select="$IpPartyLEGAL"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<cac:PartyName>
						<cbc:Name><xsl:value-of select="$IpName"/></cbc:Name>
					</cac:PartyName>
					<xsl:if test="$fIpAddressFlag = 'true'">
						<cac:PostalAddress>
							<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
							<cbc:StreetName><xsl:value-of select="$IpStreet1"/></cbc:StreetName>
							<xsl:if test="string($IpStreet2)"><cbc:AdditionalStreetName><xsl:value-of select="$IpStreet2"/></cbc:AdditionalStreetName></xsl:if>
							<xsl:if test="string($IpCity)"><cbc:CityName><xsl:value-of select="$IpCity"/></cbc:CityName></xsl:if>
							<xsl:if test="string($IpZip)"><cbc:PostalZone><xsl:value-of select="$IpZip"/></cbc:PostalZone></xsl:if>
							<xsl:if test="string($IpState)"><cbc:CountrySubentity><xsl:value-of select="$IpState"/></cbc:CountrySubentity></xsl:if>
							<xsl:if test="string($IpCountry)">
								<cac:Country>
									<cbc:IdentificationCode><xsl:value-of select="$IpCountry"/></cbc:IdentificationCode>
								</cac:Country>
							</xsl:if>
						</cac:PostalAddress>
					</xsl:if>
					<xsl:if test="string($IpPartyTAX)">
						<cac:PartyTaxScheme>
							<cbc:CompanyID schemeID="{$fIpPartyTAXscheme}"><xsl:value-of select="$IpPartyTAX"/></cbc:CompanyID>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
								<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
					</xsl:if>
					<xsl:if test="string($IpPartyLEGAL)">
						<cac:PartyLegalEntity>
							<cbc:RegistrationName><xsl:value-of select="$IpName"/></cbc:RegistrationName>
							<cbc:CompanyID schemeID="{$fIpPartyLEGALscheme}"><xsl:value-of select="$IpPartyLEGAL"/></cbc:CompanyID>
						</cac:PartyLegalEntity>
					</xsl:if>
					<xsl:if test="string($IpRef) or string($IpRefName) or string($IpRefTlf) or string($IpRefMail)">
						<cac:Contact>
							<xsl:if test="string($IpRef)"><cbc:ID><xsl:value-of select="$IpRef"/></cbc:ID></xsl:if>
							<xsl:if test="string($IpRefName)"><cbc:Name><xsl:value-of select="$IpRefName"/></cbc:Name></xsl:if>
							<xsl:if test="string($IpRefTlf)"><cbc:Telephone><xsl:value-of select="$IpRefTlf"/></cbc:Telephone></xsl:if>
							<xsl:if test="string($IpRefMail)"><cbc:ElectronicMail><xsl:value-of select="$IpRefMail"/></cbc:ElectronicMail></xsl:if>
						</cac:Contact>
					</xsl:if>
				</cac:Party>
			</cac:AccountingCustomerParty>

			<xsl:if test="string($DelStreet1) or string($DelID) or string($fDelDate)">
				<cac:Delivery>
					<xsl:if test="string($fDelDate)"><cbc:ActualDeliveryDate><xsl:value-of select="$fDelDate"/></cbc:ActualDeliveryDate></xsl:if>
					<xsl:if test="string($DelStreet1) or string($DelID) or string($DelDescription)">
						<cac:DeliveryLocation>
							<xsl:if test="string($DelID)">
								<cbc:ID schemeAgencyID="9" schemeID="GLN"><xsl:value-of select="$DelID"/></cbc:ID>
							</xsl:if>
							<xsl:if test="string($DelDescription)">
								<cbc:Description><xsl:value-of select="$DelDescription"/></cbc:Description>
							</xsl:if>
							<xsl:if test="string($DelStreet1)">
								<cac:Address>
									<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
									<cbc:StreetName><xsl:value-of select="$DelStreet1"/></cbc:StreetName>
									<xsl:if test="string($DelStreet2)"><cbc:AdditionalStreetName><xsl:value-of select="$DelStreet2"/></cbc:AdditionalStreetName></xsl:if>
									<xsl:if test="string($DelName)"><cbc:MarkAttention><xsl:value-of select="$DelName"/></cbc:MarkAttention></xsl:if>
									<cbc:CityName><xsl:value-of select="$DelCity"/></cbc:CityName>
									<cbc:PostalZone><xsl:value-of select="$DelZip"/></cbc:PostalZone>
									<xsl:if test="string($DelState)"><cbc:CountrySubentity><xsl:value-of select="$DelState"/></cbc:CountrySubentity></xsl:if>
									<cac:Country>
										<cbc:IdentificationCode><xsl:value-of select="$DelCountry"/></cbc:IdentificationCode>
									</cac:Country>
								</cac:Address>
							</xsl:if>
						</cac:DeliveryLocation>
					</xsl:if>
				</cac:Delivery>
			</xsl:if>

			<xsl:if test="$fPaymentFlag = 'true'">
				<cac:PaymentMeans>
					<cbc:ID>1</cbc:ID>
					<xsl:choose>
						<xsl:when test="$PayType = 'Konto'">
							<cbc:PaymentMeansCode>42</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)">
								<cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate>
							</xsl:if>
							<cbc:PaymentChannelCode listAgencyID="320" listID="urn:oioubl:codelist:paymentchannelcode-1.1">DK:BANK</cbc:PaymentChannelCode>
							<cac:PayeeFinancialAccount>
								<cbc:ID><xsl:value-of select="$Kontonr"/></cbc:ID>
								<xsl:if test="string($PayNote)"><cbc:PaymentNote><xsl:value-of select="$PayNote"/></cbc:PaymentNote></xsl:if>
								<cac:FinancialInstitutionBranch>
									<cbc:ID><xsl:value-of select="$Regnr"/></cbc:ID>
								</cac:FinancialInstitutionBranch>
							</cac:PayeeFinancialAccount>
						</xsl:when>

						<xsl:when test="$PayType = 'FIK71'">
							<cbc:PaymentMeansCode>93</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)">
								<cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate>
							</xsl:if>
							<cbc:PaymentChannelCode listAgencyID="320" listID="urn:oioubl:codelist:paymentchannelcode-1.1">DK:FIK</cbc:PaymentChannelCode>
							<cbc:InstructionID><xsl:value-of select="$BetalingsID"/></cbc:InstructionID>
							<cbc:PaymentID schemeAgencyID="320" schemeID="urn:oioubl:id:paymentid-1.1">71</cbc:PaymentID>
							<cac:CreditAccount>
								<cbc:AccountID><xsl:value-of select="$Kreditornr"/></cbc:AccountID>
							</cac:CreditAccount>
						</xsl:when>

						<xsl:otherwise>
							<cbc:PaymentMeansCode>1</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</cac:PaymentMeans>
			</xsl:if>

			<xsl:if test="$M810/ITD">
				<xsl:for-each select="$M810/ITD">

					<xsl:variable name="PayTermNote" select="./ITD12"/>

					<xsl:variable name="SettlementDiscountPercent" select="./ITD03"/>

					<xsl:variable name="PenaltySurchargePercent" select="./ITD15"/>

					<cac:PaymentTerms>
						<cbc:ID><xsl:value-of select="position()"/></cbc:ID>
						<cbc:PaymentMeansID>1</cbc:PaymentMeansID>
						<xsl:if test="string($PayTermNote)">
							<cbc:Note>
								<xsl:value-of select="$PayTermNote"/>
							</cbc:Note>
						</xsl:if>
						<xsl:if test="string($SettlementDiscountPercent)">
							<cbc:SettlementDiscountPercent>
								<xsl:value-of select="$SettlementDiscountPercent"/>
							</cbc:SettlementDiscountPercent>
						</xsl:if>
						<xsl:if test="string($PenaltySurchargePercent)">
							<cbc:PenaltySurchargePercent>
								<xsl:value-of select="$PenaltySurchargePercent"/>
							</cbc:PenaltySurchargePercent>
						</xsl:if>
						<cbc:Amount currencyID="{$CurrencyCode}">
							<xsl:value-of select="$fInvTotal"/>
						</cbc:Amount>
					</cac:PaymentTerms>
				</xsl:for-each>
			</xsl:if>

			<xsl:apply-templates select="Sum/SAC">
				<xsl:with-param name="p1" select="$CurrencyCode"/>
				<xsl:with-param name="p2" select="$fTaxSchemeID"/>
				<xsl:with-param name="p3" select="$fTaxSchemeName"/>
			</xsl:apply-templates>

			<cac:TaxTotal>
				<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxAmount"/></cbc:TaxAmount>
				<xsl:choose>
					<xsl:when test="count($M810/TXI) &gt; 1 and $fTaxAmount &gt; 0">
						<xsl:for-each select="$M810/TXI">
							<xsl:variable name="t2" select="format-number(number(translate(./TXI08,',', '.')),'##.00')"/>
							<xsl:variable name="ft2">
								<xsl:choose>
									<xsl:when test="$t2 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$t2"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<!--xsl:variable name="noTaxPercent">
								<xsl:choose>
									<xsl:when test="string(./ele[3])">false</xsl:when>
									<xsl:when test="$fTaxAmount = 0 or $ft2 = 0">false</xsl:when>
									<xsl:otherwise>true</xsl:otherwise>
								</xsl:choose>
							</xsl:variable-->
							<xsl:variable name="t4">
								<xsl:choose>
									<xsl:when test="string(./TXI03)"><xsl:value-of select="./TXI03"/></xsl:when>
									<xsl:when test="$fTaxAmount = 0 or $ft2 = 0">00</xsl:when>
									<xsl:otherwise><xsl:value-of select="format-number(($fTaxAmount div $ft2) * 100,'##')"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="t5" select="format-number(number(translate(./TXI02,',', '.')),'#0.00')"/>
							<xsl:variable name="ft5">
								<xsl:choose>
									<xsl:when test="$t5 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
									<xsl:otherwise><xsl:value-of select="$t5"/></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="t3">
								<xsl:choose>
									<xsl:when test="./TXI06 = 'S'">S</xsl:when>
									<xsl:when test="./TXI06 = 'AA'">AA</xsl:when>
									<xsl:when test="./TXI06 = 'Z'">Z</xsl:when>
									<xsl:when test="./TXI06 = 'E'">E</xsl:when>
									<xsl:when test="$ft5 = 0">Z</xsl:when>
									<xsl:otherwise>S</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="t6">
								<xsl:call-template name="TaxSchemeIDLocal">
									<xsl:with-param name="p1" select="./TXI01"/>
								</xsl:call-template>								
							</xsl:variable>
							<xsl:variable name="t7">
								<xsl:call-template name="TaxSchemeName">
									<xsl:with-param name="p1" select="./TXI01"/>
								</xsl:call-template>								
							</xsl:variable>
							<xsl:variable name="t8">
								<xsl:choose>
									<xsl:when test="$t3 = 'E'"><xsl:value-of select="./TXI10"/></xsl:when>
									<xsl:otherwise></xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:choose>
								<xsl:when test="$noTaxPercent = 'true'">
									<cac:TaxSubtotal>
										<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$ft2"/></cbc:TaxableAmount>
										<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$ft5"/></cbc:TaxAmount>
										<cac:TaxCategory>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$t3"/></cbc:ID>
											<cbc:Percent><xsl:value-of select="$t4"/></cbc:Percent>
											<cbc:BaseUnitMeasure unitCode="EA">1</cbc:BaseUnitMeasure>
											<cbc:PerUnitAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxAmount"/></cbc:PerUnitAmount>
											<xsl:if test="string($t8)"><cbc:TaxExemptionReason><xsl:value-of select="$t8"/></cbc:TaxExemptionReason></xsl:if>
											<cac:TaxScheme>
												<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$t6"/></cbc:ID>
												<cbc:Name><xsl:value-of select="$t7"/></cbc:Name>
											</cac:TaxScheme>
										</cac:TaxCategory>
									</cac:TaxSubtotal>
								</xsl:when>
								<xsl:otherwise>
									<cac:TaxSubtotal>
										<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$ft2"/></cbc:TaxableAmount>
										<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$ft5"/></cbc:TaxAmount>
										<cac:TaxCategory>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$t3"/></cbc:ID>
											<cbc:Percent><xsl:value-of select="$t4"/></cbc:Percent>
											<xsl:if test="string($t8)"><cbc:TaxExemptionReason><xsl:value-of select="$t8"/></cbc:TaxExemptionReason></xsl:if>
											<cac:TaxScheme>
												<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$t6"/></cbc:ID>
												<cbc:Name><xsl:value-of select="$t7"/></cbc:Name>
											</cac:TaxScheme>
										</cac:TaxCategory>
									</cac:TaxSubtotal>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$fTaxAmount &gt; 0">
								<xsl:variable name="t3">
									<xsl:choose>
										<xsl:when test="$TaxRateCode = 'S'">S</xsl:when>
										<xsl:when test="$TaxRateCode = 'AA'">AA</xsl:when>
										<xsl:otherwise>S</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:choose>
									<xsl:when test="$noTaxPercent = 'true'">
										<cac:TaxSubtotal>
											<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxableAmount"/></cbc:TaxableAmount>
											<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fTaxAmount"/></cbc:TaxAmount>
											<cac:TaxCategory>
												<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$t3"/></cbc:ID>
												<cbc:Percent><xsl:value-of select="$fTaxRate"/></cbc:Percent>
												<cbc:BaseUnitMeasure unitCode="EA">1</cbc:BaseUnitMeasure>
												<cbc:PerUnitAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxAmount"/></cbc:PerUnitAmount>
												<cac:TaxScheme>
													<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
													<cbc:Name><xsl:value-of select="$fTaxSchemeName"/></cbc:Name>
												</cac:TaxScheme>
											</cac:TaxCategory>
										</cac:TaxSubtotal>
									</xsl:when>
									<xsl:otherwise>
										<cac:TaxSubtotal>
											<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxableAmount"/></cbc:TaxableAmount>
											<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fTaxAmount"/></cbc:TaxAmount>
											<cac:TaxCategory>
												<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$t3"/></cbc:ID>
												<cbc:Percent><xsl:value-of select="$fTaxRate"/></cbc:Percent>
												<cac:TaxScheme>
													<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
													<cbc:Name><xsl:value-of select="$fTaxSchemeName"/></cbc:Name>
												</cac:TaxScheme>
											</cac:TaxCategory>
										</cac:TaxSubtotal>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="t3">
									<xsl:choose>
										<xsl:when test="$TaxRateCode = 'Z'">Z</xsl:when>
										<xsl:when test="$TaxRateCode = 'E'">E</xsl:when>
										<xsl:otherwise>Z</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<cac:TaxSubtotal>
									<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxableAmount"/></cbc:TaxableAmount>
									<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="'0.00'"/></cbc:TaxAmount>
									<cac:TaxCategory>
										<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$t3"/></cbc:ID>
										<cbc:Percent>00</cbc:Percent>
										<xsl:if test="string($TaxExemptReason) and $TaxRateCode = 'E'"><cbc:TaxExemptionReason><xsl:value-of select="$TaxExemptReason"/></cbc:TaxExemptionReason></xsl:if>
										<cac:TaxScheme>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
											<cbc:Name><xsl:value-of select="$fTaxSchemeName"/></cbc:Name>
										</cac:TaxScheme>
									</cac:TaxCategory>
								</cac:TaxSubtotal>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</cac:TaxTotal>

			<cac:LegalMonetaryTotal>
				<cbc:LineExtensionAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fLineTotal"/></cbc:LineExtensionAmount>
				<cbc:TaxExclusiveAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fTaxAmount"/></cbc:TaxExclusiveAmount>
				<cbc:TaxInclusiveAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fInvTotal"/></cbc:TaxInclusiveAmount>
				<xsl:if test="$fAllowanceAmount &gt; 0"><cbc:AllowanceTotalAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fAllowanceAmount"/></cbc:AllowanceTotalAmount></xsl:if>
				<xsl:if test="$fChargeAmount &gt; 0"><cbc:ChargeTotalAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fChargeAmount"/></cbc:ChargeTotalAmount></xsl:if>
				<cbc:PayableAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fInvTotal"/></cbc:PayableAmount>
			</cac:LegalMonetaryTotal>


			<!-- InvoiceLine -->
			<xsl:for-each select="$M810/SG20010">

				<cac:InvoiceLine>
					<!-- Variable -->


					<!-- Line fields -->

					<xsl:variable name="LineID" select="IT1/IT101"/>

					<xsl:variable name="LineAccCost" select="REF[REF01 = '79']/REF02"/>

					<xsl:variable name="LineRefID" select="REF[REF01 = 'BV']/REF02"/>

					<xsl:variable name="LineOrderID" select="REF[REF01 = 'PO']/REF02"/>

					<xsl:variable name="LineFileReferenceID" select="REF[REF01 = 'CR']/REF02"/>

					<xsl:variable name="LineBOLReferenceID" select="REF[REF01 = 'BM']/REF02"/>

					<xsl:variable name="LineVehicleNumber" select="REF[REF01 = 'VT']/REF02"/>

					<xsl:variable name="LineNote" select="''"/>

					<xsl:variable name="ItemIdType" select="''"/>

					<xsl:variable name="ItemId" select="IT1/IT107"/>

					<xsl:variable name="ItemName" select="SG20060/PID/PID05"/>

					<xsl:variable name="Quantity" select="IT1/IT102"/>

					<xsl:variable name="UnitCode" select="'EA'"/>

					<xsl:variable name="UnitPrice" select="IT1/IT104"/>

					<xsl:variable name="LineAllowanceAmount" select="''"/>

					<xsl:variable name="LineAllowanceReason" select="''"/>

					<xsl:variable name="LineTaxRate" select="TXI/TXI03"/>

					<xsl:variable name="LineTaxExemptReason" select="TXI/TXI10"/>

					<xsl:variable name="LineTaxRateCode" select="TXI/TXI06"/>

					<xsl:variable name="LineTaxSchemeID" select="TXI/TXI01"/>

					<xsl:variable name="LineTaxSchemeName" select="TXI/TXI01"/>

					<xsl:variable name="LineTaxAmount" select="TXI/TXI02"/>

					<xsl:variable name="LineAmount" select="IT1/IT104"/>


					<!-- Konverteringer etc. -->
					<xsl:variable name="fQuantity" select="number(translate($Quantity,',', '.'))"/>

					<xsl:variable name="fItemName" select="substring($ItemName, 1, 40)"/>


					<xsl:variable name="fLineID">
						<xsl:choose>
							<xsl:when test="string($LineID)"><xsl:value-of select="$LineID"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="position()"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>


					<xsl:variable name="fLineAllowanceFlag">
						<xsl:choose>
							<xsl:when test="string($LineAllowanceAmount)"><xsl:value-of select="'true'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l5" select="format-number(number(translate($LineAllowanceAmount,',', '.')),'##.00')"/>
					<xsl:variable name="fLineAllowanceAmount">
						<xsl:choose>
							<xsl:when test="$l5 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$l5"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l3" select="format-number(number(translate($UnitPrice,',', '.')),'##.00##')"/>
					<xsl:variable name="fUnitPrice">
						<xsl:choose>
							<xsl:when test="$l3 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$l3"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l1" select="format-number(number(translate($LineAmount,',', '.')),'##.00')"/>
					<xsl:variable name="fLineAmount">
						<xsl:choose>
							<xsl:when test="$fQuantity = 0 or not(number($fQuantity))"><xsl:value-of select="$l1"/></xsl:when>
							<xsl:when test="$fQuantity != 1"><xsl:value-of select="format-number($fUnitPrice * $fQuantity, '##.00')"/></xsl:when>
							<xsl:when test="$l1 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$l1"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="IsoCode" select="',04,05,08,10,11,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,43,44,45,46,47,48,53,54,56,57,58,59,60,61,62,63,64,66,69,71,72,73,74,76,77,78,80,81,84,85,87,89,90,91,92,93,94,95,96,97,98,1A,1B,1C,1D,1E,1F,1G,1H,1I,1J,1K,1L,1M,1X,2A,2B,2C,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2V,2W,2X,2Y,2Z,3B,3C,3E,3G,3H,3I,4A,4B,4C,4E,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,5A,5B,5C,5E,5F,5G,5H,5I,5J,5K,5P,5Q,A1,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A50,A51,A52,A53,A54,A55,A56,A57,A58,A6,A60,A61,A62,A63,A64,A65,A66,A67,A68,A69,A7,A70,A71,A73,A74,A75,A76,A77,A78,A79,A8,A80,A81,A82,A83,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,AA,AB,ACR,AD,AE,AH,AI,AJ,AK,AL,AM,AMH,AMP,ANN,AP,APZ,AQ,AR,ARE,AS,ASM,ASU,ATM,ATT,AV,AW,AY,AZ,B0,B1,B11,B12,B13,B14,B15,B16,B18,B2,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B31,B32,B33,B34,B35,B36,B37,B38,B39,B4,B40,B41,B42,B43,B44,B45,B46,B47,B48,B49,B5,B50,B51,B52,B53,B54,B55,B56,B57,B58,B59,B6,B60,B61,B62,B63,B64,B65,B66,B67,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B81,B83,B84,B85,B86,B87,B88,B89,B9,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BB,BD,BE,BFT,BG,BH,BHP,BIL,BJ,BK,BL,BLD,BLL,BO,BP,BQL,BR,BT,BTU,BUA,BUI,BW,BX,BZ,C0,C1,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C2,C20,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C38,C39,C4,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C5,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C6,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C75,C76,C77,C78,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C98,C99,CA,CCT,CDL,CEL,CEN,CG,CGM,CH,CJ,CK,CKG,CL,CLF,CLT,CMK,CMQ,CMT,CNP,CNT,CO,COU,CQ,CR,CS,CT,CTM,CU,CUR,CV,CWA,CWI,CY,CZ,D1,D10,D12,D13,D14,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30,D31,D32,D33,D34,D35,D37,D38,D39,D40,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D64,D65,D66,D67,D69,D7,D70,D71,D72,D73,D74,D75,D76,D77,D79,D8,D80,D81,D82,D83,D85,D86,D87,D88,D89,D9,D90,D91,D92,D93,D94,D95,D96,D97,D98,D99,DAA,DAD,DAY,DB,DC,DD,DE,DEC,DG,DI,DJ,DLT,DMK,DMQ,DMT,DN,DPC,DPR,DPT,DQ,DR,DRA,DRI,DRL,DRM,DS,DT,DTN,DU,DWT,DX,DY,DZN,DZP,E2,E3,E4,E5,EA,EB,EC,EP,EQ,EV,F1,F9,FAH,FAR,FB,FC,FD,FE,FF,FG,FH,FL,FM,FOT,FP,FR,FS,FTK,FTQ,G2,G3,G7,GB,GBQ,GC,GD,GE,GF,GFI,GGR,GH,GIA,GII,GJ,GK,GL,GLD,GLI,GLL,GM,GN,GO,GP,GQ,GRM,GRN,GRO,GRT,GT,GV,GW,GWH,GY,GZ,H1,H2,HA,HAR,HBA,HBX,HC,HD,HE,HF,HGM,HH,HI,HIU,HJ,HK,HL,HLT,HM,HMQ,HMT,HN,HO,HP,HPA,HS,HT,HTZ,HUR,HY,IA,IC,IE,IF,II,IL,IM,INH,INK,INQ,IP,IT,IU,IV,J2,JB,JE,JG,JK,JM,JO,JOU,JR,K1,K2,K3,K5,K6,KA,KB,KBA,KD,KEL,KF,KG,KGM,KGS,KHZ,KI,KJ,KJO,KL,KMH,KMK,KMQ,KNI,KNS,KNT,KO,KPA,KPH,KPO,KPP,KR,KS,KSD,KSH,KT,KTM,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWT,KX,L2,LA,LBR,LBT,LC,LD,LE,LEF,LF,LH,LI,LJ,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUM,LUX,LX,LY,M0,M1,M4,M5,M7,M9,MA,MAL,MAM,MAW,MBE,MBF,MBR,MC,MCU,MD,MF,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MK,MLD,MLT,MMK,MMQ,MMT,MON,MPA,MQ,MQH,MQS,MSK,MT,MTK,MTQ,MTR,MTS,MV,MVA,MWH,N1,N2,N3,NA,NAR,NB,NBB,NC,NCL,ND,NE,NEW,NF,NG,NH,NI,NIU,NJ,NL,NMI,NMP,NN,NPL,NPR,NPT,NQ,NR,NRL,NT,NTT,NU,NV,NX,NY,OA,OHM,ON,ONZ,OP,OT,OZ,OZA,OZI,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,PA,PAL,PB,PD,PE,PF,PG,PGL,PI,PK,PL,PM,PN,PO,PQ,PR,PS,PT,PTD,PTI,PTL,PU,PV,PW,PY,PZ,Q3,QA,QAN,QB,QD,QH,QK,QR,QT,QTD,QTI,QTL,QTR,R1,R4,R9,RA,RD,RG,RH,RK,RL,RM,RN,RO,RP,RPM,RPS,RS,RT,RU,S3,S4,S5,S6,S7,S8,SA,SAN,SCO,SCR,SD,SE,SEC,SET,SG,SHT,SIE,SK,SL,SMI,SN,SO,SP,SQ,SR,SS,SST,ST,STI,STN,SV,SW,SX,T0,T1,T3,T4,T5,T6,T7,T8,TA,TAH,TC,TD,TE,TF,TI,TJ,TK,TL,TN,TNE,TP,TPR,TQ,TQD,TR,TRL,TS,TSD,TSH,TT,TU,TV,TW,TY,U1,U2,UA,UB,UC,UD,UE,UF,UH,UM,VA,VI,VLT,VQ,VS,W2,W4,WA,WB,WCD,WE,WEB,WEE,WG,WH,WHR,WI,WM,WR,WSD,WTT,WW,X1,YDK,YDQ,YL,YRD,YT,Z1,Z2,Z3,Z4,Z5,Z6,Z8,ZP,ZZ,'"/>

					<xsl:variable name="l2" select="$UnitCode"/>
					<xsl:variable name="fUnitCode">
						<xsl:choose>
							<xsl:when test="contains($IsoCode, concat(',',$l2,','))"><xsl:value-of select="$l2"/></xsl:when>
							<xsl:when test="$l2 = 'NMB'"><xsl:value-of select="'EA'"/></xsl:when>
							<xsl:when test="$l2 = 'PCE'"><xsl:value-of select="'EA'"/></xsl:when>
							<xsl:when test="$l2 = 'stk'"><xsl:value-of select="'EA'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'ZZ'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l4" select="format-number(number(translate($LineTaxAmount,',', '.')),'#0.00')"/>
					<xsl:variable name="fLineTaxAmount">
						<xsl:choose>
							<xsl:when test="$l4 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$l4"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxRateCode">
						<xsl:choose>
							<xsl:when test="$LineTaxRateCode = 'S'">S</xsl:when>
							<xsl:when test="$LineTaxRateCode = 'AA'">AA</xsl:when>
							<xsl:when test="$LineTaxRateCode = 'Z'">Z</xsl:when>
							<xsl:when test="$LineTaxRateCode = 'E'">E</xsl:when>
							<xsl:when test="$fLineTaxAmount = 0 and $fLineAmount != 0">Z</xsl:when>
							<xsl:otherwise>S</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="noLineTaxPercent">
						<xsl:choose>
							<xsl:when test="string($LineTaxRate)">false</xsl:when>
							<xsl:when test="$fLineTaxAmount = 0 or $fLineAmount = 0">false</xsl:when>
							<xsl:when test="TXI and not(string($LineTaxRate))">true</xsl:when>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxRate">
						<xsl:choose>
							<xsl:when test="string($LineTaxRate)"><xsl:value-of select="translate($LineTaxRate,',', '.')"/></xsl:when>
							<xsl:when test="$fLineTaxAmount = 0 or $fLineAmount = 0">00</xsl:when>
							<xsl:otherwise><xsl:value-of select="format-number(($fLineTaxAmount div $fLineAmount) * 100,'##')"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxExemptReason">
						<xsl:choose>
							<xsl:when test="$LineTaxRateCode = 'E'"><xsl:value-of select="$LineTaxExemptReason"/></xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxSchemeID">
						<xsl:call-template name="TaxSchemeIDLocal">
							<xsl:with-param name="p1" select="$LineTaxSchemeID"/>
						</xsl:call-template>								
					</xsl:variable>

					<xsl:variable name="fLineTaxSchemeName">
						<xsl:call-template name="TaxSchemeName">
							<xsl:with-param name="p1" select="$LineTaxSchemeName"/>
						</xsl:call-template>								
					</xsl:variable>



					<!-- Start invoiceline -->

					<cbc:ID><xsl:value-of select="$fLineID"/></cbc:ID>
					<xsl:if test="string($LineNote)"><cbc:Note><xsl:value-of select="$LineNote"/></cbc:Note></xsl:if>
					<cbc:InvoicedQuantity unitCode="{$fUnitCode}"><xsl:value-of select="$fQuantity"/></cbc:InvoicedQuantity>
					<cbc:LineExtensionAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineAmount"/></cbc:LineExtensionAmount>

					<xsl:if test="string($LineAccCost)"><cbc:AccountingCost><xsl:value-of select="$LineAccCost"/></cbc:AccountingCost></xsl:if>

					<xsl:if test="string($LineRefID) or string($LineOrderID)">
						<xsl:variable name="fLineRefID">
							<xsl:choose>
								<xsl:when test="string($LineRefID)"><xsl:value-of select="$LineRefID"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="'n/a'"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<cac:OrderLineReference>
							<cbc:LineID><xsl:value-of select="$fLineRefID"/></cbc:LineID>
							<xsl:if test="string($LineOrderID)">
								<cac:OrderReference>
									<cbc:ID><xsl:value-of select="$LineOrderID"/></cbc:ID>
								</cac:OrderReference>
							</xsl:if>
						</cac:OrderLineReference>
					</xsl:if>

					<xsl:if test="string($LineFileReferenceID)">
						<cac:DocumentReference>
							<cbc:ID><xsl:value-of select="$LineFileReferenceID"/></cbc:ID>
							<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">File ID</cbc:DocumentTypeCode>
						</cac:DocumentReference>
					</xsl:if>

					<xsl:if test="string($LineBOLReferenceID)">
						<cac:DocumentReference>
							<cbc:ID><xsl:value-of select="$LineBOLReferenceID"/></cbc:ID>
							<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">BOL ID</cbc:DocumentTypeCode>
						</cac:DocumentReference>
					</xsl:if>

					<xsl:if test="string($LineVehicleNumber)">
						<cac:DocumentReference>
							<cbc:ID><xsl:value-of select="$LineVehicleNumber"/></cbc:ID>
							<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">VN ID</cbc:DocumentTypeCode>
						</cac:DocumentReference>
					</xsl:if>

					<xsl:apply-templates select="SAC">
						<xsl:with-param name="p1" select="$CurrencyCode"/>
						<xsl:with-param name="p2" select="$fLineTaxSchemeID"/>
					</xsl:apply-templates>

					<cac:TaxTotal>
						<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineTaxAmount"/></cbc:TaxAmount>
						<xsl:choose>
							<xsl:when test="$noLineTaxPercent = 'true'">
								<cac:TaxSubtotal>
										<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineAmount"/></cbc:TaxableAmount>
										<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineTaxAmount"/></cbc:TaxAmount>
										<cac:TaxCategory>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxRateCode"/></cbc:ID>
											<cbc:Percent><xsl:value-of select="$fLineTaxRate"/></cbc:Percent>
											<cbc:BaseUnitMeasure unitCode="EA">1</cbc:BaseUnitMeasure>
											<cbc:PerUnitAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineTaxAmount"/></cbc:PerUnitAmount>
											<xsl:if test="string($fLineTaxExemptReason)"><cbc:TaxExemptionReason><xsl:value-of select="$fLineTaxExemptReason"/></cbc:TaxExemptionReason></xsl:if>
											<cac:TaxScheme>
												<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxSchemeID"/></cbc:ID>
												<cbc:Name><xsl:value-of select="$fLineTaxSchemeName"/></cbc:Name>
											</cac:TaxScheme>
										</cac:TaxCategory>
								</cac:TaxSubtotal>
							</xsl:when>
							<xsl:otherwise>
								<cac:TaxSubtotal>
										<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineAmount"/></cbc:TaxableAmount>
										<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineTaxAmount"/></cbc:TaxAmount>
										<cac:TaxCategory>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxRateCode"/></cbc:ID>
											<cbc:Percent><xsl:value-of select="$fLineTaxRate"/></cbc:Percent>
											<xsl:if test="string($fLineTaxExemptReason)"><cbc:TaxExemptionReason><xsl:value-of select="$fLineTaxExemptReason"/></cbc:TaxExemptionReason></xsl:if>
											<cac:TaxScheme>
												<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxSchemeID"/></cbc:ID>
												<cbc:Name><xsl:value-of select="$fLineTaxSchemeName"/></cbc:Name>
											</cac:TaxScheme>
										</cac:TaxCategory>
								</cac:TaxSubtotal>
							</xsl:otherwise>
						</xsl:choose>
					</cac:TaxTotal>

					<cac:Item>
						<cbc:Description><xsl:value-of select="$ItemName"/></cbc:Description>
						<cbc:Name><xsl:value-of select="$fItemName"/></cbc:Name>
						<xsl:if test="string($ItemId)">
							<cac:SellersItemIdentification>
								<xsl:choose>
									<xsl:when test="$ItemIdType = 'GTIN' or $ItemIdType = 'EAN'">
										<cbc:ID schemeAgencyID="9" schemeID="GTIN"><xsl:value-of select="$ItemId"/></cbc:ID>
									</xsl:when>
									<xsl:otherwise>
										<cbc:ID><xsl:value-of select="$ItemId"/></cbc:ID>
									</xsl:otherwise>
								</xsl:choose>
							</cac:SellersItemIdentification>
						</xsl:if>
					</cac:Item>

					<cac:Price>
						<cbc:PriceAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fUnitPrice"/></cbc:PriceAmount>
						<cbc:BaseQuantity unitCode="{$fUnitCode}">1</cbc:BaseQuantity>
						<cbc:OrderableUnitFactorRate>1</cbc:OrderableUnitFactorRate>
					</cac:Price>

				</cac:InvoiceLine>

			</xsl:for-each>

		</Invoice>

	</xsl:template>


	<!-- .............................. -->
	<!--           Templates            -->
	<!-- .............................. -->


	<!-- TaxSchemeIDLocal -->
	<xsl:template name="TaxSchemeIDLocal">
		<xsl:param name="p1"/>
		<xsl:variable name="ft1">
			<xsl:choose>
				<xsl:when test="$p1 = 'VA'">VAT</xsl:when>
				<xsl:when test="$p1 = 'GS'">GST</xsl:when>
				<xsl:when test="$p1 = 'CS'">LOC</xsl:when>
				<xsl:when test="$p1 = 'LT'">STT</xsl:when>
				<xsl:when test="$p1 = 'SP'">STT</xsl:when>
				<xsl:when test="$p1 = 'SL'">STT</xsl:when>
				<xsl:when test="$p1 = 'LS'">STT</xsl:when>
				<xsl:when test="$p1 = 'ST'">STT</xsl:when>
				<xsl:when test="$p1 = 'SU'">STT</xsl:when>
				<xsl:when test="$p1 = 'TX'">OTH</xsl:when>
				<xsl:otherwise>OTH</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$ft1"/>
	</xsl:template>


	<!-- TaxSchemeName -->
	<xsl:template name="TaxSchemeName">
		<xsl:param name="p1"/>
		<xsl:variable name="ft1">
			<xsl:choose>
				<xsl:when test="$p1 = 'VA'">VAT</xsl:when>
				<xsl:when test="$p1 = 'GS'">GST</xsl:when>
				<xsl:when test="$p1 = 'CS'">LOC</xsl:when>
				<xsl:when test="$p1 = 'LT'">STT</xsl:when>
				<xsl:when test="$p1 = 'SP'">STT</xsl:when>
				<xsl:when test="$p1 = 'SL'">STT</xsl:when>
				<xsl:when test="$p1 = 'LS'">STT</xsl:when>
				<xsl:when test="$p1 = 'ST'">STT</xsl:when>
				<xsl:when test="$p1 = 'SU'">STT</xsl:when>
				<xsl:when test="$p1 = 'TX'">OTH</xsl:when>
				<xsl:when test="string($p1)"><xsl:value-of select="$p1"/></xsl:when>
				<xsl:otherwise>OTH</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:value-of select="$ft1"/>
	</xsl:template>


	<!--  Header ALC -->
	<xsl:template match="MESSAGES/M810/SAC">
		<xsl:param name="p1"/>
		<xsl:param name="p2"/>
		<xsl:param name="p3"/>

		<xsl:variable name="CurrencyCode" select="$p1"/>

		<xsl:variable name="fTaxSchemeID" select="$p2"/>

		<xsl:variable name="fTaxSchemeName" select="$p3"/>

		<xsl:variable name="AlcAmount" select="./SAC05 div 100"/>

		<xsl:variable name="h1" select="format-number(number(translate($AlcAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fAlcAmount">
			<xsl:choose>
				<xsl:when test="$h1 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h1"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fAlcIndicator">
			<xsl:choose>
				<xsl:when test="./SAC01 = 'A'"><xsl:value-of select="'false'"/></xsl:when>
				<xsl:when test="./SAC01 = 'C'"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'true'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxRate">
			<xsl:choose>
				<xsl:when test="number(./SAC13)"><xsl:value-of select="translate(./SAC13,',', '.')"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxRateCode">
			<xsl:choose>
				<xsl:when test="$fTaxRate &gt; 0"><xsl:value-of select="'S'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'Z'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="AlcTaxSchemeID">
			<xsl:call-template name="TaxSchemeIDLocal">
				<xsl:with-param name="p1" select="./SAC12"/>
			</xsl:call-template>								
		</xsl:variable>

		<xsl:variable name="AlcTaxSchemeName">
			<xsl:call-template name="TaxSchemeName">
				<xsl:with-param name="p1" select="./SAC12"/>
			</xsl:call-template>								
		</xsl:variable>

		<xsl:variable name="fAlcReason">
			<xsl:choose>
				<xsl:when test="string(./SAC15)"><xsl:value-of select="./SAC15"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'n/a'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="TaxExemptReason" select="''"/>

		<xsl:variable name="fTaxExemptReason">
			<xsl:choose>
				<xsl:when test="$fTaxRate = 0"><xsl:value-of select="$TaxExemptReason"/></xsl:when>
				<xsl:otherwise></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$fAlcAmount &gt; 0">
			<cac:AllowanceCharge>
				<cbc:ID><xsl:value-of select="position()"/></cbc:ID>
				<cbc:ChargeIndicator><xsl:value-of select="$fAlcIndicator"/></cbc:ChargeIndicator>
				<cbc:AllowanceChargeReason><xsl:value-of select="$fAlcReason"/></cbc:AllowanceChargeReason>
				<cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
				<cbc:SequenceNumeric>1</cbc:SequenceNumeric>
				<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAlcAmount"/></cbc:Amount>
				<cbc:BaseAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAlcAmount"/></cbc:BaseAmount>
				<cac:TaxCategory>
					<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fTaxRateCode"/></cbc:ID>
					<cbc:Percent><xsl:value-of select="$fTaxRate"/></cbc:Percent>
					<xsl:if test="string($fTaxExemptReason)"><cbc:TaxExemptionReason><xsl:value-of select="$fTaxExemptReason"/></cbc:TaxExemptionReason></xsl:if>
					<cac:TaxScheme>
						<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$AlcTaxSchemeID"/></cbc:ID>
						<cbc:Name><xsl:value-of select="$AlcTaxSchemeName"/></cbc:Name>
					</cac:TaxScheme>
				</cac:TaxCategory>
			</cac:AllowanceCharge>
		</xsl:if>
	</xsl:template>


	<!--  Line ALC -->
	<xsl:template match="SAC">
		<xsl:param name="p1"/>
		<xsl:param name="p2"/>

		<xsl:variable name="CurrencyCode" select="$p1"/>

		<xsl:variable name="fLineTaxSchemeID" select="$p2"/>

		<xsl:variable name="AlcAmount" select="./SAC05 div 100"/>

		<xsl:variable name="h1" select="format-number(number(translate($AlcAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fAlcAmount">
			<xsl:choose>
				<xsl:when test="$h1 = 'NaN'"><xsl:value-of select="'0.00'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h1"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fAllowanceFlag">
			<xsl:choose>
				<xsl:when test="./SAC01 = 'A'"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fChargeFlag">
			<xsl:choose>
				<xsl:when test="./SAC01 = 'C'"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fAlcReason">
			<xsl:choose>
				<xsl:when test="string(./SAC15)"><xsl:value-of select="./SAC15"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'n/a'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$fAllowanceFlag = 'true'">
			<cac:AllowanceCharge>
				<cbc:ID><xsl:value-of select="position()"/></cbc:ID>
				<cbc:ChargeIndicator>false</cbc:ChargeIndicator>
				<cbc:AllowanceChargeReason><xsl:value-of select="$fAlcReason"/></cbc:AllowanceChargeReason>
				<cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
				<cbc:SequenceNumeric>1</cbc:SequenceNumeric>
				<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAlcAmount"/></cbc:Amount>
				<cbc:BaseAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAlcAmount"/></cbc:BaseAmount>
			</cac:AllowanceCharge>
		</xsl:if>
		<xsl:if test="$fChargeFlag = 'true'">
			<cac:AllowanceCharge>
				<cbc:ID><xsl:value-of select="position()"/></cbc:ID>
				<cbc:ChargeIndicator>true</cbc:ChargeIndicator>
				<cbc:AllowanceChargeReason><xsl:value-of select="$fAlcReason"/></cbc:AllowanceChargeReason>
				<cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
				<cbc:SequenceNumeric>1</cbc:SequenceNumeric>
				<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAlcAmount"/></cbc:Amount>
				<cbc:BaseAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAlcAmount"/></cbc:BaseAmount>
			</cac:AllowanceCharge>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>