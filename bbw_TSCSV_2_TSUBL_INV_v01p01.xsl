<?xml version="1.0" encoding="UTF-8"?>

<!--
******************************************************************************************************************
		TSUBL Stylesheet	
		title= bbw_TSCSV_2_TSUBL_INV_v01p01
		publisher= "Tradeshift"
		creator= "IngKye Ng, Tradeshift"
		created= 2019-07-01
		modified= 2019-07-01
		issued= 2019-07-01
		
******************************************************************************************************************
-->


<xsl:stylesheet version="2.0"
	xmlns:xsl  = "http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi  = "http://www.w3.org/2001/XMLSchema-instance" 
	xmlns:xs   = "http://www.w3.org/2001/XMLSchema"
	xmlns      = "urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
	xmlns:cac  = "urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc  = "urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:ccts = "urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2"
	xmlns:sdt  = "urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2"
	xmlns:udt  = "urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"
	xmlns:metadata-util="java:com.babelway.messaging.transformation.xslt.function.MetadataUtil"
	xmlns:bbw="java:com.babelway.messaging.transformation.xslt.function.BabelwayFunctions"
	xmlns:bbwx="http://xmlns.babelway.com/com.babelway.messaging.transformation.xslt.function.BBWXContextFactory"
	xmlns:ts1="http://ts1" 
	exclude-result-prefixes="xs metadata-util bbw bbwx ts1">

	<xsl:output method="xml" encoding="UTF-8" indent="yes"/>
	<xsl:strip-space elements="*" />
	<xsl:param name="MSG"/>
	
	<xsl:function name="ts1:format-date" as="xs:string">
		<xsl:param name="inDate" />
		<xsl:value-of select="bbw:changeDateTimeFormat($inDate, 'dd.MM.yyyy', 'yyyy-MM-dd')"/>
	</xsl:function>

     <xsl:template match="/">
		<xsl:apply-templates/>
     </xsl:template>

	<xsl:template match="*">
		<Fejl>
			<Fejltekst>Fatal fejl: Dokumenttypen supporteres ikke! Dette stylesheet kan alene konvertere en TSCSV TS meta-fil.</Fejltekst>
			<Input><xsl:value-of select="."/></Input>
		</Fejl>
	</xsl:template>

	<xsl:template match="/csv">

		<!-- Parameters (please assign before using this stylesheet) -->

		<!-- End parameters -->


		<!-- Global Headerfields -->

		<xsl:variable name="UBLVersionID" select="'2.0'"/>

		<xsl:variable name="CustomizationID" select="'urn:tradeshift.com:ubl-2.0-customizations:2010-06'"/>

		<xsl:variable name="ProfileID" select="'urn:www.cenbii.eu:profile:bii04:ver1.0'"/>

		<xsl:variable name="ProfileID_schemeID" select="'CWA 16073:2010'"/>

		<xsl:variable name="ProfileID_schemeAgencyID" select="'CEN/ISSS WS/BII'"/>

		<xsl:variable name="DocID" select="line[1]/InvoiceNumber"/>

		<xsl:variable name="DocDate" select="ts1:format-date(line[1]/InvoiceDate)"/>

		<xsl:variable name="TaxDate">
			<xsl:choose>
				<xsl:when test="string(line[1]/InvoiceTaxPointDate)"><xsl:value-of select="ts1:format-date(line[1]/InvoiceTaxPointDate)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$DocDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name="Note" select="line[1]/InvoiceNote"/>
		
		<xsl:variable name="tokenNote" select="tokenize($Note,',')"/>
		
		<xsl:variable name="fNote">
			<xsl:for-each select="$tokenNote">
				<xsl:value-of select="."/>
				<xsl:text>&#10;</xsl:text>
			</xsl:for-each>
		</xsl:variable>

	    <xsl:variable name="InvoiceTypeCode" select="line[1]/InvoiceTypeCode"/>

	    <xsl:variable name="CurrencyCode" select="line[1]/InvoiceCurrencyCode"/>

	    <xsl:variable name="AccCost" select="line[1]/InvoiceCostCenter"/>

	    <xsl:variable name="RefID" select="line[1]/InvoiceBuyersOrderID"/>

	    <xsl:variable name="SelRefID" select="line[1]/InvoiceSellersOrderID"/>

		<xsl:variable name="RefDate" select="ts1:format-date(line[1]/InvoiceOrderDate)"/>
		
		<xsl:variable name="InvRefID" select="line[1]/CreditNoteInvoiceID"/>
		
		<xsl:variable name="InvRefDate" select="ts1:format-date(line[1]/CreditNoteInvoiceDate)"/>

	    <xsl:variable name="InvoiceContractReferenceID" select="line[1]/InvoiceContractReferenceID"/>

	    <xsl:variable name="InvoiceBOLReferenceID" select="line[1]/InvoiceBOLReferenceID"/>

	    <xsl:variable name="InvoiceFileReferenceID" select="line[1]/InvoiceFileReferenceID"/>

	    <xsl:variable name="InvoiceVehicleNumber" select="line[1]/InvoiceVehicleNumber"/>

		<xsl:variable name="SeEndpointID" select="''"/>

		<xsl:variable name="SeEndpointIDtype" select="''"/>

	    <xsl:variable name="SePartyID" select="line[1]/InvoiceSenderPartyID"/>

	    <xsl:variable name="SePartyIDtype" select="line[1]/InvoiceSenderPartyIDScheme"/>

	    <xsl:variable name="SePartyCVR"	select="line[1]/InvoiceSenderLegalCompanyID"/>

	    <xsl:variable name="SePartyCVRtype" select="line[1]/InvoiceSenderLegalCompanyIDScheme"/>

	    <xsl:variable name="SePartySE" select="line[1]/InvoiceSenderTaxCompanyID"/>

	    <xsl:variable name="SePartySEtype" select="line[1]/InvoiceSenderTaxCompanyIDScheme"/>

	    <xsl:variable name="SePartyTaxSchemeID" select="line[1]/InvoiceSenderTaxSchemeID"/>

	    <xsl:variable name="SeName" select="line[1]/InvoiceSenderPartyName"/>

	    <xsl:variable name="SeStreet1" select="line[1]/InvoiceSenderStreetName"/>

	    <xsl:variable name="SeStreet2" select="line[1]/InvoiceSenderAdditionalStreetName"/>

	    <xsl:variable name="SeBuilding" select="line[1]/InvoiceSenderBuildingNumber"/>

	    <xsl:variable name="SeCity" select="line[1]/InvoiceSenderCityName"/>

	    <xsl:variable name="SeZip" select="line[1]/InvoiceSenderPostalZone"/>

	    <xsl:variable name="SeState" select="line[1]/InvoiceSenderCountrySubentity"/>

	    <xsl:variable name="SeCountry" select="line[1]/InvoiceSenderCountryCode"/>

	    <xsl:variable name="SeRef" select="line[1]/InvoiceSenderContactID"/>

	    <xsl:variable name="SeRefName" select="line[1]/InvoiceSenderContactName"/>

	    <xsl:variable name="SeRefTlf" select="line[1]/InvoiceSenderContactPhone"/>

	    <xsl:variable name="SeRefMail" select="line[1]/InvoiceSenderContactMail"/>


		<xsl:variable name="IpCustomerAssignedAccountID" select="line[1]/InvoiceReceiverCustomerAssignedAccountID"/>

		<xsl:variable name="IpEndpointID" select="''"/>

		<xsl:variable name="IpEndpointIDtype" select="''"/>

		<xsl:variable name="IpPartyID" select="line[1]/InvoiceReceiverPartyID"/>

		<xsl:variable name="IpPartyIDtype" select="line[1]/InvoiceReceiverPartyIDScheme"/>

		<xsl:variable name="IpPartyCVR" select="line[1]/InvoiceReceiverLegalCompanyID"/>

		<xsl:variable name="IpPartyCVRtype" select="line[1]/InvoiceReceiverLegalCompanyIDScheme"/>

		<xsl:variable name="IpPartySE" select="line[1]/InvoiceReceiverTaxCompanyID"/>

		<xsl:variable name="IpPartySEtype" select="line[1]/InvoiceReceiverTaxCompanyIDScheme"/>

		<xsl:variable name="IpPartyTaxSchemeID" select="line[1]/InvoiceReceiverTaxSchemeID"/>

		<xsl:variable name="IpName" select="line[1]/InvoiceReceiverPartyName"/>

		<xsl:variable name="IpStreet1" select="line[1]/InvoiceReceiverStreetName"/>

		<xsl:variable name="IpStreet2" select="line[1]/InvoiceReceiverAdditionalStreetName"/>

		<xsl:variable name="IpBuilding" select="line[1]/InvoiceReceiverBuildingNumber"/>

		<xsl:variable name="IpCity" select="line[1]/InvoiceReceiverCityName"/>

		<xsl:variable name="IpZip" select="line[1]/InvoiceReceiverPostalZone"/>

		<xsl:variable name="IpState" select="line[1]/InvoiceReceiverCountrySubentity"/>

		<xsl:variable name="IpCountry" select="line[1]/InvoiceReceiverCountryCode"/>

		<xsl:variable name="IpRef" select="line[1]/InvoiceReceiverContactID"/>

		<xsl:variable name="IpRefName" select="line[1]/InvoiceReceiverContactName"/>								

		<xsl:variable name="IpRefTlf" select="line[1]/InvoiceReceiverContactPhone"/>

		<xsl:variable name="IpRefMail" select="line[1]/InvoiceReceiverContactMail"/>


		<xsl:variable name="DelDate" select="ts1:format-date(line[1]/InvoiceDeliveryDate)"/>

		<xsl:variable name="DelIDtype" select="'GLN'"/>

		<xsl:variable name="DelID" select="line[1]/InvoiceDeliveryLocationID"/>

		<xsl:variable name="DelDescription" select="line[1]/InvoiceDeliveryLocationDescription"/>

		<xsl:variable name="DelName" select="line[1]/InvoiceDeliveryName"/>

		<xsl:variable name="DelStreet1" select="line[1]/InvoiceDeliveryStreetName"/>

		<xsl:variable name="DelStreet2" select="line[1]/InvoiceDeliveryAdditionalStreetName"/>

		<xsl:variable name="DelBuilding" select="line[1]/InvoiceDeliveryBuildingNumber"/>

		<xsl:variable name="DelCity" select="line[1]/InvoiceDeliveryCityName"/>

		<xsl:variable name="DelZip" select="line[1]/InvoiceDeliveryPostalZone"/>

		<xsl:variable name="DelState" select="line[1]/InvoiceDeliveryCountrySubentity"/>

		<xsl:variable name="DelCountry" select="line[1]/InvoiceDeliveryCountryCode"/>


		<xsl:variable name="PayType" select="line[1]/InvoicePaymentMeansCode"/>

		<xsl:variable name="PayDate" select="ts1:format-date(line[1]/InvoicePaymentDueDate)"/>

		<xsl:variable name="InvoicePayment31AccountNumber" select="line[1]/InvoicePayment31AccountNumber"/>

		<xsl:variable name="InvoicePayment31PaymentNote" select="line[1]/InvoicePayment31PaymentNote"/>

		<xsl:variable name="InvoicePayment31BankID" select="line[1]/InvoicePayment31BankID"/>

		<xsl:variable name="InvoicePayment31ClearingID" select="line[1]/InvoicePayment31ClearingID"/>

		<xsl:variable name="InvoicePayment31BranchName" select="line[1]/InvoicePayment31BranchName"/>

		<xsl:variable name="InvoicePayment31StreetName" select="line[1]/InvoicePayment31StreetName"/>

		<xsl:variable name="InvoicePayment31AdditonalStreetName" select="line[1]/InvoicePayment31AdditonalStreetName"/>

		<xsl:variable name="InvoicePayment31BuildingNumber" select="line[1]/InvoicePayment31BuildingNumber"/>

		<xsl:variable name="InvoicePayment31CityName" select="line[1]/InvoicePayment31CityName"/>

		<xsl:variable name="InvoicePayment31PostalZone" select="line[1]/InvoicePayment31PostalZone"/>

		<xsl:variable name="InvoicePayment31CountryCode" select="line[1]/InvoicePayment31CountryCode"/>

		<xsl:variable name="InvoicePayment42ChannelCode" select="line[1]/InvoicePayment42ChannelCode"/>

		<xsl:variable name="InvoicePayment42ID" select="line[1]/InvoicePayment42ID"/>

		<xsl:variable name="InvoicePayment42AccountNumber" select="line[1]/InvoicePayment42AccountNumber"/>

		<xsl:variable name="InvoicePayment42PaymentNote" select="line[1]/InvoicePayment42PaymentNote"/>

		<xsl:variable name="InvoicePayment42RegNumber" select="line[1]/InvoicePayment42RegNumber"/>

		<xsl:variable name="InvoicePayment42BranchName" select="line[1]/InvoicePayment42BranchName"/>

		<xsl:variable name="BetalingsID" select="''"/>

		<xsl:variable name="Kreditornr" select="''"/>

		<xsl:variable name="PayTerms" select="line[1]/InvoicePaymentTermsNote"/>

		<xsl:variable name="SettlementDiscountPercent" select="line[1]/InvoicePaymentTermsSettlementDiscountPercent"/>

		<xsl:variable name="PenaltySurchargePercent" select="line[1]/InvoicePaymentTermsPenaltySurchargePercent"/>


		<xsl:variable name="AllowanceAmount" select="line[1]/InvoiceAllowanceAmount"/>

		<xsl:variable name="AllowanceReason" select="line[1]/InvoiceAllowanceReason"/>

		<xsl:variable name="ChargeAmount" select="line[1]/InvoiceChargeAmount"/>

		<xsl:variable name="ChargeReason" select="line[1]/InvoiceChargeReason"/>

		<xsl:variable name="ChargeVatCat" select="line[1]/InvoiceChargeTaxCategoryID"/>


		<xsl:variable name="TaxExchangeRateTargetCurrencyCode" select="line[1]/InvoiceTaxExchangeRateTargetCurrencyCode"/>

		<xsl:variable name="TaxExchangeRateTargetAmount" select="line[1]/InvoiceSubTotalTransactionCurrencyTaxAmount"/>

		<xsl:variable name="TaxExchangeRateCalculationRate" select="line[1]/InvoiceTaxExchangeRateCalculationRate"/>

		<xsl:variable name="TaxExchangeRateDate">
			<xsl:choose>
				<xsl:when test="string(line[1]/InvoiceTaxExchangeRateDate)"><xsl:value-of select="ts1:format-date(line[1]/InvoiceTaxExchangeRateDate)"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$DocDate"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>


		<xsl:variable name="TaxAmountP1" select="line[1]/InvoiceSubTotalTaxAmount"/>

		<xsl:variable name="TaxRateP2" select="line[1]/InvoiceSubTotalTaxCategoryPercent2"/>

		<xsl:variable name="TaxAmountP2" select="line[1]/InvoiceSubTotalTaxAmount2"/>

		<xsl:variable name="TaxableAmountP2" select="line[1]/InvoiceSubTotalTaxableAmount2"/>

		<xsl:variable name="TaxRateP3" select="line[1]/InvoiceSubTotalTaxCategoryPercent3"/>

		<xsl:variable name="TaxAmountP3" select="line[1]/InvoiceSubTotalTaxAmount3"/>

		<xsl:variable name="TaxableAmountP3" select="line[1]/InvoiceSubTotalTaxableAmount3"/>


		<xsl:variable name="TaxRate" select="line[1]/InvoiceSubTotalTaxCategoryPercent"/>

		<xsl:variable name="TaxRateCode" select="line[1]/InvoiceSubTotalTaxCategoryID"/>

		<xsl:variable name="TaxSchemeID" select="line[1]/InvoiceSubTotalTaxSchemeID"/>

		<xsl:variable name="TaxAmountTotal" select="line[1]/InvoiceTaxTotal"/>

		<xsl:variable name="TaxableAmount" select="line[1]/InvoiceSubTotalTaxableAmount"/>

		<xsl:variable name="LineTotal" select="line[1]/InvoiceTotalLineAmount"/>

		<xsl:variable name="InvTotal" select="line[1]/InvoiceTotal"/>


		<!-- Global conversions etc. -->

		<xsl:variable name="fIpSenderAssignedAdvFlag">
			<xsl:choose>
				<xsl:when test="$IpPartyIDtype = 'SenderAssigned' and contains($IpPartyID, '$')"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSeSenderAssignedAdvFlag">
			<xsl:choose>
				<xsl:when test="$SePartyIDtype = 'SenderAssigned' and contains($SePartyID, '$')"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

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

		<xsl:variable name="fExemptFlag">
			<xsl:choose>
				<xsl:when test="count(line[InvoiceLineSubTotalTaxCategoryID = 'E']) &gt; 0"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fPayType">
			<xsl:choose>
				<xsl:when test="$PayType = 31 and string($InvoicePayment31ClearingID)"><xsl:value-of select="'31noneu'"/></xsl:when>
				<xsl:when test="$PayType = 31 and not(string($InvoicePayment31ClearingID))"><xsl:value-of select="'31eu'"/></xsl:when>
				<xsl:when test="$PayType = 42"><xsl:value-of select="'42'"/></xsl:when>
				<xsl:when test="$PayType = 10"><xsl:value-of select="'10'"/></xsl:when>
				<xsl:when test="$PayType = 20"><xsl:value-of select="'20'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'1'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fInvoicePayment42ChannelCode">
			<xsl:choose>
				<xsl:when test="string($InvoicePayment42ChannelCode)"><xsl:value-of select="$InvoicePayment42ChannelCode"/></xsl:when>
				<xsl:when test="$SeCountry = 'DK'"><xsl:value-of select="'DK:BANK'"/></xsl:when>
				<xsl:when test="$SeCountry = 'FI'"><xsl:value-of select="'FI:BANK'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="concat($SeCountry,':BANK')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fInvoiceTypeCode">
			<xsl:choose>
				<xsl:when test="$InvoiceTypeCode = 'INV'"><xsl:value-of select="'380'"/></xsl:when>
				<xsl:when test="$InvoiceTypeCode = '325'"><xsl:value-of select="'325'"/></xsl:when>
				<xsl:when test="$InvoiceTypeCode = '386'"><xsl:value-of select="'386'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'380'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h25" select="format-number(number(translate($TaxAmountP1,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxAmountP1">
			<xsl:choose>
				<xsl:when test="string($TaxAmountP1)"><xsl:value-of select="$h25"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h6" select="format-number(number(translate($TaxableAmountP2,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxableAmountP2">
			<xsl:choose>
				<xsl:when test="string($TaxableAmountP2)"><xsl:value-of select="$h6"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h7" select="format-number(number(translate($TaxAmountP2,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxAmountP2">
			<xsl:choose>
				<xsl:when test="string($TaxAmountP2)"><xsl:value-of select="$h7"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h13" select="format-number(number(translate($TaxRateP2,',', '.')),'##.##')"/>
		<xsl:variable name="fTaxRateP2">
			<xsl:choose>
				<xsl:when test="$fTaxAmountP2 = 0"><xsl:value-of select="'00'"/></xsl:when>
				<xsl:when test="string($TaxRateP2)"><xsl:value-of select="$h13"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h10" select="format-number(number(translate($TaxableAmountP3,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxableAmountP3">
			<xsl:choose>
				<xsl:when test="string($TaxableAmountP3)"><xsl:value-of select="$h10"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h12" select="format-number(number(translate($TaxAmountP3,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxAmountP3">
			<xsl:choose>
				<xsl:when test="string($TaxAmountP3)"><xsl:value-of select="$h12"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h14" select="format-number(number(translate($TaxRateP3,',', '.')),'##.##')"/>
		<xsl:variable name="fTaxRateP3">
			<xsl:choose>
				<xsl:when test="$fTaxAmountP3 = 0"><xsl:value-of select="'00'"/></xsl:when>
				<xsl:when test="string($TaxRateP3)"><xsl:value-of select="$h14"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fMulVatFlag">
			<xsl:choose>
				<xsl:when test="$fTaxAmountP2 &gt; 0 or $fTaxAmountP3 &gt; 0"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h4" select="format-number(number(translate($LineTotal,',', '.')),'##.00')"/>
		<xsl:variable name="fLineTotal">
			<xsl:choose>
				<xsl:when test="string($LineTotal)"><xsl:value-of select="$h4"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h2" select="format-number(number(translate($TaxAmountTotal,',', '.')),'#0.00')"/>
		<xsl:variable name="fTaxAmountTotal">
			<xsl:choose>
				<xsl:when test="string($TaxAmountTotal)"><xsl:value-of select="$h2"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="ffTaxAmountP1">
			<xsl:choose>
				<xsl:when test="$fMulVatFlag = 'true'"><xsl:value-of select="$fTaxAmountP1"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fTaxAmountTotal"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h1" select="format-number(number(translate($TaxableAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxableAmount">
			<xsl:choose>
				<xsl:when test="string($TaxableAmount)"><xsl:value-of select="$h1"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name="h5" select="format-number(number(translate($TaxExchangeRateTargetAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fTaxExchangeRateTargetAmount">
			<xsl:choose>
				<xsl:when test="string($TaxExchangeRateTargetAmount)"><xsl:value-of select="$h5"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name="h3" select="format-number(number(translate($InvTotal,',', '.')),'##.00')"/>
		<xsl:variable name="fInvTotal">
			<xsl:choose>
				<xsl:when test="string($InvTotal)"><xsl:value-of select="$h3"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fAllowanceFlag">
			<xsl:choose>
				<xsl:when test="string($AllowanceAmount)"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fChargeFlag">
			<xsl:choose>
				<xsl:when test="string($ChargeAmount)"><xsl:value-of select="'true'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name="h8" select="format-number(number(translate($AllowanceAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fAllowanceAmount">
			<xsl:choose>
				<xsl:when test="string($AllowanceAmount)"><xsl:value-of select="$h8"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name="h9" select="format-number(number(translate($ChargeAmount,',', '.')),'##.00')"/>
		<xsl:variable name="fChargeAmount">
			<xsl:choose>
				<xsl:when test="string($ChargeAmount)"><xsl:value-of select="$h9"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name="h11" select="format-number(number(translate($TaxRate,',', '.')),'##.##')"/>
		<xsl:variable name="fTaxRate">
			<xsl:choose>
				<xsl:when test="$fTaxAmountTotal = 0"><xsl:value-of select="'00'"/></xsl:when>
				<xsl:when test="string($TaxRate)"><xsl:value-of select="$h11"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxRateCode">
			<xsl:choose>
				<xsl:when test="string($TaxRateCode)"><xsl:value-of select="$TaxRateCode"/></xsl:when>
				<xsl:when test="$fTaxAmountTotal = 0 and $fExemptFlag = 'true'"><xsl:value-of select="'E'"/></xsl:when>
				<xsl:when test="$fTaxAmountTotal = 0"><xsl:value-of select="'Z'"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'S'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxSchemeID">
			<xsl:choose>
				<xsl:when test="string($TaxSchemeID)"><xsl:value-of select="$TaxSchemeID"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'VAT'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fTaxableAmount2">
			<xsl:choose>
				<xsl:when test="$fTaxableAmount > 0 and $fTaxableAmount != $fLineTotal"><xsl:value-of select="$fTaxableAmount"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fLineTotal"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

	    <xsl:variable name="h26" select="format-number($fLineTotal - $fTaxableAmount2 - $fTaxableAmountP2 - $fTaxableAmountP3 - $fAllowanceAmount + $fChargeAmount,'##.00')"/>
		<xsl:variable name="fZeroRatedAmount2">
			<xsl:choose>
			    <xsl:when test="number($h26) &gt; 0"><xsl:value-of select="$h26"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSePartyIDtype">
			<xsl:choose>
				<xsl:when test="string($SePartyIDtype)"><xsl:value-of select="$SePartyIDtype"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'TS:VAT'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSePartySEtype">
			<xsl:choose>
				<xsl:when test="string($SePartySEtype)"><xsl:value-of select="$SePartySEtype"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fSePartyIDtype"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSePartyCVRtype">
			<xsl:choose>
				<xsl:when test="string($SePartyCVRtype)"><xsl:value-of select="$SePartyCVRtype"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fSePartyIDtype"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fSePartyTaxSchemeID">
			<xsl:choose>
				<xsl:when test="string($SePartyTaxSchemeID)"><xsl:value-of select="$SePartyTaxSchemeID"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fTaxSchemeID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpPartyIDtype">
			<xsl:choose>
				<xsl:when test="string($IpPartyIDtype)"><xsl:value-of select="$IpPartyIDtype"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="'TS:VAT'"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpPartySEtype">
			<xsl:choose>
				<xsl:when test="string($IpPartySEtype)"><xsl:value-of select="$IpPartySEtype"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fIpPartyIDtype"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpPartyCVRtype">
			<xsl:choose>
				<xsl:when test="string($IpPartyCVRtype)"><xsl:value-of select="$IpPartyCVRtype"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fIpPartyIDtype"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="fIpPartyTaxSchemeID">
			<xsl:choose>
				<xsl:when test="string($IpPartyTaxSchemeID)"><xsl:value-of select="$IpPartyTaxSchemeID"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$fTaxSchemeID"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h15" select="$DocDate"/>
		<xsl:variable name="fDocDate">
			<xsl:choose>
				<xsl:when test="contains($h15, '/')"><xsl:value-of select="concat(substring($h15, 7, 4), '-', substring($h15, 4, 2), '-', substring($h15, 1, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h15"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h16" select="$RefDate"/>
		<xsl:variable name="fRefDate">
			<xsl:choose>
				<xsl:when test="contains($h16, '/')"><xsl:value-of select="concat(substring($h16, 7, 4), '-', substring($h16, 4, 2), '-', substring($h16, 1, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h16"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h17" select="$DelDate"/>
		<xsl:variable name="fDelDate">
			<xsl:choose>
				<xsl:when test="contains($h17, '/')"><xsl:value-of select="concat(substring($h17, 7, 4), '-', substring($h17, 4, 2), '-', substring($h17, 1, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h17"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h18" select="$PayDate"/>
		<xsl:variable name="fPayDate">
			<xsl:choose>
				<xsl:when test="contains($h18, '/')"><xsl:value-of select="concat(substring($h18, 7, 4), '-', substring($h18, 4, 2), '-', substring($h18, 1, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h18"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h19" select="$TaxDate"/>
		<xsl:variable name="fTaxDate">
			<xsl:choose>
				<xsl:when test="contains($h19, '/')"><xsl:value-of select="concat(substring($h19, 7, 4), '-', substring($h19, 4, 2), '-', substring($h19, 1, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h19"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="h20" select="$TaxExchangeRateDate"/>
		<xsl:variable name="fTaxExchangeRateDate">
			<xsl:choose>
				<xsl:when test="contains($h20, '/')"><xsl:value-of select="concat(substring($h20, 7, 4), '-', substring($h20, 4, 2), '-', substring($h20, 1, 2))"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$h20"/></xsl:otherwise>
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

			<xsl:if test="string($fNote)"><cbc:Note><xsl:value-of select="$fNote"/></cbc:Note></xsl:if>

			<xsl:if test="string($TaxDate)"><cbc:TaxPointDate><xsl:value-of select="$fTaxDate"/></cbc:TaxPointDate></xsl:if>

			<cbc:DocumentCurrencyCode><xsl:value-of select="$CurrencyCode"/></cbc:DocumentCurrencyCode>

			<xsl:if test="string($AccCost)"><cbc:AccountingCost><xsl:value-of select="$AccCost"/></cbc:AccountingCost></xsl:if>

			<xsl:if test="string($RefID)">
				<cac:OrderReference>
					<cbc:ID><xsl:value-of select="$RefID"/></cbc:ID>
					<xsl:if test="string($SelRefID)"><cbc:SalesOrderID><xsl:value-of select="$SelRefID"/></cbc:SalesOrderID></xsl:if>
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
			
			<xsl:if test="string($InvRefID)">
				<cac:BillingReference>
					<cac:InvoiceDocumentReference>
						<cbc:ID>
							<xsl:value-of select="$InvRefID"/>
						</cbc:ID>
						<xsl:if test="string($InvRefDate)">
							<cbc:IssueDate>
								<xsl:value-of select="$InvRefDate"/>
							</cbc:IssueDate>
						</xsl:if>
					</cac:InvoiceDocumentReference>
				</cac:BillingReference>
			</xsl:if>
			
			<xsl:if test="bbw:metadata('inFile') != ''">
				<cac:AdditionalDocumentReference>
					<cbc:ID>1</cbc:ID>
					<cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">sourcedocument</cbc:DocumentTypeCode>
					<cac:Attachment>
						<cbc:EmbeddedDocumentBinaryObject encodingCode="Base64" filename="sourcedocument" mimeCode="text/csv">
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
						<cbc:EndpointID schemeID="{$SeEndpointIDtype}"><xsl:value-of select="$SeEndpointID"/></cbc:EndpointID>
					</xsl:if>
					<xsl:if test="string($SePartyID) and $fSeSenderAssignedAdvFlag = 'false'">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fSePartyIDtype}"><xsl:value-of select="$SePartyID"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartyCVR) and $fSePartyCVRtype != $fSePartyIDtype">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fSePartyCVRtype}"><xsl:value-of select="$SePartyCVR"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SePartySE) and $fSePartySEtype != $fSePartyIDtype">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fSePartySEtype}"><xsl:value-of select="$SePartySE"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($SeName)">
						<cac:PartyName>
							<cbc:Name><xsl:value-of select="$SeName"/></cbc:Name>
						</cac:PartyName>
					</xsl:if>
					<xsl:if test="$fSeAddressFlag = 'true'">
						<cac:PostalAddress>
							<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
							<xsl:if test="string($SeStreet1)"><cbc:StreetName><xsl:value-of select="$SeStreet1"/></cbc:StreetName></xsl:if>
							<xsl:if test="string($SeStreet2)"><cbc:AdditionalStreetName><xsl:value-of select="$SeStreet2"/></cbc:AdditionalStreetName></xsl:if>
							<xsl:if test="string($SeBuilding)"><cbc:BuildingNumber><xsl:value-of select="$SeBuilding"/></cbc:BuildingNumber></xsl:if>
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
					<xsl:if test="string($SePartySE)">
						<cac:PartyTaxScheme>
							<cbc:CompanyID schemeID="{$fSePartySEtype}"><xsl:value-of select="$SePartySE"/></cbc:CompanyID>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fSePartyTaxSchemeID"/></cbc:ID>
								<cbc:Name><xsl:value-of select="$fSePartyTaxSchemeID"/></cbc:Name>
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
					</xsl:if>
					<xsl:if test="string($SePartyCVR)">
						<cac:PartyLegalEntity>
							<cbc:RegistrationName><xsl:value-of select="$SeName"/></cbc:RegistrationName>
							<cbc:CompanyID schemeID="{$fSePartyCVRtype}"><xsl:value-of select="$SePartyCVR"/></cbc:CompanyID>
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
						<cbc:EndpointID schemeID="{$IpEndpointIDtype}"><xsl:value-of select="$IpEndpointID"/></cbc:EndpointID>
					</xsl:if>
					<xsl:if test="$fIpSenderAssignedAdvFlag = 'true'">
						<xsl:variable name="SAtag1" select="substring-before($IpPartyID, '$')"/>
						<xsl:variable name="h21" select="substring-after($IpPartyID, '$')"/>
						<xsl:variable name="SAtag2" select="substring-before($h21, '$')"/>
						<xsl:variable name="h22" select="substring-after($h21, '$')"/>
						<xsl:variable name="SAtag3">
							<xsl:choose>
								<xsl:when test="contains($h22, '$')"><xsl:value-of select="substring-before($h22, '$')"/></xsl:when>
								<xsl:otherwise><xsl:value-of select="$h22"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="h23" select="substring-after($h22, '$')"/>
						<xsl:variable name="SAtag4" select="substring-before($h23, '$')"/>
						<xsl:variable name="SAtag5" select="substring-after($h23, '$')"/>
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
  									<cbc:ID schemeID="SenderAssigned"><xsl:value-of select="$IpPartyID"/></cbc:ID>
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
					<xsl:if test="string($IpPartyID) and $fIpSenderAssignedAdvFlag = 'false'">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fIpPartyIDtype}"><xsl:value-of select="$IpPartyID"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartyCVR) and $fIpPartyCVRtype != $fIpPartyIDtype">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fIpPartyCVRtype}"><xsl:value-of select="$IpPartyCVR"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<xsl:if test="string($IpPartySE)  and $fIpPartySEtype != $fIpPartyIDtype">
						<cac:PartyIdentification>
							<cbc:ID schemeID="{$fIpPartySEtype}"><xsl:value-of select="$IpPartySE"/></cbc:ID>
						</cac:PartyIdentification>
					</xsl:if>
					<cac:PartyName>
						<cbc:Name><xsl:value-of select="$IpName"/></cbc:Name>
					</cac:PartyName>
					<xsl:if test="$fIpAddressFlag = 'true'">
						<cac:PostalAddress>
							<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
							<xsl:if test="string($IpStreet1)"><cbc:StreetName><xsl:value-of select="$IpStreet1"/></cbc:StreetName></xsl:if>
							<xsl:if test="string($IpStreet2)"><cbc:AdditionalStreetName><xsl:value-of select="$IpStreet2"/></cbc:AdditionalStreetName></xsl:if>
							<xsl:if test="string($IpBuilding)"><cbc:BuildingNumber><xsl:value-of select="$IpBuilding"/></cbc:BuildingNumber></xsl:if>
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
					<xsl:if test="string($IpPartySE)">
						<cac:PartyTaxScheme>
							<cbc:CompanyID schemeID="{$fIpPartySEtype}"><xsl:value-of select="$IpPartySE"/></cbc:CompanyID>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fIpPartyTaxSchemeID"/></cbc:ID>
								<cbc:Name><xsl:value-of select="$fIpPartyTaxSchemeID"/></cbc:Name>
							</cac:TaxScheme>
						</cac:PartyTaxScheme>
					</xsl:if>
					<xsl:if test="string($IpPartyCVR)">
						<cac:PartyLegalEntity>
							<cbc:RegistrationName><xsl:value-of select="$IpName"/></cbc:RegistrationName>
							<cbc:CompanyID schemeID="{$fIpPartyCVRtype}"><xsl:value-of select="$IpPartyCVR"/></cbc:CompanyID>
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

			<xsl:if test="string($DelStreet1) or string($DelID) or string($DelDescription) or string($fDelDate)">
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
									<xsl:if test="string($DelStreet1)"><cbc:StreetName><xsl:value-of select="$DelStreet1"/></cbc:StreetName></xsl:if>
									<xsl:if test="string($DelStreet2)"><cbc:AdditionalStreetName><xsl:value-of select="$DelStreet2"/></cbc:AdditionalStreetName></xsl:if>
									<xsl:if test="string($DelBuilding)"><cbc:BuildingNumber><xsl:value-of select="$DelBuilding"/></cbc:BuildingNumber></xsl:if>
									<xsl:if test="string($DelName)"><cbc:MarkAttention><xsl:value-of select="$DelName"/></cbc:MarkAttention></xsl:if>
									<xsl:if test="string($DelCity)"><cbc:CityName><xsl:value-of select="$DelCity"/></cbc:CityName></xsl:if>
									<xsl:if test="string($DelZip)"><cbc:PostalZone><xsl:value-of select="$DelZip"/></cbc:PostalZone></xsl:if>
									<xsl:if test="string($DelState)"><cbc:CountrySubentity><xsl:value-of select="$DelState"/></cbc:CountrySubentity></xsl:if>
									<xsl:if test="string($DelCountry)">
										<cac:Country>
											<cbc:IdentificationCode><xsl:value-of select="$DelCountry"/></cbc:IdentificationCode>
										</cac:Country>
									</xsl:if>
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
							<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode">42</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
							<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode"><xsl:value-of select="$fInvoicePayment42ChannelCode"/></cbc:PaymentChannelCode>
							<xsl:if test="string($InvoicePayment42ID)"><cbc:PaymentID><xsl:value-of select="$InvoicePayment42ID"/></cbc:PaymentID></xsl:if>
							<cac:PayeeFinancialAccount>
								<cbc:ID><xsl:value-of select="$InvoicePayment42AccountNumber"/></cbc:ID>
								<xsl:if test="string($InvoicePayment42PaymentNote)"><cbc:PaymentNote><xsl:value-of select="$InvoicePayment42PaymentNote"/></cbc:PaymentNote></xsl:if>
								<xsl:if test="string($InvoicePayment42RegNumber)">
									<cac:FinancialInstitutionBranch>
										<cbc:ID><xsl:value-of select="$InvoicePayment42RegNumber"/></cbc:ID>
										<xsl:if test="string($InvoicePayment42BranchName)"><cbc:Name><xsl:value-of select="$InvoicePayment42BranchName"/></cbc:Name></xsl:if>
									</cac:FinancialInstitutionBranch>
								</xsl:if>
							</cac:PayeeFinancialAccount>
						</xsl:when>

						<xsl:when test="$fPayType = 'FIK71'">
							<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode">93</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
							<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode">DK:FIK</cbc:PaymentChannelCode>
							<cbc:InstructionID><xsl:value-of select="$BetalingsID"/></cbc:InstructionID>
							<cbc:PaymentID schemeAgencyID="320" schemeID="urn:oioubl:id:paymentid-1.1">71</cbc:PaymentID>
							<cac:CreditAccount>
								<cbc:AccountID><xsl:value-of select="$Kreditornr"/></cbc:AccountID>
							</cac:CreditAccount>
						</xsl:when>

						<xsl:when test="$fPayType = '31eu'">
							<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode">31</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
							<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode">IBAN</cbc:PaymentChannelCode>
							<cac:PayeeFinancialAccount>
								<cbc:ID><xsl:value-of select="$InvoicePayment31AccountNumber"/></cbc:ID>
								<xsl:if test="string($InvoicePayment31PaymentNote)"><cbc:PaymentNote><xsl:value-of select="$InvoicePayment31PaymentNote"/></cbc:PaymentNote></xsl:if>
								<cac:FinancialInstitutionBranch>
									<cac:FinancialInstitution>
										<cbc:ID><xsl:value-of select="$InvoicePayment31BankID"/></cbc:ID>
									</cac:FinancialInstitution>
								</cac:FinancialInstitutionBranch>
							</cac:PayeeFinancialAccount>
						</xsl:when>

						<xsl:when test="$fPayType = '31noneu'">
							<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode">31</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
							<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode">ZZZ</cbc:PaymentChannelCode>
							<cac:PayeeFinancialAccount>
								<cbc:ID><xsl:value-of select="$InvoicePayment31AccountNumber"/></cbc:ID>
								<xsl:if test="string($InvoicePayment31PaymentNote)"><cbc:PaymentNote><xsl:value-of select="$InvoicePayment31PaymentNote"/></cbc:PaymentNote></xsl:if>
								<cac:FinancialInstitutionBranch>
									<cbc:ID><xsl:value-of select="$InvoicePayment31ClearingID"/></cbc:ID>
									<cbc:Name><xsl:value-of select="$InvoicePayment31BranchName"/></cbc:Name>
									<cac:Address>
										<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
										<xsl:if test="string($InvoicePayment31StreetName)"><cbc:StreetName><xsl:value-of select="$InvoicePayment31StreetName"/></cbc:StreetName></xsl:if>
										<xsl:if test="string($InvoicePayment31BuildingNumber)"><cbc:BuildingNumber><xsl:value-of select="$InvoicePayment31BuildingNumber"/></cbc:BuildingNumber></xsl:if>
										<xsl:if test="string($InvoicePayment31CityName)"><cbc:CityName><xsl:value-of select="$InvoicePayment31CityName"/></cbc:CityName></xsl:if>
										<xsl:if test="string($InvoicePayment31PostalZone)"><cbc:PostalZone><xsl:value-of select="$InvoicePayment31PostalZone"/></cbc:PostalZone></xsl:if>
										<cac:Country>
											<cbc:IdentificationCode><xsl:value-of select="$InvoicePayment31CountryCode"/></cbc:IdentificationCode>
										</cac:Country>
									</cac:Address>
								</cac:FinancialInstitutionBranch>
							</cac:PayeeFinancialAccount>
						</xsl:when>

						<xsl:when test="$fPayType = '10'">
							<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode">10</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
						</xsl:when>

						<xsl:when test="$fPayType = '20'">
							<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode">20</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
						</xsl:when>

						<xsl:otherwise>
							<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode">1</cbc:PaymentMeansCode>
							<xsl:if test="string($fPayDate)"><cbc:PaymentDueDate><xsl:value-of select="$fPayDate"/></cbc:PaymentDueDate></xsl:if>
						</xsl:otherwise>
					</xsl:choose>
				</cac:PaymentMeans>
			</xsl:if>

			<cac:PaymentTerms>
				<cbc:ID>1</cbc:ID>
				<cbc:PaymentMeansID>1</cbc:PaymentMeansID>
				<xsl:if test="string($PayTerms)"><cbc:Note><xsl:value-of select="$PayTerms"/></cbc:Note></xsl:if>
				<xsl:if test="string($SettlementDiscountPercent)">
					<cbc:SettlementDiscountPercent><xsl:value-of select="$SettlementDiscountPercent"/>
					</cbc:SettlementDiscountPercent></xsl:if>
				<xsl:if test="string($PenaltySurchargePercent)">
					<cbc:PenaltySurchargePercent><xsl:value-of select="$PenaltySurchargePercent"/>
					</cbc:PenaltySurchargePercent></xsl:if>
				<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fInvTotal"/></cbc:Amount>
			</cac:PaymentTerms>

			<xsl:if test="$fAllowanceFlag = 'true'">
				<cac:AllowanceCharge>
					<cbc:ID>1</cbc:ID>
					<cbc:ChargeIndicator>false</cbc:ChargeIndicator>
					<xsl:if test="string($AllowanceReason)"><cbc:AllowanceChargeReason><xsl:value-of select="$AllowanceReason"/></cbc:AllowanceChargeReason></xsl:if>
					<cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
					<cbc:SequenceNumeric>1</cbc:SequenceNumeric>
					<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAllowanceAmount"/></cbc:Amount>
					<cbc:BaseAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fAllowanceAmount"/></cbc:BaseAmount>
					<cac:TaxCategory>
						<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="'S'"/></cbc:ID>
						<cbc:Percent><xsl:value-of select="$fTaxRate"/></cbc:Percent>
						<cac:TaxScheme>
							<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
							<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
						</cac:TaxScheme>
					</cac:TaxCategory>
				</cac:AllowanceCharge>
			</xsl:if>

			<xsl:if test="$fChargeFlag = 'true'">
				<cac:AllowanceCharge>
					<xsl:choose>
						<xsl:when test="$fAllowanceFlag = 'true'"><cbc:ID>2</cbc:ID></xsl:when>
						<xsl:otherwise><cbc:ID>1</cbc:ID></xsl:otherwise>
					</xsl:choose>
					<cbc:ChargeIndicator>true</cbc:ChargeIndicator>
					<xsl:if test="string($ChargeReason)"><cbc:AllowanceChargeReason><xsl:value-of select="$ChargeReason"/></cbc:AllowanceChargeReason></xsl:if>
					<cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
					<cbc:SequenceNumeric>1</cbc:SequenceNumeric>
					<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fChargeAmount"/></cbc:Amount>
					<cbc:BaseAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fChargeAmount"/></cbc:BaseAmount>
					<xsl:choose>
						<xsl:when test="string($ChargeVatCat)">
							<cac:TaxCategory>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$ChargeVatCat"/></cbc:ID>
								<xsl:choose>
									<xsl:when test="$ChargeVatCat = 'Z' or $ChargeVatCat = 'E'"><cbc:Percent>00</cbc:Percent></xsl:when>
									<xsl:otherwise><cbc:Percent><xsl:value-of select="$fTaxRate"/></cbc:Percent></xsl:otherwise>
								</xsl:choose>
								<cac:TaxScheme>
									<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
									<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
								</cac:TaxScheme>
							</cac:TaxCategory>
						</xsl:when>
						<xsl:otherwise>
							<cac:TaxCategory>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fTaxRateCode"/></cbc:ID>
								<cbc:Percent><xsl:value-of select="$fTaxRate"/></cbc:Percent>
								<cac:TaxScheme>
									<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
									<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
								</cac:TaxScheme>
							</cac:TaxCategory>
						</xsl:otherwise>
					</xsl:choose>
				</cac:AllowanceCharge>
			</xsl:if>

			<xsl:if test="string($TaxExchangeRateTargetCurrencyCode)">
				<cac:TaxExchangeRate>
					<cbc:SourceCurrencyCode><xsl:value-of select="$CurrencyCode"/></cbc:SourceCurrencyCode>
					<cbc:TargetCurrencyCode><xsl:value-of select="$TaxExchangeRateTargetCurrencyCode"/></cbc:TargetCurrencyCode>
					<cbc:CalculationRate><xsl:value-of select="$TaxExchangeRateCalculationRate"/></cbc:CalculationRate>
					<cbc:MathematicOperatorCode>multiply</cbc:MathematicOperatorCode>
					<xsl:if test="string($TaxExchangeRateDate)"><cbc:Date><xsl:value-of select="$fTaxExchangeRateDate"/></cbc:Date></xsl:if>
				</cac:TaxExchangeRate>
			</xsl:if>

			<cac:TaxTotal>
				<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxAmountTotal"/></cbc:TaxAmount>
				<cac:TaxSubtotal>
					<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxableAmount2"/></cbc:TaxableAmount>
					<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$ffTaxAmountP1"/></cbc:TaxAmount>
					<xsl:if test="string($TaxExchangeRateTargetAmount) and string($TaxExchangeRateCalculationRate)"><cbc:TransactionCurrencyTaxAmount currencyID ="{$TaxExchangeRateTargetCurrencyCode}"><xsl:value-of select="$fTaxExchangeRateTargetAmount"/></cbc:TransactionCurrencyTaxAmount></xsl:if>
					<cac:TaxCategory>
						<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fTaxRateCode"/></cbc:ID>
						<cbc:Percent><xsl:value-of select="$fTaxRate"/></cbc:Percent>
						<cac:TaxScheme>
							<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
							<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
						</cac:TaxScheme>
					</cac:TaxCategory>
				</cac:TaxSubtotal>
				<xsl:if test="$fTaxAmountP2 &gt; 0">
					<cac:TaxSubtotal>
						<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxableAmountP2"/></cbc:TaxableAmount>
						<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fTaxAmountP2"/></cbc:TaxAmount>
						<cac:TaxCategory>
							<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fTaxRateCode"/></cbc:ID>
							<cbc:Percent><xsl:value-of select="$fTaxRateP2"/></cbc:Percent>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
								<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
							</cac:TaxScheme>
						</cac:TaxCategory>
					</cac:TaxSubtotal>
				</xsl:if>
				<xsl:if test="$fTaxAmountP3 &gt; 0">
					<cac:TaxSubtotal>
						<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxableAmountP3"/></cbc:TaxableAmount>
						<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fTaxAmountP3"/></cbc:TaxAmount>
						<cac:TaxCategory>
							<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fTaxRateCode"/></cbc:ID>
							<cbc:Percent><xsl:value-of select="$fTaxRateP3"/></cbc:Percent>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
								<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
							</cac:TaxScheme>
						</cac:TaxCategory>
					</cac:TaxSubtotal>
				</xsl:if>
				<xsl:if test="$fZeroRatedAmount2 &gt; 0">
					<cac:TaxSubtotal>
						<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fZeroRatedAmount2"/></cbc:TaxableAmount>
						<cbc:TaxAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="'0.00'"/></cbc:TaxAmount>
						<xsl:if test="string($TaxExchangeRateCalculationRate)"><cbc:TransactionCurrencyTaxAmount currencyID ="{$TaxExchangeRateTargetCurrencyCode}"><xsl:value-of select="'0.00'"/></cbc:TransactionCurrencyTaxAmount></xsl:if>
						<cac:TaxCategory>
							<xsl:choose>
								<xsl:when test="$fExemptFlag = 'true'"><cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">E</cbc:ID></xsl:when>
								<xsl:otherwise><cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">Z</cbc:ID></xsl:otherwise>
							</xsl:choose>
							<cbc:Percent>00</cbc:Percent>
							<cac:TaxScheme>
								<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fTaxSchemeID"/></cbc:ID>
								<cbc:Name><xsl:value-of select="$fTaxSchemeID"/></cbc:Name>
							</cac:TaxScheme>
						</cac:TaxCategory>
					</cac:TaxSubtotal>
				</xsl:if>
			</cac:TaxTotal>

			<cac:LegalMonetaryTotal>
				<cbc:LineExtensionAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fLineTotal"/></cbc:LineExtensionAmount>
				<cbc:TaxExclusiveAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fTaxAmountTotal"/></cbc:TaxExclusiveAmount>
				<cbc:TaxInclusiveAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fInvTotal"/></cbc:TaxInclusiveAmount>
				<xsl:if test="$fAllowanceFlag = 'true'"><cbc:AllowanceTotalAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fAllowanceAmount"/></cbc:AllowanceTotalAmount></xsl:if>
				<xsl:if test="$fChargeFlag = 'true'"><cbc:ChargeTotalAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fChargeAmount"/></cbc:ChargeTotalAmount></xsl:if>
				<cbc:PayableAmount currencyID ="{$CurrencyCode}"><xsl:value-of select="$fInvTotal"/></cbc:PayableAmount>
			</cac:LegalMonetaryTotal>

            
			<!-- InvoiceLine -->
		    
			<xsl:for-each select="line">
			
				<cac:InvoiceLine>
					<!-- Variable -->

					<!-- Line fields -->
                    
					<xsl:variable name="LineID" select="InvoiceLineID"/>

					<xsl:variable name="LineAccCost" select="InvoiceLineCostCenter"/>

					<xsl:variable name="LineRefID" select="InvoiceLineOrderLineReferenceID"/>

					<xsl:variable name="LineOrderID" select="InvoiceLineBuyersOrderID"/>

					<xsl:variable name="LineSelOrderID" select="InvoiceLineSellersOrderID"/>

					<xsl:variable name="LineOrderDate" select="InvoiceLineOrderDate"/>

					<xsl:variable name="LineFileReferenceID" select="InvoiceLineFileReferenceID"/>

					<xsl:variable name="LineBOLReferenceID" select="InvoiceLineBOLReferenceID"/>

					<xsl:variable name="LineVehicleNumber" select="InvoiceLineVehicleNumber"/>

					<xsl:variable name="LineNote" select="InvoiceLineNote"/>

					<xsl:variable name="ItemIdType" select="InvoiceLineSellersItemIDScheme"/>

					<xsl:variable name="ItemId" select="InvoiceLineSellersItemID"/>

					<xsl:variable name="ItemName" select="InvoiceLineItemName"/>

					<xsl:variable name="ItemDescription" select="InvoiceLineItemDescription"/>

					<xsl:variable name="Quantity" select="InvoiceLineQuantity"/>

					<xsl:variable name="UnitCode" select="InvoiceLineUnitCode"/>

					<xsl:variable name="UnitPrice" select="InvoiceLineUnitPrice"/>

					<xsl:variable name="BaseQuantity" select="InvoiceLineBaseQuantity"/>

					<xsl:variable name="FactorRate" select="InvoiceLineOrderableUnitFactorRate"/>

					<xsl:variable name="LineAllowanceAmount" select="InvoiceLineAllowanceAmount"/>

					<xsl:variable name="LineAllowanceReason" select="InvoiceLineAllowanceReason"/>

					<xsl:variable name="LineChargeAmount" select="InvoiceLineChargeAmount"/>

					<xsl:variable name="LineChargeReason" select="InvoiceLineChargeReason"/>

					<xsl:variable name="LineChargeVatCat" select="InvoiceLineAllowanceTaxCategoryID"/>

					<xsl:variable name="LineTaxRate" select="InvoiceLineSubTotalTaxCategoryPercent"/>

					<xsl:variable name="LineTaxExemptReason" select="InvoiceLineSubTotalTaxExemptionReason"/>

					<xsl:variable name="LineTaxRateCode" select="InvoiceLineSubTotalTaxCategoryID"/>

					<xsl:variable name="LineTaxSchemeID" select="InvoiceLineSubTotalTaxSchemeID"/>

					<xsl:variable name="LineTaxAmount" select="InvoiceLineTotalTaxAmount"/>

					<xsl:variable name="LineAmount" select="InvoiceLineExtensionAmount"/>


					<!-- Konverteringer etc. -->
					<xsl:variable name="fQuantity" select="translate($Quantity,',', '.')"/>

					<xsl:variable name="fItemName">
						<xsl:choose>
							<xsl:when test="string($ItemName)"><xsl:value-of select="$ItemName"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="$ItemDescription"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

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

					<xsl:variable name="fLineChargeFlag">
						<xsl:choose>
							<xsl:when test="string($LineChargeAmount)"><xsl:value-of select="'true'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'false'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

				    <xsl:variable name="l5" select="format-number(number(translate($LineAllowanceAmount,',', '.')),'##.00')"/>
					<xsl:variable name="fLineAllowanceAmount">
						<xsl:choose>
							<xsl:when test="string($LineAllowanceAmount)"><xsl:value-of select="$l5"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

				    <xsl:variable name="l7" select="format-number(number(translate($LineChargeAmount,',', '.')),'##.00')"/>
					<xsl:variable name="fLineChargeAmount">
						<xsl:choose>
							<xsl:when test="string($LineChargeAmount)"><xsl:value-of select="$l7"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

				    <xsl:variable name="l1" select="format-number(number(translate($LineAmount,',', '.')),'##.00')"/>
					<xsl:variable name="fLineAmount">
						<xsl:choose>
							<xsl:when test="string($LineAmount)"><xsl:value-of select="$l1"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
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

					<xsl:variable name="l3" select="translate($UnitPrice,',', '.')"/>
					<xsl:variable name="fUnitPrice">
						<xsl:choose>
							<xsl:when test="string($UnitPrice)"><xsl:value-of select="$l3"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fBaseQuantity" select="translate($BaseQuantity,',', '.')"/>

					<xsl:variable name="fFactorRate" select="translate($FactorRate,',', '.')"/>

					<xsl:variable name="ffBaseQuantity">
						<xsl:choose>
							<xsl:when test="number($fBaseQuantity)"><xsl:value-of select="$fBaseQuantity"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'1'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="ffFactorRate">
						<xsl:choose>
							<xsl:when test="number($fFactorRate)"><xsl:value-of select="$fFactorRate"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'1'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

				    <xsl:variable name="l4" select="format-number(number(translate($LineTaxAmount,',', '.')),'##.00')"/>
					<xsl:variable name="fLineTaxAmount">
						<xsl:choose>
							<xsl:when test="string($LineTaxAmount)"><xsl:value-of select="$l4"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'0.00'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fTaxCat">
						<xsl:choose>
							<xsl:when test="$fLineTaxAmount = 0 and $fLineAmount != 0">ZeroRated</xsl:when>
							<xsl:otherwise>StandardRated</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

				    <xsl:variable name="l6" select="format-number(number(translate($LineTaxRate,',', '.')),'##.##')"/>
					<xsl:variable name="fLineTaxRate">
						<xsl:choose>
							<xsl:when test="$LineTaxRate = 0"><xsl:value-of select="'00'"/></xsl:when>
							<xsl:when test="string($LineTaxRate)"><xsl:value-of select="$l6"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'00'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxRateCode">
						<xsl:choose>
							<xsl:when test="string($LineTaxRateCode)"><xsl:value-of select="$LineTaxRateCode"/></xsl:when>
							<xsl:when test="$fLineTaxAmount = 0 and $fLineAmount != 0"><xsl:value-of select="'Z'"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'S'"/></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:variable name="fLineTaxSchemeID">
						<xsl:choose>
							<xsl:when test="string($LineTaxSchemeID)"><xsl:value-of select="$LineTaxSchemeID"/></xsl:when>
							<xsl:otherwise><xsl:value-of select="'VAT'"/></xsl:otherwise>
						</xsl:choose>
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
									<xsl:if test="string($LineSelOrderID)"><cbc:SalesOrderID><xsl:value-of select="$LineSelOrderID"/></cbc:SalesOrderID></xsl:if>
									<xsl:if test="string($LineOrderDate)"><cbc:IssueDate><xsl:value-of select="$LineOrderDate"/></cbc:IssueDate></xsl:if>
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

					<xsl:if test="$fLineAllowanceFlag = 'true'">
						<cac:AllowanceCharge>
							<cbc:ID>1</cbc:ID>
							<cbc:ChargeIndicator>false</cbc:ChargeIndicator>
							<xsl:if test="string($LineAllowanceReason)"><cbc:AllowanceChargeReason><xsl:value-of select="$LineAllowanceReason"/></cbc:AllowanceChargeReason></xsl:if>
							<cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
							<cbc:SequenceNumeric>1</cbc:SequenceNumeric>
							<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineAllowanceAmount"/></cbc:Amount>
							<cbc:BaseAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineAllowanceAmount"/></cbc:BaseAmount>
						</cac:AllowanceCharge>
					</xsl:if>

					<xsl:if test="$fLineChargeFlag = 'true'">
						<cac:AllowanceCharge>
							<xsl:choose>
								<xsl:when test="$fLineAllowanceFlag = 'true'"><cbc:ID>2</cbc:ID></xsl:when>
								<xsl:otherwise><cbc:ID>1</cbc:ID></xsl:otherwise>
							</xsl:choose>
							<cbc:ChargeIndicator>true</cbc:ChargeIndicator>
							<xsl:if test="string($LineChargeReason)"><cbc:AllowanceChargeReason><xsl:value-of select="$LineChargeReason"/></cbc:AllowanceChargeReason></xsl:if>
							<cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
							<cbc:SequenceNumeric>1</cbc:SequenceNumeric>
							<cbc:Amount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineChargeAmount"/></cbc:Amount>
							<cbc:BaseAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineChargeAmount"/></cbc:BaseAmount>
							<xsl:choose>
								<xsl:when test="string($LineChargeVatCat)">
									<cac:TaxCategory>
										<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$LineChargeVatCat"/></cbc:ID>
										<cbc:Percent><xsl:value-of select="$fLineTaxRate"/></cbc:Percent>
										<cac:TaxScheme>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxSchemeID"/></cbc:ID>
											<cbc:Name><xsl:value-of select="$fLineTaxSchemeID"/></cbc:Name>
										</cac:TaxScheme>
									</cac:TaxCategory>
								</xsl:when>
								<xsl:otherwise>
									<cac:TaxCategory>
										<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxRateCode"/></cbc:ID>
										<cbc:Percent><xsl:value-of select="$fLineTaxRate"/></cbc:Percent>
										<cac:TaxScheme>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxSchemeID"/></cbc:ID>
											<cbc:Name><xsl:value-of select="$fLineTaxSchemeID"/></cbc:Name>
										</cac:TaxScheme>
									</cac:TaxCategory>
								</xsl:otherwise>
							</xsl:choose>
						</cac:AllowanceCharge>
					</xsl:if>

					<cac:TaxTotal>
						<xsl:choose>
							<xsl:when test="$fTaxCat = 'StandardRated'">
								<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineTaxAmount"/></cbc:TaxAmount>
								<cac:TaxSubtotal>
									<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineAmount"/></cbc:TaxableAmount>
									<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineTaxAmount"/></cbc:TaxAmount>
									<cac:TaxCategory>
										<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxRateCode"/></cbc:ID>
										<cbc:Percent><xsl:value-of select="$fLineTaxRate"/></cbc:Percent>
										<xsl:if test="string($LineTaxExemptReason)"><cbc:TaxExemptionReason><xsl:value-of select="$LineTaxExemptReason"/></cbc:TaxExemptionReason></xsl:if>
										<cac:TaxScheme>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxSchemeID"/></cbc:ID>
											<cbc:Name><xsl:value-of select="$fLineTaxSchemeID"/></cbc:Name>
										</cac:TaxScheme>
									</cac:TaxCategory>
								</cac:TaxSubtotal>
							</xsl:when>
							<xsl:otherwise>
								<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="'0.00'"/></cbc:TaxAmount>
								<cac:TaxSubtotal>
									<cbc:TaxableAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineAmount"/></cbc:TaxableAmount>
									<cbc:TaxAmount currencyID="{$CurrencyCode}"><xsl:value-of select="'0.00'"/></cbc:TaxAmount>
									<cac:TaxCategory>
										<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxRateCode"/></cbc:ID>
										<cbc:Percent>00</cbc:Percent>
										<xsl:if test="string($LineTaxExemptReason)"><cbc:TaxExemptionReason><xsl:value-of select="$LineTaxExemptReason"/></cbc:TaxExemptionReason></xsl:if>
										<cac:TaxScheme>
											<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B"><xsl:value-of select="$fLineTaxSchemeID"/></cbc:ID>
											<cbc:Name><xsl:value-of select="$fLineTaxSchemeID"/></cbc:Name>
										</cac:TaxScheme>
									</cac:TaxCategory>
								</cac:TaxSubtotal>
							</xsl:otherwise>
						</xsl:choose>
					</cac:TaxTotal>

					<cac:Item>
						<cbc:Description><xsl:value-of select="$ItemDescription"/></cbc:Description>
						<cbc:Name><xsl:value-of select="$fItemName"/></cbc:Name>
						<xsl:if test="string($ItemId)">
							<cac:SellersItemIdentification>
								<xsl:choose>
									<xsl:when test="$ItemIdType = 'GTIN' or $ItemIdType = 'EAN'">
										<cbc:ID schemeAgencyID="9" schemeID="GTIN"><xsl:value-of select="$ItemId"/></cbc:ID>
									</xsl:when>
									<xsl:when test="string($ItemIdType)">
										<cbc:ID schemeID="{$ItemIdType}"><xsl:value-of select="$ItemId"/></cbc:ID>
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
						<cbc:BaseQuantity unitCode="{$fUnitCode}"><xsl:value-of select="$ffBaseQuantity"/></cbc:BaseQuantity>
						<cbc:OrderableUnitFactorRate><xsl:value-of select="$ffFactorRate"/></cbc:OrderableUnitFactorRate>
					</cac:Price>

				</cac:InvoiceLine>
			    
			</xsl:for-each>
		
		</Invoice>

	</xsl:template>


	<!-- .............................. -->
	<!--           Templates            -->
	<!-- .............................. -->



</xsl:stylesheet>