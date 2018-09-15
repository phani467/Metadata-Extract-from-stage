<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>RenewalAtRiskNotification</fullName>
        <description>SFDC1-471;Email to the Account Team or Opportunity Team when an Opportunity is put at risk</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>BL Leader</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Consultant</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Covering Rep</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Opportunity Owner</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Specialist</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>SME</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Operations</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Specialist</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>BL Leader</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Channel Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Consultant</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Covering Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Opportunity Owner</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Product Specialist</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>SME</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Manager</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Operations</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Sales Specialist</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RenewalAtRisk</template>
    </alerts>
    <fieldUpdates>
        <fullName>UpdateEstimatedValueRisk</fullName>
        <description>SFDC1-6876: Update value of Estimated Value Risk field in Opportunity from Opportunity at Risk object</description>
        <field>EstimatedValueatRiskautoupdate__c</field>
        <formula>OpportunityAtRisk__r.EstimatedValueatRiskautoupdate__c</formula>
        <name>Update Estimated Value Risk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityAtRisk__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateFieldonAssociatedOpportunity</fullName>
        <description>SFDC1-4163 Update field on Opportunity with value in renewal at risk record</description>
        <field>EstimatedValueatRiskautoupdate__c</field>
        <formula>EstimatedValueatRisk__c</formula>
        <name>UpdateFieldonAssociatedOpportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityAtRisk__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateOaRfield</fullName>
        <description>SFDC1-6709 : OaRStatus field gets updated each time the OaR record status is updated.</description>
        <field>OaRStatus__c</field>
        <formula>TEXT(Status__c)</formula>
        <name>Update OaR field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityAtRisk__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>OpportunityAtRiskcreation</fullName>
        <actions>
            <name>RenewalAtRiskNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RenewalatRisk__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SFDC1-471;Email to the Account Team or Opportunity Team when an Opportunity is put at risk</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UpdateAssociatedOpportunityEstimatedValueatRisk</fullName>
        <actions>
            <name>UpdateFieldonAssociatedOpportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-4163 Update Associated Opportunity&apos;s field -  Estimated Value at Risk</description>
        <formula>NOT(ISBLANK(EstimatedValueatRisk__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateEstimatedValueatRisk</fullName>
        <actions>
            <name>UpdateEstimatedValueRisk</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>RenewalatRisk__c.EstimatedValueatRisk__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SFDC1-6876: Update Estimated Value at Risk to value present in Opportunity at risk object.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateOaRStatusfieldonOpportunity</fullName>
        <actions>
            <name>UpdateOaRfield</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-6709 : This workflow updates the OaR status field on opportunity</description>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
