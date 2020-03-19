<?xml version="1.0" encoding="UTF-8"?>

<!--
******************************************************************************************************************
        TSUBL Stylesheet	
        title= bbw_cXML_2_TSUBL_INV_v01p01	
        publisher= "Tradeshift"
        creator= "IngKye Ng, Tradeshift"
        created= 2019-01-29
        modified= 2020-03-19
        issued= 2020-03-19
        
******************************************************************************************************************
-->

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:functx="http://www.functx.com"
                xmlns:metadata-util="java:com.babelway.messaging.transformation.xslt.function.MetadataUtil"
                xmlns:bbw="java:com.babelway.messaging.transformation.xslt.function.BabelwayFunctions"
                xmlns:bbwx="http://xmlns.babelway.com/com.babelway.messaging.transformation.xslt.function.BBWXContextFactory"
                exclude-result-prefixes="xs metadata-util bbw bbwx functx">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" omit-xml-declaration="no"/>
    <xsl:strip-space elements="*"/>
    <xsl:param name="MSG"/>

    <xsl:variable name="g1"
                  select="format-number(sum(/cXML/Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem/SubtotalAmount/Money), '0.00##')"/>
    <xsl:variable name="g2"
                  select="format-number(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money, '0.00##')"/>
    <xsl:variable name="g3" select="format-number(number($g2) - number($g1), '0.00##')"/>
    <xsl:variable name="g4"
                  select="format-number(/cXML/Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money, '0.00##')"/>
    
    <xsl:function name="functx:substring-after-if-contains" as="xs:string?">
        <xsl:param name="arg" as="xs:string?"/>
        <xsl:param name="delim" as="xs:string"/>
        
        <xsl:sequence select="
            if (contains($arg,$delim))
            then substring-after($arg,$delim)
            else $arg
            "/>
    </xsl:function>
    
    <xsl:function name="functx:note-extraction" as="xs:string?">
        <xsl:param name="note"/>
        <xsl:param name="label"/>
        
        <xsl:for-each select="tokenize($note, '\n\r?')[.]">
            <xsl:if test="contains(.,$label)">
                <xsl:value-of select="bbw:trim(functx:substring-after-if-contains(.,$label))"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:function>

    <xsl:variable name="GHXflag">
        <xsl:choose>
            <xsl:when test="number($g3) &gt; 0 and $g3 = $g4">
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
            <Errortext>Fatal error: Unsupported documenttype! This stylesheet only supports conversion of a cXML
                invoice.
            </Errortext>
            <Input>
                <xsl:value-of select="."/>
            </Input>
        </Error>
    </xsl:template>

    <xsl:template match="/cXML">

        <!-- Parameters (please assign before using this stylesheet) -->

        <!-- End parameters -->


        <!-- Global Headerfields -->

        <xsl:variable name="UBLVersionID" select="'2.0'"/>

        <xsl:variable name="CustomizationID" select="'urn:tradeshift.com:ubl-2.0-customizations:2010-06'"/>

        <xsl:variable name="ProfileID" select="'urn:www.cenbii.eu:profile:bii04:ver1.0'"/>

        <xsl:variable name="ProfileID_schemeID" select="'CWA 16073:2010'"/>

        <xsl:variable name="ProfileID_schemeAgencyID" select="'CEN/ISSS WS/BII'"/>

        <xsl:variable name="DocID" select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceID"/>

        <xsl:variable name="DocDate" select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@invoiceDate"/>

        <xsl:variable name="TaxDate">
            <xsl:choose>
                <xsl:when test="string(Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate)">
                    <xsl:value-of
                            select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@taxPointDate"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$DocDate"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="PaymentCode" select="functx:note-extraction(Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments,'PaymentCode:')"/>
        
        <xsl:variable name="SortCode" select="functx:note-extraction(Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments,'SortCode:')"/>
        
        <xsl:variable name="BankAcctNum" select="functx:note-extraction(Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments,'AccountNumber:')"/>
        
        <xsl:variable name="PaymentID" select="functx:note-extraction(Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments,'PaymentID:')"/>
        
        <xsl:variable name="BankName" select="functx:note-extraction(Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments,'BankName:')"/>
        
        <xsl:variable name="Note">
            <xsl:choose>
                <xsl:when test="string($PaymentCode) or string($SortCode) or string($BankAcctNum) or string($PaymentID) or string($BankName)">
                    <xsl:value-of select="functx:note-extraction(Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments,'Freetext:')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Comments"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="InvoiceTypeCode">
            <xsl:choose>
                <xsl:when test="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose='standard'">
                    <xsl:value-of select="380"/>
                </xsl:when>
                <xsl:when test="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/@purpose='creditMemo'">
                    <xsl:value-of select="381"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="380"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="CurrencyCode"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@currency"/>

        <xsl:variable name="AccCost"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='CostCenter']"/>

        <xsl:variable name="RefID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/OrderReference/@orderID"/>
        
        <xsl:variable name="InvRefID"
            select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceID"/>
        
        <xsl:variable name="InvRefDate"
            select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceIDInfo/@invoiceDate"/>

        <xsl:variable name="SelRefID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailOrderInfo/SupplierOrderInfo/@orderID"/>

        <xsl:variable name="InvoiceContractReferenceID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='CTID']"/>

        <xsl:variable name="RefDate" select="''"/>

        <xsl:variable name="InvoiceFileReferenceID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='FileID']"/>

        <xsl:variable name="InvoiceBOLReferenceID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='BOL']"/>

        <xsl:variable name="InvoiceVehicleNumber"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='VehicleNumber']"/>

        <xsl:variable name="SeEndpointID" select="Header/From/Credential/Identity"/>

        <xsl:variable name="SeEndpointIDtype" select="'DUNS'"/>

        <xsl:variable name="SePartySenderAssigned"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/IdReference[@domain='SenderAssigned']/@identifier"/>

        <xsl:variable name="SePartyGLN" select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/IdReference[@domain='GLN']/@identifier"/>

        <xsl:variable name="SePartyLEGAL"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/IdReference[@domain='legalID']/@identifier"/>

        <xsl:variable name="SePartyLEGALscheme" select="''"/>

        <xsl:variable name="SePartyTAX"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/IdReference[@domain='vatID']/@identifier"/>

        <xsl:variable name="SePartyTAXscheme" select="''"/>

        <xsl:variable name="SeName"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/Name"/>

        <xsl:variable name="SeStreet1"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/PostalAddress/Street"/>

        <xsl:variable name="SeStreet2"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/PostalAddress/Street[2]"/>

        <xsl:variable name="SeCity"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/PostalAddress/City"/>

        <xsl:variable name="SeZip"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/PostalAddress/PostalCode"/>

        <xsl:variable name="SeState"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/PostalAddress/State"/>

        <xsl:variable name="SeCountry"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/PostalAddress/Country/@isoCountryCode"/>

        <xsl:variable name="SeRef" select="''"/>

        <xsl:variable name="SeRefName" select="''"/>

        <xsl:variable name="t11"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/Phone/TelephoneNumber/CountryCode"/>
        <xsl:variable name="t12"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/Phone/TelephoneNumber/AreaOrCityCode"/>
        <xsl:variable name="t13"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/Phone/TelephoneNumber/Number"/>
        <xsl:variable name="SeRefTlf" select="concat($t11, $t12, $t13)"/>

        <xsl:variable name="SeRefMail"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'issuerOfInvoice']/Contact/Email"/>


        <xsl:variable name="IpCustomerAssignedAccountID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='CustomerAssignedAccountID']"/>

        <xsl:variable name="IpEndpointID" select="Header/To/Credential/Identity"/>

        <xsl:variable name="IpEndpointIDtype" select="'DUNS'"/>

        <xsl:variable name="IpPartyTSGLI"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/IdReference[@domain='tsgliID']/@identifier"/>

        <xsl:variable name="IpPartyTSID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/IdReference[@domain='tsID']/@identifier"/>

        <xsl:variable name="IpPartySenderAssigned"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/IdReference[@domain='SenderAssigned']/@identifier"/>

        <xsl:variable name="IpPartyTSLEID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/IdReference[@domain='tsleID']/@identifier"/>

        <xsl:variable name="IpPartyGLN" select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/IdReference[@domain='GLN']/@identifier"/>

        <xsl:variable name="IpPartyLEGAL"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/IdReference[@domain='legalID']/@identifier"/>

        <xsl:variable name="IpPartyLEGALscheme" select="''"/>

        <xsl:variable name="IpPartyTAX"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/IdReference[@domain='vatID']/@identifier"/>

        <xsl:variable name="IpPartyTAXscheme" select="''"/>

        <xsl:variable name="IpName"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/Name"/>

        <xsl:variable name="IpStreet1"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/PostalAddress/Street"/>

        <xsl:variable name="IpStreet2"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/PostalAddress/Street[2]"/>

        <xsl:variable name="IpCity"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/PostalAddress/City"/>

        <xsl:variable name="IpZip"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/PostalAddress/PostalCode"/>

        <xsl:variable name="IpState"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/PostalAddress/State"/>

        <xsl:variable name="IpCountry"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/PostalAddress/Country/@isoCountryCode"/>

        <xsl:variable name="IpRef"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='InvoiceReceiverContactID']"/>

        <xsl:variable name="IpRefName" select="''"/>

        <xsl:variable name="t21"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/Phone/TelephoneNumber/CountryCode"/>
        <xsl:variable name="t22"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/Phone/TelephoneNumber/AreaOrCityCode"/>
        <xsl:variable name="t23"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/Phone/TelephoneNumber/Number"/>
        <xsl:variable name="IpRefTlf" select="concat($t21, $t22, $t23)"/>

        <xsl:variable name="IpRefMail"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'billTo']/Contact/Email"/>


        <xsl:variable name="DelDate"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Period/@startDate"/>

        <xsl:variable name="DelIDtype" select="''"/>

        <xsl:variable name="DelID" select="''"/>

        <xsl:variable name="DelName"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/Contact/Name"/>

        <xsl:variable name="DelStreet1"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/Contact/PostalAddress/Street"/>

        <xsl:variable name="DelStreet2"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/Contact/PostalAddress/Street[2]"/>

        <xsl:variable name="DelCity"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/Contact/PostalAddress/City"/>

        <xsl:variable name="DelZip"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/Contact/PostalAddress/PostalCode"/>

        <xsl:variable name="DelState"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/Contact/PostalAddress/State"/>

        <xsl:variable name="DelCountry"
                      select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoicePartner[Contact/@role = 'soldTo']/Contact/PostalAddress/Country/@isoCountryCode"/>

        <xsl:variable name="PayDate"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail/@paymentDate"/>

        <xsl:variable name="PayNote" select="''"/>

        <xsl:variable name="AllowanceAmount"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/InvoiceDetailDiscount/Money"/>

        <xsl:variable name="AllowanceReason" select="'General discount'"/>

        <xsl:variable name="ChargeAmount1"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Money"/>

        <xsl:variable name="ChargeReason1"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/SpecialHandlingAmount/Description/ShortName"/>

        <xsl:variable name="ChargeAmount2"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Money"/>

        <xsl:variable name="ChargeReason2"
            select="Request/InvoiceDetailRequest/InvoiceDetailSummary/ShippingAmount/Description/ShortName"/>

        <xsl:variable name="TaxExchangeRateTargetCurrencyCode"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money/@alternateCurrency"/>

        <xsl:variable name="TaxExchangeRateTargetAmount"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/TaxAmount/Money/@alternateAmount"/>

        <xsl:variable name="TaxExchangeRateCalculationRate"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Extrinsic[@name='alternateExchangerate']"/>

        <xsl:variable name="TaxExchangeRateDate">
            <xsl:choose>
                <xsl:when
                        test="string(Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Extrinsic[@name='alternateExchangerateDate'])">
                    <xsl:value-of
                            select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Extrinsic[@name='alternateExchangerateDate']"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$DocDate"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>


        <xsl:variable name="TaxRate"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/@percentageRate"/>

        <xsl:variable name="TaxRateCode"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/Description"/>

        <xsl:variable name="TaxSchemeID"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/@category"/>

        <xsl:variable name="TaxSchemeName"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/@category"/>

        <xsl:variable name="TaxAmount" select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/Money"/>

        <xsl:variable name="TaxableAmount"
                      select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail[1]/TaxableAmount/Money"/>

        <xsl:variable name="LineTotal" select="Request/InvoiceDetailRequest/InvoiceDetailSummary/SubtotalAmount/Money"/>

        <xsl:variable name="InvTotal" select="Request/InvoiceDetailRequest/InvoiceDetailSummary/NetAmount/Money"/>


        <!-- Global conversions etc. -->

        <xsl:variable name="fIpAddressFlag">
            <xsl:choose>
                <xsl:when
                        test="string($IpStreet1) or string($IpStreet2) or string($IpCity) or string($IpZip) or string($IpState) or string($IpCountry)">
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
                        test="string($SeStreet1) or string($SeStreet2) or string($SeCity) or string($SeZip) or string($SeState) or string($SeCountry)">
                    <xsl:value-of select="'true'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'false'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fPaymentFlag">
            <xsl:choose>
                <xsl:when test="string($PaymentCode) or string($PayDate)">
                    <xsl:value-of select="'true'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'false'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="h4" select="format-number(number(translate($LineTotal,',', '')),'##.00')"/>
        <xsl:variable name="fLineTotal">
            <xsl:choose>
                <xsl:when test="$h4 = 'NaN'">
                    <xsl:value-of select="$LineTotal"/>
                </xsl:when>
                <xsl:when test="$GHXflag = 'true'">
                    <xsl:value-of select="$g1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$h4"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="h2" select="format-number(number(translate($TaxAmount,',', '')),'##.00')"/>
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

        <xsl:variable name="h1" select="format-number(number(translate($TaxableAmount,',', '')),'##.00')"/>
        <xsl:variable name="fTaxableAmount">
            <xsl:choose>
                <xsl:when test="$h1 = 'NaN'">
                    <xsl:value-of select="'0.00'"/>
                </xsl:when>
                <xsl:when test="$GHXflag = 'true'">
                    <xsl:value-of select="$g2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$h1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="h5" select="format-number(number(translate($TaxExchangeRateTargetAmount,',', '')),'##.00')"/>
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

        <xsl:variable name="fTaxRate">
            <xsl:choose>
                <xsl:when test="string($TaxRate)">
                    <xsl:value-of select="$TaxRate"/>
                </xsl:when>
                <xsl:when test="$fTaxAmount = 0 or $fTaxableAmount = 0">00</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="format-number(($fTaxAmount div $fTaxableAmount) * 100,'##.##')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="noTaxPercent">
            <xsl:choose>
                <xsl:when test="string($TaxRate)">false</xsl:when>
                <xsl:when test="$fTaxAmount = 0 or $fTaxableAmount = 0">false</xsl:when>
                <xsl:when test="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail and not(string($TaxRate))">true</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fTaxSchemeID">
            <xsl:choose>
                <xsl:when test="$TaxSchemeID = 'vat'">VAT</xsl:when>
                <xsl:when test="$TaxSchemeID = 'gst'">GST</xsl:when>
                <xsl:when test="$TaxSchemeID = 'stt'">STT</xsl:when>
                
                <xsl:otherwise>OTH</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fTaxSchemeName">
            <xsl:choose>
                <xsl:when test="$TaxSchemeName = 'vat'">VAT</xsl:when>
                <xsl:when test="$TaxSchemeName = 'gst'">GST</xsl:when>
                <xsl:when test="$TaxSchemeName = 'stt'">STT</xsl:when>
                <xsl:when test="string($TaxSchemeName)">
                    <xsl:value-of select="$TaxSchemeName"/>
                </xsl:when>
                <xsl:otherwise>OTH</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fTaxRateCode">
            <xsl:choose>
                <xsl:when test="$TaxRateCode = 'Standard'">S</xsl:when>
                <xsl:when test="$TaxRateCode = 'Reduced'">AA</xsl:when>
                <xsl:when test="$TaxRateCode = 'Zero'">Z</xsl:when>
                <xsl:when test="$TaxRateCode = 'Exempt'">E</xsl:when>
                <xsl:when test="$fTaxAmount = 0">Z</xsl:when>
                <xsl:otherwise>S</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="h3" select="format-number(number(translate($InvTotal,',', '')),'##.00')"/>
        <xsl:variable name="fInvTotal">
            <xsl:choose>
                <xsl:when test="$h3 = 'NaN'">
                    <xsl:value-of select="$InvTotal"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$h3"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="h8" select="format-number(number(translate($AllowanceAmount,',', '')),'##.00')"/>
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

        <xsl:variable name="h9" select="format-number(number(translate($ChargeAmount1,',', '')),'##.00')"/>
        <xsl:variable name="fChargeAmount1">
            <xsl:choose>
                <xsl:when test="$h9 = 'NaN'">
                    <xsl:value-of select="'0.00'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$h9"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fChargeReason1">
            <xsl:choose>
                <xsl:when test="string($ChargeReason1)">
                    <xsl:value-of select="$ChargeReason1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'Special handling'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="fChargeReason2">
            <xsl:choose>
                <xsl:when test="string($ChargeReason2)">
                    <xsl:value-of select="$ChargeReason2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'Shipping'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="h10" select="format-number(number(translate($ChargeAmount2,',', '')),'##.00')"/>
        <xsl:variable name="fChargeAmount2">
            <xsl:choose>
                <xsl:when test="$h10 = 'NaN'">
                    <xsl:value-of select="'0.00'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$h10"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="fChargeAmountTotal" select="format-number($fChargeAmount1 + $fChargeAmount2,'##.00')"/>

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

        <xsl:variable name="fDocDate" select="substring($DocDate, 1, 10)"/>

        <xsl:variable name="fTaxDate" select="substring($TaxDate, 1, 10)"/>

        <xsl:variable name="fRefDate" select="substring($RefDate, 1, 10)"/>
        
        <xsl:variable name="fInvRefDate" select="substring($InvRefDate, 1, 10)"/>

        <xsl:variable name="fDelDate" select="substring($DelDate, 1, 10)"/>

        <xsl:variable name="fPayDate" select="substring($PayDate, 1, 10)"/>

        <xsl:variable name="fTaxExchangeRateDate" select="substring($TaxExchangeRateDate, 1, 10)"/>
        
        <xsl:if test="$MSG">
            <xsl:value-of select="metadata-util:put($MSG, 'com_babelway_messaging_context_message_reference', string(concat('INV', $DocID, '_', $SeCountry)))"/>
        </xsl:if>

        <!-- Start of Invoice -->
        <Invoice>

            <cbc:UBLVersionID>
                <xsl:value-of select="$UBLVersionID"/>
            </cbc:UBLVersionID>

            <cbc:CustomizationID>
                <xsl:value-of select="$CustomizationID"/>
            </cbc:CustomizationID>

            <cbc:ProfileID schemeAgencyID="{$ProfileID_schemeAgencyID}" schemeID="{$ProfileID_schemeID}">
                <xsl:value-of select="$ProfileID"/>
            </cbc:ProfileID>

            <cbc:ID>
                <xsl:value-of select="$DocID"/>
            </cbc:ID>

            <cbc:IssueDate>
                <xsl:value-of select="$fDocDate"/>
            </cbc:IssueDate>

            <xsl:if test="$InvoiceTypeCode != '381'">
                <cbc:InvoiceTypeCode listAgencyID="6" listID="UN/ECE 1001 Subset">
                    <xsl:value-of select="$InvoiceTypeCode"/>
                </cbc:InvoiceTypeCode>
            </xsl:if>

            <xsl:if test="string($Note)">
                <cbc:Note>
                    <xsl:value-of select="$Note"/>
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
                    <xsl:if test="string($SelRefID)">
                        <cbc:SalesOrderID>
                            <xsl:value-of select="$SelRefID"/>
                        </cbc:SalesOrderID>
                    </xsl:if>
                    <xsl:if test="string($fRefDate)">
                        <cbc:IssueDate>
                            <xsl:value-of select="$fRefDate"/>
                        </cbc:IssueDate>
                    </xsl:if>
                </cac:OrderReference>
            </xsl:if>
            
            <xsl:if test="string($InvRefID)">
                <cac:BillingReference>
                    <cac:InvoiceDocumentReference>
                        <cbc:ID>
                            <xsl:value-of select="$InvRefID"/>
                        </cbc:ID>
                        <xsl:if test="string($fInvRefDate)">
                            <cbc:IssueDate>
                                <xsl:value-of select="$fInvRefDate"/>
                            </cbc:IssueDate>
                        </xsl:if>
                    </cac:InvoiceDocumentReference>
                </cac:BillingReference>
            </xsl:if>

            <xsl:if test="string($InvoiceContractReferenceID)">
              <cac:ContractDocumentReference>
                <cbc:ID>
                  <xsl:value-of select="$InvoiceContractReferenceID"/>
                </cbc:ID>
              </cac:ContractDocumentReference>
           </xsl:if>

            <xsl:if test="string($InvoiceFileReferenceID)">
                <cac:AdditionalDocumentReference>
                    <cbc:ID>
                        <xsl:value-of select="$InvoiceFileReferenceID"/>
                    </cbc:ID>
                    <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">File ID</cbc:DocumentTypeCode>
                </cac:AdditionalDocumentReference>
            </xsl:if>

            <xsl:if test="string($InvoiceBOLReferenceID)">
                <cac:AdditionalDocumentReference>
                    <cbc:ID>
                        <xsl:value-of select="$InvoiceBOLReferenceID"/>
                    </cbc:ID>
                    <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">BOL ID</cbc:DocumentTypeCode>
                </cac:AdditionalDocumentReference>
            </xsl:if>

            <xsl:if test="string($InvoiceVehicleNumber)">
                <cac:AdditionalDocumentReference>
                    <cbc:ID>
                        <xsl:value-of select="$InvoiceVehicleNumber"/>
                    </cbc:ID>
                    <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">VN ID</cbc:DocumentTypeCode>
                </cac:AdditionalDocumentReference>
            </xsl:if>
            
            <xsl:if test="bbw:metadata('inFile') != ''">
                <cac:AdditionalDocumentReference>
                    <cbc:ID>1</cbc:ID>
                    <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">sourcedocument</cbc:DocumentTypeCode>
                    <cac:Attachment>
                        <cbc:EmbeddedDocumentBinaryObject encodingCode="Base64" filename="sourcedocument" mimeCode="application/xml">
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
                        <cbc:EmbeddedDocumentBinaryObject encodingCode="Base64" filename="attachment">
                            <xsl:attribute name="mimeCode">
				<xsl:value-of select="bbw:metadata('mimeCode')"/>
			    </xsl:attribute>
                            <xsl:value-of select="bbw:metadataBase64('attachment')" disable-output-escaping="no"/>
                        </cbc:EmbeddedDocumentBinaryObject>
                    </cac:Attachment>
                </cac:AdditionalDocumentReference>
            </xsl:if>
           
            <cac:AccountingSupplierParty>
                <cac:Party>
                    <xsl:if test="string($SeEndpointID)">
                        <cbc:EndpointID schemeID="{$SeEndpointIDtype}">
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
                    <cac:PartyName>
                        <cbc:Name>
                            <xsl:value-of select="$SeName"/>
                        </cbc:Name>
                    </cac:PartyName>
                    <xsl:if test="$fSeAddressFlag = 'true'">
                        <cac:PostalAddress>
                            <cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
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
                                <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
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
                    <xsl:if test="string($SeRef) or string($SeRefName) or string($SeRefTlf) or string($SeRefMail)">
                        <cac:Contact>
                            <xsl:if test="string($SeRef)">
                                <cbc:ID>
                                    <xsl:value-of select="$SeRef"/>
                                </cbc:ID>
                            </xsl:if>
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
                        <cbc:EndpointID schemeID="{$IpEndpointIDtype}">
                            <xsl:value-of select="$IpEndpointID"/>
                        </cbc:EndpointID>
                    </xsl:if>
                    <xsl:if test="string($IpPartySenderAssigned)">
                        <xsl:variable name="SAtag1" select="substring-before($IpPartySenderAssigned, '$')"/>
                        <xsl:variable name="h21" select="substring-after($IpPartySenderAssigned, '$')"/>
                        <xsl:variable name="SAtag2" select="substring-before($h21, '$')"/>
                        <xsl:variable name="h22" select="substring-after($h21, '$')"/>
                        <xsl:variable name="SAtag3">
                            <xsl:choose>
                                <xsl:when test="contains($h22, '$')">
                                    <xsl:value-of select="substring-before($h22, '$')"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$h22"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:variable name="h23" select="substring-after($h22, '$')"/>
                        <xsl:variable name="SAtag4" select="substring-before($h23, '$')"/>
                        <xsl:variable name="SAtag5" select="substring-after($h23, '$')"/>
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
                    <xsl:if test="string($IpPartyTSID)">
                        <cac:PartyIdentification>
                            <cbc:ID schemeID="TS:ID">
                                <xsl:value-of select="$IpPartyTSID"/>
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
                    <cac:PartyName>
                        <cbc:Name>
                            <xsl:value-of select="$IpName"/>
                        </cbc:Name>
                    </cac:PartyName>
                    <xsl:if test="$fIpAddressFlag = 'true'">
                        <cac:PostalAddress>
                            <cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
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
                                <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
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
                    <xsl:if test="string($IpRef) or string($IpRefName) or string($IpRefTlf) or string($IpRefMail)">
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
                                    <cbc:AddressFormatCode listAgencyID="6" listID="UN/ECE 3477">5</cbc:AddressFormatCode>
                                    <xsl:if test="string($DelStreet1)">
                                        <cbc:StreetName>
                                            <xsl:value-of select="$DelStreet1"/>
                                        </cbc:StreetName>
                                    </xsl:if>
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
                                    <xsl:if test="string($DelCity)">
                                        <cbc:CityName>
                                            <xsl:value-of select="$DelCity"/>
                                        </cbc:CityName>
                                    </xsl:if>
                                    <xsl:if test="string($DelZip)">
                                        <cbc:PostalZone>
                                            <xsl:value-of select="$DelZip"/>
                                        </cbc:PostalZone>
                                    </xsl:if>
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

            <xsl:if test="$fPaymentFlag = 'true' and $InvoiceTypeCode != '381'">
                <cac:PaymentMeans>
                    <cbc:ID>1</cbc:ID>
                    <xsl:choose>
                        <xsl:when test="$PaymentCode = '42'">
                            <cbc:PaymentMeansCode>
                                <xsl:value-of select="$PaymentCode"/>
                            </cbc:PaymentMeansCode>
                            <xsl:if test="string($fPayDate)">
                                <cbc:PaymentDueDate>
                                    <xsl:value-of select="$fPayDate"/>
                                </cbc:PaymentDueDate>
                            </xsl:if>
                            
                            <xsl:choose>
                                <xsl:when test="$SeCountry='CH'">
                                    <cbc:PaymentChannelCode listAgencyID="320"
                                        listID="urn:oioubl:codelist:paymentchannelcode-1.1">CH:BANK</cbc:PaymentChannelCode>
                                </xsl:when>
                                <xsl:otherwise>
                                    <cbc:PaymentChannelCode listAgencyID="320"
                                        listID="urn:oioubl:codelist:paymentchannelcode-1.1">BBAN</cbc:PaymentChannelCode>
                                </xsl:otherwise>
                            </xsl:choose>
                            
                            <xsl:if test="string($PaymentID)">
                                <cbc:PaymentID>
                                    <xsl:value-of select="$PaymentID"/>
                                </cbc:PaymentID>
                            </xsl:if>
                            
                            <cac:PayeeFinancialAccount>
                                <cbc:ID>
                                    <xsl:value-of select="$BankAcctNum"/>
                                </cbc:ID>
                                <xsl:if test="string($PayNote)">
                                    <cbc:PaymentNote>
                                        <xsl:value-of select="$PayNote"/>
                                    </cbc:PaymentNote>
                                </xsl:if>
                                <cac:FinancialInstitutionBranch>
                                    <cbc:ID>
                                        <xsl:value-of select="$SortCode"/>
                                    </cbc:ID>
                                    <cbc:Name>
                                        <xsl:value-of select="$BankName"/>
                                    </cbc:Name>
                                    <cac:FinancialInstitution>
                                        <cbc:Name>
                                            <xsl:value-of select="$BankName"/>
                                        </cbc:Name>
                                    </cac:FinancialInstitution>
                                </cac:FinancialInstitutionBranch>
                            </cac:PayeeFinancialAccount>
                        </xsl:when>

                        <xsl:when test="$PaymentCode = '31'">
                            <cbc:PaymentMeansCode>42</cbc:PaymentMeansCode>
                            <xsl:if test="string($fPayDate)">
                                <cbc:PaymentDueDate>
                                    <xsl:value-of select="$fPayDate"/>
                                </cbc:PaymentDueDate>
                            </xsl:if>
                            <cbc:PaymentChannelCode listAgencyID="320"
                                                    listID="urn:oioubl:codelist:paymentchannelcode-1.1">IBAN</cbc:PaymentChannelCode>
                            
                            <xsl:if test="string($PaymentID)">
                                <cbc:PaymentID>
                                    <xsl:value-of select="$PaymentID"/>
                                </cbc:PaymentID>
                            </xsl:if>
                            
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

            <xsl:if test="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/PaymentTerm">
                <xsl:for-each select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/PaymentTerm">

                    <xsl:variable name="DaysOfDiscount">
                        <xsl:if test="string(current()[Discount/DiscountPercent[@percent &gt; 0]]/@payInNumberOfDays)">
                            <xsl:value-of
                                    select="current()[Discount/DiscountPercent[@percent &gt; 0]]/@payInNumberOfDays"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="DaysOfPenalty">
                        <xsl:if test="string(current()[Discount/DiscountPercent[@percent &lt; 0]]/@payInNumberOfDays)">
                            <xsl:value-of
                                    select="current()[Discount/DiscountPercent[@percent &lt; 0]]/@payInNumberOfDays"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="DaysOfDueDate">
                        <xsl:if test="string(current()[Discount/DiscountPercent[@percent = 0]]/@payInNumberOfDays)">
                            <xsl:value-of
                                    select="current()[Discount/DiscountPercent[@percent = 0]]/@payInNumberOfDays"/>
                        </xsl:if>
                        <xsl:if test="string(current()[not(Discount)]/@payInNumberOfDays)">
                            <xsl:value-of select="current()[not(Discount)]/@payInNumberOfDays"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="fDaysOfDiscount">
                        <xsl:if test="string($DaysOfDiscount)">
                            <xsl:value-of select="concat('SettlementDiscountPercent for payment in ',$DaysOfDiscount, ' days.')"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="fDaysOfPenalty">
                        <xsl:if test="string($DaysOfPenalty)">
                            <xsl:value-of select="concat('PenaltySurchargePercent for payment in ',$DaysOfPenalty, ' days.')"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="fDaysOfDueDate">
                        <xsl:if test="string($DaysOfDueDate)">
                            <xsl:value-of select="concat('Due date of payment in ',$DaysOfDueDate, ' days.')"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="PayTermNote">
                        <xsl:if test="string($fDaysOfDiscount)">
                            <xsl:value-of select="$fDaysOfDiscount"/>
                        </xsl:if>
                        <xsl:if test="string($fDaysOfPenalty)">
                            <xsl:value-of select="$fDaysOfPenalty"/>
                        </xsl:if>
                        <xsl:if test="string($fDaysOfDueDate)">
                            <xsl:value-of select="$fDaysOfDueDate"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="SettlementDiscountPercent">
                        <xsl:if test="string(current()/Discount/DiscountPercent[@percent &gt; 0]/@percent)">
                            <xsl:value-of select="current()/Discount/DiscountPercent[@percent &gt; 0]/@percent"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="PenaltySurchargePercent">
                            <xsl:if test="string(current()/Discount/DiscountPercent[@percent &lt; 0]/@percent)">
                                <xsl:value-of select="current()/Discount/DiscountPercent[@percent &lt; 0]/@percent"/>
                            </xsl:if>
                    </xsl:variable>


                    <xsl:variable name="fPenaltySurchargePercent">
                        <xsl:if test="string($PenaltySurchargePercent)">
                            <xsl:value-of select="format-number(($PenaltySurchargePercent * -1),'##.##')"/>
                        </xsl:if>
                    </xsl:variable>

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
                                <xsl:value-of select="$fPenaltySurchargePercent"/>
                            </cbc:PenaltySurchargePercent>
                        </xsl:if>
                        <cbc:Amount currencyID="{$CurrencyCode}">
                            <xsl:value-of select="$fInvTotal"/>
                        </cbc:Amount>
                    </cac:PaymentTerms>
                </xsl:for-each>
            </xsl:if>

            <xsl:if test="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailPaymentTerm and $InvoiceTypeCode != '381'">
                <xsl:for-each select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/InvoiceDetailPaymentTerm">

                    <xsl:variable name="DaysOfDiscount_old">
                        <xsl:if test="string(current()[@percentageRate &gt; 0]/@payInNumberOfDays)">
                            <xsl:value-of select="current()[@percentageRate &gt; 0]/@payInNumberOfDays"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="DaysOfPenalty_old">
                        <xsl:if test="string(current()[@percentageRate &lt; 0]/@payInNumberOfDays)">
                            <xsl:value-of select="current()[@percentageRate &lt; 0]/@payInNumberOfDays"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="DaysOfDueDate_old">
                        <xsl:if test="string(current()[@percentageRate = 0]/@payInNumberOfDays)">
                            <xsl:value-of select="current()[@percentageRate = 0]/@payInNumberOfDays"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="fDaysOfDiscount_old">
                        <xsl:if test="string($DaysOfDiscount_old)">
                            <xsl:value-of
                                  select="concat('SettlementDiscountPercent for payment in ',$DaysOfDiscount_old, ' days.')"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="fDaysOfPenalty_old">
                        <xsl:if test="string($DaysOfPenalty_old)">
                            <xsl:value-of
                                  select="concat('PenaltySurchargePercent for payment in ',$DaysOfPenalty_old, ' days.')"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="fDaysOfDueDate_old">
                        <xsl:if test="string($DaysOfDueDate_old)">
                            <xsl:value-of
                                    select="concat('Due date of payment in ',$DaysOfDueDate_old, ' days.')"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="PayTermNote_old">
                        <xsl:if test="string($fDaysOfDiscount_old)">
                            <xsl:value-of select="$fDaysOfDiscount_old"/>
                        </xsl:if>
                        <xsl:if test="string($fDaysOfPenalty_old)">
                            <xsl:value-of select="$fDaysOfPenalty_old"/>
                        </xsl:if>
                        <xsl:if test="string($fDaysOfDueDate_old)">
                            <xsl:value-of select="$fDaysOfDueDate_old"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="SettlementDiscountPercent_old">
                        <xsl:if test="string(current()[@percentageRate &gt; 0]/@percentageRate)">
                            <xsl:value-of select="current()[@percentageRate &gt; 0]/@percentageRate"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="PenaltySurchargePercent_old">
                        <xsl:if test="string(current()[@percentageRate &lt; 0]/@percentageRate)">
                            <xsl:value-of select="current()[@percentageRate &lt; 0]/@percentageRate"/>
                        </xsl:if>
                    </xsl:variable>

                    <xsl:variable name="fPenaltySurchargePercent_old"
                                  select="format-number(($PenaltySurchargePercent_old * -1),'##.##')"/>

                    <cac:PaymentTerms>
                        <cbc:ID><xsl:value-of select="position()"/></cbc:ID>
                        <cbc:PaymentMeansID>1</cbc:PaymentMeansID>
                        <xsl:if test="string($PayTermNote_old)">
                            <cbc:Note>
                                <xsl:value-of select="$PayTermNote_old"/>
                            </cbc:Note>
                        </xsl:if>
                        <xsl:if test="string($SettlementDiscountPercent_old)">
                            <cbc:SettlementDiscountPercent>
                                <xsl:value-of select="$SettlementDiscountPercent_old"/>
                            </cbc:SettlementDiscountPercent>
                        </xsl:if>
                        <xsl:if test="string($PenaltySurchargePercent_old)">
                            <cbc:PenaltySurchargePercent>
                                <xsl:value-of select="$fPenaltySurchargePercent_old"/>
                            </cbc:PenaltySurchargePercent>
                        </xsl:if>
                        <cbc:Amount currencyID="{$CurrencyCode}">
                            <xsl:value-of select="$fInvTotal"/>
                        </cbc:Amount>
                    </cac:PaymentTerms>
                </xsl:for-each>
            </xsl:if>

            <xsl:if test="$fAllowanceAmount &gt; 0">
                <cac:AllowanceCharge>
                    <cbc:ID>1</cbc:ID>
                    <cbc:ChargeIndicator>false</cbc:ChargeIndicator>
                    <cbc:AllowanceChargeReason>
                        <xsl:value-of select="$AllowanceReason"/>
                    </cbc:AllowanceChargeReason>
                    <cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
                    <cbc:SequenceNumeric>1</cbc:SequenceNumeric>
                    <cbc:Amount currencyID="{$CurrencyCode}">
                        <xsl:value-of select="$fAllowanceAmount"/>
                    </cbc:Amount>
                    <cbc:BaseAmount currencyID="{$CurrencyCode}">
                        <xsl:value-of select="$fAllowanceAmount"/>
                    </cbc:BaseAmount>
                    <cac:TaxCategory>
                        <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                            <xsl:value-of select="$fTaxRateCode"/>
                        </cbc:ID>
                        <cbc:Percent>
                            <xsl:value-of select="$fTaxRate"/>
                        </cbc:Percent>
                        <cac:TaxScheme>
                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
                                <xsl:value-of select="$fTaxSchemeID"/>
                            </cbc:ID>
                            <cbc:Name>
                                <xsl:value-of select="$fTaxSchemeName"/>
                            </cbc:Name>
                        </cac:TaxScheme>
                    </cac:TaxCategory>
                </cac:AllowanceCharge>
            </xsl:if>

            <xsl:if test="$fChargeAmount1 &gt; 0">
                <xsl:variable name="t1"
                              select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='SpecialhandlingAmountTaxPercent']"/>
                <xsl:variable name="t2">
                    <xsl:choose>
                        <xsl:when test="$t1 = 0">
                            <xsl:value-of select="'00'"/>
                        </xsl:when>
                        <xsl:when test="string($t1)">
                            <xsl:value-of select="$t1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$fTaxRate"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="t3">
                    <xsl:choose>
                        <xsl:when test="$t1 = 0">
                            <xsl:value-of select="'Z'"/>
                        </xsl:when>
                        <xsl:when test="string($t1)">
                            <xsl:value-of select="'S'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$fTaxRateCode"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <cac:AllowanceCharge>
                    <xsl:choose>
                        <xsl:when test="$fAllowanceAmount &gt; 0">
                            <cbc:ID>2</cbc:ID>
                        </xsl:when>
                        <xsl:otherwise>
                            <cbc:ID>1</cbc:ID>
                        </xsl:otherwise>
                    </xsl:choose>
                    <cbc:ChargeIndicator>true</cbc:ChargeIndicator>
                    <cbc:AllowanceChargeReason>
                        <xsl:value-of select="$fChargeReason1"/>
                    </cbc:AllowanceChargeReason>
                    <cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
                    <cbc:SequenceNumeric>1</cbc:SequenceNumeric>
                    <cbc:Amount currencyID="{$CurrencyCode}">
                        <xsl:value-of select="$fChargeAmount1"/>
                    </cbc:Amount>
                    <cbc:BaseAmount currencyID="{$CurrencyCode}">
                        <xsl:value-of select="$fChargeAmount1"/>
                    </cbc:BaseAmount>
                    <cac:TaxCategory>
                        <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                            <xsl:value-of select="$t3"/>
                        </cbc:ID>
                        <cbc:Percent>
                            <xsl:value-of select="$t2"/>
                        </cbc:Percent>
                        <cac:TaxScheme>
                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
                                <xsl:value-of select="$fTaxSchemeID"/>
                            </cbc:ID>
                            <cbc:Name>
                                <xsl:value-of select="$fTaxSchemeName"/>
                            </cbc:Name>
                        </cac:TaxScheme>
                    </cac:TaxCategory>
                </cac:AllowanceCharge>
            </xsl:if>

            <xsl:if test="$fChargeAmount2 &gt; 0">
                <xsl:variable name="t1"
                              select="Request/InvoiceDetailRequest/InvoiceDetailRequestHeader/Extrinsic[@name='ShippingAmountTaxPercent']"/>
                <xsl:variable name="t2">
                    <xsl:choose>
                        <xsl:when test="$t1 = 0">
                            <xsl:value-of select="'00'"/>
                        </xsl:when>
                        <xsl:when test="string($t1)">
                            <xsl:value-of select="$t1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$fTaxRate"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="t3">
                    <xsl:choose>
                        <xsl:when test="$t1 = 0">
                            <xsl:value-of select="'Z'"/>
                        </xsl:when>
                        <xsl:when test="string($t1)">
                            <xsl:value-of select="'S'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$fTaxRateCode"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <cac:AllowanceCharge>
                    <xsl:choose>
                        <xsl:when test="$fAllowanceAmount &gt; 0 and $fChargeAmount1 &gt; 0">
                            <cbc:ID>3</cbc:ID>
                        </xsl:when>
                        <xsl:when test="$fAllowanceAmount &gt; 0">
                            <cbc:ID>2</cbc:ID>
                        </xsl:when>
                        <xsl:otherwise>
                            <cbc:ID>1</cbc:ID>
                        </xsl:otherwise>
                    </xsl:choose>
                    <cbc:ChargeIndicator>true</cbc:ChargeIndicator>
                    <cbc:AllowanceChargeReason>
                        <xsl:value-of select="$fChargeReason2"/>
                    </cbc:AllowanceChargeReason>
                    <cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
                    <cbc:SequenceNumeric>1</cbc:SequenceNumeric>
                    <cbc:Amount currencyID="{$CurrencyCode}">
                        <xsl:value-of select="$fChargeAmount2"/>
                    </cbc:Amount>
                    <cbc:BaseAmount currencyID="{$CurrencyCode}">
                        <xsl:value-of select="$fChargeAmount2"/>
                    </cbc:BaseAmount>
                    <cac:TaxCategory>
                        <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                            <xsl:value-of select="$t3"/>
                        </cbc:ID>
                        <cbc:Percent>
                            <xsl:value-of select="$t2"/>
                        </cbc:Percent>
                        <cac:TaxScheme>
                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
                                <xsl:value-of select="$fTaxSchemeID"/>
                            </cbc:ID>
                            <cbc:Name>
                                <xsl:value-of select="$fTaxSchemeName"/>
                            </cbc:Name>
                        </cac:TaxScheme>
                    </cac:TaxCategory>
                </cac:AllowanceCharge>
            </xsl:if>

            <xsl:if test="string($TaxExchangeRateCalculationRate)">
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
            
            <!-- Header Tax -->

            <cac:TaxTotal>
                <cbc:TaxAmount currencyID="{$CurrencyCode}">
                    <xsl:value-of select="$fTaxAmount"/>
                </cbc:TaxAmount>
                <xsl:choose>
                    <xsl:when test="count(Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail) &gt; 1 and $fTaxAmount &gt; 0">
                        <xsl:for-each select="Request/InvoiceDetailRequest/InvoiceDetailSummary/Tax/TaxDetail">
                            <xsl:variable name="ft2" select="./TaxableAmount/Money"/>
                            <xsl:variable name="ft5" select="./TaxAmount/Money"/>
                            <xsl:variable name="t4">
                                <xsl:choose>
                                    <xsl:when test="string(./@percentageRate)">
                                        <xsl:value-of select="./@percentageRate"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="format-number(($ft5 div $ft2) * 100,'##.##')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <!--xsl:variable name="noTaxPercent">
                                <xsl:choose>
                                    <xsl:when test="string(./@percentageRate)">false</xsl:when>
                                    <xsl:when test="$ft5 = 0 or $ft2 = 0">false</xsl:when>
                                    <xsl:otherwise>true</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable-->
                            <xsl:variable name="t3">
                                <xsl:choose>
                                    <xsl:when test="./Description = 'Standard'">S</xsl:when>
                                    <xsl:when test="./Description = 'Reduced'">AA</xsl:when>
                                    <xsl:when test="./Description = 'Zero'">Z</xsl:when>
                                    <xsl:when test="./Description = 'Exempt'">E</xsl:when>
                                    <xsl:when test="$ft5 = 0">Z</xsl:when>
                                    <xsl:otherwise>S</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="t6">
                                <xsl:choose>
                                    <xsl:when test="./@category = 'vat'">VAT</xsl:when>
                                    <xsl:when test="./@category = 'gst'">GST</xsl:when>
                                    <xsl:when test="./@category = 'stt'">STT</xsl:when>
                                    
                                    <xsl:otherwise>OTH</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="t7">
                                <xsl:choose>
                                    <xsl:when test="./@category = 'vat'">VAT</xsl:when>
                                    <xsl:when test="./@category = 'gst'">GST</xsl:when>
                                    <xsl:when test="./@category = 'stt'">STT</xsl:when>
                                    <xsl:when test="string(./@category)">
                                        <xsl:value-of select="./@category"/>
                                    </xsl:when>
                                    <xsl:otherwise>OTH</xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="ft8" select="./TaxAmount/Money/@alternateAmount"/>
                            <xsl:choose>
                                <xsl:when test="$noTaxPercent = 'true'">
                                    <cac:TaxSubtotal>
                                        <cbc:TaxableAmount currencyID="{$CurrencyCode}">
                                            <xsl:value-of select="$ft2"/>
                                        </cbc:TaxableAmount>
                                        <cbc:TaxAmount currencyID="{$CurrencyCode}">
                                            <xsl:value-of select="$ft5"/>
                                        </cbc:TaxAmount>
                                        <xsl:if test="string($ft8) and string($TaxExchangeRateCalculationRate)">
                                            <cbc:TransactionCurrencyTaxAmount currencyID="{$TaxExchangeRateTargetCurrencyCode}">
                                                <xsl:value-of select="$ft8"/>
                                            </cbc:TransactionCurrencyTaxAmount>
                                        </xsl:if>
                                        <cac:TaxCategory>
                                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                                                <xsl:value-of select="$t3"/>
                                            </cbc:ID>
                                            <cbc:Percent>
                                                <xsl:value-of select="$t4"/>
                                            </cbc:Percent>
                                            <cbc:BaseUnitMeasure unitCode="EA">1</cbc:BaseUnitMeasure>
                                            <cbc:PerUnitAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$ft5"/></cbc:PerUnitAmount>
                                            <cac:TaxScheme>
                                                <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
                                                    <xsl:value-of select="$t6"/>
                                                </cbc:ID>
                                                <cbc:Name>
                                                    <xsl:value-of select="$t7"/>
                                                </cbc:Name>
                                            </cac:TaxScheme>
                                        </cac:TaxCategory>
                                    </cac:TaxSubtotal>
                                </xsl:when>
                                <xsl:otherwise>
                                    <cac:TaxSubtotal>
                                        <cbc:TaxableAmount currencyID="{$CurrencyCode}">
                                            <xsl:value-of select="$ft2"/>
                                        </cbc:TaxableAmount>
                                        <cbc:TaxAmount currencyID="{$CurrencyCode}">
                                            <xsl:value-of select="$ft5"/>
                                        </cbc:TaxAmount>
                                        <xsl:if test="string($ft8) and string($TaxExchangeRateCalculationRate)">
                                            <cbc:TransactionCurrencyTaxAmount currencyID="{$TaxExchangeRateTargetCurrencyCode}">
                                                <xsl:value-of select="$ft8"/>
                                            </cbc:TransactionCurrencyTaxAmount>
                                        </xsl:if>
                                        <cac:TaxCategory>
                                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                                                <xsl:value-of select="$t3"/>
                                            </cbc:ID>
                                            <cbc:Percent>
                                                <xsl:value-of select="$t4"/>
                                            </cbc:Percent>
                                            <cac:TaxScheme>
                                                <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
                                                    <xsl:value-of select="$t6"/>
                                                </cbc:ID>
                                                <cbc:Name>
                                                    <xsl:value-of select="$t7"/>
                                                </cbc:Name>
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
                                <xsl:choose>
                                    <xsl:when test="$noTaxPercent = 'true'">
                                        <cac:TaxSubtotal>
                                            <cbc:TaxableAmount currencyID="{$CurrencyCode}">
                                                <xsl:value-of select="$fTaxableAmount"/>
                                            </cbc:TaxableAmount>
                                            <cbc:TaxAmount currencyID="{$CurrencyCode}">
                                                <xsl:value-of select="$fTaxAmount"/>
                                            </cbc:TaxAmount>
                                            <xsl:if test="string($TaxExchangeRateTargetAmount) and string($TaxExchangeRateCalculationRate)">
                                                <cbc:TransactionCurrencyTaxAmount
                                                        currencyID="{$TaxExchangeRateTargetCurrencyCode}">
                                                    <xsl:value-of select="$fTaxExchangeRateTargetAmount"/>
                                                </cbc:TransactionCurrencyTaxAmount>
                                            </xsl:if>
                                            <cac:TaxCategory>
                                                <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                                                    <xsl:value-of select="$fTaxRateCode"/>
                                                </cbc:ID>
                                                <cbc:Percent>
                                                    <xsl:value-of select="$fTaxRate"/>
                                                </cbc:Percent>
                                                <cbc:BaseUnitMeasure unitCode="EA">1</cbc:BaseUnitMeasure>
                                                <cbc:PerUnitAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fTaxAmount"/></cbc:PerUnitAmount>
                                                <cac:TaxScheme>
                                                    <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
                                                            schemeVersionID="D08B">
                                                        <xsl:value-of select="$fTaxSchemeID"/>
                                                    </cbc:ID>
                                                    <cbc:Name>
                                                        <xsl:value-of select="$fTaxSchemeName"/>
                                                    </cbc:Name>
                                                </cac:TaxScheme>
                                            </cac:TaxCategory>
                                        </cac:TaxSubtotal>
                                     </xsl:when>
                                     <xsl:otherwise>
                                        <cac:TaxSubtotal>
                                            <cbc:TaxableAmount currencyID="{$CurrencyCode}">
                                                <xsl:value-of select="$fTaxableAmount"/>
                                            </cbc:TaxableAmount>
                                            <cbc:TaxAmount currencyID="{$CurrencyCode}">
                                                <xsl:value-of select="$fTaxAmount"/>
                                            </cbc:TaxAmount>
                                            <xsl:if test="string($TaxExchangeRateTargetAmount) and string($TaxExchangeRateCalculationRate)">
                                                <cbc:TransactionCurrencyTaxAmount
                                                        currencyID="{$TaxExchangeRateTargetCurrencyCode}">
                                                    <xsl:value-of select="$fTaxExchangeRateTargetAmount"/>
                                                </cbc:TransactionCurrencyTaxAmount>
                                            </xsl:if>
                                            <cac:TaxCategory>
                                                <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                                                    <xsl:value-of select="$fTaxRateCode"/>
                                                </cbc:ID>
                                                <cbc:Percent>
                                                    <xsl:value-of select="$fTaxRate"/>
                                                </cbc:Percent>
                                                <cac:TaxScheme>
                                                    <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
                                                            schemeVersionID="D08B">
                                                        <xsl:value-of select="$fTaxSchemeID"/>
                                                    </cbc:ID>
                                                    <cbc:Name>
                                                        <xsl:value-of select="$fTaxSchemeName"/>
                                                    </cbc:Name>
                                                </cac:TaxScheme>
                                            </cac:TaxCategory>
                                        </cac:TaxSubtotal>
                                     </xsl:otherwise>
                                 </xsl:choose>
                            </xsl:when>
                            <xsl:otherwise>
                                <cac:TaxSubtotal>
                                    <cbc:TaxableAmount currencyID="{$CurrencyCode}">
                                        <xsl:value-of select="$fTaxableAmount"/>
                                    </cbc:TaxableAmount>
                                    <cbc:TaxAmount currencyID="{$CurrencyCode}">
                                        <xsl:value-of select="'0.00'"/>
                                    </cbc:TaxAmount>
                                    <xsl:if test="string($TaxExchangeRateCalculationRate)">
                                        <cbc:TransactionCurrencyTaxAmount
                                                currencyID="{$TaxExchangeRateTargetCurrencyCode}">
                                            <xsl:value-of select="'0.00'"/>
                                        </cbc:TransactionCurrencyTaxAmount>
                                    </xsl:if>
                                    <cac:TaxCategory>
                                        <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                                            <xsl:value-of select="$fTaxRateCode"/>
                                        </cbc:ID>
                                        <cbc:Percent>00</cbc:Percent>
                                        <cac:TaxScheme>
                                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset"
                                                    schemeVersionID="D08B">
                                                <xsl:value-of select="$fTaxSchemeID"/>
                                            </cbc:ID>
                                            <cbc:Name>
                                                <xsl:value-of select="$fTaxSchemeName"/>
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
                <xsl:if test="number($fChargeAmountTotal) &gt; 0">
                    <cbc:ChargeTotalAmount currencyID="{$CurrencyCode}">
                        <xsl:value-of select="$fChargeAmountTotal"/>
                    </cbc:ChargeTotalAmount>
                </xsl:if>
                <cbc:PayableAmount currencyID="{$CurrencyCode}">
                    <xsl:value-of select="$fInvTotal"/>
                </cbc:PayableAmount>
            </cac:LegalMonetaryTotal>


            <!-- InvoiceLines -->
            <xsl:for-each select="Request/InvoiceDetailRequest/InvoiceDetailOrder/InvoiceDetailItem">

                <cac:InvoiceLine>
                    <!-- Variable -->


                    <!-- Line fields -->


                    <xsl:variable name="LineID" select="./@invoiceLineNumber"/>

                    
                    <xsl:variable name="LineAccCost">
                        <xsl:choose>
                            <xsl:when test="string(Extrinsic[@name='CostCenter'])">
                                <xsl:value-of select="Extrinsic[@name='CostCenter']"/>
                            </xsl:when>
                            <xsl:when test="string(Extrinsic[@name='CostCentre'])">
                                <xsl:value-of select="Extrinsic[@name='CostCentre']"/>
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="LineRefID" select="Extrinsic[@name='OrderLineReferenceID']"/>

                    <xsl:variable name="LineOrderID" select="Extrinsic[@name='BuyersOrderNumber']"/>

                    <xsl:variable name="LineSelOrderID" select="Extrinsic[@name='SellersOrderNumber']"/>

                    <xsl:variable name="LineFileReferenceID" select="Extrinsic[@name='FileID']"/>

                    <xsl:variable name="LineBOLReferenceID" select="Extrinsic[@name='BOL']"/>

                    <xsl:variable name="LineVehicleNumber" select="Extrinsic[@name='VehicleNumber']"/>

                    <xsl:variable name="LineNote" select="Comments"/>

                    <xsl:variable name="ItemIdType" select="''"/>

                    <xsl:variable name="ItemId" select="InvoiceDetailItemReference/ItemID/SupplierPartID"/>

                    <xsl:variable name="ItemName" select="InvoiceDetailItemReference/Description"/>

                    <xsl:variable name="Quantity" select="./@quantity"/>

                    <xsl:variable name="UnitCode" select="UnitOfMeasure"/>

                    <xsl:variable name="UnitPrice" select="UnitPrice/Money"/>

                    <xsl:variable name="BaseQuantity1" select="Extrinsic[@name='PriceBasisQuantity']"/>

                    <xsl:variable name="BaseQuantity2" select="PriceBasisQuantity/@quantity"/>

                    <xsl:variable name="UnitFactorRate" select="PriceBasisQuantity/@conversionFactor"/>

                    <xsl:variable name="LineAllowanceAmount" select="InvoiceDetailDiscount/Money"/>

                    <xsl:variable name="LineAllowanceReason" select="''"/>

                    <xsl:variable name="LineTaxRate" select="Tax/TaxDetail/@percentageRate"/>

                    <xsl:variable name="LineTaxRateCode" select="Tax/TaxDetail/Description"/>

                    <xsl:variable name="LineTaxExemptReason" select="Tax/TaxDetail/@exemptDetail"/>

                    <xsl:variable name="LineTaxSchemeID" select="Tax/TaxDetail/@category"/>

                    <xsl:variable name="LineTaxSchemeName" select="Tax/TaxDetail/@category"/>

                    <xsl:variable name="LineTaxAmount" select="Tax/Money"/>

                    <xsl:variable name="LineAmount" select="SubtotalAmount/Money"/>


                    <!-- Konverteringer etc. -->

                    <xsl:variable name="fQuantity" select="translate($Quantity,',', '')"/>

                    <xsl:variable name="fBaseQuantity1" select="translate($BaseQuantity1,',', '')"/>

                    <xsl:variable name="fBaseQuantity2" select="translate($BaseQuantity2,',', '')"/>

                    <xsl:variable name="fUnitFactorRate" select="translate($UnitFactorRate,',', '')"/>

                    <xsl:variable name="ffBaseQuantity">
                        <xsl:choose>
                            <xsl:when test="number($fBaseQuantity1)">
                                <xsl:value-of select="$fBaseQuantity1"/>
                            </xsl:when>
                            <xsl:when test="number($fBaseQuantity2)">
                                <xsl:value-of select="$fBaseQuantity2"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'1'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="ffUnitFactorRate">
                        <xsl:choose>
                            <xsl:when test="number($fUnitFactorRate)">
                                <xsl:value-of select="$fUnitFactorRate"/>
                            </xsl:when>
                            <xsl:when test="$ffBaseQuantity = 1">
                                <xsl:value-of select="'1'"/>
                            </xsl:when>
                            <xsl:when test="$ffBaseQuantity = 0">
                                <xsl:value-of select="'1'"/>
                            </xsl:when>
                            <xsl:when test="number($ffBaseQuantity)">
                                <xsl:value-of select="1 div $ffBaseQuantity"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'1'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

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

                    <xsl:variable name="l5" select="format-number(number(translate($LineAllowanceAmount,',', '')),'##.00')"/>
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

                    <xsl:variable name="l1" select="format-number(number(translate($LineAmount,',', '')),'##.00')"/>
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
                            <xsl:when test="contains($IsoCode, concat(',',$l2,','))">
                                <xsl:value-of select="$l2"/>
                            </xsl:when>
                            <xsl:when test="$l2 = 'PCE'">
                                <xsl:value-of select="'EA'"/>
                            </xsl:when>
                            <xsl:when test="$l2 = 'Stk'">
                                <xsl:value-of select="'EA'"/>
                            </xsl:when>
                            <xsl:when test="$l2 = 'stk'">
                                <xsl:value-of select="'EA'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'ZZ'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="l3" select="translate($UnitPrice,',', '')"/>
                    <xsl:variable name="fUnitPrice">
                        <xsl:choose>
                            <xsl:when test="string($UnitPrice)">
                                <xsl:value-of select="$l3"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'0.00'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="l4" select="format-number(number(translate($LineTaxAmount,',', '')),'#0.00')"/>
                    <xsl:variable name="i1">
                        <xsl:choose>
                            <xsl:when test="number($LineTaxRate) and $LineTaxRate &gt; 0">
                                <xsl:value-of select="format-number($fLineAmount * ($LineTaxRate div 100),'#0.00')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="''"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="InsightFlag">
                        <xsl:choose>
                            <xsl:when test="number($LineTaxRate) and $LineTaxRate &gt; 0 and $l4 != $i1">
                                <xsl:value-of select="'true'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="'false'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="fLineTaxAmount">
                        <xsl:choose>
                            <xsl:when test="$InsightFlag = 'true'">
                                <xsl:value-of select="$i1"/>
                            </xsl:when>
                            <xsl:when test="$l4 = 'NaN'">
                                <xsl:value-of select="'0.00'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$l4"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="fLineTaxRateCode">
                        <xsl:choose>
                            <xsl:when test="$LineTaxRateCode = 'Standard'">S</xsl:when>
                            <xsl:when test="$LineTaxRateCode = 'Reduced'">AA</xsl:when>
                            <xsl:when test="$LineTaxRateCode = 'Zero'">Z</xsl:when>
                            <xsl:when test="$LineTaxRateCode = 'Exempt'">E</xsl:when>
                            <xsl:when test="$fLineTaxAmount = 0 and $fLineAmount != 0">Z</xsl:when>
                            <xsl:otherwise>S</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="fLineTaxRate">
                        <xsl:choose>
                            <xsl:when test="string($LineTaxRate)">
                                <xsl:value-of select="translate($LineTaxRate,',', '')"/>
                            </xsl:when>
                            <xsl:when test="$fLineTaxAmount = 0 or $fLineAmount = 0">00</xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="format-number(($fLineTaxAmount div $fLineAmount) * 100,'##.##')"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="noLineTaxPercent">
                        <xsl:choose>
                            <xsl:when test="string($LineTaxRate)">false</xsl:when>
                            <xsl:when test="$fLineTaxAmount = 0 or $fLineAmount = 0">false</xsl:when>
                            <xsl:when test="Tax/TaxDetail and not(string($LineTaxRate))">true</xsl:when>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="fLineTaxExemptReason">
                        <xsl:choose>
                            <xsl:when test="$LineTaxRateCode = 'Exempt'">
                                <xsl:value-of select="$LineTaxExemptReason"/>
                            </xsl:when>
                            <xsl:otherwise></xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="fLineTaxSchemeID">
                        <xsl:choose>
                            <xsl:when test="$LineTaxSchemeID = 'vat'">VAT</xsl:when>
                            <xsl:when test="$LineTaxSchemeID = 'gst'">GST</xsl:when>
                            <xsl:when test="$LineTaxSchemeID = 'stt'">STT</xsl:when>
                            <xsl:otherwise>OTH</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="fLineTaxSchemeName">
                        <xsl:choose>
                            <xsl:when test="$LineTaxSchemeName = 'vat'">VAT</xsl:when>
                            <xsl:when test="$LineTaxSchemeName = 'gst'">GST</xsl:when>
                            <xsl:when test="$LineTaxSchemeName = 'stt'">STT</xsl:when>
                            <xsl:when test="string($LineTaxSchemeName)">
                                <xsl:value-of select="$LineTaxSchemeName"/>
                            </xsl:when>
                            <xsl:otherwise>OTH</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="fItemId">
                        <xsl:choose>
                            <xsl:when test="string($ItemId)">
                                <xsl:value-of select="$ItemId"/>
                            </xsl:when>
                            <xsl:otherwise>n/a</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>


                    <!-- Start invoiceline -->

                    <cbc:ID>
                        <xsl:value-of select="$fLineID"/>
                    </cbc:ID>
                    <xsl:if test="string($LineNote)">
                        <cbc:Note>
                            <xsl:value-of select="$LineNote"/>
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

                    <xsl:if test="(string($LineRefID) or string($LineOrderID) or string($LineSelOrderID) and $InvoiceTypeCode != '381')">
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
                            <xsl:if test="string($LineOrderID) or string($LineSelOrderID)">
                                <cac:OrderReference>
                                    <xsl:if test="string($LineOrderID)">
                                        <cbc:ID>
                                            <xsl:value-of select="$LineOrderID"/>
                                        </cbc:ID>
                                    </xsl:if>
                                    <xsl:if test="string($LineSelOrderID)">
                                        <cbc:SalesOrderID>
                                            <xsl:value-of select="$LineSelOrderID"/>
                                        </cbc:SalesOrderID>
                                    </xsl:if>
                                </cac:OrderReference>
                            </xsl:if>
                        </cac:OrderLineReference>
                    </xsl:if>
                    
                    <xsl:if test="((string($LineRefID) or string($LineOrderID)) and $InvoiceTypeCode = '381')">
                        <cac:DocumentReference>
                            <cbc:ID>
                                <xsl:value-of select="$LineRefID"/>
                            </cbc:ID>
                            <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">Order ID</cbc:DocumentTypeCode>
                        </cac:DocumentReference>
                        
                        <cac:DocumentReference>
                            <cbc:ID>
                                <xsl:value-of select="$LineOrderID"/>
                            </cbc:ID>
                            <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">Order Line ID</cbc:DocumentTypeCode>
                        </cac:DocumentReference>
                    </xsl:if>
                    <xsl:if test="string($LineFileReferenceID)">
                        <cac:DocumentReference>
                            <cbc:ID>
                                <xsl:value-of select="$LineFileReferenceID"/>
                            </cbc:ID>
                            <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">File ID</cbc:DocumentTypeCode>
                        </cac:DocumentReference>
                    </xsl:if>

                    <xsl:if test="string($LineBOLReferenceID)">
                        <cac:DocumentReference>
                            <cbc:ID>
                                <xsl:value-of select="$LineBOLReferenceID"/>
                            </cbc:ID>
                            <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">BOL ID</cbc:DocumentTypeCode>
                        </cac:DocumentReference>
                    </xsl:if>

                    <xsl:if test="string($LineVehicleNumber)">
                        <cac:DocumentReference>
                            <cbc:ID>
                                <xsl:value-of select="$LineVehicleNumber"/>
                            </cbc:ID>
                            <cbc:DocumentTypeCode listID="urn:tradeshift.com:api:1.0:documenttypecode">VN ID</cbc:DocumentTypeCode>
                        </cac:DocumentReference>
                    </xsl:if>

                    <xsl:if test="$fLineAllowanceFlag = 'true'">
                        <cac:AllowanceCharge>
                            <cbc:ID>1</cbc:ID>
                            <cbc:ChargeIndicator>false</cbc:ChargeIndicator>
                            <xsl:if test="string($LineAllowanceReason)">
                                <cbc:AllowanceChargeReason>
                                    <xsl:value-of select="$LineAllowanceReason"/>
                                </cbc:AllowanceChargeReason>
                            </xsl:if>
                            <cbc:MultiplierFactorNumeric>1</cbc:MultiplierFactorNumeric>
                            <cbc:SequenceNumeric>1</cbc:SequenceNumeric>
                            <cbc:Amount currencyID="{$CurrencyCode}">
                                <xsl:value-of select="$fLineAllowanceAmount"/>
                            </cbc:Amount>
                            <cbc:BaseAmount currencyID="{$CurrencyCode}">
                                <xsl:value-of select="$fLineAllowanceAmount"/>
                            </cbc:BaseAmount>
                        </cac:AllowanceCharge>
                    </xsl:if>

                    <cac:TaxTotal>
                        <cbc:TaxAmount currencyID="{$CurrencyCode}">
                            <xsl:value-of select="$fLineTaxAmount"/>
                        </cbc:TaxAmount>
                        <xsl:choose>
                            <xsl:when test="$noLineTaxPercent = 'true'">
                                <cac:TaxSubtotal>
                                    <cbc:TaxableAmount currencyID="{$CurrencyCode}">
                                        <xsl:value-of select="$fLineAmount"/>
                                    </cbc:TaxableAmount>
                                    <cbc:TaxAmount currencyID="{$CurrencyCode}">
                                        <xsl:value-of select="$fLineTaxAmount"/>
                                    </cbc:TaxAmount>
                                    <cac:TaxCategory>
                                        <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
                                            <xsl:value-of select="$fLineTaxRateCode"/>
                                        </cbc:ID>
                                        <cbc:Percent>
                                            <xsl:value-of select="$fLineTaxRate"/>
                                        </cbc:Percent>
                                        <cbc:BaseUnitMeasure unitCode="EA">1</cbc:BaseUnitMeasure>
                                        <cbc:PerUnitAmount currencyID="{$CurrencyCode}"><xsl:value-of select="$fLineTaxAmount"/></cbc:PerUnitAmount>
                                        <xsl:if test="string($fLineTaxExemptReason)">
                                            <cbc:TaxExemptionReason>
                                                <xsl:value-of select="$fLineTaxExemptReason"/>
                                            </cbc:TaxExemptionReason>
                                        </xsl:if>
                                        <cac:TaxScheme>
                                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
                                                <xsl:value-of select="$fLineTaxSchemeID"/>
                                            </cbc:ID>
                                            <cbc:Name>
                                                <xsl:value-of select="$fLineTaxSchemeName"/>
                                            </cbc:Name>
                                        </cac:TaxScheme>
                                    </cac:TaxCategory>
                                </cac:TaxSubtotal>
                            </xsl:when>
                            <xsl:otherwise>
                              <cac:TaxSubtotal>
                                    <cbc:TaxableAmount currencyID="{$CurrencyCode}">
                                        <xsl:value-of select="$fLineAmount"/>
                                    </cbc:TaxableAmount>
                                    <cbc:TaxAmount currencyID="{$CurrencyCode}">
                                        <xsl:value-of select="$fLineTaxAmount"/>
                                    </cbc:TaxAmount>
                                    <cac:TaxCategory>
                                        <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5305" schemeVersionID="D08B">
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
                                            <cbc:ID schemeAgencyID="6" schemeID="UN/ECE 5153 Subset" schemeVersionID="D08B">
                                                <xsl:value-of select="$fLineTaxSchemeID"/>
                                            </cbc:ID>
                                            <cbc:Name>
                                                <xsl:value-of select="$fLineTaxSchemeName"/>
                                            </cbc:Name>
                                        </cac:TaxScheme>
                                    </cac:TaxCategory>
                                </cac:TaxSubtotal>
                            </xsl:otherwise>
                        </xsl:choose>
                    </cac:TaxTotal>

                    <cac:Item>
                        <cbc:Description>
                            <xsl:value-of select="$ItemName"/>
                        </cbc:Description>
                        <cbc:Name>
                            <xsl:value-of select="$fItemName"/>
                        </cbc:Name>
                        <cac:SellersItemIdentification>
                            <xsl:choose>
                                <xsl:when test="$ItemIdType = 'GTIN' or $ItemIdType = 'EAN'">
                                    <cbc:ID schemeAgencyID="9" schemeID="GTIN">
                                        <xsl:value-of select="$fItemId"/>
                                    </cbc:ID>
                                </xsl:when>
                                <xsl:otherwise>
                                    <cbc:ID>
                                        <xsl:value-of select="$fItemId"/>
                                    </cbc:ID>
                                </xsl:otherwise>
                            </xsl:choose>
                        </cac:SellersItemIdentification>
                    </cac:Item>

                    <cac:Price>
                        <cbc:PriceAmount currencyID="{$CurrencyCode}">
                            <xsl:value-of select="$fUnitPrice"/>
                        </cbc:PriceAmount>
                        <cbc:BaseQuantity unitCode="{$fUnitCode}">
                            <xsl:value-of select="$ffBaseQuantity"/>
                        </cbc:BaseQuantity>
                        <cbc:OrderableUnitFactorRate>
                            <xsl:value-of select="$ffUnitFactorRate"/>
                        </cbc:OrderableUnitFactorRate>
                    </cac:Price>

                </cac:InvoiceLine>

            </xsl:for-each>

        </Invoice>

    </xsl:template>

</xsl:stylesheet>
