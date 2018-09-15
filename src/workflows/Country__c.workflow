<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateIsProhibited</fullName>
        <field>IsProhibited__c</field>
        <literalValue>1</literalValue>
        <name>Update IsProhibited</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SyncProhibitedWhenLegalStatusChanges</fullName>
        <actions>
            <name>UpdateIsProhibited</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-402 Update IsProhibited field when the country&apos;s LegalStatus changed to &quot;Prohibited&quot;</description>
        <formula>ISPICKVAL(LegalStatus__c, &quot;Prohibited&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
