<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NotifyOwnerOfTheRecordRejection</fullName>
        <description>SFDC1-460 Notify Owner of the Record Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/EmailOnAdClaimChangeLogStatusChange</template>
    </alerts>
    <alerts>
        <fullName>NotifyOwnerOftheRecordApproval</fullName>
        <description>SFDC1-460 Notify Owner of the Record Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/EmailOnAdClaimChangeLogStatusChange</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateApprovedDateToToday</fullName>
        <description>SFDC1-460 The approved date is set to Today&apos;s date</description>
        <field>ApprovedDate__c</field>
        <formula>TODAY()</formula>
        <name>Update Approved Date To Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRequestDateToTodayWhenSubmission</fullName>
        <description>SFDC1-2069 : Update the Request Date to Today when Submit for Approval.</description>
        <field>RequestDate__c</field>
        <formula>TODAY()</formula>
        <name>UpdateRequestDateToTodayWhenSubmission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
