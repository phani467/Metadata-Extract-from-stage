<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>ChangeLogApproval</fullName>
        <description>Change Log Approval</description>
        <protected>false</protected>
        <recipients>
            <field>ChangeDocumentedBy__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRFPLCTemplates/ChangeLogApproved</template>
    </alerts>
    <alerts>
        <fullName>ChangeLogOwnerChange</fullName>
        <description>Change Log Owner Change</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>ChangeDocumentedBy__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRFPLCTemplates/ChangeLogFormOwnerChange</template>
    </alerts>
    <rules>
        <fullName>ChangeLogApproved</fullName>
        <actions>
            <name>ChangeLogApproval</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ChangeLog__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ChangeLogOwnerChanges</fullName>
        <actions>
            <name>ChangeLogOwnerChange</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>OwnerId &lt;&gt; PRIORVALUE(OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
