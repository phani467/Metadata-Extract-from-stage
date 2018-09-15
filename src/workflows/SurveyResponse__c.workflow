<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SurveyResponseHotAlert</fullName>
        <description>SFDC1-1895: An email from Salesforce informing user when a survey response requires a hot alert follow up to Case Owner</description>
        <protected>false</protected>
        <recipients>
            <field>CaseOwnerEmailId__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCustomerCare/SurveyResponseHotAlert</template>
    </alerts>
    <alerts>
        <fullName>SurveyResponseHotAlertForDistributionList</fullName>
        <description>SFDC1-1895: An email from Salesforce informing user when a survey response requires a hot alert follow up</description>
        <protected>false</protected>
        <recipients>
            <field>DistributionList1__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>DistributionList2__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCustomerCare/SurveyResponseHotAlert</template>
    </alerts>
    <alerts>
        <fullName>SurveyResponseHotAlertToCaseOwnerManagerId</fullName>
        <description>SFDC1-1895: An email alert informing user when a survey response requires a hot alert follow up</description>
        <protected>false</protected>
        <recipients>
            <field>CaseOwnerEmailId__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSCustomerCare/SurveyResponseHotAlert</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateFieldCsOwnerMngrWithOwnerMngrEmail</fullName>
        <description>SFDC1-1895: Update field &quot;Case Owner Manager Email Id&quot; With Case Owner Manager&apos;s Email Id</description>
        <field>CaseOwnerEmailId__c</field>
        <formula>Case__r.Owner:User.Manager.Email</formula>
        <name>Update Field With Case Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldWithCaseOwnerEmail</fullName>
        <description>SFDC1-1895: Update Field With Case Owner Email</description>
        <field>CaseOwnerEmailId__c</field>
        <formula>Case__r.Owner:User.Email</formula>
        <name>Update Field With Case Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SurveyResponseHotAlertToCaseOwnerManager</fullName>
        <actions>
            <name>SurveyResponseHotAlertToCaseOwnerManagerId</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>UpdateFieldCsOwnerMngrWithOwnerMngrEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-1895: Sending an email alert informing Case Owner manager when survey response record requires a hot alert follow up</description>
        <formula>AND( NOT(ISNULL(Case__r.Owner:User.ManagerId) ), ISPICKVAL( AlertType__c , &apos;Hot Alert&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SurveyResponseHotAlertToDistributionList</fullName>
        <actions>
            <name>SurveyResponseHotAlertForDistributionList</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SFDC1-1895: Receive a email from Salesforce informing user when survey response record requires a hot alert follow up</description>
        <formula>AND(   ISBLANK(Case__r.Owner:User.ManagerId),  ISPICKVAL( AlertType__c , &apos;Hot Alert&apos;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
