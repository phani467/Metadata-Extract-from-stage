<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NotifyOwnerOfTheRecordApproval</fullName>
        <description>SFDC1-366 Notify Owner of the Record Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/EmailOnAdClaimChangeStatus</template>
    </alerts>
    <alerts>
        <fullName>NotifyOwnerOfTheRecordRejection</fullName>
        <description>SFDC1-366 Notify Owner of the Record Rejection</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/EmailOnAdClaimChangeStatus</template>
    </alerts>
    <fieldUpdates>
        <fullName>CheckSubmittedCheckbox</fullName>
        <description>SFDC1-366 This field prevents record from being processed by process builder when it is already approved</description>
        <field>Submitted__c</field>
        <literalValue>1</literalValue>
        <name>Check Submitted Checkbox</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateApprovedDateToToday</fullName>
        <description>SFDC1-366 The approved date is set to Today&apos;s date</description>
        <field>ApprovedDate__c</field>
        <formula>TODAY()</formula>
        <name>Update Approved Date To Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
