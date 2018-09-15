<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LiveChatEmailTranscript</fullName>
        <description>Live Chat Email Transcript</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CSCustomerCare/LiveChatTranscript</template>
    </alerts>
    <rules>
        <fullName>Live Chat Transcript Send</fullName>
        <actions>
            <name>LiveChatEmailTranscript</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5359 : Send Live Chat Transcript when requested by customer.</description>
        <formula>AND(NOT(ISBLANK( SuppliedEmail__c)), SendTranscript__c,  ISPICKVAL(Status , &apos;Completed&apos;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
