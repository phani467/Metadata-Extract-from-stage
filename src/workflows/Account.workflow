<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AccountOwnerChangeNotificationEmailAlert</fullName>
        <description>Account Owner Change Notification Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <field>PreviousOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/AccountOwnerChangeNotificationEmail</template>
    </alerts>
    <alerts>
        <fullName>NotifyAccountInvalidation7Days</fullName>
        <description>Notify Data Governance and Account Creator that status is changed to Inactive - Invalid</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>DataGovernanceUsers</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/AccountInvalidateAccountNotification</template>
    </alerts>
    <alerts>
        <fullName>NotifyAccountUnapproved4Days</fullName>
        <description>Notify Data Governance and Creator that Account has been pending &quot;Unapproved&quot; for 4 days</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>DataGovernanceUsers</recipient>
            <type>group</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/AccountPendingUnapprovedNotification</template>
    </alerts>
    <alerts>
        <fullName>Test_NotifyAccountUnapproved1Hour</fullName>
        <description>Test: Notify Data Governance and Creator that Account has been pending &quot;Unapproved&quot; for 1 day</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <recipient>DataGovernanceUsers</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/AccountPendingUnapprovedNotification</template>
    </alerts>
    <fieldUpdates>
        <fullName>AccountInvalidation7Days</fullName>
        <description>Set the account status to &quot;Inactive - Invalid&quot;</description>
        <field>Status__c</field>
        <literalValue>InactiveInvalid</literalValue>
        <name>Account Invalidation - 7 Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ClearStateOfIncorporation</fullName>
        <description>SFDC1-5766, This clears out the &quot;State of Incorporation&quot; field when the &quot;Incorporated in&quot; field get changed from &quot;United States&quot; into something else (or empty)</description>
        <field>StateOfIncorporation__c</field>
        <name>ClearStateOfIncorporation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateDataGovernanceStatus</fullName>
        <description>Update DataGovernanceStatus to &quot;Approved&quot;</description>
        <field>DataGovernanceStatus__c</field>
        <literalValue>Approved</literalValue>
        <name>Update DataGovernanceStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRelationshipProspect</fullName>
        <description>SFDC1-775 set relationship as &apos;Prospect&apos; on account creation</description>
        <field>Relationship__c</field>
        <formula>&quot;Prospect&quot;</formula>
        <name>Update Relationship: Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>ClearStateOfIncorporation</fullName>
        <actions>
            <name>ClearStateOfIncorporation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5814, This clears out the &quot;State of Incorporation&quot; field when the &quot;Incorporated in&quot; field get changed from &quot;United States&quot; into something else (or empty).</description>
        <formula>IncorporatedIn__r.Name != &apos;United States&apos; &amp;&amp;   NOT(ISBLANK(TEXT(StateOfIncorporation__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Invalidate If Not Approved After 7 Days</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Account.DataGovernanceStatus__c</field>
            <operation>equals</operation>
            <value>Unapproved</value>
        </criteriaItems>
        <description>SFDC1-195 Invalidate when the account has been at the Data Governance Status of Unapproved for more than 7 days after creation.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NotifyAccountInvalidation7Days</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>AccountInvalidation7Days</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>NotifyAccountUnapproved4Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Account.CreatedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>SetAccountAsProspect</fullName>
        <actions>
            <name>UpdateRelationshipProspect</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-775 set account relationship as prospect when account is created</description>
        <formula>true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SetStatusForDataGovernanceCreatedAccount</fullName>
        <actions>
            <name>UpdateDataGovernanceStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>SFDC1-558 Set Account&apos;s DataGovernanceStatus to &quot;Approved&quot; if the user who created account belongs to Data Governance profile.
SFDC1-902 Deactivate this workflow to set default Account&apos;s Data Governance Status to &quot;Unapproved&quot; on creation</description>
        <formula>$Profile.Name = &quot;Data Governance&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
