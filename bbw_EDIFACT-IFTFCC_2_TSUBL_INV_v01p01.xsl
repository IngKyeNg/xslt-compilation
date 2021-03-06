<?xml version="1.0" encoding="UTF-8"?>

<!--
******************************************************************************************************************
		TSUBL Stylesheet
		title= bbw_DIFACT_IFTFCC_2_TSUBL_INV_v01p01
		publisher= "Tradeshift"
		creator= "IngKye Ng, Tradeshift"
		created= 2019-04-03
		modified= 2019-04-10
		issued= 2019-04-08
******************************************************************************************************************
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:metadata-util="java:com.babelway.messaging.transformation.xslt.function.MetadataUtil"
	xmlns:bbw="java:com.babelway.messaging.transformation.xslt.function.BabelwayFunctions"
	xmlns:bbwx="http://xmlns.babelway.com/com.babelway.messaging.transformation.xslt.function.BBWXContextFactory"
	exclude-result-prefixes="xs metadata-util bbw bbwx">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*"/>
	<xsl:param name="MSG"/>

	<xsl:variable name="CMAflag">
		<xsl:choose>
			<xsl:when test="count(/EDIFACT/MESSAGES/IFTFCC/SG4[TAX/TAX0101 = '61']) &gt; 0">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:variable name="ShippingFlag">
		<xsl:choose>
			<xsl:when
				test="
					string(/EDIFACT/MESSAGES/IFTFCC/SG17[1]/TDT/TDT0804) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG17[1]/TDT/TDT0201) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG28[1]/TDT/TDT0804) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG28[1]/TDT/TDT0201) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG1[1]/LOC[LOC0101 = '9']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG1[1]/LOC[LOC0101 = '11']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG1[1]/LOC[LOC0101 = '7']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG1[1]/LOC[LOC0101 = '88']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG17[1]/LOC[LOC0101 = '9']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG17[1]/LOC[LOC0101 = '11']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG17[1]/LOC[LOC0101 = '7']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG17[1]/LOC[LOC0101 = '88']/LOC0204) or
					string(/EDIFACT/MESSAGES/IFTFCC/SG24[1]/EQD[EQD0101 = 'CN'])">
				<xsl:value-of select="'true'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'false'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="*">
		<Error>
			<Errortext>Fatal error: Unsupported documenttype! This stylesheet only supports
				conversion of a EDIFACT IFTFCC (380).</Errortext>
			<Input>
				<xsl:value-of select="."/>
			</Input>
		</Error>
	</xsl:template>

	<xsl:template match="/EDIFACT">

		<!-- Parameters (please assign before using this stylesheet) -->

		<!-- End parameters -->

		<xsl:variable name="IFTFCC" select="MESSAGES/IFTFCC"/>


		<!-- Global Headerfields -->

		<xsl:variable name="UBLVersionID" select="'2.0'"/>

		<xsl:variable name="CustomizationID"
			select="'urn:tradeshift.com:ubl-2.0-customizations:2010-06'"/>

		<xsl:variable name="ProfileID" select="'urn:www.cenbii.eu:profile:bii04:ver1.0'"/>

		<xsl:variable name="ProfileID_schemeID" select="'CWA 16073:2010'"/>

		<xsl:variable name="ProfileID_schemeAgencyID" select="'CEN/ISSS WS/BII'"/>

		<xsl:variable name="DocID" select="$IFTFCC/BGM/BGM0201"/>

		<xsl:variable name="DocDate">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/DTM[DTM0101 = '3']/DTM0102)">
					<xsl:value-of select="$IFTFCC/DTM[DTM0101 = '3']/DTM0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$IFTFCC/DTM[DTM0101 = '137']/DTM0102"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="TaxDate">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/DTM[DTM0101 = '131']/DTM0102)">
					<xsl:value-of select="$IFTFCC/DTM[DTM0101 = '131']/DTM0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$DocDate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="Note">
			<xsl:apply-templates select="MESSAGES/IFTFCC/FTX"> </xsl:apply-templates>
		</xsl:variable>

		<xsl:variable name="InvoiceTypeCode" select="$IFTFCC/BGM/BGM0101"/>

		<xsl:variable name="CurrencyCode">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG5/CUX[CUX0103 = '11']/CUX0102)">
					<xsl:value-of select="$IFTFCC/SG5/CUX[CUX0103 = '11']/CUX0102"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG5/CUX[CUX0103 = '4']/CUX0102)">
					<xsl:value-of select="$IFTFCC/SG5/CUX[CUX0103 = '4']/CUX0102"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG5/CUX/CUX0102)">
					<xsl:value-of select="$IFTFCC/SG5/CUX/CUX0102"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="AccCost" select="$IFTFCC/SG2/RFF[RFF0101 = 'AE']/RFF0102"/>

		<xsl:variable name="RefID" select="$IFTFCC/SG2/RFF[RFF0101 = 'ON']/RFF0102"/>

		<xsl:variable name="RefDate" select="$IFTFCC/SG2//DTM[DTM01 = '171']/DTM02"/>

		<xsl:variable name="InvoiceBOLReferenceID" select="$IFTFCC/SG2/RFF[RFF0101 = 'BM']/RFF0102"/>

		<xsl:variable name="InvoiceFileReferenceID">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG2/RFF[RFF0101 = 'SI']/RFF0102)">
					<xsl:value-of select="$IFTFCC/SG2/RFF[RFF0101 = 'SI']/RFF0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$IFTFCC/SG2/RFF[RFF0101 = 'CR']/RFF0102"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="InvoiceBookingReferenceID"
			select="$IFTFCC/SG2/RFF[RFF0101 = 'BN']/RFF0102"/>

		<!-- Supplier (SU or RE) -->
		<xsl:variable name="Se_id">
			<xsl:choose>
				<xsl:when test="$IFTFCC/SG11/NAD[NAD0101 = 'SU']">
					<xsl:value-of select="'SU'"/>
				</xsl:when>
				<xsl:when test="$IFTFCC/SG11/NAD[NAD0101 = 'RE']">
					<xsl:value-of select="'RE'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="SeEndpointID" select="UNB/UNB0201"/>

		<xsl:variable name="SeEndpointIDscheme" select="''"/>

		<xsl:variable name="SePartySenderAssigned"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG13/RFF[RFF0101 = 'API']/RFF0102"/>

		<xsl:variable name="SePartyGLN"
			select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id and NAD0203 = '9']/NAD0201"/>

		<xsl:variable name="SePartyLEGAL"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG13/RFF[RFF0101 = 'GN']/RFF0102"/>

		<xsl:variable name="SePartyLEGALscheme" select="''"/>

		<xsl:variable name="SePartyTAX"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG13/RFF[RFF0101 = 'VA']/RFF0102"/>

		<xsl:variable name="SePartyTAXscheme" select="''"/>

		<xsl:variable name="SeName" select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0401"/>

		<xsl:variable name="SeStreet1" select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0501"/>

		<xsl:variable name="SeStreet2">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0502)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0502"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0503)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0503"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="SeCity">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0601)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0601"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0504)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0504"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="SeZip" select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0801"/>

		<xsl:variable name="SeState" select="''"/>

		<xsl:variable name="SeCountry" select="$IFTFCC/SG11/NAD[NAD0101 = $Se_id]/NAD0901"/>

		<xsl:variable name="SeRefName">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG12/CTA[CTA0101 = 'PE']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG12/CTA[CTA0101 = 'PE']/CTA0202"
					/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG12/CTA[CTA0101 = 'IC']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG12/CTA[CTA0101 = 'IC']/CTA0202"
					/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/CTA[CTA0101 = 'PE']/CTA0202)">
					<xsl:value-of select="$IFTFCC/CTA[CTA0101 = 'PE']/CTA0202"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="SeRefTlf"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG12/COM[COM0102 = 'TE']/COM0101"/>

		<xsl:variable name="SeRefMail"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/SG12/COM[COM0102 = 'MA' or COM0102 = 'EM']/COM0101"/>


		<!-- Buyer (BY or AA) -->
		<xsl:variable name="Ip_id">
			<xsl:choose>
				<xsl:when test="$IFTFCC/SG11/NAD[NAD0101 = 'BY']">
					<xsl:value-of select="'BY'"/>
				</xsl:when>
				<xsl:when test="$IFTFCC/SG11/NAD[NAD0101 = 'AA']">
					<xsl:value-of select="'AA'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="IpCustomerAssignedAccountID"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'BY']/SG13/RFF[RFF0101 = 'IT']/RFF0102"/>

		<xsl:variable name="IpEndpointID" select="$IFTFCC/UNB/UNB0301"/>

		<xsl:variable name="IpEndpointIDscheme" select="''"/>

		<xsl:variable name="IpPartyTSGLI"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG13/RFF[RFF0101 = 'AP']/RFF0102"/>

		<xsl:variable name="IpPartySenderAssigned"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG13/RFF[RFF0101 = 'API']/RFF0102"/>

		<xsl:variable name="IpPartyTSLEID"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG13/RFF[RFF0101 = 'ACF']/RFF0102"/>

		<xsl:variable name="IpPartyGLN"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id and NAD0203 = 9]/NAD0201"/>

		<xsl:variable name="IpPartyLEGAL"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG13/RFF[RFF0101 = 'GN']/RFF0102"/>

		<xsl:variable name="IpPartyLEGALscheme" select="''"/>

		<xsl:variable name="IpPartyTAX"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG13/RFF[RFF0101 = 'VA']/RFF0102"/>

		<xsl:variable name="IpPartyTAXscheme" select="''"/>

		<xsl:variable name="IpName" select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0401"/>

		<xsl:variable name="IpStreet1" select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0501"/>

		<xsl:variable name="IpStreet2">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0502)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0502"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0503)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0503"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="IpCity">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0601)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0601"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0504)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0504"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="IpZip" select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0801"/>

		<xsl:variable name="IpState" select="''"/>

		<xsl:variable name="IpCountry" select="$IFTFCC/SG11/NAD[NAD0101 = $Ip_id]/NAD0901"/>

		<xsl:variable name="IpRef">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG12/CTA[CTA0101 = 'OC']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG12/CTA[CTA0101 = 'OC']/CTA0202"
					/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/CTA[CTA0101 = 'OC']/CTA0202)">
					<xsl:value-of select="$IFTFCC/CTA[CTA0101 = 'OC']/CTA0202"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="IpRefName" select="''"/>

		<xsl:variable name="IpRefTlf"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG12/COM[COM0102 = 'OC']/COM0101"/>

		<xsl:variable name="IpRefMail"
			select="$IFTFCC/SG11[NAD/NAD0101 = $Ip_id]/SG12/COM[COM0102 = 'MA' or COM0102 = 'EM']/COM0101"/>


		<!-- Consignor (CZ) for notes-->

		<xsl:variable name="CzPartyTAX"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG13/RFF[RFF0101 = 'VA']/RFF0102"/>

		<xsl:variable name="CzName" select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0401"/>

		<xsl:variable name="CzStreet1" select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0501"/>

		<xsl:variable name="CzStreet2">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0502)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0502"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0503)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0503"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CzCity">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0601)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0601"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0504)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0504"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CzZip" select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0801"/>

		<xsl:variable name="CzCountry" select="$IFTFCC/SG11/NAD[NAD0101 = 'CZ']/NAD0901"/>

		<xsl:variable name="CzRef"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG12/CTA[CTA0101 = 'OC']/CTA0202"/>

		<xsl:variable name="CzRefName">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG12/CTA[CTA0101 = 'PE']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG12/CTA[CTA0101 = 'PE']/CTA0202"/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG12/CTA[CTA0101 = 'IC']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG12/CTA[CTA0101 = 'IC']/CTA0202"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CzRefTlf"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG12/COM[COM0102 = 'TE']/COM0101"/>

		<xsl:variable name="CzRefMail"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CZ']/SG12/COM[COM0102 = 'MA' or COM0102 = 'EM']/COM0101"/>


		<!-- Consignee (CN)  for notes-->

		<xsl:variable name="CnPartyTAX"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG13/RFF[RFF0101 = 'VA']/RFF0102"/>

		<xsl:variable name="CnName" select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0401"/>

		<xsl:variable name="CnStreet1" select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0501"/>

		<xsl:variable name="CnStreet2">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0502)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0502"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0503)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0503"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CnCity">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0601)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0601"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0504)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0504"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CnZip" select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0801"/>

		<xsl:variable name="CnCountry" select="$IFTFCC/SG11/NAD[NAD0101 = 'CN']/NAD0901"/>

		<xsl:variable name="CnRef"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG12/CTA[CTA0101 = 'OC']/CTA0202"/>

		<xsl:variable name="CnRefName">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG12/CTA[CTA0101 = 'PE']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG12/CTA[CTA0101 = 'PE']/CTA0202"/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG12/CTA[CTA0101 = 'IC']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG12/CTA[CTA0101 = 'IC']/CTA0202"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CnRefTlf"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG12/COM[COM0102 = 'TE']/COM0101"/>

		<xsl:variable name="CnRefMail"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'CN']/SG12/COM[COM0102 = 'MA' or COM0102 = 'EM']/COM0101"/>

		<!-- Notify Party (NI)  for notes-->

		<xsl:variable name="NiPartyTAX"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG13/RFF[RFF0101 = 'VA']/RFF0102"/>

		<xsl:variable name="NiName" select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0401"/>

		<xsl:variable name="NiStreet1" select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0501"/>

		<xsl:variable name="NiStreet2">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0502)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0502"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0503)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0503"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="NiCity">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0601)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0601"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0504)">
					<xsl:value-of select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0504"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="NiZip" select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0801"/>

		<xsl:variable name="NiCountry" select="$IFTFCC/SG11/NAD[NAD0101 = 'NI']/NAD0901"/>

		<xsl:variable name="NiRef"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG12/CTA[CTA0101 = 'OC']/CTA0202"/>

		<xsl:variable name="NiRefName">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG12/CTA[CTA0101 = 'PE']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG12/CTA[CTA0101 = 'PE']/CTA0202"/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG12/CTA[CTA0101 = 'IC']/CTA0202)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG12/CTA[CTA0101 = 'IC']/CTA0202"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="NiRefTlf"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG12/COM[COM0102 = 'TE']/COM0101"/>

		<xsl:variable name="NiRefMail"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'NI']/SG12/COM[COM0102 = 'MA' or COM0102 = 'EM']/COM0101"/>


		<xsl:variable name="DelDate" select="$IFTFCC/DTM[DTM0101 = '35']/DTM0102"/>

		<!-- Delivery (DP) -->

		<xsl:variable name="DelIDtype" select="'GLN'"/>

		<xsl:variable name="DelID" select="$IFTFCC/SG11/NAD[NAD0101 = 'DP' and NAD0203 = 9]/NAD0201"/>

		<xsl:variable name="DelName" select="$IFTFCC/SG11/NAD[NAD0101 = 'DP']/NAD0401"/>

		<xsl:variable name="DelStreet1" select="$IFTFCC/SG11/NAD[NAD0101 = 'DP']/NAD0501"/>

		<xsl:variable name="DelStreet2" select="$IFTFCC/SG11/NAD[NAD0101 = 'DP']/NAD0502"/>

		<xsl:variable name="DelCity" select="$IFTFCC/SG11/NAD[NAD0101 = 'DP']/NAD0601"/>

		<xsl:variable name="DelZip" select="$IFTFCC/SG11/NAD[NAD0101 = 'DP']/NAD0801"/>

		<xsl:variable name="DelState" select="''"/>

		<xsl:variable name="DelCountry" select="$IFTFCC/SG11/NAD[NAD0101 = 'DP']/NAD0901"/>


		<xsl:variable name="PayType" select="''"/>

		<xsl:variable name="PayDate">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/DTM[DTM0101 = '13']/DTM0102)">
					<xsl:value-of select="$IFTFCC/DTM[DTM0101 = '13']/DTM0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$IFTFCC/DTM[DTM0101 = '140']/DTM0102"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="InvoicePayment31AccountNumber">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH' or FII0101 = 'BF']/FII0201)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH' or FII0101 = 'BF']/FII0201"
					/>
				</xsl:when>
				<xsl:when
					test="UNB/UNB0201 = 'CMACGM' and string($IFTFCC/SG11[NAD/NAD0101 = 'RB' or NAD/NAD0101 = 'SU' or NAD/NAD0101 = 'RE']/SG13/RFF[RFF0101 = 'ANP']/RFF0102)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'RB' or NAD/NAD0101 = 'SU' or NAD/NAD0101 = 'RE']/SG13/RFF[RFF0101 = 'ANP']/RFF0102"
					/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="InvoicePayment31PaymentNote" select="''"/>

		<xsl:variable name="InvoicePayment31BankID">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH' or FII0101 = 'BF']/FII0301)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH' or FII0101 = 'BF']/FII0301"
					/>
				</xsl:when>
				<xsl:when
					test="UNB/UNB0201 = 'CMACGM' and string($IFTFCC/SG11[NAD/NAD0101 = 'RB' or NAD/NAD0101 = 'SU' or NAD/NAD0101 = 'RE']/SG13/RFF[RFF0101 = 'ANM']/RFF0102)">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = 'RB' or NAD/NAD0101 = 'SU' or NAD/NAD0101 = 'RE']/SG13/RFF[RFF0101 = 'ANM']/RFF0102"
					/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="InvoicePayment31ClearingID" select="''"/>

		<xsl:variable name="InvoicePayment31BranchName" select="''"/>

		<xsl:variable name="InvoicePayment31StreetName" select="''"/>

		<xsl:variable name="InvoicePayment31AdditonalStreetName" select="''"/>

		<xsl:variable name="InvoicePayment31BuildingNumber" select="''"/>

		<xsl:variable name="InvoicePayment31CityName" select="''"/>

		<xsl:variable name="InvoicePayment31PostalZone" select="''"/>

		<xsl:variable name="InvoicePayment31CountryCode" select="''"/>

		<xsl:variable name="InvoicePayment42ChannelCode" select="''"/>

		<xsl:variable name="ip1"
			select="$IFTFCC/SG11[NAD/NAD0101 = 'PE' or NAD/NAD0101 = 'SU' or NAD/NAD0101 = 'II']/SG13/RFF[RFF0101 = 'PQ']/RFF0102"/>

		<xsl:variable name="InvoicePayment42ID">
			<xsl:choose>
				<xsl:when test="string($ip1) and ($SeCountry = 'FI' or $SeCountry = 'NO')">
					<xsl:value-of select="$ip1"/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH']/FII0301) and ($SeCountry = 'FI' or $SeCountry = 'NO')">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH']/FII0301"/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH']/FII0201) and ($SeCountry = 'FI' or $SeCountry = 'NO')">
					<xsl:value-of
						select="$IFTFCC/SG11[NAD/NAD0101 = $Se_id]/FII[FII0101 = 'RH']/FII0201"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="InvoicePayment42AccountNumber" select="''"/>

		<xsl:variable name="InvoicePayment42PaymentNote" select="''"/>

		<xsl:variable name="InvoicePayment42RegNumber" select="''"/>

		<xsl:variable name="InvoicePayment42BranchName" select="''"/>

		<xsl:variable name="isSWIFT"
			select="
				string($InvoicePayment31BankID) and
				string-length(translate(substring($InvoicePayment31BankID, 1, 5),
				'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ', '')) = 0"> </xsl:variable>

		<xsl:variable name="PayTerms" select="''"/>


		<xsl:variable name="AllowanceAmount" select="''"/>

		<xsl:variable name="AllowanceReason" select="''"/>

		<xsl:variable name="ChargeAmount" select="''"/>

		<xsl:variable name="ChargeReason" select="''"/>

		<xsl:variable name="ChargeVatCat" select="''"/>


		<xsl:variable name="TaxExchangeRateTargetCurrencyCode">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG5/CUX[CUX0103 = '10']/CUX0102) and $IFTFCC/SG5/CUX[CUX0103 = '10']/CUX0102 != $CurrencyCode">
					<xsl:value-of select="$IFTFCC/SG5/CUX[CUX0103 = '10']/CUX0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="TaxExchangeRateTargetAmount">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG3/MOA[MOA0101 = '124' and MOA0103 = $TaxExchangeRateTargetCurrencyCode]/MOA0102)">
					<xsl:value-of
						select="$IFTFCC/SG3/MOA[MOA0101 = '124' and MOA0103 = $TaxExchangeRateTargetCurrencyCode]/MOA0102"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="TaxExchangeRateCalculationRate">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG5/CUX/CUX0103) and $IFTFCC/SG5/CUX/CUX0103 != 1">
					<xsl:value-of select="$IFTFCC/SG5/CUX/CUX0103"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="TaxExchangeRateDate">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/DTM[DTM0101 = '134']/DTM0102)">
					<xsl:value-of select="$IFTFCC/DTM[DTM0101 = '134']/DTM0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$TaxDate"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="TaxRate" select="''"/>

		<xsl:variable name="TaxRateCode" select="''"/>

		<xsl:variable name="TaxSchemeID" select="''"/>

		<xsl:variable name="TaxAmount">
			<xsl:choose>
				<xsl:when
					test="string($IFTFCC/SG3/MOA[MOA0101 = '124' and (MOA0103 = $CurrencyCode or not(string(MOA0103)))]/MOA0102)">
					<xsl:value-of
						select="$IFTFCC/SG3/MOA[MOA0101 = '124' and (MOA0103 = $CurrencyCode or not(string(MOA0103)))]/MOA0102"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="TaxableAmount">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG3/MOA[MOA0101 = '125']/MOA0102)">
					<xsl:value-of select="$IFTFCC/SG3/MOA[MOA0101 = '125']/MOA0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$IFTFCC/SG3/MOA[MOA0101 = '77']/MOA0102"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="LineTotal">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG3/MOA[MOA0101 = '125']/MOA0102)">
					<xsl:value-of select="$IFTFCC/SG3/MOA[MOA0101 = '125']/MOA0102"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$IFTFCC/SG3/MOA[MOA0101 = '77']/MOA0102"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="InvTotal" select="$IFTFCC/SG3/MOA[MOA0101 = '77']/MOA0102"/>


		<!-- Shippingfields -->

		<xsl:variable name="br">
			<xsl:text>&#10;</xsl:text>
		</xsl:variable>

		<xsl:variable name="VesselName">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/TDT/TDT0804)">
					<xsl:value-of select="concat('VesselName: ', $IFTFCC/SG17/TDT/TDT0804, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="Voyage">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/TDT/TDT0201)">
					<xsl:value-of select="concat('Voyage: ', $IFTFCC/SG17/TDT/TDT0201, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="PortOfLoading">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/LOC[LOC0101 = '9']/LOC0204)">
					<xsl:value-of
						select="concat('PortOfLoading: ', $IFTFCC/SG17/LOC[LOC0101 = '9']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG1/LOC[LOC0101 = '9']/LOC0204)">
					<xsl:value-of
						select="concat('PortOfLoading: ', $IFTFCC/SG1/LOC[LOC0101 = '9']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="PortOfDischarge">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/LOC[LOC0101 = '11']/LOC0204)">
					<xsl:value-of
						select="concat('PortOfDischarge: ', $IFTFCC/SG17/LOC[LOC0101 = '11']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG1/LOC[LOC0101 = '11']/LOC0204)">
					<xsl:value-of
						select="concat('PortOfDischarge: ', $IFTFCC/SG1/LOC[LOC0101 = '11']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="PlaceOfDelivery">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/LOC[LOC0101 = '7']/LOC0204)">
					<xsl:value-of
						select="concat('PlaceOfDelivery: ', $IFTFCC/SG17/LOC[LOC0101 = '7']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG1/LOC[LOC0101 = '7']/LOC0204)">
					<xsl:value-of
						select="concat('PlaceOfDelivery: ', $IFTFCC/SG1/LOC[LOC0101 = '7']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="PlaceOfReceipt">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/LOC[LOC0101 = '88']/LOC0204)">
					<xsl:value-of
						select="concat('PlaceOfReceipt: ', $IFTFCC/SG17/LOC[LOC0101 = '88']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG1/LOC[LOC0101 = '88']/LOC0204)">
					<xsl:value-of
						select="concat('PlaceOfReceipt: ', $IFTFCC/SG1/LOC[LOC0101 = '88']/LOC0204, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h26">
			<xsl:apply-templates select="/EDIFACT/MESSAGES/IFTFCC/SG24/EQD[EQD0101 = 'CN']"/>
		</xsl:variable>
		<xsl:variable name="Equipment">
			<xsl:choose>
				<xsl:when test="string($h26)">
					<xsl:value-of select="concat('Equipment: ', $h26, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Package -->
		<xsl:variable name="gd1" select="$IFTFCC/SG19//GID/GID0201"/>
		<xsl:variable name="gd2" select="$IFTFCC/SG19//GID/GID0202"/>
		<xsl:variable name="gd3" select="$IFTFCC/SG19//GID/GID0205"/>
		<xsl:variable name="gd4" select="$IFTFCC/SG19//GID/GID0206"/>
		<xsl:variable name="Package">
			<xsl:choose>
				<xsl:when test="string($gd1) or string($gd2) or string($gd3) or string($gd4)">
					<xsl:value-of
						select="concat('Goods Description: ', $gd1, ' ', $gd2, ' ', $gd3, ' ', $gd4, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Weight measure -->
		<xsl:variable name="m1">
			<xsl:apply-templates select="/EDIFACT/MESSAGES/IFTFCC/SG24/MEA[MEA0101 = 'AAI']"/>
		</xsl:variable>
		<xsl:variable name="Weight">
			<xsl:choose>
				<xsl:when test="string($m1)">
					<xsl:value-of select="concat('Weight: ', $m1, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<!-- Volume measure -->
		<xsl:variable name="m2">
			<xsl:apply-templates select="/EDIFACT/MESSAGES/IFTFCC/SG24/MEA[MEA0101 = 'VOL']"/>
		</xsl:variable>
		<xsl:variable name="Volume">
			<xsl:choose>
				<xsl:when test="string($m2)">
					<xsl:value-of select="concat('Volume: ', $m2, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h29">
			<xsl:apply-templates select="/EDIFACT/MESSAGES/IFTFCC/SG28/CNI"/>
		</xsl:variable>
		<xsl:variable name="BOL">
			<xsl:choose>
				<xsl:when test="string($h29)">
					<xsl:value-of select="concat('B/L: ', $h29, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="ArrivalDate">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/DTM[DTM0101 = '178']/DTM0102)">
					<xsl:value-of select="$IFTFCC/SG17/DTM[DTM0101 = '178']/DTM0102"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG17/DTM[DTM0101 = '132']/DTM0102)">
					<xsl:value-of select="$IFTFCC/SG17/DTM[DTM0101 = '132']/DTM0102"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG17/DTM[DTM0101 = '252']/DTM0102)">
					<xsl:value-of select="$IFTFCC/SG17/DTM[DTM0101 = '252']/DTM0102"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="DepartureDate">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG17/DTM[DTM0101 = '186']/DTM0102)">
					<xsl:value-of select="$IFTFCC/SG17/DTM[DTM0101 = '186']/DTM0102"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG17/DTM[DTM0101 = '133']/DTM0102)">
					<xsl:value-of select="$IFTFCC/SG17/DTM[DTM0101 = '133']/DTM0102"/>
				</xsl:when>
				<xsl:when test="string($IFTFCC/SG17/DTM[DTM0101 = '253']/DTM0102)">
					<xsl:value-of select="$IFTFCC/SG17/DTM[DTM0101 = '253']/DTM0102"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>




		<!-- Global conversions etc. -->

		<xsl:variable name="fIpAddressFlag">
			<xsl:choose>
				<xsl:when
					test="string($IpStreet1) or string($IpStreet2) or string($IpCity) or string($IpZip) or string($IpCountry)">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSeAddressFlag">
			<xsl:choose>
				<xsl:when
					test="string($SeStreet1) or string($SeStreet2) or string($SeCity) or string($SeZip) or string($SeCountry)">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fPaymentFlag">
			<xsl:choose>
				<xsl:when
					test="
						string($InvoicePayment42AccountNumber) or string($InvoicePayment31BankID)
						or string($InvoicePayment42ID) or string($PayDate)">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fPayType">
			<xsl:choose>
				<!-- Do not reenable this until CMA is moved to BBW
				<xsl:when test="string($InvoicePayment31AccountNumber) and $isSWIFT = 'true' and
					string($InvoicePayment31ClearingID)"><xsl:value-of select="'31noneu'"/>
				</xsl:when>
				<xsl:when test="string($InvoicePayment31AccountNumber) and $isSWIFT = 'true' and
					not(string($InvoicePayment31ClearingID))"><xsl:value-of select="'31eu'"/>
				</xsl:when> -->
				<xsl:when
					test="string($InvoicePayment42AccountNumber) and string($InvoicePayment42RegNumber) and not($isSWIFT)">
					<xsl:value-of select="'42'"/>
				</xsl:when>
				<xsl:when
					test="string($InvoicePayment42ID) and ($SeCountry = 'FI' or $SeCountry = 'NO')">
					<xsl:value-of select="'42'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'1'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fInvoicePayment42ChannelCode">
			<xsl:choose>
				<xsl:when test="string($InvoicePayment42ChannelCode)">
					<xsl:value-of select="$InvoicePayment42ChannelCode"/>
				</xsl:when>
				<xsl:when test="$SeCountry = 'DK'">
					<xsl:value-of select="'DK:BANK'"/>
				</xsl:when>
				<xsl:when test="$SeCountry = 'FI'">
					<xsl:value-of select="'FI:BANK'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="concat($SeCountry, ':BANK')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fInvoicePayment31PaymentNote">
			<xsl:choose>
				<xsl:when test="string($InvoicePayment31PaymentNote)">
					<xsl:value-of select="$InvoicePayment31PaymentNote"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$InvoicePayment42ID"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxExchangeFlag">
			<xsl:choose>
				<xsl:when test="count($IFTFCC/SG4) &lt; 2 and string($TaxExchangeRateTargetAmount)">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG4/MOA[MOA0101 = '168' and MOA0103 = $TaxExchangeRateTargetCurrencyCode]/MOA0102)">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:when
					test="string($IFTFCC/SG4/MOA[MOA0101 = '289' and MOA0103 = $TaxExchangeRateTargetCurrencyCode]/MOA0102)">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fInvoiceTypeCode">
			<xsl:choose>
				<xsl:when test="$InvoiceTypeCode = 'INV'">
					<xsl:value-of select="'380'"/>
				</xsl:when>
				<xsl:when test="$InvoiceTypeCode = '325'">
					<xsl:value-of select="'325'"/>
				</xsl:when>
				<xsl:when test="$InvoiceTypeCode = '386'">
					<xsl:value-of select="'386'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'380'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h4"
			select="format-number(number(translate($LineTotal, ',', '.')), '##.00')"/>
		<xsl:variable name="fLineTotal">
			<xsl:choose>
				<xsl:when test="$h4 = 'NaN'">
					<xsl:value-of select="'0.00'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h4"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h2"
			select="format-number(number(translate($TaxAmount, ',', '.')), '#0.00')"/>
		<xsl:variable name="fTaxAmount">
			<xsl:choose>
				<xsl:when test="$h2 = 'NaN'">
					<xsl:value-of select="'0.00'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h2"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h1"
			select="format-number(number(translate($TaxableAmount, ',', '.')), '##.00')"/>
		<xsl:variable name="fTaxableAmount">
			<xsl:choose>
				<xsl:when test="$h1 = 'NaN'">
					<xsl:value-of select="'0.00'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxRate">
			<xsl:choose>
				<xsl:when test="string($TaxRate)">
					<xsl:value-of select="$TaxRate"/>
				</xsl:when>
				<xsl:when test="$fTaxableAmount = 0">
					<xsl:value-of select="''"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="format-number(($fTaxAmount div $fTaxableAmount) * 100, '##')"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h5"
			select="format-number(number(translate($TaxExchangeRateTargetAmount, ',', '.')), '##.00')"/>
		<xsl:variable name="fTaxExchangeRateTargetAmount">
			<xsl:choose>
				<xsl:when test="$h5 = 'NaN'">
					<xsl:value-of select="'0.00'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h5"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h3"
			select="format-number(number(translate($InvTotal, ',', '.')), '##.00')"/>
		<xsl:variable name="fInvTotal">
			<xsl:choose>
				<xsl:when test="$h3 = 'NaN'">
					<xsl:value-of select="'0.00'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h3"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h8"
			select="format-number(number(translate($AllowanceAmount, ',', '.')), '##.00')"/>
		<xsl:variable name="fAllowanceAmount">
			<xsl:choose>
				<xsl:when test="$h8 = 'NaN'">
					<xsl:value-of select="'0.00'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h8"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h9"
			select="format-number(number(translate($ChargeAmount, ',', '.')), '##.00')"/>
		<xsl:variable name="fChargeAmount">
			<xsl:choose>
				<xsl:when test="$h9 = 'NaN'">
					<xsl:value-of select="'0.00'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h9"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSeEndpointIDscheme">
			<xsl:choose>
				<xsl:when test="string($SeEndpointIDscheme)">
					<xsl:value-of select="$SeEndpointIDscheme"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'ZZ'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpEndpointIDscheme">
			<xsl:choose>
				<xsl:when test="string($IpEndpointIDscheme)">
					<xsl:value-of select="$IpEndpointIDscheme"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'ZZ'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSePartyTAXscheme">
			<xsl:choose>
				<xsl:when test="string($SePartyTAXscheme)">
					<xsl:value-of select="$SePartyTAXscheme"/>
				</xsl:when>
				<xsl:when
					test="$SeCountry = 'MY' and (string-length($SePartyTAX) = 12 or string-length($SePartyTAX) = 16)">
					<xsl:value-of select="'MY:GST'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="(bbw:lookupTableValue('PartyTAXscheme', 'CountryCode', 'PartyTAXscheme', $SeCountry, 'TS:VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSePartyLEGALscheme">
			<xsl:choose>
				<xsl:when test="string($SePartyLEGALscheme)">
					<xsl:value-of select="$SePartyLEGALscheme"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="(bbw:lookupTableValue('PartyLEGALscheme', 'CountryCode', 'PartyLEGALscheme', $SeCountry, 'VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpPartyTAXscheme">
			<xsl:choose>
				<xsl:when test="string($IpPartyTAXscheme)">
					<xsl:value-of select="$IpPartyTAXscheme"/>
				</xsl:when>
				<xsl:when
					test="$IpCountry = 'MY' and (string-length($IpPartyTAX) = 12 or string-length($IpPartyTAX) = 16)">
					<xsl:value-of select="'MY:GST'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="(bbw:lookupTableValue('PartyTAXscheme', 'CountryCode', 'PartyTAXscheme', $IpCountry, 'TS:VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpPartyLEGALscheme">
			<xsl:choose>
				<xsl:when test="string($IpPartyLEGALscheme)">
					<xsl:value-of select="$IpPartyLEGALscheme"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="(bbw:lookupTableValue('PartyLEGALscheme', 'CountryCode', 'PartyLEGALscheme', $IpCountry, 'VAT'))[1]"
						disable-output-escaping="no"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxSchemeID">
			<xsl:choose>
				<xsl:when test="string($TaxSchemeID)">
					<xsl:value-of select="$TaxSchemeID"/>
				</xsl:when>
				<xsl:when test="$IpCountry = 'SG'">
					<xsl:value-of select="'GST'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'VAT'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h15" select="$DocDate"/>
		<xsl:variable name="fDocDate">
			<xsl:choose>
				<xsl:when test="string-length($h15) = 8 or string-length($h15) = 12">
					<xsl:value-of
						select="concat(substring($h15, 1, 4), '-', substring($h15, 5, 2), '-', substring($h15, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h15"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h16" select="$RefDate"/>
		<xsl:variable name="fRefDate">
			<xsl:choose>
				<xsl:when test="string-length($h16) = 8 or string-length($h16) = 12">
					<xsl:value-of
						select="concat(substring($h16, 1, 4), '-', substring($h16, 5, 2), '-', substring($h16, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h16"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h17" select="$DelDate"/>
		<xsl:variable name="fDelDate">
			<xsl:choose>
				<xsl:when test="string-length($h17) = 8 or string-length($h17) = 12">
					<xsl:value-of
						select="concat(substring($h17, 1, 4), '-', substring($h17, 5, 2), '-', substring($h17, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h17"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h18" select="$PayDate"/>
		<xsl:variable name="fPayDate">
			<xsl:choose>
				<xsl:when test="string-length($h18) = 8 or string-length($h18) = 12">
					<xsl:value-of
						select="concat(substring($h18, 1, 4), '-', substring($h18, 5, 2), '-', substring($h18, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h18"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h19" select="$TaxDate"/>
		<xsl:variable name="fTaxDate">
			<xsl:choose>
				<xsl:when test="string-length($h19) = 8 or string-length($h19) = 12">
					<xsl:value-of
						select="concat(substring($h19, 1, 4), '-', substring($h19, 5, 2), '-', substring($h19, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h19"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h21" select="$TaxExchangeRateDate"/>
		<xsl:variable name="fTaxExchangeRateDate">
			<xsl:choose>
				<xsl:when test="string-length($h21) = 8 or string-length($h21) = 12">
					<xsl:value-of
						select="concat(substring($h21, 1, 4), '-', substring($h21, 5, 2), '-', substring($h21, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h21"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h25" select="$ArrivalDate"/>
		<xsl:variable name="fArrivalDate">
			<xsl:choose>
				<xsl:when test="string-length($h25) = 8 or string-length($h25) = 12">
					<xsl:value-of
						select="concat(substring($h25, 1, 4), '-', substring($h25, 5, 2), '-', substring($h25, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h25"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ffArrivalDate">
			<xsl:choose>
				<xsl:when test="string($ArrivalDate)">
					<xsl:value-of select="concat('ArrivalDate: ', $fArrivalDate, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h27" select="$DepartureDate"/>
		<xsl:variable name="fDepartureDate">
			<xsl:choose>
				<xsl:when test="string-length($h27) = 8 or string-length($h27) = 12">
					<xsl:value-of
						select="concat(substring($h27, 1, 4), '-', substring($h27, 5, 2), '-', substring($h27, 7, 2))"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$h27"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="ffDepartureDate">
			<xsl:choose>
				<xsl:when test="string($DepartureDate)">
					<xsl:value-of select="concat('DepartureDate: ', $fDepartureDate, $br)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CzFlag">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11[NAD/NAD0101 = 'CZ'])">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="CnFlag">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11/NAD[NAD0101 = 'CN'])">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="NiFlag">
			<xsl:choose>
				<xsl:when test="string($IFTFCC/SG11[NAD/NAD0101 = 'NI'])">
					<xsl:value-of select="'true'"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'false'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="Consignor">
			<xsl:choose>
				<xsl:when test="$CzFlag = 'true'">
					<xsl:value-of
						select="concat('Consignor: ', $CzName, ' ', $CzStreet1, ' ', $CzStreet2, ' ', $CzCity, ' ', $CzZip, ' ', $CzCountry, ' ', $CzPartyTAX, ' ', $CzRefName, ' ', $CzRefTlf, ' ', $CzRefMail, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="Consignee">
			<xsl:choose>
				<xsl:when test="$CnFlag = 'true'">
					<xsl:value-of
						select="concat('Consignee: ', $CnName, ' ', $CnStreet1, ' ', $CnStreet2, ' ', $CnCity, ' ', $CnZip, ' ', $CnCountry, ' ', $CnPartyTAX, ' ', $CnRefName, ' ', $CnRefTlf, ' ', $CnRefMail, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="NotifyParty">
			<xsl:choose>
				<xsl:when test="$NiFlag = 'true'">
					<xsl:value-of
						select="concat('Notify party: ', $NiName, ' ', $NiStreet1, ' ', $NiStreet2, ' ', $NiCity, ' ', $NiZip, ' ', $NiCountry, ' ', $NiPartyTAX, ' ', $NiRefName, ' ', $NiRefTlf, ' ', $NiRefMail, $br)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="fNote">
			<xsl:choose>
				<xsl:when test="$ShippingFlag = 'false' and string($Note)">
					<xsl:value-of
						select="concat($Package, $Weight, $Volume, $Consignor, $Consignee, $NotifyParty, 'Freetext: ', $Note)"
					/>
				</xsl:when>
				<xsl:when test="string($Note)">
					<xsl:value-of
						select="concat($VesselName, $Voyage, $PortOfLoading, $PortOfDischarge, $PlaceOfReceipt, $PlaceOfDelivery, $Package, $Weight, $Volume, $Equipment, $BOL, $ffDepartureDate, $ffArrivalDate, $Consignor, $Consignee, $NotifyParty, 'Freetext: ', $Note)"
					/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of
						select="concat($VesselName, $Voyage, $PortOfLoading, $PortOfDischarge, $PlaceOfReceipt, $PlaceOfDelivery, $Package, $Weight, $Volume, $Equipment, $BOL, $ffDepartureDate, $ffArrivalDate, $Consignor, $Consignee, $NotifyParty)"
					/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:if test="$MSG">
			<xsl:value-of
				select="metadata-util:put($MSG, 'com_babelway_messaging_context_message_reference', string(concat('INV', $DocID, '_', $SeCountry)))"
			/>
		</xsl:if>

		<!-- Start of Invoice -->
		<Invoice>
			<xsl:attribute name="xsi:schemaLocation"
				>urn:oasis:names:specification:ubl:schema:xsd:Invoice-2
				UBL-Invoice-2.0.xsd</xsl:attribute>

			<cbc:UBLVersionID>
				<xsl:value-of select="$UBLVersionID"/>
			</cbc:UBLVersionID>

			<cbc:CustomizationID>
				<xsl:value-of select="$CustomizationID"/>
			</cbc:CustomizationID>

			<cbc:ProfileID schemeAgencyID="{$ProfileID_schemeAgencyID}"
				schemeID="{$ProfileID_schemeID}">
				<xsl:value-of select="$ProfileID"/>
			</cbc:ProfileID>

			<cbc:ID>
				<xsl:value-of select="$DocID"/>
			</cbc:ID>

			<cbc:IssueDate>
				<xsl:value-of select="$fDocDate"/>
			</cbc:IssueDate>

			<cbc:InvoiceTypeCode listAgencyID="6" listID="UN/ECE 1001 Subset">
				<xsl:value-of select="$fInvoiceTypeCode"/>
			</cbc:InvoiceTypeCode>

			<xsl:if test="string($fNote)">
				<cbc:Note>
					<xsl:value-of select="$fNote"/>
				</cbc:Note>
			</xsl:if>

			<xsl:if test="string($TaxDate)">
				<cbc:TaxPointDate>
					<xsl:value-of select="$fTaxDate"/>
				</cbc:TaxPointDate>
			</xsl:if>

			<cbc:DocumentCurrencyCode>
				<xsl:value-of select="$CurrencyCode"/>
			</cbc:DocumentCurrencyCode>

			<xsl:if test="string($AccCost)">
				<cbc:AccountingCost>
					<xsl:value-of select="$AccCost"/>
				</cbc:AccountingCost>
			</xsl:if>

			<xsl:if test="string($RefID)">
				<cac:OrderReference>
					<cbc:ID>
						<xsl:value-of select="$RefID"/>
					</cbc:ID>
					<xsl:if test="string($fRefDate)">
						<cbc:IssueDate>
							<xsl:value-of select="$fRefDate"/>
						</cbc:IssueDate>
					</xsl:if>
				</cac:OrderReference>
			</xsl:if>

			<xsl:if test="string($InvoiceFileReferenceID)">
				<cac:AdditionalDocumentReference>
					<cbc:ID>
						<xsl:value-of select="$InvoiceFileReferenceID"/>
					</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">File
						ID</cbc:DocumentTypeCode>
				</cac:AdditionalDocumentReference>
			</xsl:if>

			<xsl:if test="string($InvoiceBOLReferenceID)">
				<cac:AdditionalDocumentReference>
					<cbc:ID>
						<xsl:value-of select="$InvoiceBOLReferenceID"/>
					</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">BOL
						ID</cbc:DocumentTypeCode>
				</cac:AdditionalDocumentReference>
			</xsl:if>

			<xsl:if test="string($InvoiceBookingReferenceID)">
				<cac:AdditionalDocumentReference>
					<cbc:ID>
						<xsl:value-of select="$InvoiceBookingReferenceID"/>
					</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode"
						>BookingNumber</cbc:DocumentTypeCode>
				</cac:AdditionalDocumentReference>
			</xsl:if>

			<xsl:if test="bbw:metadata('inFile') != ''">
				<cac:AdditionalDocumentReference>
					<cbc:ID>1</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode"
						>sourcedocument</cbc:DocumentTypeCode>
					<cac:Attachment>
						<cbc:EmbeddedDocumentBinaryObject encodingCode="Base64"
							filename="sourcedocument" mimeCode="text/plain">
							<xsl:value-of select="bbw:metadataBase64('inFile')"
								disable-output-escaping="no"/>
						</cbc:EmbeddedDocumentBinaryObject>
					</cac:Attachment>
				</cac:AdditionalDocumentReference>
			</xsl:if>

			<xsl:if test="bbw:metadata('attachment') != ''">
				<cac:AdditionalDocumentReference>
					<cbc:ID>1</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode"
						>attachment</cbc:DocumentTypeCode>
					<cac:Attachment>
						<cbc:EmbeddedDocumentBinaryObject encodingCode="Base64"
							filename="attachment" mimeCode="bbw:metadata('mimeCode')">
							<xsl:value-of select="bbw:metadataBase64('attachment')"
								disable-output-escaping="no"/>
						</cbc:EmbeddedDocumentBinaryObject>
					</cac:Attachment>
				</cac:AdditionalDocumentReference>
			</xsl:if>

			<cac:AccountingSupplierParty>
				<cac:Party>
					<xsl:if test="string($SeEndpointID)">
						<cbc:EndpointID schemeID="{$fSeEndpointIDscheme}">
							<xsl:value-of select="$SeEndpointID"/>
						</cbc:EndpointID>
					</xsl:if>
					<xsl:if test="string($SePartySenderAssigned)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="SenderAssigned">
								<xsl:value-of select="$SePartySenderAssigned"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartyGLN)">
						<cac:PartyIdentification>
							<cbc:ID schemeAgencyID="9" schemeID="GLN">
								<xsl:value-of select="$SePartyGLN"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartyTAX)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fSePartyTAXscheme}">
								<xsl:value-of select="$SePartyTAX"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartyLEGAL)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fSePartyLEGALscheme}">
								<xsl:value-of select="$SePartyLEGAL"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SeName)">
						<cac:PartyName>
							<cbc:Name>
								<xsl:value-of select="$SeName"/>
							</cbc:Name>
						</cac:PartyName>
					</xsl:if>
					<xsl:if test="$fSeAddressFlag = 'true'">
						<cac:PostalAddress>
							<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477"
								>5</cbc:AddressFormatCode>
							<xsl:if test="string($SeStreet1)">
								<cbc:StreetName>
									<xsl:value-of select="$SeStreet1"/>
								</cbc:StreetName>
							</xsl:if>
							<xsl:if test="string($SeStreet2)">
								<cbc:AdditionalStreetName>
									<xsl:value-of select="$SeStreet2"/>
								</cbc:AdditionalStreetName>
							</xsl:if>
							<xsl:if test="string($SeCity)">
								<cbc:CityName>
									<xsl:value-of select="$SeCity"/>
								</cbc:CityName>
							</xsl:if>
							<xsl:if test="string($SeZip)">
								<cbc:PostalZone>
									<xsl:value-of select="$SeZip"/>
								</cbc:PostalZone>
							</xsl:if>
							<xsl:if test="string($SeState)">
								<cbc:CountrySubentity>
									<xsl:value-of select="$SeState"/>
								</cbc:CountrySubentity>
							</xsl:if>
							<xsl:if test="string($SeCountry)">
								<cac:Country>
									<cbc:IdentificationCode>
										<xsl:value-of select="$SeCountry"/>
									</cbc:IdentificationCode>
								</cac:Country>
							</xsl:if>
						</cac:PostalAddress>
					</xsl:if>
					<xsl:if test="string($SePartyTAX)">
						<cac:PartyTaxScheme>
							<cbc:CompanyID schemeID="{$fSePartyTAXscheme}">
								<xsl:value-of select="$SePartyTAX"/>
							</cbc:CompanyID>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
									schemeVersionID="D08B">
									<xsl:value-of select="$fTaxSchemeID"/>
								</cbc:ID>
								<cbc:Name>
									<xsl:value-of select="$fTaxSchemeID"/>
								</cbc:Name>
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
					</xsl:if>
					<xsl:if test="string($SePartyLEGAL)">
						<cac:PartyLegalEntity>
							<cbc:RegistrationName>
								<xsl:value-of select="$SeName"/>
							</cbc:RegistrationName>
							<cbc:CompanyID schemeID="{$fSePartyLEGALscheme}">
								<xsl:value-of select="$SePartyLEGAL"/>
							</cbc:CompanyID>
						</cac:PartyLegalEntity>
					</xsl:if>
					<xsl:if test="string($SeRefName) or string($SeRefTlf) or string($SeRefMail)">
						<cac:Contact>
							<xsl:if test="string($SeRefName)">
								<cbc:Name>
									<xsl:value-of select="$SeRefName"/>
								</cbc:Name>
							</xsl:if>
							<xsl:if test="string($SeRefTlf)">
								<cbc:Telephone>
									<xsl:value-of select="$SeRefTlf"/>
								</cbc:Telephone>
							</xsl:if>
							<xsl:if test="string($SeRefMail)">
								<cbc:ElectronicMail>
									<xsl:value-of select="$SeRefMail"/>
								</cbc:ElectronicMail>
							</xsl:if>
						</cac:Contact>
					</xsl:if>
				</cac:Party>
			</cac:AccountingSupplierParty>

			<cac:AccountingCustomerParty>
				<xsl:if test="string($IpCustomerAssignedAccountID)">
					<cbc:CustomerAssignedAccountID>
						<xsl:value-of select="$IpCustomerAssignedAccountID"/>
					</cbc:CustomerAssignedAccountID>
				</xsl:if>
				<cac:Party>
					<xsl:if test="string($IpEndpointID)">
						<cbc:EndpointID schemeID="{$fIpEndpointIDscheme}">
							<xsl:value-of select="$IpEndpointID"/>
						</cbc:EndpointID>
					</xsl:if>
					<xsl:if test="string($IpPartySenderAssigned)">
						<xsl:variable name="SAtag1"
							select="substring-before($IpPartySenderAssigned, '$')"/>
						<xsl:variable name="h22"
							select="substring-after($IpPartySenderAssigned, '$')"/>
						<xsl:variable name="SAtag2" select="substring-before($h22, '$')"/>
						<xsl:variable name="h23" select="substring-after($h22, '$')"/>
						<xsl:variable name="SAtag3">
							<xsl:choose>
								<xsl:when test="contains($h23, '$')">
									<xsl:value-of select="substring-before($h23, '$')"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$h23"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="h24" select="substring-after($h23, '$')"/>
						<xsl:variable name="SAtag4" select="substring-before($h24, '$')"/>
						<xsl:variable name="SAtag5" select="substring-after($h24, '$')"/>
						<xsl:variable name="SAtype">
							<xsl:choose>
								<xsl:when test="string($SAtag4) and string($SAtag5)">
									<xsl:value-of select="'4'"/>
								</xsl:when>
								<xsl:when test="string($SAtag3) and string($SAtag1)">
									<xsl:value-of select="'3'"/>
								</xsl:when>
								<xsl:when test="string($SAtag3)">
									<xsl:value-of select="'2'"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'1'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:choose>
							<xsl:when test="$SAtype = '1'">
								<cac:PartyIdentification>
									<cbc:ID schemeID="SenderAssigned">
										<xsl:value-of select="$IpPartySenderAssigned"/>
									</cbc:ID>
								</cac:PartyIdentification>
							</xsl:when>
							<xsl:when test="$SAtype = '2'">
								<cac:PartyIdentification>
									<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag2}">
										<xsl:value-of select="$SAtag3"/>
									</cbc:ID>
								</cac:PartyIdentification>
							</xsl:when>
							<xsl:when test="$SAtype = '3'">
								<cac:PartyIdentification>
									<cbc:ID schemeID="SenderAssigned">
										<xsl:value-of select="$SAtag1"/>
									</cbc:ID>
								</cac:PartyIdentification>
								<cac:PartyIdentification>
									<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag2}">
										<xsl:value-of select="$SAtag3"/>
									</cbc:ID>
								</cac:PartyIdentification>
							</xsl:when>
							<xsl:when test="$SAtype = '4'">
								<cac:PartyIdentification>
									<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag2}">
										<xsl:value-of select="$SAtag3"/>
									</cbc:ID>
								</cac:PartyIdentification>
								<cac:PartyIdentification>
									<cbc:ID schemeID="SenderAssigned" schemeName="{$SAtag4}">
										<xsl:value-of select="$SAtag5"/>
									</cbc:ID>
								</cac:PartyIdentification>
							</xsl:when>
						</xsl:choose>
					</xsl:if>
					<xsl:if test="string($IpPartyTSGLI)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="TS:GLI">
								<xsl:value-of select="$IpPartyTSGLI"/>
							</cbc:ID>
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
							<cbc:ID schemeAgencyID="9" schemeID="GLN">
								<xsl:value-of select="$IpPartyGLN"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartyTAX)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fIpPartyTAXscheme}">
								<xsl:value-of select="$IpPartyTAX"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartyLEGAL)">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fIpPartyLEGALscheme}">
								<xsl:value-of select="$IpPartyLEGAL"/>
							</cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpName)">
						<cac:PartyName>
							<cbc:Name>
								<xsl:value-of select="$IpName"/>
							</cbc:Name>
						</cac:PartyName>
					</xsl:if>
					<xsl:if test="$fIpAddressFlag = 'true'">
						<cac:PostalAddress>
							<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477"
								>5</cbc:AddressFormatCode>
							<xsl:if test="string($IpStreet1)">
								<cbc:StreetName>
									<xsl:value-of select="$IpStreet1"/>
								</cbc:StreetName>
							</xsl:if>
							<xsl:if test="string($IpStreet2)">
								<cbc:AdditionalStreetName>
									<xsl:value-of select="$IpStreet2"/>
								</cbc:AdditionalStreetName>
							</xsl:if>
							<xsl:if test="string($IpCity)">
								<cbc:CityName>
									<xsl:value-of select="$IpCity"/>
								</cbc:CityName>
							</xsl:if>
							<xsl:if test="string($IpZip)">
								<cbc:PostalZone>
									<xsl:value-of select="$IpZip"/>
								</cbc:PostalZone>
							</xsl:if>
							<xsl:if test="string($IpState)">
								<cbc:CountrySubentity>
									<xsl:value-of select="$IpState"/>
								</cbc:CountrySubentity>
							</xsl:if>
							<xsl:if test="string($IpCountry)">
								<cac:Country>
									<cbc:IdentificationCode>
										<xsl:value-of select="$IpCountry"/>
									</cbc:IdentificationCode>
								</cac:Country>
							</xsl:if>
						</cac:PostalAddress>
					</xsl:if>
					<xsl:if test="string($IpPartyTAX)">
						<cac:PartyTaxScheme>
							<cbc:CompanyID schemeID="{$fIpPartyTAXscheme}">
								<xsl:value-of select="$IpPartyTAX"/>
							</cbc:CompanyID>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
									schemeVersionID="D08B">
									<xsl:value-of select="$fTaxSchemeID"/>
								</cbc:ID>
								<cbc:Name>
									<xsl:value-of select="$fTaxSchemeID"/>
								</cbc:Name>
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
					</xsl:if>
					<xsl:if test="string($IpPartyLEGAL)">
						<cac:PartyLegalEntity>
							<cbc:RegistrationName>
								<xsl:value-of select="$IpName"/>
							</cbc:RegistrationName>
							<cbc:CompanyID schemeID="{$fIpPartyLEGALscheme}">
								<xsl:value-of select="$IpPartyLEGAL"/>
							</cbc:CompanyID>
						</cac:PartyLegalEntity>
					</xsl:if>
					<xsl:if
						test="string($IpRef) or string($IpRefName) or string($IpRefTlf) or string($IpRefMail)">
						<cac:Contact>
							<xsl:if test="string($IpRef)">
								<cbc:ID>
									<xsl:value-of select="$IpRef"/>
								</cbc:ID>
							</xsl:if>
							<xsl:if test="string($IpRefName)">
								<cbc:Name>
									<xsl:value-of select="$IpRefName"/>
								</cbc:Name>
							</xsl:if>
							<xsl:if test="string($IpRefTlf)">
								<cbc:Telephone>
									<xsl:value-of select="$IpRefTlf"/>
								</cbc:Telephone>
							</xsl:if>
							<xsl:if test="string($IpRefMail)">
								<cbc:ElectronicMail>
									<xsl:value-of select="$IpRefMail"/>
								</cbc:ElectronicMail>
							</xsl:if>
						</cac:Contact>
					</xsl:if>
				</cac:Party>
			</cac:AccountingCustomerParty>

			<xsl:if test="string($DelStreet1) or string($DelID) or string($fDelDate)">
				<cac:Delivery>
					<xsl:if test="string($fDelDate)">
						<cbc:ActualDeliveryDate>
							<xsl:value-of select="$fDelDate"/>
						</cbc:ActualDeliveryDate>
					</xsl:if>
					<xsl:if test="string($DelStreet1) or string($DelID)">
						<cac:DeliveryLocation>
							<xsl:if test="string($DelID)">
								<cbc:ID schemeAgencyID="9" schemeID="GLN">
									<xsl:value-of select="$DelID"/>
								</cbc:ID>
							</xsl:if>
							<xsl:if test="string($DelStreet1)">
								<cac:Address>
									<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477"
										>5</cbc:AddressFormatCode>
									<cbc:StreetName>
										<xsl:value-of select="$DelStreet1"/>
									</cbc:StreetName>
									<xsl:if test="string($DelStreet2)">
										<cbc:AdditionalStreetName>
											<xsl:value-of select="$DelStreet2"/>
										</cbc:AdditionalStreetName>
									</xsl:if>
									<xsl:if test="string($DelName)">
										<cbc:MarkAttention>
											<xsl:value-of select="$DelName"/>
										</cbc:MarkAttention>
									</xsl:if>
									<cbc:CityName>
										<xsl:value-of select="$DelCity"/>
									</cbc:CityName>
									<cbc:PostalZone>
										<xsl:value-of select="$DelZip"/>
									</cbc:PostalZone>
									<xsl:if test="string($DelState)">
										<cbc:CountrySubentity>
											<xsl:value-of select="$DelState"/>
										</cbc:CountrySubentity>
									</xsl:if>
									<cac:Country>
										<cbc:IdentificationCode>
											<xsl:value-of select="$DelCountry"/>
										</cbc:IdentificationCode>
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
						<xsl:when test="$fPayType = '42'">
							<cbc:PaymentMeansCode
								listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
								>42</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)">
								<cbc:PaymentDueDate>
									<xsl:value-of select="$fPayDate"/>
								</cbc:PaymentDueDate>
							</xsl:if>
							<cbc:PaymentChannelCode
								listID="urn:tradeshift.com:api:1.0:paymentchannelcode">
								<xsl:value-of select="$fInvoicePayment42ChannelCode"/>
							</cbc:PaymentChannelCode>
							<xsl:if test="string($InvoicePayment42ID)">
								<cbc:PaymentID>
									<xsl:value-of select="$InvoicePayment42ID"/>
								</cbc:PaymentID>
							</xsl:if>
							<xsl:if test="string($InvoicePayment42AccountNumber)">
								<cac:PayeeFinancialAccount>
									<cbc:ID>
										<xsl:value-of select="$InvoicePayment42AccountNumber"/>
									</cbc:ID>
									<xsl:if test="string($InvoicePayment42PaymentNote)">
										<cbc:PaymentNote>
											<xsl:value-of select="$InvoicePayment42PaymentNote"/>
										</cbc:PaymentNote>
									</xsl:if>
									<xsl:if test="string($InvoicePayment42RegNumber)">
										<cac:FinancialInstitutionBranch>
											<cbc:ID>
												<xsl:value-of select="$InvoicePayment42RegNumber"/>
											</cbc:ID>
											<xsl:if test="string($InvoicePayment42BranchName)">
												<cbc:Name>
												<xsl:value-of select="$InvoicePayment42BranchName"
												/>
												</cbc:Name>
											</xsl:if>
										</cac:FinancialInstitutionBranch>
									</xsl:if>
								</cac:PayeeFinancialAccount>
							</xsl:if>
						</xsl:when>

						<xsl:when test="$fPayType = '31eu'">
							<cbc:PaymentMeansCode
								listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
								>31</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)">
								<cbc:PaymentDueDate>
									<xsl:value-of select="$fPayDate"/>
								</cbc:PaymentDueDate>
							</xsl:if>
							<cbc:PaymentChannelCode
								listID="urn:tradeshift.com:api:1.0:paymentchannelcode"
								>IBAN</cbc:PaymentChannelCode>
							<xsl:if test="string($ip1)">
								<cbc:PaymentID>
									<xsl:value-of select="$ip1"/>
								</cbc:PaymentID>
							</xsl:if>
							<cac:PayeeFinancialAccount>
								<cbc:ID>
									<xsl:value-of select="$InvoicePayment31AccountNumber"/>
								</cbc:ID>
								<xsl:if test="string($fInvoicePayment31PaymentNote)">
									<cbc:PaymentNote>
										<xsl:value-of select="$fInvoicePayment31PaymentNote"/>
									</cbc:PaymentNote>
								</xsl:if>
								<cac:FinancialInstitutionBranch>
									<cac:FinancialInstitution>
										<cbc:ID>
											<xsl:value-of select="$InvoicePayment31BankID"/>
										</cbc:ID>
									</cac:FinancialInstitution>
								</cac:FinancialInstitutionBranch>
							</cac:PayeeFinancialAccount>
						</xsl:when>

						<xsl:when test="$fPayType = '31noneu'">
							<cbc:PaymentMeansCode
								listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
								>31</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)">
								<cbc:PaymentDueDate>
									<xsl:value-of select="$fPayDate"/>
								</cbc:PaymentDueDate>
							</xsl:if>
							<cbc:PaymentChannelCode
								listID="urn:tradeshift.com:api:1.0:paymentchannelcode"
								>ZZZ</cbc:PaymentChannelCode>
							<cac:PayeeFinancialAccount>
								<cbc:ID>
									<xsl:value-of select="$InvoicePayment31AccountNumber"/>
								</cbc:ID>
								<xsl:if test="string($InvoicePayment31PaymentNote)">
									<cbc:PaymentNote>
										<xsl:value-of select="$InvoicePayment31PaymentNote"/>
									</cbc:PaymentNote>
								</xsl:if>
								<cac:FinancialInstitutionBranch>
									<cbc:ID>
										<xsl:value-of select="$InvoicePayment31ClearingID"/>
									</cbc:ID>
									<cbc:Name>
										<xsl:value-of select="$InvoicePayment31BranchName"/>
									</cbc:Name>
									<cac:Address>
										<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477"
											>5</cbc:AddressFormatCode>
										<xsl:if test="string($InvoicePayment31StreetName)">
											<cbc:StreetName>
												<xsl:value-of select="$InvoicePayment31StreetName"/>
											</cbc:StreetName>
										</xsl:if>
										<xsl:if test="string($InvoicePayment31BuildingNumber)">
											<cbc:BuildingNumber>
												<xsl:value-of
												select="$InvoicePayment31BuildingNumber"/>
											</cbc:BuildingNumber>
										</xsl:if>
										<xsl:if test="string($InvoicePayment31CityName)">
											<cbc:CityName>
												<xsl:value-of select="$InvoicePayment31CityName"/>
											</cbc:CityName>
										</xsl:if>
										<xsl:if test="string($InvoicePayment31PostalZone)">
											<cbc:PostalZone>
												<xsl:value-of select="$InvoicePayment31PostalZone"/>
											</cbc:PostalZone>
										</xsl:if>
										<cac:Country>
											<cbc:IdentificationCode>
												<xsl:value-of select="$InvoicePayment31CountryCode"
												/>
											</cbc:IdentificationCode>
										</cac:Country>
									</cac:Address>
								</cac:FinancialInstitutionBranch>
							</cac:PayeeFinancialAccount>
						</xsl:when>

						<xsl:otherwise>
							<cbc:PaymentMeansCode>1</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)">
								<cbc:PaymentDueDate>
									<xsl:value-of select="$fPayDate"/>
								</cbc:PaymentDueDate>
							</xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</cac:PaymentMeans>
			</xsl:if>

			<cac:PaymentTerms>
				<cbc:ID>1</cbc:ID>
				<cbc:PaymentMeansID>1</cbc:PaymentMeansID>
				<xsl:if test="string($PayTerms)">
					<cbc:Note>
						<xsl:value-of select="$PayTerms"/>
					</cbc:Note>
				</xsl:if>
				<cbc:Amount currencyID="{$CurrencyCode}">
					<xsl:value-of select="$fInvTotal"/>
				</cbc:Amount>
			</cac:PaymentTerms>

			<xsl:if test="string($TaxExchangeRateCalculationRate) and $fTaxExchangeFlag = 'true'">
				<cac:TaxExchangeRate>
					<cbc:SourceCurrencyCode>
						<xsl:value-of select="$CurrencyCode"/>
					</cbc:SourceCurrencyCode>
					<cbc:TargetCurrencyCode>
						<xsl:value-of select="$TaxExchangeRateTargetCurrencyCode"/>
					</cbc:TargetCurrencyCode>
					<cbc:CalculationRate>
						<xsl:value-of select="$TaxExchangeRateCalculationRate"/>
					</cbc:CalculationRate>
					<cbc:MathematicOperatorCode>multiply</cbc:MathematicOperatorCode>
					<xsl:if test="string($TaxExchangeRateDate)">
						<cbc:Date>
							<xsl:value-of select="$fTaxExchangeRateDate"/>
						</cbc:Date>
					</xsl:if>
				</cac:TaxExchangeRate>
			</xsl:if>

			<cac:TaxTotal>
				<cbc:TaxAmount currencyID="{$CurrencyCode}">
					<xsl:value-of select="$fTaxAmount"/>
				</cbc:TaxAmount>
				<xsl:choose>
					<xsl:when test="count($IFTFCC/SG4) &gt; 1">
						<xsl:for-each select="$IFTFCC/SG4">

							<xsl:variable name="t2"
								select="format-number(number(translate(./TAX/TAX0401, ',', '.')), '##.00')"/>
							<xsl:variable name="t2b"
								select="format-number(number(translate(./MOA[MOA0101 = '128' and MOA0103 = $CurrencyCode]/MOA0102, ',', '.')), '##.00')"/>
							<xsl:variable name="ft2">
								<xsl:choose>
									<xsl:when test="number($t2)">
										<xsl:value-of select="$t2"/>
									</xsl:when>
									<xsl:when test="number($t2b)">
										<xsl:value-of select="$t2b"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'0.00'"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:variable name="t4" select="./PCD[1]/PCD0102"/>

							<xsl:variable name="t1" select="./TAX/TAX0101"/>
							<xsl:variable name="ft1">
								<xsl:choose>
									<xsl:when test="$CMAflag = 'true'">
										<xsl:value-of select="$t1"/>
									</xsl:when>
									<xsl:when test="$t4 = 0">
										<xsl:value-of select="'61'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$t1"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:variable name="t3">
								<xsl:choose>
									<xsl:when test="string(./TAX/TAX0601)">
										<xsl:value-of select="./TAX/TAX0601"/>
									</xsl:when>
									<xsl:when test="$ft1 = '61' and string(./TAX/TAX0204)">
										<xsl:value-of select="'E'"/>
									</xsl:when>
									<xsl:when test="$ft1 = '61'">Z</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="'S'"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:variable name="t5"
								select="format-number(number(translate(./MOA[MOA0101 != '128' and MOA0103 = $CurrencyCode]/MOA0102, ',', '.')), '##.00')"/>
							<xsl:variable name="ft5">
								<xsl:choose>
									<xsl:when test="$t5 = 'NaN'">
										<xsl:value-of select="'0.00'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$t5"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:variable name="t6">
								<xsl:choose>
									<xsl:when
										test="string(./MOA[MOA0103 = $TaxExchangeRateTargetCurrencyCode]/MOA0102)">
										<xsl:value-of
											select="./MOA[MOA0103 = $TaxExchangeRateTargetCurrencyCode]/MOA0102"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="''"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>
							<xsl:variable name="ft6"
								select="format-number(number(translate($t6, ',', '.')), '##.00')"/>
							<xsl:variable name="fft6">
								<xsl:choose>
									<xsl:when test="$ft6 = 'NaN'">
										<xsl:value-of select="'0.00'"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$ft6"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:variable>

							<xsl:choose>
								<xsl:when test="$ft1 = '50'">
									<cac:TaxSubtotal>
										<cbc:TaxableAmount currencyID="{$CurrencyCode}">
											<xsl:value-of select="$ft2"/>
										</cbc:TaxableAmount>
										<cbc:TaxAmount currencyID="{$CurrencyCode}">
											<xsl:value-of select="$ft5"/>
										</cbc:TaxAmount>
										<xsl:if
											test="string($t6) and string($TaxExchangeRateCalculationRate) and $fTaxExchangeFlag = 'true'">
											<cbc:TransactionCurrencyTaxAmount
												currencyID="{$TaxExchangeRateTargetCurrencyCode}">
												<xsl:value-of select="$fft6"/>
											</cbc:TransactionCurrencyTaxAmount>
										</xsl:if>
										<cac:TaxCategory>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305"
												schemeVersionID="D08B">
												<xsl:value-of select="$t3"/>
											</cbc:ID>
											<cbc:Percent>
												<xsl:value-of select="$t4"/>
											</cbc:Percent>
											<cac:TaxScheme>
												<cbc:ID schemeAgencyID="6"
												schemeID="UN/ECE 5153 Subset"
												schemeVersionID="D08B">
												<xsl:value-of select="$fTaxSchemeID"/>
												</cbc:ID>
												<cbc:Name>
												<xsl:value-of select="$fTaxSchemeID"/>
												</cbc:Name>
											</cac:TaxScheme>
										</cac:TaxCategory>
									</cac:TaxSubtotal>
								</xsl:when>
								<xsl:when test="$ft1 = '61'">
									<cac:TaxSubtotal>
										<cbc:TaxableAmount currencyID="{$CurrencyCode}">
											<xsl:value-of select="$ft2"/>
										</cbc:TaxableAmount>
										<cbc:TaxAmount currencyID="{$CurrencyCode}">
											<xsl:value-of select="'0.00'"/>
										</cbc:TaxAmount>
										<xsl:if
											test="string($TaxExchangeRateCalculationRate) and $fTaxExchangeFlag = 'true'">
											<cbc:TransactionCurrencyTaxAmount
												currencyID="{$TaxExchangeRateTargetCurrencyCode}">
												<xsl:value-of select="'0.00'"/>
											</cbc:TransactionCurrencyTaxAmount>
										</xsl:if>
										<cac:TaxCategory>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305"
												schemeVersionID="D08B">
												<xsl:value-of select="$t3"/>
											</cbc:ID>
											<cbc:Percent>
												<xsl:value-of select="'00'"/>
											</cbc:Percent>
											<xsl:if test="string(./TAX/TAX0204)">
												<cbc:TaxExemptionReason>
												<xsl:value-of select="./TAX/TAX0204"/>
												</cbc:TaxExemptionReason>
											</xsl:if>
											<cac:TaxScheme>
												<cbc:ID schemeAgencyID="6"
												schemeID="UN/ECE 5153 Subset"
												schemeVersionID="D08B">
												<xsl:value-of select="$fTaxSchemeID"/>
												</cbc:ID>
												<cbc:Name>
												<xsl:value-of select="$fTaxSchemeID"/>
												</cbc:Name>
											</cac:TaxScheme>
										</cac:TaxCategory>
									</cac:TaxSubtotal>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="$fTaxAmount &gt; 0">
								<xsl:variable name="t4">
									<xsl:choose>
										<xsl:when test="string($IFTFCC/SG4/PCD/PCD0102)">
											<xsl:value-of select="$IFTFCC/SG4/PCD/PCD0102"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$IFTFCC/SG4/TAX/TAX0501"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="ft4">
									<xsl:choose>
										<xsl:when test="string($t4)">
											<xsl:value-of select="translate($t4, ',', '.')"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of
												select="format-number(($fTaxAmount div $fTaxableAmount) * 100, '##')"
											/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="t3">
									<xsl:choose>
										<xsl:when test="string($IFTFCC/SG4/TAX/TAX0601)">
											<xsl:value-of select="$IFTFCC/SG4/TAX/TAX0601"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'S'"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<cac:TaxSubtotal>
									<cbc:TaxableAmount currencyID="{$CurrencyCode}">
										<xsl:value-of select="$fTaxableAmount"/>
									</cbc:TaxableAmount>
									<cbc:TaxAmount currencyID="{$CurrencyCode}">
										<xsl:value-of select="$fTaxAmount"/>
									</cbc:TaxAmount>
									<xsl:if
										test="string($TaxExchangeRateTargetAmount) and string($TaxExchangeRateCalculationRate) and $fTaxExchangeFlag = 'true'">
										<cbc:TransactionCurrencyTaxAmount
											currencyID="{$TaxExchangeRateTargetCurrencyCode}">
											<xsl:value-of select="$fTaxExchangeRateTargetAmount"/>
										</cbc:TransactionCurrencyTaxAmount>
									</xsl:if>
									<cac:TaxCategory>
										<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305"
											schemeVersionID="D08B">
											<xsl:value-of select="$t3"/>
										</cbc:ID>
										<cbc:Percent>
											<xsl:value-of select="$ft4"/>
										</cbc:Percent>
										<cac:TaxScheme>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
												schemeVersionID="D08B">
												<xsl:value-of select="$fTaxSchemeID"/>
											</cbc:ID>
											<cbc:Name>
												<xsl:value-of select="$fTaxSchemeID"/>
											</cbc:Name>
										</cac:TaxScheme>
									</cac:TaxCategory>
								</cac:TaxSubtotal>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="t3">
									<xsl:choose>
										<xsl:when test="string($IFTFCC/SG4/TAX/TAX0601)">
											<xsl:value-of select="$IFTFCC/SG4/TAX/TAX0601"/>
										</xsl:when>
										<xsl:when test="string($IFTFCC/SG4/TAX/TAX0204)">
											<xsl:value-of select="'E'"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="'Z'"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<cac:TaxSubtotal>
									<cbc:TaxableAmount currencyID="{$CurrencyCode}">
										<xsl:value-of select="$fTaxableAmount"/>
									</cbc:TaxableAmount>
									<cbc:TaxAmount currencyID="{$CurrencyCode}">
										<xsl:value-of select="'0.00'"/>
									</cbc:TaxAmount>
									<xsl:if
										test="string($TaxExchangeRateCalculationRate) and $fTaxExchangeFlag = 'true'">
										<cbc:TransactionCurrencyTaxAmount
											currencyID="{$TaxExchangeRateTargetCurrencyCode}">
											<xsl:value-of select="'0.00'"/>
										</cbc:TransactionCurrencyTaxAmount>
									</xsl:if>
									<cac:TaxCategory>
										<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305"
											schemeVersionID="D08B">
											<xsl:value-of select="$t3"/>
										</cbc:ID>
										<cbc:Percent>00</cbc:Percent>
										<xsl:if test="string($IFTFCC/SG4/TAX/TAX0204)">
											<cbc:TaxExemptionReason>
												<xsl:value-of select="$IFTFCC/SG4/TAX/TAX0204"/>
											</cbc:TaxExemptionReason>
										</xsl:if>
										<cac:TaxScheme>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
												schemeVersionID="D08B">
												<xsl:value-of select="$fTaxSchemeID"/>
											</cbc:ID>
											<cbc:Name>
												<xsl:value-of select="$fTaxSchemeID"/>
											</cbc:Name>
										</cac:TaxScheme>
									</cac:TaxCategory>
								</cac:TaxSubtotal>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
				</xsl:choose>
			</cac:TaxTotal>

			<cac:LegalMonetaryTotal>
				<cbc:LineExtensionAmount currencyID="{$CurrencyCode}">
					<xsl:value-of select="$fLineTotal"/>
				</cbc:LineExtensionAmount>
				<cbc:TaxExclusiveAmount currencyID="{$CurrencyCode}">
					<xsl:value-of select="$fTaxAmount"/>
				</cbc:TaxExclusiveAmount>
				<cbc:TaxInclusiveAmount currencyID="{$CurrencyCode}">
					<xsl:value-of select="$fInvTotal"/>
				</cbc:TaxInclusiveAmount>
				<xsl:if test="$fAllowanceAmount &gt; 0">
					<cbc:AllowanceTotalAmount currencyID="{$CurrencyCode}">
						<xsl:value-of select="$fAllowanceAmount"/>
					</cbc:AllowanceTotalAmount>
				</xsl:if>
				<xsl:if test="$fChargeAmount &gt; 0">
					<cbc:ChargeTotalAmount currencyID="{$CurrencyCode}">
						<xsl:value-of select="$fChargeAmount"/>
					</cbc:ChargeTotalAmount>
				</xsl:if>
				<cbc:PayableAmount currencyID="{$CurrencyCode}">
					<xsl:value-of select="$fInvTotal"/>
				</cbc:PayableAmount>
			</cac:LegalMonetaryTotal>


			<!-- InvoiceLine -->
			<xsl:for-each select="$IFTFCC/SG6">

				<cac:InvoiceLine>
					<!-- Variable -->


					<!-- Line fields -->

					<xsl:variable name="LineID" select="TCC/TCC0106"/>

					<xsl:variable name="LineAccCost" select="''"/>

					<xsl:variable name="LineRefID" select="RFF[RFF0101 = 'LI']/RFF0102"/>

					<xsl:variable name="LineOrderID" select="RFF[RFF0101 = 'ON']/RFF0102"/>

					<xsl:variable name="LineFileReferenceID">
						<xsl:choose>
							<xsl:when test="string(RFF[RFF0101 = 'SI']/RFF0102)">
								<xsl:value-of select="RFF[RFF0101 = 'SI']/RFF0102"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="RFF[RFF0101 = 'CR']/RFF0102"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="LineBOLReferenceID" select="RFF[RFF0101 = 'BM']/RFF0102"/>

					<xsl:variable name="LineNote">
						<xsl:apply-templates select="FTX"> </xsl:apply-templates>
					</xsl:variable>

					<xsl:variable name="ItemIdType">
						<xsl:choose>
							<xsl:when test="string(TCC/TCC0102)">
								<xsl:value-of select="TTCC/TCC0102"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="ItemId">
						<xsl:choose>
							<xsl:when test="string(TCC/TCC0101)">
								<xsl:value-of select="TCC/TCC0101"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="ItemName" select="TCC/TCC0104"/>

					<xsl:variable name="Quantity">
						<xsl:choose>
							<xsl:when test="QTY/QTY0102 > 0">
								<xsl:value-of select="QTY/QTY0102"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'1'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="UnitCode" select="QTY/QTY0103"/>

					<xsl:variable name="UnitPrice" select="SG7/PRI[PRI0101 = 'INV']/PRI0102"/>

					<xsl:variable name="LineAllowanceAmount" select="''"/>

					<xsl:variable name="LineAllowanceReason" select="''"/>

					<xsl:variable name="LineTaxRate" select="''"/>

					<xsl:variable name="LineTaxRateCode" select="SG8/SG10/TAX/TAX0601"/>

					<xsl:variable name="LineTaxExemptReason" select="SG8/SG10/TAX/TAX0204"/>

					<xsl:variable name="LineTaxSchemeID" select="''"/>

					<xsl:variable name="LineTaxAmount" select="''"/>

					<xsl:variable name="LineAmount"
						select="SG8/MOA[MOA0101 = '8' and MOA0104 = '11']/MOA0102"/>


					<!-- Shippingfields -->

					<xsl:variable name="lgd1" select="GID/GID0201"/>
					<xsl:variable name="lgd2" select="GID/GID0202"/>
					<xsl:variable name="lgd3" select="GID/GID0205"/>
					<xsl:variable name="lgd4" select="GID/GID0206"/>
					<xsl:variable name="LinePackage">
						<xsl:choose>
							<xsl:when
								test="string($lgd1) or string($lgd2) or string($lgd3) or string($lgd4)">
								<xsl:value-of
									select="concat('Goods Description: ', $lgd1, ' ', $lgd2, ' ', $lgd3, ' ', $lgd4, $br)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="lm1">
						<xsl:apply-templates select="MEA[MEA0101 = 'AAI']"/>
					</xsl:variable>
					<xsl:variable name="LineWeight">
						<xsl:choose>
							<xsl:when test="string($lm1)">
								<xsl:value-of select="concat('Weight: ', $lm1, $br)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="lm2">
						<xsl:apply-templates select="MEA[MEA0101 = 'VOL']"/>
					</xsl:variable>
					<xsl:variable name="LineVolume">
						<xsl:choose>
							<xsl:when test="string($lm2)">
								<xsl:value-of select="concat('Volume: ', $lm2, $br)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="LineEquipment">
						<xsl:choose>
							<xsl:when test="string(EQD[EQD0101 = 'CN']/EQD0201)">
								<xsl:value-of
									select="concat('Equipment: ', EQD[EQD0101 = 'CN']/EQD0201, '(', EQD[EQD0101 = 'CN']/EQD0301, ')', $br)"
								/>
							</xsl:when>
							<xsl:when test="string(RFF[RFF0101 = 'EQT']/RFF0102)">
								<xsl:value-of
									select="concat('Equipment: ', RFF[RFF0101 = 'EQT']/RFF0102, $br)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="LinePortOfLoading">
						<xsl:choose>
							<xsl:when test="string(LOC[LOC0101 = '9']/LOC0204)">
								<xsl:value-of
									select="concat('PortOfLoading: ', LOC[LOC0101 = '9']/LOC0204, $br)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="LinePortOfDischarge">
						<xsl:choose>
							<xsl:when
								test="string(LOC[LOC0101 = '11']/LOC0204) and string($LinePortOfLoading)">
								<xsl:value-of
									select="concat(', PortOfDischarge: ', LOC[LOC0101 = '11']/LOC0204, $br)"
								/>
							</xsl:when>
							<xsl:when test="string(LOC[LOC0101 = '11']/LOC0204)">
								<xsl:value-of
									select="concat('PortOfDischarge: ', LOC[LOC0101 = '11']/LOC0204, $br)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="LinePlaceOfReceipt">
						<xsl:choose>
							<xsl:when test="string(LOC[LOC0101 = '88']/LOC0204)">
								<xsl:value-of
									select="concat(', PlaceOfReceipt: ', LOC[LOC0101 = '88']/LOC0204, $br)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="LinePlaceOfDelivery">
						<xsl:choose>
							<xsl:when test="string(LOC[LOC0101 = '7']/LOC0204)">
								<xsl:value-of
									select="concat(', PlaceOfDelivery: ', LOC[LOC0101 = '7']/LOC0204, $br)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>



					<!-- Konverteringer etc. -->

					<xsl:variable name="fQuantity" select="number(translate($Quantity, ',', '.'))"/>

					<xsl:variable name="fItemName" select="substring($ItemName, 1, 40)"/>

					<xsl:variable name="fLineID">
						<xsl:choose>
							<xsl:when test="string($LineID)">
								<xsl:value-of select="$LineID"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="position()"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineAllowanceFlag">
						<xsl:choose>
							<xsl:when test="string($LineAllowanceAmount)">
								<xsl:value-of select="'true'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'false'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l5"
						select="format-number(number(translate($LineAllowanceAmount, ',', '.')), '#0.00')"/>
					<xsl:variable name="fLineAllowanceAmount">
						<xsl:choose>
							<xsl:when test="$l5 = 'NaN'">
								<xsl:value-of select="'0.00'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$l5"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l1"
						select="format-number(number(translate($LineAmount, ',', '.')), '#0.00')"/>
					<xsl:variable name="fLineAmount">
						<xsl:choose>
							<xsl:when test="$l1 = 'NaN'">
								<xsl:value-of select="'0.00'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$l1"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="IsoCode"
						select="',04,05,08,10,11,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,40,41,43,44,45,46,47,48,53,54,56,57,58,59,60,61,62,63,64,66,69,71,72,73,74,76,77,78,80,81,84,85,87,89,90,91,92,93,94,95,96,97,98,1A,1B,1C,1D,1E,1F,1G,1H,1I,1J,1K,1L,1M,1X,2A,2B,2C,2I,2J,2K,2L,2M,2N,2P,2Q,2R,2U,2V,2W,2X,2Y,2Z,3B,3C,3E,3G,3H,3I,4A,4B,4C,4E,4G,4H,4K,4L,4M,4N,4O,4P,4Q,4R,4T,4U,4W,4X,5A,5B,5C,5E,5F,5G,5H,5I,5J,5K,5P,5Q,A1,A10,A11,A12,A13,A14,A15,A16,A17,A18,A19,A2,A20,A21,A22,A23,A24,A25,A26,A27,A28,A29,A3,A30,A31,A32,A33,A34,A35,A36,A37,A38,A39,A4,A40,A41,A42,A43,A44,A45,A47,A48,A49,A5,A50,A51,A52,A53,A54,A55,A56,A57,A58,A6,A60,A61,A62,A63,A64,A65,A66,A67,A68,A69,A7,A70,A71,A73,A74,A75,A76,A77,A78,A79,A8,A80,A81,A82,A83,A84,A85,A86,A87,A88,A89,A9,A90,A91,A93,A94,A95,A96,A97,A98,AA,AB,ACR,AD,AE,AH,AI,AJ,AK,AL,AM,AMH,AMP,ANN,AP,APZ,AQ,AR,ARE,AS,ASM,ASU,ATM,ATT,AV,AW,AY,AZ,B0,B1,B11,B12,B13,B14,B15,B16,B18,B2,B20,B21,B22,B23,B24,B25,B26,B27,B28,B29,B3,B31,B32,B33,B34,B35,B36,B37,B38,B39,B4,B40,B41,B42,B43,B44,B45,B46,B47,B48,B49,B5,B50,B51,B52,B53,B54,B55,B56,B57,B58,B59,B6,B60,B61,B62,B63,B64,B65,B66,B67,B69,B7,B70,B71,B72,B73,B74,B75,B76,B77,B78,B79,B8,B81,B83,B84,B85,B86,B87,B88,B89,B9,B90,B91,B92,B93,B94,B95,B96,B97,B98,B99,BAR,BB,BD,BE,BFT,BG,BH,BHP,BIL,BJ,BK,BL,BLD,BLL,BO,BP,BQL,BR,BT,BTU,BUA,BUI,BW,BX,BZ,C0,C1,C10,C11,C12,C13,C14,C15,C16,C17,C18,C19,C2,C20,C22,C23,C24,C25,C26,C27,C28,C29,C3,C30,C31,C32,C33,C34,C35,C36,C38,C39,C4,C40,C41,C42,C43,C44,C45,C46,C47,C48,C49,C5,C50,C51,C52,C53,C54,C55,C56,C57,C58,C59,C6,C60,C61,C62,C63,C64,C65,C66,C67,C68,C69,C7,C70,C71,C72,C73,C75,C76,C77,C78,C8,C80,C81,C82,C83,C84,C85,C86,C87,C88,C89,C9,C90,C91,C92,C93,C94,C95,C96,C97,C98,C99,CA,CCT,CDL,CEL,CEN,CG,CGM,CH,CJ,CK,CKG,CL,CLF,CLT,CMK,CMQ,CMT,CNP,CNT,CO,COU,CQ,CR,CS,CT,CTM,CU,CUR,CV,CWA,CWI,CY,CZ,D1,D10,D12,D13,D14,D15,D16,D17,D18,D19,D2,D20,D21,D22,D23,D24,D25,D26,D27,D28,D29,D30,D31,D32,D33,D34,D35,D37,D38,D39,D40,D41,D42,D43,D44,D45,D46,D47,D48,D49,D5,D50,D51,D52,D53,D54,D55,D56,D57,D58,D59,D6,D60,D61,D62,D63,D64,D65,D66,D67,D69,D7,D70,D71,D72,D73,D74,D75,D76,D77,D79,D8,D80,D81,D82,D83,D85,D86,D87,D88,D89,D9,D90,D91,D92,D93,D94,D95,D96,D97,D98,D99,DAA,DAD,DAY,DB,DC,DD,DE,DEC,DG,DI,DJ,DLT,DMK,DMQ,DMT,DN,DPC,DPR,DPT,DQ,DR,DRA,DRI,DRL,DRM,DS,DT,DTN,DU,DWT,DX,DY,DZN,DZP,E2,E3,E4,E5,EA,EB,EC,EP,EQ,EV,F1,F9,FAH,FAR,FB,FC,FD,FE,FF,FG,FH,FL,FM,FOT,FP,FR,FS,FTK,FTQ,G2,G3,G7,GB,GBQ,GC,GD,GE,GF,GFI,GGR,GH,GIA,GII,GJ,GK,GL,GLD,GLI,GLL,GM,GN,GO,GP,GQ,GRM,GRN,GRO,GRT,GT,GV,GW,GWH,GY,GZ,H1,H2,HA,HAR,HBA,HBX,HC,HD,HE,HF,HGM,HH,HI,HIU,HJ,HK,HL,HLT,HM,HMQ,HMT,HN,HO,HP,HPA,HS,HT,HTZ,HUR,HY,IA,IC,IE,IF,II,IL,IM,INH,INK,INQ,IP,IT,IU,IV,J2,JB,JE,JG,JK,JM,JO,JOU,JR,K1,K2,K3,K5,K6,KA,KB,KBA,KD,KEL,KF,KG,KGM,KGS,KHZ,KI,KJ,KJO,KL,KMH,KMK,KMQ,KNI,KNS,KNT,KO,KPA,KPH,KPO,KPP,KR,KS,KSD,KSH,KT,KTM,KTN,KUR,KVA,KVR,KVT,KW,KWH,KWT,KX,L2,LA,LBR,LBT,LC,LD,LE,LEF,LF,LH,LI,LJ,LK,LM,LN,LO,LP,LPA,LR,LS,LTN,LTR,LUM,LUX,LX,LY,M0,M1,M4,M5,M7,M9,MA,MAL,MAM,MAW,MBE,MBF,MBR,MC,MCU,MD,MF,MGM,MHZ,MIK,MIL,MIN,MIO,MIU,MK,MLD,MLT,MMK,MMQ,MMT,MON,MPA,MQ,MQH,MQS,MSK,MT,MTK,MTQ,MTR,MTS,MV,MVA,MWH,N1,N2,N3,NA,NAR,NB,NBB,NC,NCL,ND,NE,NEW,NF,NG,NH,NI,NIU,NJ,NL,NMI,NMP,NN,NPL,NPR,NPT,NQ,NR,NRL,NT,NTT,NU,NV,NX,NY,OA,OHM,ON,ONZ,OP,OT,OZ,OZA,OZI,P0,P1,P2,P3,P4,P5,P6,P7,P8,P9,PA,PAL,PB,PD,PE,PF,PG,PGL,PI,PK,PL,PM,PN,PO,PQ,PR,PS,PT,PTD,PTI,PTL,PU,PV,PW,PY,PZ,Q3,QA,QAN,QB,QD,QH,QK,QR,QT,QTD,QTI,QTL,QTR,R1,R4,R9,RA,RD,RG,RH,RK,RL,RM,RN,RO,RP,RPM,RPS,RS,RT,RU,S3,S4,S5,S6,S7,S8,SA,SAN,SCO,SCR,SD,SE,SEC,SET,SG,SHT,SIE,SK,SL,SMI,SN,SO,SP,SQ,SR,SS,SST,ST,STI,STN,SV,SW,SX,T0,T1,T3,T4,T5,T6,T7,T8,TA,TAH,TC,TD,TE,TF,TI,TJ,TK,TL,TN,TNE,TP,TPR,TQ,TQD,TR,TRL,TS,TSD,TSH,TT,TU,TV,TW,TY,U1,U2,UA,UB,UC,UD,UE,UF,UH,UM,VA,VI,VLT,VQ,VS,W2,W4,WA,WB,WCD,WE,WEB,WEE,WG,WH,WHR,WI,WM,WR,WSD,WTT,WW,X1,YDK,YDQ,YL,YRD,YT,Z1,Z2,Z3,Z4,Z5,Z6,Z8,ZP,ZZ,'"/>

					<xsl:variable name="l2" select="$UnitCode"/>
					<xsl:variable name="fUnitCode">
						<xsl:choose>
							<xsl:when test="contains($IsoCode, concat(',', $l2, ','))">
								<xsl:value-of select="$l2"/>
							</xsl:when>
							<xsl:when test="$l2 = 'EA'">
								<xsl:value-of select="'EA'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'PCE'">
								<xsl:value-of select="'EA'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'HR'">
								<xsl:value-of select="'HUR'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'WT'">
								<xsl:value-of select="'BW'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'AMT'">
								<xsl:value-of select="'ZZ'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'BOL'">
								<xsl:value-of select="'ZZ'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'CBM'">
								<xsl:value-of select="'MTQ'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'CLA'">
								<xsl:value-of select="'ZZ'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'CH'">
								<xsl:value-of select="'CH'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'DAY'">
								<xsl:value-of select="'DAY'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'PKG'">
								<xsl:value-of select="'SP'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'PTS'">
								<xsl:value-of select="'ZZ'"/>
							</xsl:when>
							<xsl:when test="$l2 = 'TON'">
								<xsl:value-of select="'TNE'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'EA'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fUnitPrice"
						select="format-number($fLineAmount div $fQuantity, '#0.00###')"/>

					<xsl:variable name="l7" select="SG8/SG10/TAX/TAX0201"/>
					<xsl:variable name="l8"
						select="../SG4[TAX/TAX0201 = $l7 and position() = 1]/PCD/PCD0102"/>
					<xsl:variable name="fLineTaxRate">
						<xsl:choose>
							<xsl:when test="number($l8)">
								<xsl:value-of select="$l8"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'00'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxAmount"
						select="format-number($fLineAmount * ($fLineTaxRate div 100), '#0.00')"/>

					<xsl:variable name="fLineTaxExemptReason">
						<xsl:choose>
							<xsl:when test="$fLineTaxRate = 0">
								<xsl:value-of select="$LineTaxExemptReason"/>
							</xsl:when>
							<xsl:otherwise/>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxRateCode">
						<xsl:choose>
							<xsl:when test="string($LineTaxRateCode)">
								<xsl:value-of select="$LineTaxRateCode"/>
							</xsl:when>
							<xsl:when test="string($fLineTaxExemptReason)">E</xsl:when>
							<xsl:when test="$fLineTaxAmount = '0' and $fLineAmount != '0'"
								>Z</xsl:when>
							<xsl:otherwise>S</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineEquipment">
						<xsl:choose>
							<xsl:when
								test="string($LineEquipment) and (string($LinePortOfLoading) or string($LinePortOfDischarge))">
								<xsl:value-of select="concat(', ', $LineEquipment)"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$LineEquipment"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fShippingFlag">
						<xsl:choose>
							<xsl:when
								test="string($LineEquipment) or string($LinePortOfLoading) or string($LinePortOfDischarge)">
								<xsl:value-of select="$ShippingFlag"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'false'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l10">
						<xsl:choose>
							<xsl:when test="string(SG7/CUX[CUX0103 = '10']/CUX0102)">
								<xsl:value-of select="SG7/CUX[CUX0103 = '10']/CUX0102"/>
							</xsl:when>
							<xsl:when test="string(SG7/CUX/CUX0301)">
								<xsl:value-of select="SG7/CUX/CUX0102"/>
							</xsl:when>
							<xsl:when test="string(SG7/CUX[CUX0103 = '17']/CUX0102)">
								<xsl:value-of select="SG7/CUX[CUX0103 = '17']/CUX0102"/>
							</xsl:when>
							<xsl:when test="string(SG7/CUX[CUX0103 = '6']/CUX0102)">
								<xsl:value-of select="SG7/CUX[CUX0103 = '6']/CUX0102"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$TaxExchangeRateTargetCurrencyCode"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l11">
						<xsl:choose>
							<xsl:when test="string(SG7/CUX/CUX0301)">
								<xsl:value-of select="SG7/CUX/CUX0301"/>
							</xsl:when>
							<xsl:when test="string(SG7/CUX/CUX0102 and SG7/CUX/CUX0202)">
								<xsl:value-of select="''"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$TaxExchangeRateCalculationRate"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fl11">
						<xsl:choose>
							<xsl:when test="string($l11)">
								<xsl:value-of select="concat(' (Rate ', $l11, ')')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="' (Rate 1)'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l12">
						<xsl:choose>
							<xsl:when
								test="string(SG8/MOA[MOA0101 = '10' and MOA0104 = '11']/MOA0102)">
								<xsl:value-of
									select="SG8/MOA[MOA0101 = '10' and MOA0104 = '11']/MOA0102"/>
							</xsl:when>
							<xsl:when
								test="string(SG8/MOA[MOA0101 = '8' and MOA0104 = '4']/MOA0102)">
								<xsl:value-of
									select="SG8/MOA[MOA0101 = '8' and MOA0104 = '4']/MOA0102"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'0.00'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fl12"
						select="format-number(number(translate($l12, ',', '.')), '#0.00')"/>

					<xsl:variable name="l13">
						<xsl:choose>
							<xsl:when test="number(PCD[PCD0101 = '3' and PCD0103 = '13']/PCD0102)">
								<xsl:value-of
									select="PCD[PCD0101 = '3' and PCD0103 = '13']/PCD0102 * 0.01"/>
							</xsl:when>
						</xsl:choose>
					</xsl:variable>
					<xsl:variable name="ffl12">
						<xsl:choose>
							<xsl:when test="number($l13)">
								<xsl:value-of select="format-number($fl12 * $l13, '#0.00')"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$fl12"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="CurrencyFlag">
						<xsl:choose>
							<xsl:when test="string($l10)">
								<xsl:value-of select="'true'"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="'false'"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="l14">
						<xsl:choose>
							<xsl:when test="$CurrencyFlag = 'true' and $ffl12 != 0">
								<xsl:value-of
									select="concat('Booking currency: ', $l10, ', ', $ffl12, $fl11, $br)"
								/>
							</xsl:when>
							<xsl:when test="$CurrencyFlag = 'true' and $l10 = $CurrencyCode">
								<xsl:value-of
									select="concat('Booking currency: ', $l10, ', ', $fLineAmount, $fl11, $br)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="''"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>


					<xsl:variable name="fLineNote">
						<xsl:choose>
							<xsl:when test="$CurrencyFlag = 'false' and $fShippingFlag = 'false'">
								<xsl:value-of select="$LineNote"/>
							</xsl:when>
							<xsl:when test="string($LineNote) and $fShippingFlag = 'true'">
								<xsl:value-of
									select="concat($l14, $LinePortOfLoading, $LinePortOfDischarge, $LinePlaceOfReceipt, $LinePlaceOfDelivery, $LinePackage, $LineWeight, $LineVolume, $fLineEquipment, 'Freetext: ', $LineNote)"
								/>
							</xsl:when>
							<xsl:when test="string($LineNote) and $fShippingFlag = 'false'">
								<xsl:value-of select="concat($l14, 'Freetext: ', $LineNote)"/>
							</xsl:when>
							<xsl:when test="$fShippingFlag = 'true'">
								<xsl:value-of
									select="concat($l14, $LinePortOfLoading, $LinePortOfDischarge, $LinePlaceOfReceipt, $LinePlaceOfDelivery, $LinePackage, $LineWeight, $LineVolume, $fLineEquipment)"
								/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="$l14"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>




					<!-- Start invoiceline -->

					<cbc:ID>
						<xsl:value-of select="$fLineID"/>
					</cbc:ID>
					<xsl:if test="string($fLineNote)">
						<cbc:Note>
							<xsl:value-of select="$fLineNote"/>
						</cbc:Note>
					</xsl:if>
					<cbc:InvoicedQuantity unitCode="{$fUnitCode}">
						<xsl:value-of select="$fQuantity"/>
					</cbc:InvoicedQuantity>
					<cbc:LineExtensionAmount currencyID="{$CurrencyCode}">
						<xsl:value-of select="$fLineAmount"/>
					</cbc:LineExtensionAmount>

					<xsl:if test="string($LineAccCost)">
						<cbc:AccountingCost>
							<xsl:value-of select="$LineAccCost"/>
						</cbc:AccountingCost>
					</xsl:if>

					<xsl:if test="string($LineRefID) or string($LineOrderID)">
						<xsl:variable name="fLineRefID">
							<xsl:choose>
								<xsl:when test="string($LineRefID)">
									<xsl:value-of select="$LineRefID"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="'n/a'"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<cac:OrderLineReference>
							<cbc:LineID>
								<xsl:value-of select="$fLineRefID"/>
							</cbc:LineID>
							<xsl:if test="string($LineOrderID)">
								<cac:OrderReference>
									<cbc:ID>
										<xsl:value-of select="$LineOrderID"/>
									</cbc:ID>
								</cac:OrderReference>
							</xsl:if>
						</cac:OrderLineReference>
					</xsl:if>

					<xsl:if test="string($LineFileReferenceID)">
						<cac:DocumentReference>
							<cbc:ID>
								<xsl:value-of select="$LineFileReferenceID"/>
							</cbc:ID>
							<cbc:DocumentTypeCode
								listID="urn:tradeshift.com:api:1.0:documenttypecode">File
								ID</cbc:DocumentTypeCode>
						</cac:DocumentReference>
					</xsl:if>

					<xsl:if test="string($LineBOLReferenceID)">
						<cac:DocumentReference>
							<cbc:ID>
								<xsl:value-of select="$LineBOLReferenceID"/>
							</cbc:ID>
							<cbc:DocumentTypeCode
								listID="urn:tradeshift.com:api:1.0:documenttypecode">BOL
								ID</cbc:DocumentTypeCode>
						</cac:DocumentReference>
					</xsl:if>

					<cac:TaxTotal>
						<cbc:TaxAmount currencyID="{$CurrencyCode}">
							<xsl:value-of select="$fLineTaxAmount"/>
						</cbc:TaxAmount>
						<cac:TaxSubtotal>
							<cbc:TaxableAmount currencyID="{$CurrencyCode}">
								<xsl:value-of select="$fLineAmount"/>
							</cbc:TaxableAmount>
							<cbc:TaxAmount currencyID="{$CurrencyCode}">
								<xsl:value-of select="$fLineTaxAmount"/>
							</cbc:TaxAmount>
							<cac:TaxCategory>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305"
									schemeVersionID="D08B">
									<xsl:value-of select="$fLineTaxRateCode"/>
								</cbc:ID>
								<cbc:Percent>
									<xsl:value-of select="$fLineTaxRate"/>
								</cbc:Percent>
								<xsl:if test="string($fLineTaxExemptReason)">
									<cbc:TaxExemptionReason>
										<xsl:value-of select="$fLineTaxExemptReason"/>
									</cbc:TaxExemptionReason>
								</xsl:if>
								<cac:TaxScheme>
									<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
										schemeVersionID="D08B">VAT</cbc:ID>
									<cbc:Name>VAT</cbc:Name>
								</cac:TaxScheme>
							</cac:TaxCategory>
						</cac:TaxSubtotal>
					</cac:TaxTotal>

					<cac:Item>
						<cbc:Description>
							<xsl:value-of select="$ItemName"/>
						</cbc:Description>
						<cbc:Name>
							<xsl:value-of select="$fItemName"/>
						</cbc:Name>
						<xsl:if test="string($ItemId)">
							<cac:SellersItemIdentification>
								<xsl:choose>
									<xsl:when test="string($ItemIdType)">
										<cbc:ID schemeID="{$ItemIdType}">
											<xsl:value-of select="$ItemId"/>
										</cbc:ID>
									</xsl:when>
									<xsl:otherwise>
										<cbc:ID>
											<xsl:value-of select="$ItemId"/>
										</cbc:ID>
									</xsl:otherwise>
								</xsl:choose>
							</cac:SellersItemIdentification>
						</xsl:if>
					</cac:Item>

					<cac:Price>
						<cbc:PriceAmount currencyID="{$CurrencyCode}">
							<xsl:value-of select="$fUnitPrice"/>
						</cbc:PriceAmount>
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


	<!--  Header & Line FTX -->
	<xsl:template match="MESSAGES/IFTFCC/FTX | FTX">
		<xsl:variable name="t10" select="./FTX0101"/>
		<xsl:variable name="t11" select="./FTX0401"/>
		<xsl:variable name="t12" select="./FTX0401"/>
		<xsl:variable name="t13" select="./FTX0402"/>
		<xsl:variable name="t14" select="./FTX0403"/>
		<xsl:variable name="t15" select="./FTX0404"/>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:value-of
					select="concat($t10, ':&#32;', $t11, '&#32;', $t12, '&#32;', $t13, '&#32;', $t14, '&#32;', $t15)"
				/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of
					select="concat($t10, ':&#32;', $t11, '&#32;', $t12, '&#32;', $t13, '&#32;', $t14, '&#32;', $t15, '.&#32;')"
				/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--  Header EQD -->
	<xsl:template match="/EDIFACT/MESSAGES/IFTFCC/SG24/EQD[EQD0101 = 'CN']">
		<xsl:variable name="t1" select="./EQD0201"/>
		<xsl:variable name="t2" select="./EQD0301"/>
		<xsl:variable name="t10" select="concat($t1, '(', $t2, ')')"/>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:value-of select="$t10"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($t10, ',&#32;')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<!--  Header CNI -->
	<xsl:template match="/EDIFACT/MESSAGES/IFTFCC/SG28/CNI">
		<xsl:variable name="t8" select="./CNI0201"/>
		<xsl:variable name="t9" select="/EDIFACT/MESSAGES/IFTFCC/SG28[CNI0201 = $t8]/TCC/TCC0104"/>
		<xsl:variable name="t10">
			<xsl:choose>
				<xsl:when test="string($t9)">
					<xsl:value-of select="concat($t8, ' (', $t9, ')')"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$t8"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:value-of select="$t10"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($t10, ',&#32;')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  Header & Line Weight -->
	<xsl:template match="/EDIFACT/MESSAGES/IFTFCC/SG24/MEA[MEA0101 = 'AAI'] | MEA[MEA0101 = 'AAI']">
		<xsl:variable name="t1" select="./MEA0302"/>
		<xsl:variable name="t2" select="./MEA0301"/>

		<xsl:variable name="t10" select="concat($t1, ' ', $t2)"/>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:value-of select="$t10"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($t10, ',&#32;')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  Header & Line Volume -->
	<xsl:template match="/EDIFACT/MESSAGES/IFTFCC/SG24/MEA[MEA0101 = 'VOL'] | MEA[MEA0101 = 'VOL']">
		<xsl:variable name="t1" select="./MEA0302"/>
		<xsl:variable name="t2" select="./MEA0301"/>

		<xsl:variable name="t10" select="concat($t1, ' ', $t2)"/>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:value-of select="$t10"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($t10, ',&#32;')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
