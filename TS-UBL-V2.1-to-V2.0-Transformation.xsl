<?xml version="1.0" encoding="UTF-8"?>

<!--
******************************************************************************************************************
        TSUBL Stylesheet	
        title= TS-UBL-V2.1-to-V2.0-Transformation
        publisher= "Tradeshift"
        creator= "IngKye Ng, Tradeshift"
        created= 2019-02-14
        modified= 2019-02-14
        issued= 2019-02-14
        
******************************************************************************************************************
-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xmlns:in="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
	xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
	xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
	xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
	xmlns:ccts="urn:oasis:names:specification:ubl:schema:xsd:CoreComponentParameters-2"
	xmlns:sdt="urn:oasis:names:specification:ubl:schema:xsd:SpecializedDatatypes-2"
	xmlns:udt="urn:un:unece:uncefact:data:specification:UnqualifiedDataTypesSchemaModule:2"
	xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ts="http://tradeshift.com/api/public/1.0"
	exclude-result-prefixes="in xs xsi ts">

	<xsl:output method="xml" encoding="utf-8" indent="yes"/>

	<xsl:strip-space elements="*"/>

	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>

	<!-- Note: this is a special conversion, taking both OIOUBL and TSUBL as input -->
	<xsl:template match="/in:Invoice">

		<!-- Parameters (please assign before using this stylesheet) -->

		<!-- End parameters -->


		<!-- Global Headerfields -->

		<xsl:variable name="UBLVersionID" select="'2.0'"/>

		<xsl:variable name="CustomizationID"
			select="'urn:tradeshift.com:ubl-2.0-customizations:2010-06'"/>

		<xsl:variable name="ProfileID" select="'urn:www.cenbii.eu:profile:bii04:ver1.0'"/>

		<xsl:variable name="ProfileID_schemeID" select="'CWA 16073:2010'"/>

		<xsl:variable name="ProfileID_schemeAgencyID" select="'CEN/ISSS WS/BII'"/>


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
				<xsl:value-of select="cbc:ID"/>
			</cbc:ID>

			<cbc:IssueDate>
				<xsl:value-of select="cbc:IssueDate"/>
			</cbc:IssueDate>

			<cbc:InvoiceTypeCode listAgencyID="6" listID="UN/ECE 1001 Subset">
				<xsl:value-of select="cbc:InvoiceTypeCode"/>
			</cbc:InvoiceTypeCode>

			<xsl:if test="string(cbc:Note)">
				<cbc:Note>
					<xsl:value-of select="cbc:Note"/>
				</cbc:Note>
			</xsl:if>

			<xsl:if test="string(cbc:TaxPointDate)">
				<cbc:TaxPointDate>
					<xsl:value-of select="cbc:TaxPointDate"/>
				</cbc:TaxPointDate>
			</xsl:if>

			<cbc:DocumentCurrencyCode>
				<xsl:value-of select="cbc:DocumentCurrencyCode"/>
			</cbc:DocumentCurrencyCode>

			<xsl:if test="string(cbc:AccountingCost)">
				<cbc:AccountingCost>
					<xsl:value-of select="cbc:AccountingCost"/>
				</cbc:AccountingCost>
			</xsl:if>

			<!-- OrderReference -->
			<xsl:apply-templates select="cac:OrderReference"/>

			<!-- DespatchDocumentReference -->
			<xsl:apply-templates select="cac:DespatchDocumentReference"/>

			<!-- ContractDocumentReference -->
			<xsl:apply-templates select="cac:ContractDocumentReference"/>

			<!-- AdditionalDocumentReference -->
			<xsl:apply-templates select="cac:AdditionalDocumentReference"/>

			<!-- AccountingSupplierParty -->
			<xsl:apply-templates select="cac:AccountingSupplierParty"/>

			<!-- AccountingCustomerParty -->
			<xsl:apply-templates select="cac:AccountingCustomerParty"/>

			<!-- Delivery -->
			<xsl:apply-templates select="cac:Delivery"/>

			<!-- PaymentMeans -->
			<xsl:apply-templates select="cac:PaymentMeans"/>

			<!-- PaymentTerms -->
			<xsl:apply-templates select="cac:PaymentTerms"/>

			<!-- AllowanceCharge -->
			<xsl:apply-templates select="cac:AllowanceCharge"/>

			<!-- TaxExchangeRate -->
			<xsl:apply-templates select="cac:TaxExchangeRate"/>

			<!-- TaxTotal -->
			<xsl:apply-templates select="cac:TaxTotal"/>

			<!-- LegalMonetaryTotal -->
			<xsl:apply-templates select="cac:LegalMonetaryTotal"/>

			<!-- InvoiceLine -->
			<xsl:apply-templates select="cac:InvoiceLine"/>

		</Invoice>
	</xsl:template>


	<!-- .............................. -->
	<!--           Templates            -->
	<!-- .............................. -->


	<!--  OrderReference template -->
	<xsl:template match="cac:OrderReference">
		<cac:OrderReference>
			<cbc:ID>
				<xsl:value-of select="cbc:ID"/>
			</cbc:ID>
			<xsl:if test="string(cbc:SalesOrderID)">
				<cbc:SalesOrderID>
					<xsl:value-of select="cbc:SalesOrderID"/>
				</cbc:SalesOrderID>
			</xsl:if>
			<xsl:if test="string(cbc:UUID)">
				<cbc:UUID>
					<xsl:value-of select="cbc:UUID"/>
				</cbc:UUID>
			</xsl:if>
			<xsl:if test="string(cbc:IssueDate)">
				<cbc:IssueDate>
					<xsl:value-of select="cbc:IssueDate"/>
				</cbc:IssueDate>
			</xsl:if>
		</cac:OrderReference>
	</xsl:template>

	<!-- DespatchDocuementReference template -->
	<xsl:template match="cac:DespatchDocumentReference">
		<cac:DespatchDocumentReference>
			<cbc:ID>
				<xsl:value-of select="cbc:ID"/>
			</cbc:ID>
			<xsl:if test="string(cbc:UUID)">
				<cbc:UUID>
					<xsl:value-of select="cbc:UUID"/>
				</cbc:UUID>
			</xsl:if>
			<xsl:if test="string(cbc:IssueDate)">
				<cbc:IssueDate>
					<xsl:value-of select="cbc:IssueDate"/>
				</cbc:IssueDate>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentTypeCode)">
				<xsl:choose>
					<xsl:when test="string(cbc:DocumentTypeCode/@listID)">
						<cbc:DocumentTypeCode listID="{cbc:DocumentTypeCode/@listID}">
							<xsl:value-of select="cbc:DocumentTypeCode"/>
						</cbc:DocumentTypeCode>
					</xsl:when>
					<xsl:otherwise>
						<cbc:DocumentTypeCode>
							<xsl:value-of select="cbc:DocumentTypeCode"/>
						</cbc:DocumentTypeCode>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentType)">
				<cbc:DocumentType>
					<xsl:value-of select="cbc:DocumentType"/>
				</cbc:DocumentType>
			</xsl:if>
			<xsl:if test="string(cbc:XPath)">
				<cbc:XPath>
					<xsl:value-of select="cbc:XPath"/>
				</cbc:XPath>
			</xsl:if>
			<xsl:apply-templates select="cac:Attachment"/>
		</cac:DespatchDocumentReference>
	</xsl:template>

	<!--  ContractDocumentReference template -->
	<xsl:template match="cac:ContractDocumentReference">
		<cac:ContractDocumentReference>
			<cbc:ID>
				<xsl:value-of select="cbc:ID"/>
			</cbc:ID>
			<xsl:if test="string(cbc:UUID)">
				<cbc:UUID>
					<xsl:value-of select="cbc:UUID"/>
				</cbc:UUID>
			</xsl:if>
			<xsl:if test="string(cbc:IssueDate)">
				<cbc:IssueDate>
					<xsl:value-of select="cbc:IssueDate"/>
				</cbc:IssueDate>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentTypeCode)">
				<cbc:DocumentTypeCode>
					<xsl:value-of select="cbc:DocumentTypeCode"/>
				</cbc:DocumentTypeCode>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentType)">
				<cbc:DocumentType>
					<xsl:value-of select="cbc:DocumentType"/>
				</cbc:DocumentType>
			</xsl:if>
			<xsl:if test="string(cbc:XPath)">
				<cbc:XPath>
					<xsl:value-of select="cbc:XPath"/>
				</cbc:XPath>
			</xsl:if>
			<xsl:apply-templates select="cac:Attachment"/>
		</cac:ContractDocumentReference>
	</xsl:template>

	<!--  AdditionalDocumentReference template -->
	<xsl:template match="cac:AdditionalDocumentReference">
		<cac:AdditionalDocumentReference>
			<cbc:ID>
				<xsl:value-of select="cbc:ID"/>
			</cbc:ID>
			<xsl:if test="string(cbc:UUID)">
				<cbc:UUID>
					<xsl:value-of select="cbc:UUID"/>
				</cbc:UUID>
			</xsl:if>
			<xsl:if test="string(cbc:IssueDate)">
				<cbc:IssueDate>
					<xsl:value-of select="cbc:IssueDate"/>
				</cbc:IssueDate>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentTypeCode)">
				<xsl:choose>
					<xsl:when test="string(cbc:DocumentTypeCode/@listID)">
						<cbc:DocumentTypeCode listID="{cbc:DocumentTypeCode/@listID}">
							<xsl:value-of select="cbc:DocumentTypeCode"/>
						</cbc:DocumentTypeCode>
					</xsl:when>
					<xsl:otherwise>
						<cbc:DocumentTypeCode>
							<xsl:value-of select="cbc:DocumentTypeCode"/>
						</cbc:DocumentTypeCode>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentType)">
				<cbc:DocumentType>
					<xsl:value-of select="cbc:DocumentType"/>
				</cbc:DocumentType>
			</xsl:if>
			<xsl:if test="string(cbc:XPath)">
				<cbc:XPath>
					<xsl:value-of select="cbc:XPath"/>
				</cbc:XPath>
			</xsl:if>
			<xsl:apply-templates select="cac:Attachment"/>
		</cac:AdditionalDocumentReference>
	</xsl:template>

	<!--  Attachment template -->
	<xsl:template match="cac:Attachment">
		<cac:Attachment>
			<xsl:if test="string(cbc:EmbeddedDocumentBinaryObject)">
				<cbc:EmbeddedDocumentBinaryObject
					encodingCode="{cbc:EmbeddedDocumentBinaryObject/@encodingCode}"
					filename="{cbc:EmbeddedDocumentBinaryObject/@filename}"
					mimeCode="{cbc:EmbeddedDocumentBinaryObject/@mimeCode}">
					<xsl:value-of select="cbc:EmbeddedDocumentBinaryObject"/>
				</cbc:EmbeddedDocumentBinaryObject>
			</xsl:if>
			<xsl:apply-templates select="cac:ExternalReference"/>
		</cac:Attachment>
	</xsl:template>

	<!--  ExternalReference template -->
	<xsl:template match="cac:ExternalReference">
		<cac:ExternalReference>
			<xsl:if test="string(cbc:URI)">
				<cbc:URI>
					<xsl:value-of select="cbc:URI"/>
				</cbc:URI>
			</xsl:if>
		</cac:ExternalReference>
	</xsl:template>

	<!--  AccountingSupplierParty template -->
	<xsl:template match="cac:AccountingSupplierParty">
		<cac:AccountingSupplierParty>
			<cac:Party>
				<xsl:apply-templates select="cac:Party/cbc:EndpointID"/>
				<xsl:apply-templates select="cac:Party/cac:PartyIdentification"/>
				<xsl:apply-templates select="cac:Party/cac:PartyName"/>
				<xsl:apply-templates select="cac:Party/cac:PostalAddress"/>
				<xsl:apply-templates select="cac:Party/cac:PartyTaxScheme"/>
				<xsl:apply-templates select="cac:Party/cac:PartyLegalEntity"/>
				<xsl:apply-templates select="cac:Party/cac:Contact"/>
				<xsl:apply-templates select="cac:Party/cac:Person"/>
			</cac:Party>
		</cac:AccountingSupplierParty>
	</xsl:template>

	<!--  AccountingCustomerParty template -->
	<xsl:template match="cac:AccountingCustomerParty">
		<cac:AccountingCustomerParty>
			<xsl:if test="string(cbc:CustomerAssignedAccountID)">
				<cbc:CustomerAssignedAccountID>
					<xsl:value-of select="cbc:CustomerAssignedAccountID"/>
				</cbc:CustomerAssignedAccountID>
			</xsl:if>
			<cac:Party>
				<xsl:apply-templates select="cac:Party/cbc:EndpointID"/>
				<xsl:apply-templates select="cac:Party/cac:PartyIdentification"/>
				<xsl:apply-templates select="cac:Party/cac:PartyName"/>
				<xsl:apply-templates select="cac:Party/cac:PostalAddress"/>
				<xsl:apply-templates select="cac:Party/cac:PartyTaxScheme"/>
				<xsl:apply-templates select="cac:Party/cac:PartyLegalEntity"/>
				<xsl:apply-templates select="cac:Party/cac:Contact"/>
				<xsl:apply-templates select="cac:Party/cac:Person"/>
			</cac:Party>
		</cac:AccountingCustomerParty>
	</xsl:template>

	<!--  EndpointID template -->
	<xsl:template match="cbc:EndpointID">
		<xsl:variable name="fschemeID" select="./@schemeID"/>
		<xsl:choose>
			<xsl:when test="$fschemeID = 'GLN'">
				<cbc:EndpointID schemeAgencyID="9" schemeID="{$fschemeID}">
					<xsl:value-of select="."/>
				</cbc:EndpointID>
			</xsl:when>
			<xsl:otherwise>
				<cbc:EndpointID schemeID="{$fschemeID}">
					<xsl:value-of select="."/>
				</cbc:EndpointID>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  PartyIdentification template -->
	<xsl:template match="cac:PartyIdentification">
		<xsl:variable name="fschemeID" select="cbc:ID/@schemeID"/>
		<cac:PartyIdentification>
			<xsl:choose>
				<xsl:when test="$fschemeID = 'GLN'">
					<cbc:ID schemeAgencyID="9" schemeID="{$fschemeID}">
						<xsl:value-of select="cbc:ID"/>
					</cbc:ID>
				</xsl:when>
				<xsl:otherwise>
					<cbc:ID schemeID="{$fschemeID}">
						<xsl:value-of select="cbc:ID"/>
					</cbc:ID>
				</xsl:otherwise>
			</xsl:choose>
		</cac:PartyIdentification>
	</xsl:template>

	<!--  PartyName template -->
	<xsl:template match="cac:PartyName">
		<cac:PartyName>
			<cbc:Name>
				<xsl:value-of select="cbc:Name"/>
			</cbc:Name>
		</cac:PartyName>
	</xsl:template>

	<!--  PostalAddress template -->
	<xsl:template match="cac:PostalAddress">
		<cac:PostalAddress>
			<xsl:call-template name="Address"/>
		</cac:PostalAddress>
	</xsl:template>

	<!--  Address template -->
	<xsl:template match="cac:Address">
		<cac:Address>
			<xsl:call-template name="Address"/>
		</cac:Address>
	</xsl:template>

	<!--  PartyTaxScheme template -->
	<xsl:template match="cac:PartyTaxScheme">
		<cac:PartyTaxScheme>
			<cbc:CompanyID schemeID="{cbc:CompanyID/@schemeID}">
				<xsl:value-of select="cbc:CompanyID"/>
			</cbc:CompanyID>
			<xsl:apply-templates select="cac:TaxScheme"/>
		</cac:PartyTaxScheme>
	</xsl:template>

	<!--  PartyLegalEntity template -->
	<xsl:template match="cac:PartyLegalEntity">
		<cac:PartyLegalEntity>
			<cbc:RegistrationName>
				<xsl:value-of select="cbc:RegistrationName"/>
			</cbc:RegistrationName>
			<cbc:CompanyID schemeID="{cbc:CompanyID/@schemeID}">
				<xsl:value-of select="cbc:CompanyID"/>
			</cbc:CompanyID>
		</cac:PartyLegalEntity>
	</xsl:template>

	<!--  Contact template -->
	<xsl:template match="cac:Contact">
		<cac:Contact>
			<xsl:if test="string(cbc:ID)">
				<cbc:ID>
					<xsl:value-of select="cbc:ID"/>
				</cbc:ID>
			</xsl:if>
			<xsl:if test="string(cbc:Name)">
				<cbc:Name>
					<xsl:value-of select="cbc:Name"/>
				</cbc:Name>
			</xsl:if>
			<xsl:if test="string(cbc:Telephone)">
				<cbc:Telephone>
					<xsl:value-of select="cbc:Telephone"/>
				</cbc:Telephone>
			</xsl:if>
			<xsl:if test="string(cbc:ElectronicMail)">
				<cbc:ElectronicMail>
					<xsl:value-of select="cbc:ElectronicMail"/>
				</cbc:ElectronicMail>
			</xsl:if>
		</cac:Contact>
	</xsl:template>

	<!--  Person template -->
	<xsl:template match="cac:Person">
		<xsl:if test="string(cbc:FirstName) or string(cbc:FamilyName)">
			<cac:Person>
				<xsl:if test="string(cbc:FirstName)">
					<cbc:FirstName>
						<xsl:value-of select="cbc:FirstName"/>
					</cbc:FirstName>
				</xsl:if>
				<xsl:if test="string(cbc:FamilyName)">
					<cbc:FamilyName>
						<xsl:value-of select="cbc:FamilyName"/>
					</cbc:FamilyName>
				</xsl:if>
			</cac:Person>
		</xsl:if>
	</xsl:template>

	<!--  Delivery template -->
	<xsl:template match="cac:Delivery">
		<cac:Delivery>
			<xsl:if test="string(cbc:ActualDeliveryDate)">
				<cbc:ActualDeliveryDate>
					<xsl:value-of select="cbc:ActualDeliveryDate"/>
				</cbc:ActualDeliveryDate>
			</xsl:if>
			<xsl:apply-templates select="cac:DeliveryLocation"/>
		</cac:Delivery>
	</xsl:template>

	<!--  DeliveryLocation template -->
	<xsl:template match="cac:DeliveryLocation">
		<cac:DeliveryLocation>
			<xsl:if test="string(cbc:ID)">
				<cbc:ID schemeAgencyID="{cbc:ID/@schemeAgencyID}" schemeID="{cbc:ID/@schemeID}">
					<xsl:value-of select="cbc:ID"/>
				</cbc:ID>
			</xsl:if>
			<xsl:apply-templates select="cac:Address"/>
		</cac:DeliveryLocation>
	</xsl:template>

	<!-- PaymentMeans template -->
	<xsl:template match="cac:PaymentMeans">
		<xsl:variable name="t1" select="cbc:PaymentMeansCode"/>
		<cac:PaymentMeans>
			<xsl:choose>
				<xsl:when test="$t1 = '31'">
					<xsl:call-template name="PaymentMeansCode31"/>
				</xsl:when>
				<xsl:when test="$t1 = '42'">
					<xsl:call-template name="PaymentMeansCode42"/>
				</xsl:when>
				<xsl:when test="$t1 = '49'">
					<xsl:call-template name="PaymentMeansCode49"/>
				</xsl:when>
				<xsl:when test="$t1 = '50'">
					<xsl:call-template name="PaymentMeansCode50"/>
				</xsl:when>
				<xsl:when test="$t1 = '93'">
					<xsl:call-template name="PaymentMeansCode93"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="PaymentMeansCode97"/>
				</xsl:otherwise>
			</xsl:choose>
		</cac:PaymentMeans>
	</xsl:template>

	<!--  PaymentTerms template -->
	<xsl:template match="cac:PaymentTerms">
		<xsl:if test="string(cbc:Note) or string(cbc:Amount)">
			<cac:PaymentTerms>
				<cbc:ID>1</cbc:ID>
				<cbc:PaymentMeansID>1</cbc:PaymentMeansID>
				<xsl:if test="string(cbc:Note)">
					<cbc:Note>
						<xsl:value-of select="cbc:Note"/>
					</cbc:Note>
				</xsl:if>
				<xsl:if test="string(cbc:Amount)">
					<cbc:Amount currencyID="{cbc:Amount/@currencyID}">
						<xsl:value-of select="cbc:Amount"/>
					</cbc:Amount>
				</xsl:if>
			</cac:PaymentTerms>
		</xsl:if>
	</xsl:template>

	<!--  AllowanceCharge template -->
	<xsl:template match="cac:AllowanceCharge">
		<cac:AllowanceCharge>
			<cbc:ChargeIndicator>
				<xsl:value-of select="cbc:ChargeIndicator"/>
			</cbc:ChargeIndicator>
			<xsl:if test="string(cbc:AllowanceChargeReason)">
				<cbc:AllowanceChargeReason>
					<xsl:value-of select="cbc:AllowanceChargeReason"/>
				</cbc:AllowanceChargeReason>
			</xsl:if>
			<cbc:Amount currencyID="{cbc:Amount/@currencyID}">
				<xsl:value-of select="cbc:Amount"/>
			</cbc:Amount>
			<xsl:apply-templates select="cac:TaxCategory"/>
		</cac:AllowanceCharge>
	</xsl:template>

	<!--  TaxExchangeRate template -->
	<xsl:template match="cac:TaxExchangeRate">
		<cac:TaxExchangeRate>
			<xsl:if test="string(cbc:SourceCurrencyCode)">
				<cbc:SourceCurrencyCode>
					<xsl:value-of select="cbc:SourceCurrencyCode"/>
				</cbc:SourceCurrencyCode>
			</xsl:if>
			<xsl:if test="string(cbc:TargetCurrencyCode)">
				<cbc:TargetCurrencyCode>
					<xsl:value-of select="cbc:TargetCurrencyCode"/>
				</cbc:TargetCurrencyCode>
			</xsl:if>
			<xsl:if test="string(cbc:CalculationRate)">
				<cbc:CalculationRate>
					<xsl:value-of select="cbc:CalculationRate"/>
				</cbc:CalculationRate>
			</xsl:if>
			<xsl:if test="string(cbc:MathematicOperatorCode)">
				<cbc:MathematicOperatorCode>
					<xsl:value-of select="cbc:MathematicOperatorCode"/>
				</cbc:MathematicOperatorCode>
			</xsl:if>
			<xsl:if test="string(cbc:Date)">
				<cbc:Date>
					<xsl:value-of select="cbc:Date"/>
				</cbc:Date>
			</xsl:if>
		</cac:TaxExchangeRate>
	</xsl:template>

	<!--  TaxTotal template -->
	<xsl:template match="cac:TaxTotal">
		<cac:TaxTotal>
			<cbc:TaxAmount currencyID="{cbc:TaxAmount/@currencyID}">
				<xsl:value-of select="cbc:TaxAmount"/>
			</cbc:TaxAmount>
			<xsl:apply-templates select="cac:TaxSubtotal"/>
		</cac:TaxTotal>
	</xsl:template>

	<!--  TaxSubtotal template -->
	<xsl:template match="cac:TaxSubtotal">
		<cac:TaxSubtotal>
			<cbc:TaxableAmount currencyID="{cbc:TaxableAmount/@currencyID}">
				<xsl:value-of select="cbc:TaxableAmount"/>
			</cbc:TaxableAmount>
			<cbc:TaxAmount currencyID="{cbc:TaxAmount/@currencyID}">
				<xsl:value-of select="cbc:TaxAmount"/>
			</cbc:TaxAmount>
			<xsl:if test="string(cbc:TransactionCurrencyTaxAmount)">
				<cbc:TransactionCurrencyTaxAmount
					currencyID="{cbc:TransactionCurrencyTaxAmount/@currencyID}">
					<xsl:value-of select="cbc:TransactionCurrencyTaxAmount"/>
				</cbc:TransactionCurrencyTaxAmount>
			</xsl:if>
			<xsl:apply-templates select="cac:TaxCategory"/>
		</cac:TaxSubtotal>
	</xsl:template>

	<!--  TaxCategory template -->
	<xsl:template match="cac:TaxCategory">
		<xsl:variable name="TSUBLids" select="',A,AA,AB,AC,AD,AE,B,C,E,G,H,O,S,Z,'"/>
		<xsl:variable name="t1">
			<xsl:choose>
				<xsl:when test="cbc:ID = 'StandardRated'">
					<xsl:value-of select="'S'"/>
				</xsl:when>
				<xsl:when test="cbc:ID = 'ZeroRated'">
					<xsl:value-of select="'Z'"/>
				</xsl:when>
				<xsl:when test="cbc:ID = 'ReverseCharge'">
					<xsl:value-of select="'AE'"/>
				</xsl:when>
				<xsl:when test="contains($TSUBLids, concat(',', cbc:ID, ','))">
					<xsl:value-of select="cbc:ID"/>
				</xsl:when>
				<xsl:otherwise>S</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cac:TaxCategory>
			<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
				<xsl:value-of select="$t1"/>
			</cbc:ID>
			<xsl:if test="string(cbc:Percent)">
				<cbc:Percent>
					<xsl:value-of select="cbc:Percent"/>
				</cbc:Percent>
			</xsl:if>
			<xsl:if test="string(cbc:BaseUnitMeasure)">
				<cbc:BaseUnitMeasure unitCode="EA">
					<xsl:value-of select="cbc:BaseUnitMeasure"/>
				</cbc:BaseUnitMeasure>
			</xsl:if>
			<xsl:if test="string(cbc:PerUnitAmount)">
				<cbc:PerUnitAmount currencyID="{cbc:PerUnitAmount/@currencyID}">
					<xsl:value-of select="cbc:PerUnitAmount"/>
				</cbc:PerUnitAmount>
			</xsl:if>
			<xsl:if test="string(cbc:TaxExemptionReason)">
				<cbc:TaxExemptionReason>
					<xsl:value-of select="cbc:TaxExemptionReason"/>
				</cbc:TaxExemptionReason>
			</xsl:if>
			<xsl:apply-templates select="cac:TaxScheme"/>
		</cac:TaxCategory>
	</xsl:template>

	<!--  TaxScheme template -->
	<xsl:template match="cac:TaxScheme">
		<xsl:variable name="OIOUBLidsEXC"
			select="',9,10,11,16,17,18,19,21,21a,21b,21c,21d,21e,21f,24,25,27,28,30,31,32,33,39,40,41,53,54,56,57,61,61a,62,69,70,71,72,75,76,77,79,85,86,87,91,94,94a,95,97,98,99,99a,100,108,109,110,110a,110b,110c,111,112,112a,112b,112c,112d,112e,112f,127,127a,127b,127c,128,130,133,134,135,136,137,138,139,140,142,146,151,152,0,'"/>
		<xsl:variable name="TSUBLids"
			select="',AAA,AAB,AAC,AAD,AAE,AAF,AAG,AAH,AAI,AAJ,AAK,AAL,ADD,BOL,CAP,CAR,COC,CST,CUD,CVD,ENV,EXC,EXP,FET,FRE,GCN,GST,ILL,IMP,IND,LAC,LCN,LDP,LOC,LST,MCA,MCD,OTH,PDB,PDC,PRF,SCN,SSS,STT,SUP,SUR,SWT,TAC,TOT,TOX,TTA,VAD,VAT,'"/>
		<xsl:variable name="t1">
			<xsl:choose>
				<xsl:when test="cbc:ID = '63'">
					<xsl:value-of select="'VAT'"/>
				</xsl:when>
				<xsl:when test="contains($OIOUBLidsEXC, concat(',', cbc:ID, ','))">
					<xsl:value-of select="'EXC'"/>
				</xsl:when>
				<xsl:when test="contains($TSUBLids, concat(',', cbc:ID, ','))">
					<xsl:value-of select="cbc:ID"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="cbc:ID"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cac:TaxScheme>
			<cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
				<xsl:value-of select="$t1"/>
			</cbc:ID>
			<cbc:Name>
				<xsl:value-of select="$t1"/>
			</cbc:Name>
			<xsl:if test="cbc:TaxTypeCode = 'StandardRated'">
				<cbc:TaxTypeCode>
					<xsl:value-of select="'S'"/>
				</cbc:TaxTypeCode>
			</xsl:if>
			<xsl:if test="cbc:TaxTypeCode = 'ZeroRated'">
				<cbc:TaxTypeCode>
					<xsl:value-of select="'Z'"/>
				</cbc:TaxTypeCode>
			</xsl:if>
		</cac:TaxScheme>
	</xsl:template>

	<!--  LegalMonetaryTotal template -->
	<xsl:template match="cac:LegalMonetaryTotal">
		<cac:LegalMonetaryTotal>
			<xsl:if test="string(cbc:LineExtensionAmount)">
				<cbc:LineExtensionAmount currencyID="{cbc:LineExtensionAmount/@currencyID}">
					<xsl:value-of select="cbc:LineExtensionAmount"/>
				</cbc:LineExtensionAmount>
			</xsl:if>
			<xsl:if test="string(cbc:TaxExclusiveAmount)">
				<cbc:TaxExclusiveAmount currencyID="{cbc:TaxExclusiveAmount/@currencyID}">
					<xsl:value-of select="cbc:TaxExclusiveAmount"/>
				</cbc:TaxExclusiveAmount>
			</xsl:if>
			<xsl:if test="string(cbc:TaxInclusiveAmount)">
				<cbc:TaxInclusiveAmount currencyID="{cbc:TaxInclusiveAmount/@currencyID}">
					<xsl:value-of select="cbc:TaxInclusiveAmount"/>
				</cbc:TaxInclusiveAmount>
			</xsl:if>
			<xsl:if test="string(cbc:AllowanceTotalAmount)">
				<cbc:AllowanceTotalAmount currencyID="{cbc:AllowanceTotalAmount/@currencyID}">
					<xsl:value-of select="cbc:AllowanceTotalAmount"/>
				</cbc:AllowanceTotalAmount>
			</xsl:if>
			<xsl:if test="string(cbc:ChargeTotalAmount)">
				<cbc:ChargeTotalAmount currencyID="{cbc:ChargeTotalAmount/@currencyID}">
					<xsl:value-of select="cbc:ChargeTotalAmount"/>
				</cbc:ChargeTotalAmount>
			</xsl:if>
			<xsl:if test="string(cbc:PrepaidAmount)">
				<cbc:PrepaidAmount currencyID="{cbc:PrepaidAmount/@currencyID}">
					<xsl:value-of select="cbc:PrepaidAmount"/>
				</cbc:PrepaidAmount>
			</xsl:if>
			<xsl:if test="string(cbc:PayableRoundingAmount)">
				<cbc:PayableRoundingAmount currencyID="{cbc:PayableRoundingAmount/@currencyID}">
					<xsl:value-of select="cbc:PayableRoundingAmount"/>
				</cbc:PayableRoundingAmount>
			</xsl:if>
			<cbc:PayableAmount currencyID="{cbc:PayableAmount/@currencyID}">
				<xsl:value-of select="cbc:PayableAmount"/>
			</cbc:PayableAmount>
		</cac:LegalMonetaryTotal>
	</xsl:template>

	<!-- InvoiceLine template -->
	<xsl:template match="cac:InvoiceLine">
		<xsl:variable name="fQuantity">
			<xsl:choose>
				<xsl:when test="string(cbc:InvoicedQuantity)">
					<xsl:value-of select="cbc:InvoicedQuantity"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'1'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="fUnitCode">
			<xsl:choose>
				<xsl:when test="string(cbc:InvoicedQuantity/@unitCode)">
					<xsl:value-of select="cbc:InvoicedQuantity/@unitCode"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="'EA'"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cac:InvoiceLine>
			<cbc:ID>
				<xsl:value-of select="cbc:ID"/>
			</cbc:ID>
			<xsl:if test="string(cbc:Note)">
				<cbc:Note>
					<xsl:value-of select="cbc:Note"/>
				</cbc:Note>
			</xsl:if>
			<cbc:InvoicedQuantity unitCode="{$fUnitCode}">
				<xsl:value-of select="$fQuantity"/>
			</cbc:InvoicedQuantity>
			<cbc:LineExtensionAmount currencyID="{cbc:LineExtensionAmount/@currencyID}">
				<xsl:value-of select="cbc:LineExtensionAmount"/>
			</cbc:LineExtensionAmount>
			<xsl:if test="string(cbc:AccountingCost)">
				<cbc:AccountingCost>
					<xsl:value-of select="cbc:AccountingCost"/>
				</cbc:AccountingCost>
			</xsl:if>
			<xsl:apply-templates select="cac:OrderLineReference"/>
			<xsl:apply-templates select="cac:DocumentReference"/>
			<xsl:apply-templates select="cac:AllowanceCharge"/>
			<xsl:apply-templates select="cac:TaxTotal"/>
			<xsl:apply-templates select="cac:Item"/>
			<xsl:apply-templates select="cac:Price"/>
		</cac:InvoiceLine>
	</xsl:template>

	<!--  OrderLineReference template -->
	<xsl:template match="cac:OrderLineReference">
		<cac:OrderLineReference>
			<cbc:LineID>
				<xsl:value-of select="cbc:LineID"/>
			</cbc:LineID>
			<xsl:apply-templates select="cac:OrderReference"/>
		</cac:OrderLineReference>
	</xsl:template>

	<!--  DocumentReference template -->
	<xsl:template match="cac:DocumentReference">
		<cac:DocumentReference>
			<cbc:ID>
				<xsl:value-of select="cbc:ID"/>
			</cbc:ID>
			<xsl:if test="string(cbc:UUID)">
				<cbc:UUID>
					<xsl:value-of select="cbc:UUID"/>
				</cbc:UUID>
			</xsl:if>
			<xsl:if test="string(cbc:IssueDate)">
				<cbc:IssueDate>
					<xsl:value-of select="cbc:IssueDate"/>
				</cbc:IssueDate>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentTypeCode)">
				<xsl:choose>
					<xsl:when test="string(cbc:DocumentTypeCode/@listID)">
						<cbc:DocumentTypeCode listID="{cbc:DocumentTypeCode/@listID}">
							<xsl:value-of select="cbc:DocumentTypeCode"/>
						</cbc:DocumentTypeCode>
					</xsl:when>
					<xsl:otherwise>
						<cbc:DocumentTypeCode>
							<xsl:value-of select="cbc:DocumentTypeCode"/>
						</cbc:DocumentTypeCode>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="string(cbc:DocumentType)">
				<cbc:DocumentType>
					<xsl:value-of select="cbc:DocumentType"/>
				</cbc:DocumentType>
			</xsl:if>
			<xsl:if test="string(cbc:XPath)">
				<cbc:XPath>
					<xsl:value-of select="cbc:XPath"/>
				</cbc:XPath>
			</xsl:if>
			<xsl:apply-templates select="cac:Attachment"/>
		</cac:DocumentReference>
	</xsl:template>

	<!--  Item template -->
	<xsl:template match="cac:Item">
		<xsl:variable name="fDescription">
			<xsl:choose>
				<xsl:when test="not(string(cbc:Description))">
					<xsl:value-of select="cbc:Name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="cbc:Description"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cac:Item>
			<xsl:if test="string($fDescription)">
				<cbc:Description>
					<xsl:value-of select="$fDescription"/>
				</cbc:Description>
			</xsl:if>
			<xsl:if test="string(cbc:Name)">
				<cbc:Name>
					<xsl:value-of select="cbc:Name"/>
				</cbc:Name>
			</xsl:if>
			<xsl:if test="string(cbc:ModelName)">
				<cbc:ModelName>
					<xsl:value-of select="cbc:ModelName"/>
				</cbc:ModelName>
			</xsl:if>
			<xsl:apply-templates select="cac:BuyersItemIdentification"/>
			<xsl:apply-templates select="cac:SellersItemIdentification"/>
			<xsl:apply-templates select="cac:ManufacturersItemIdentification"/>
			<xsl:apply-templates select="cac:StandardItemIdentification"/>
			<xsl:apply-templates select="cac:CatalogueItemIdentification"/>
			<xsl:apply-templates select="cac:AdditionalItemIdentification"/>
			<xsl:apply-templates select="cac:CommodityClassification"/>
			<!--  ClassifiedTaxCategory template -->
			<!--  AdditionalItemProperty template -->
		</cac:Item>
	</xsl:template>

	<!--  BuyersItemIdentification template -->
	<xsl:template match="cac:BuyersItemIdentification">
		<cac:BuyersItemIdentification>
			<xsl:call-template name="ItemIdentification"/>
		</cac:BuyersItemIdentification>
	</xsl:template>

	<!--  SellersItemIdentification template -->
	<xsl:template match="cac:SellersItemIdentification">
		<xsl:if test="string(cbc:ID)">
			<cac:SellersItemIdentification>
				<xsl:call-template name="ItemIdentification"/>
			</cac:SellersItemIdentification>
		</xsl:if>
	</xsl:template>

	<!--  ManufacturersItemIdentification template -->
	<xsl:template match="cac:ManufacturersItemIdentification">
		<cac:ManufacturersItemIdentification>
			<xsl:call-template name="ItemIdentification"/>
		</cac:ManufacturersItemIdentification>
	</xsl:template>

	<!--  StandardItemIdentification template -->
	<xsl:template match="cac:StandardItemIdentification">
		<cac:StandardItemIdentification>
			<xsl:call-template name="ItemIdentification"/>
		</cac:StandardItemIdentification>
	</xsl:template>

	<!--  CatalogueItemIdentification template -->
	<xsl:template match="cac:CatalogueItemIdentification">
		<cac:CatalogueItemIdentification>
			<xsl:call-template name="ItemIdentification"/>
		</cac:CatalogueItemIdentification>
	</xsl:template>

	<!--  AdditionalItemIdentification template -->
	<xsl:template match="cac:AdditionalItemIdentification">
		<cac:AdditionalItemIdentification>
			<xsl:call-template name="ItemIdentification"/>
		</cac:AdditionalItemIdentification>
	</xsl:template>

	<!--  CommodityClassification template -->
	<xsl:template match="cac:CommodityClassification">
		<cac:CommodityClassification>
			<cbc:ItemClassificationCode listAgencyID="{cbc:ItemClassificationCode/@listAgencyID}"
				listID="{cbc:ItemClassificationCode/@listID}"
				listVersionID="{cbc:ItemClassificationCode/@listVersionID}">
				<xsl:value-of select="cbc:ItemClassificationCode"/>
			</cbc:ItemClassificationCode>
		</cac:CommodityClassification>
	</xsl:template>

	<!--  Price template -->
	<xsl:template match="cac:Price">
		<cac:Price>
			<cbc:PriceAmount currencyID="{cbc:PriceAmount/@currencyID}">
				<xsl:value-of select="cbc:PriceAmount"/>
			</cbc:PriceAmount>
			<xsl:if test="string(cbc:BaseQuantity)">
				<cbc:BaseQuantity unitCode="{cbc:BaseQuantity/@unitCode}">
					<xsl:value-of select="cbc:BaseQuantity"/>
				</cbc:BaseQuantity>
			</xsl:if>
			<xsl:if test="string(cbc:OrderableUnitFactorRate)">
				<cbc:OrderableUnitFactorRate>
					<xsl:value-of select="cbc:OrderableUnitFactorRate"/>
				</cbc:OrderableUnitFactorRate>
			</xsl:if>
		</cac:Price>
	</xsl:template>



	<!-- .............................. -->
	<!--   Utility Templates            -->
	<!-- .............................. -->

	<!-- PaymentMeansCode31 template (International bank transfer) -->
	<xsl:template name="PaymentMeansCode31">
		<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
			>31</cbc:PaymentMeansCode>
		<xsl:if test="string(cbc:PaymentDueDate)">
			<cbc:PaymentDueDate>
				<xsl:value-of select="cbc:PaymentDueDate"/>
			</cbc:PaymentDueDate>
		</xsl:if>
		<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode">
			<xsl:value-of select="cbc:PaymentChannelCode"/>
		</cbc:PaymentChannelCode>
		<cac:PayeeFinancialAccount>
			<cbc:ID>
				<xsl:value-of select="cac:PayeeFinancialAccount/cbc:ID"/>
			</cbc:ID>
			<xsl:if test="string(cac:PayeeFinancialAccount/cbc:PaymentNote)">
				<cbc:PaymentNote>
					<xsl:value-of select="cac:PayeeFinancialAccount/cbc:PaymentNote"/>
				</cbc:PaymentNote>
			</xsl:if>
			<cac:FinancialInstitutionBranch>
				<xsl:if
					test="string(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID)">
					<cbc:ID>
						<xsl:value-of
							select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"
						/>
					</cbc:ID>
				</xsl:if>
				<cac:FinancialInstitution>
					<xsl:if
						test="string(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID)">
						<cbc:ID>
							<xsl:value-of
								select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:ID"
							/>
						</cbc:ID>
					</xsl:if>
					<xsl:if
						test="string(cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name)">
						<cbc:Name>
							<xsl:value-of
								select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cac:FinancialInstitution/cbc:Name"
							/>
						</cbc:Name>
					</xsl:if>
				</cac:FinancialInstitution>
			</cac:FinancialInstitutionBranch>
		</cac:PayeeFinancialAccount>
	</xsl:template>

	<!-- PaymentMeansCode42 template (Domestic transfer) -->
	<xsl:template name="PaymentMeansCode42">
		<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
			>42</cbc:PaymentMeansCode>
		<xsl:if test="string(cbc:PaymentDueDate)">
			<cbc:PaymentDueDate>
				<xsl:value-of select="cbc:PaymentDueDate"/>
			</cbc:PaymentDueDate>
		</xsl:if>
		<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode">
			<xsl:value-of select="cbc:PaymentChannelCode"/>
		</cbc:PaymentChannelCode>
		<cac:PayeeFinancialAccount>
			<cbc:ID>
				<xsl:value-of select="cac:PayeeFinancialAccount/cbc:ID"/>
			</cbc:ID>
			<cbc:PaymentNote>
				<xsl:value-of select="cac:PayeeFinancialAccount/cbc:PaymentNote"/>
			</cbc:PaymentNote>
			<cac:FinancialInstitutionBranch>
				<cbc:ID>
					<xsl:value-of
						select="cac:PayeeFinancialAccount/cac:FinancialInstitutionBranch/cbc:ID"/>
				</cbc:ID>
			</cac:FinancialInstitutionBranch>
		</cac:PayeeFinancialAccount>
	</xsl:template>

	<!-- PaymentMeansCode49 template (Betalingsservice) -->
	<xsl:template name="PaymentMeansCode49">
		<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
			>49</cbc:PaymentMeansCode>
		<xsl:if test="string(cbc:PaymentDueDate)">
			<cbc:PaymentDueDate>
				<xsl:value-of select="cbc:PaymentDueDate"/>
			</cbc:PaymentDueDate>
		</xsl:if>
		<xsl:if test="string(cbc:InstructionID)">
			<cbc:InstructionID>
				<xsl:value-of select="cbc:InstructionID"/>
			</cbc:InstructionID>
		</xsl:if>
		<xsl:if test="string(cbc:PaymentID)">
			<cbc:PaymentID schemeAgencyID="320" schemeID="urn:oioubl:id:paymentid-1.1">
				<xsl:value-of select="cbc:PaymentID"/>
			</cbc:PaymentID>
		</xsl:if>
		<xsl:if test="string(cac:CreditAccount/cbc:AccountID)">
			<cac:CreditAccount>
				<cbc:AccountID>
					<xsl:value-of select="cac:CreditAccount/cbc:AccountID"/>
				</cbc:AccountID>
			</cac:CreditAccount>
		</xsl:if>
	</xsl:template>

	<!-- PaymentMeansCode50 template (GIRO Indbetalingskort) -->
	<xsl:template name="PaymentMeansCode50">
		<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
			>50</cbc:PaymentMeansCode>
		<xsl:if test="string(cbc:PaymentDueDate)">
			<cbc:PaymentDueDate>
				<xsl:value-of select="cbc:PaymentDueDate"/>
			</cbc:PaymentDueDate>
		</xsl:if>
		<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode"
			>DK:GIRO</cbc:PaymentChannelCode>
		<xsl:if test="string(cbc:InstructionID)">
			<cbc:InstructionID>
				<xsl:value-of select="cbc:InstructionID"/>
			</cbc:InstructionID>
		</xsl:if>
		<xsl:if test="string(cbc:InstructionNote)">
			<cbc:InstructionNote>
				<xsl:value-of select="cbc:InstructionNote"/>
			</cbc:InstructionNote>
		</xsl:if>
		<cbc:PaymentID schemeAgencyID="320" schemeID="urn:oioubl:id:paymentid-1.1">
			<xsl:value-of select="cbc:PaymentID"/>
		</cbc:PaymentID>
		<cac:PayeeFinancialAccount>
			<cbc:ID>
				<xsl:value-of select="cac:PayeeFinancialAccount/cbc:ID"/>
			</cbc:ID>
		</cac:PayeeFinancialAccount>
	</xsl:template>

	<!-- PaymentMeansCode93 template (FIK Indbetalingskort) -->
	<xsl:template name="PaymentMeansCode93">
		<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
			>93</cbc:PaymentMeansCode>
		<xsl:if test="string(cbc:PaymentDueDate)">
			<cbc:PaymentDueDate>
				<xsl:value-of select="cbc:PaymentDueDate"/>
			</cbc:PaymentDueDate>
		</xsl:if>
		<xsl:if test="string(cbc:PaymentChannelCode)">
			<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode">
				<xsl:value-of select="cbc:PaymentChannelCode"/>
			</cbc:PaymentChannelCode>
		</xsl:if>
		<xsl:if test="string(cbc:InstructionID)">
			<cbc:InstructionID>
				<xsl:value-of select="cbc:InstructionID"/>
			</cbc:InstructionID>
		</xsl:if>
		<xsl:if test="string(cbc:InstructionNote)">
			<cbc:InstructionNote>
				<xsl:value-of select="cbc:InstructionNote"/>
			</cbc:InstructionNote>
		</xsl:if>
		<cbc:PaymentID schemeAgencyID="320" schemeID="urn:oioubl:id:paymentid-1.1">
			<xsl:value-of select="cbc:PaymentID"/>
		</cbc:PaymentID>
		<xsl:if test="string(cac:CreditAccount/cbc:AccountID)">
			<cac:CreditAccount>
				<cbc:AccountID>
					<xsl:value-of select="cac:CreditAccount/cbc:AccountID"/>
				</cbc:AccountID>
			</cac:CreditAccount>
		</xsl:if>
	</xsl:template>

	<!-- PaymentMeansCode97 template (bilateral) -->
	<xsl:template name="PaymentMeansCode97">
		<cbc:PaymentMeansCode listID="urn:tradeshift.com:api:1.0:paymentmeanscode"
			>97</cbc:PaymentMeansCode>
		<xsl:if test="string(cbc:PaymentDueDate)">
			<cbc:PaymentDueDate>
				<xsl:value-of select="cbc:PaymentDueDate"/>
			</cbc:PaymentDueDate>
		</xsl:if>
		<xsl:if test="string(cbc:PaymentChannelCode)">
			<cbc:PaymentChannelCode listID="urn:tradeshift.com:api:1.0:paymentchannelcode">
				<xsl:value-of select="cbc:PaymentChannelCode"/>
			</cbc:PaymentChannelCode>
		</xsl:if>
		<xsl:if test="string(cbc:PaymentID)">
			<cbc:PaymentID>
				<xsl:value-of select="cbc:PaymentID"/>
			</cbc:PaymentID>
		</xsl:if>
	</xsl:template>

	<!-- ItemIdentification -->
	<xsl:template name="ItemIdentification">
		<xsl:variable name="t1" select="cbc:ID/@schemeID"/>
		<xsl:variable name="t2" select="cbc:ID/@schemeAgencyID"/>
		<xsl:choose>
			<xsl:when test="$t1 = 'GTIN' and string-length(cbc:ID) = 13">
				<cbc:ID schemeAgencyID="9" schemeID="GTIN">
					<xsl:value-of select="cbc:ID"/>
				</cbc:ID>
			</xsl:when>
			<xsl:when test="$t1 = 'GTIN' and string-length(cbc:ID) != 13">
				<cbc:ID>
					<xsl:value-of select="cbc:ID"/>
				</cbc:ID>
			</xsl:when>
			<xsl:when test="string($t1)">
				<cbc:ID schemeID="{$t1}">
					<xsl:value-of select="cbc:ID"/>
				</cbc:ID>
			</xsl:when>
			<xsl:otherwise>
				<cbc:ID>
					<xsl:value-of select="cbc:ID"/>
				</cbc:ID>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!--  Address template -->
	<xsl:template name="Address">
		<xsl:variable name="t2">
			<xsl:choose>
				<xsl:when test="string(cbc:StreetName)">
					<xsl:value-of select="cbc:StreetName"/>
				</xsl:when>
				<xsl:when test="string(cac:AddressLine/cbc:Line)">
					<xsl:apply-templates select="cac:AddressLine"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="''"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477" listVersionID="D08B"
			>5</cbc:AddressFormatCode>
		<xsl:if test="string($t2)">
			<cbc:StreetName>
				<xsl:value-of select="$t2"/>
			</cbc:StreetName>
		</xsl:if>
		<xsl:if test="string(cbc:AdditionalStreetName)">
			<cbc:AdditionalStreetName>
				<xsl:value-of select="cbc:AdditionalStreetName"/>
			</cbc:AdditionalStreetName>
		</xsl:if>
		<xsl:if test="string(cbc:BuildingNumber)">
			<cbc:BuildingNumber>
				<xsl:value-of select="cbc:BuildingNumber"/>
			</cbc:BuildingNumber>
		</xsl:if>
		<xsl:if test="string(cbc:MarkAttention)">
			<cbc:MarkAttention>
				<xsl:value-of select="cbc:MarkAttention"/>
			</cbc:MarkAttention>
		</xsl:if>
		<xsl:if test="string(cbc:CityName)">
			<cbc:CityName>
				<xsl:value-of select="cbc:CityName"/>
			</cbc:CityName>
		</xsl:if>
		<xsl:if test="string(cbc:PostalZone)">
			<cbc:PostalZone>
				<xsl:value-of select="cbc:PostalZone"/>
			</cbc:PostalZone>
		</xsl:if>
		<xsl:if test="string(cbc:CountrySubentity)">
			<cbc:CountrySubentity>
				<xsl:value-of select="cbc:CountrySubentity"/>
			</cbc:CountrySubentity>
		</xsl:if>
		<xsl:if test="string(cac:Country/cbc:IdentificationCode)">
			<cac:Country>
				<cbc:IdentificationCode>
					<xsl:value-of select="cac:Country/cbc:IdentificationCode"/>
				</cbc:IdentificationCode>
			</cac:Country>
		</xsl:if>
	</xsl:template>

	<!--  Addressline template -->
	<xsl:template match="cac:AddressLine">
		<xsl:variable name="t1">
			<xsl:choose>
				<xsl:when test="string(./cbc:Line)">
					<xsl:value-of select="./cbc:Line"/>
				</xsl:when>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="position() = last()">
				<xsl:value-of select="$t1"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="concat($t1, ',&#160;')"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
