<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>EmailOptOutChangeResult</fullName>
        <description>SFDC1- 452, Read only date/time field which is changed by Emai lOpt Out</description>
        <field>EmailOptOutTimeStamp__c</field>
        <formula>Now()</formula>
        <name>EmailOptOutChangeResult</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EmailOptOutTimeStampUpdate</fullName>
        <description>SFDC1 -452; Workflow rule helps to update the field Email Opt Out Time Stamp
 when a new contact created from Lead</description>
        <field>EmailOptOutTimeStamp__c</field>
        <name>Email Opt Out Time Stamp Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetEloquaHardBounceToBlank</fullName>
        <description>SFDC1-8576: Set EloquaHardBounce  date to blank when Email is changed</description>
        <field>EloquaHardBounce__c</field>
        <name>SetEloquaHardBounceToBlank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetInactiveReasonToNone</fullName>
        <description>Set Inactive Reason to &quot;None&quot;</description>
        <field>InactiveReason__c</field>
        <name>Set InactiveReason To None</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>EmailOptOutChangeResult</fullName>
        <actions>
            <name>EmailOptOutChangeResult</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.EmailOptOut__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SFDC1- 452, WF rule changes the Date/time field when record created or Email Opt out changes</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetEloquaHardBounceToBlankWhenEmailUpdated</fullName>
        <actions>
            <name>SetEloquaHardBounceToBlank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-8576:  Set EloquaHardBounce date to &quot;blank&quot; when Email is changed</description>
        <formula>ISCHANGED(Email)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SetInactiveReasonWhenReactivateContact</fullName>
        <actions>
            <name>SetInactiveReasonToNone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-536 Set InactiveReason to &quot;None&quot; when Contact is re-activated</description>
        <formula>ISPICKVAL (Status__c, &quot;Active&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
