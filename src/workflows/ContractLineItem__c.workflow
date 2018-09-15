<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateEndDate</fullName>
        <description>SFDC1-4582 Set Contract Line Item End Date to Contract End Date</description>
        <field>EndDate__c</field>
        <formula>Contract__r.EndDate</formula>
        <name>UpdateEndDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStartDate</fullName>
        <description>SFDC1-4582 Set Contract Line Item Start Date equal to Contract Start Date</description>
        <field>StartDate__c</field>
        <formula>Contract__r.StartDate</formula>
        <name>UpdateStartDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PopulateContractLineItem</fullName>
        <actions>
            <name>UpdateEndDate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateStartDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>ContractLineItem__c.StartDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>ContractLineItem__c.EndDate__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>SFDC1-4582 Workflow rule to populate Contract Line Item start date and end date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
