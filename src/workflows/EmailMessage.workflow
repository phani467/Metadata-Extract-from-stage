<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CaseStatusUpdateToCustomerResponded</fullName>
        <description>SFDC1-1749 - Update Case Status after customer email response from Waiting - Customer to Customer Responded.</description>
        <field>Status</field>
        <literalValue>Customer Responded</literalValue>
        <name>CaseStatusUpdateToCustomerResponded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>CaseUpdateStatusWhenCustomerResponse</fullName>
        <actions>
            <name>CaseStatusUpdateToCustomerResponded</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Waiting - Customer</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <description>SFDC1-1749 - Update Case Status after customer email response from Waiting - Customer to Customer Responded. SFDC1-8151: Deactivating this WR</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
