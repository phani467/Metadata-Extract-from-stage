<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ContractInternalApprovalfromContact</fullName>
        <description>SFDC1-6282: Contract Internal Approval from Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContractInternalApproval</template>
    </alerts>
    <alerts>
        <fullName>ContractInternalApprovalfromContactUpdated</fullName>
        <description>SFDC1-6282: Contract Internal Approval from Contact</description>
        <protected>false</protected>
        <recipients>
            <field>Contact__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/ContractInternalApproval</template>
    </alerts>
    <rules>
        <fullName>SendNotificationtoContact</fullName>
        <actions>
            <name>ContractInternalApprovalfromContactUpdated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>InternalApproval__c.DoNotSendEmail__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>SFDC1-7758 Send Notification to Contact when &quot;Do not send email&quot; to not checked</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
