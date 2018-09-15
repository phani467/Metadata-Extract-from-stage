<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SetPricingCodeTo1000</fullName>
        <description>SFDC1-292 set price reason code to 1000 for Opportunity product</description>
        <field>PriceReasonCode__c</field>
        <formula>&quot;1000&quot;</formula>
        <name>Set Pricing Code to 1000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UpdatePricingCodeOnCreateUpdate</fullName>
        <actions>
            <name>SetPricingCodeTo1000</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-292 Set pricing code to 1000 whenever a non service account updates records
SFDC1-7919 remove exception for user and add for profiles instead</description>
        <formula>AND (NOT(CONTAINS($Profile.Name, &quot;System Administrator&quot;)),NOT(CONTAINS($Profile.Name, &quot;API&quot;)),NOT(CONTAINS($Profile.Name, &quot;IHSMarkit System Admin&quot;)),   	OR(	 		ISNEW(), ISCHANGED( UnitPrice),  ISCHANGED( Quantity), ISCHANGED( DiscountPercentage__c ) 	)   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
