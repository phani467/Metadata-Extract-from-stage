<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>SAPContractNumberUpdate</fullName>
        <description>SFDC1 -5442 ; Updating SAP Contract number coming from Opportunity</description>
        <field>SAPContractNumberNew__c</field>
        <formula>(&quot;$Opportunity.SAPContractNumber__c&quot;)</formula>
        <name>SAP Contract Number Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>LinkSAPHistorytoOpportunity</fullName>
        <actions>
            <name>SAPContractNumberUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1</booleanFilter>
        <criteriaItems>
            <field>SAPHistory__c.SAPContractNumberNew__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>SFDC1-5442 linking SAP Contract Number</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
