<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EmailAlertNotifyOwnerWhenTMCStatusIsInactive</fullName>
        <description>SFDC1-7001: Email alert to notify Opportunity owner when TMC status is inactive</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/NotifyOpportunityOwnerWhenTMCStatusIsInactive</template>
    </alerts>
    <alerts>
        <fullName>NotifyOldandNewOpportunityOwnerForOwnerChange</fullName>
        <description>NotifyOldandNewOpportunityOwnerForOwnerChange</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>PreviousOpportunityOwner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/OpportunityOwnerChangeNotificationEmail</template>
    </alerts>
    <alerts>
        <fullName>Opportunity6WEmailAlert</fullName>
        <description>Opportunity6WEmailAlert</description>
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
            <recipient>Consultant</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Contract Support</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Covering Rep</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager</recipient>
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
            <recipient>Sales Coordinator</recipient>
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
            <recipient>Consultant</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contract Support</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Covering Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager</recipient>
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
            <recipient>Sales Coordinator</recipient>
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
        <template>unfiled$public/ClosedWonOpportunity</template>
    </alerts>
    <alerts>
        <fullName>OpportunityClosedLostEmailAlert</fullName>
        <description>OpportunityClosedLostEmailAlert</description>
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
            <recipient>Consultant</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Contract Support</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Covering Rep</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager</recipient>
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
            <recipient>Sales Coordinator</recipient>
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
            <recipient>Consultant</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Contract Support</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Covering Rep</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager</recipient>
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
            <recipient>Sales Coordinator</recipient>
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
        <template>unfiled$public/ClosedLostOpportunity</template>
    </alerts>
    <alerts>
        <fullName>OpportunityOwnerEmailTMCActive</fullName>
        <description>SFDC1-6911;This workflow is sent when TMC team sets the Opportunity to TMC Status field to Active, this emails Oppy Owner that his/her oppy is now TMC Active (scheduled for TMC review)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/OpportunityTMCSetToActive</template>
    </alerts>
    <alerts>
        <fullName>RenewalOpportunityAtRiskNotification</fullName>
        <description>SFDC1-471;Renewal Opportunity At Risk Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account Manager</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>BL Leader</recipient>
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
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/RenewalAtRisk</template>
    </alerts>
    <alerts>
        <fullName>SendNotificationToOpportunityAndAccountTeam</fullName>
        <description>SFDC1-1433 Send Notification To Opportunity And Account Team</description>
        <protected>false</protected>
        <recipients>
            <recipient>Contract Support</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager</recipient>
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
            <recipient>Sales Coordinator</recipient>
            <type>accountTeam</type>
        </recipients>
        <recipients>
            <recipient>Contract Support</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Executive Sponsor</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <recipients>
            <recipient>Manager</recipient>
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
            <recipient>Sales Coordinator</recipient>
            <type>opportunityTeam</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/AutoCloseRenewalOpportunityNotification</template>
    </alerts>
    <fieldUpdates>
        <fullName>ClosedDateSetToToday</fullName>
        <description>SFDC1-488;If the Opportunity is set to 6L and the Close Date is in the Future - the Date should update with the Current Date.</description>
        <field>CloseDate</field>
        <formula>Today()</formula>
        <name>ClosedDateSetToToday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NewOppySalesstage1</fullName>
        <description>SFDC1- 171; Sales Stage should default to Sales Stage 1 on New Business.</description>
        <field>StageName</field>
        <literalValue>1-Sales Qualified</literalValue>
        <name>NewOppySalesstage1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OpportunityCloseDateRemainUnchanged</fullName>
        <description>SFDC1-488;Closed date remain unchanged</description>
        <field>CloseDate</field>
        <formula>Priorvalue(CloseDate)</formula>
        <name>OpportunityCloseDateRemainUnchanged</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OpportunityCloseDateToday</fullName>
        <description>SFDC1-488;The close date to change to today&apos;s date when an Opportunity is set to 6L or 6W and the Close date was in the past</description>
        <field>CloseDate</field>
        <formula>TODAY()</formula>
        <name>OpportunityCloseDateToday</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TotalOpptyAmountUpdate</fullName>
        <description>SFDC1-7045:Overlay spit type amount is calculated from Total Opportunity Amount field</description>
        <field>TotalOpportunityAmount__c</field>
        <formula>Amount</formula>
        <name>TotalOpptyAmountUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateLostCodeField</fullName>
        <description>SFDC1-5019 The Lost reason and lost code should be removed when Opportunity is reopened.</description>
        <field>LostReasonCode__c</field>
        <name>UpdateLostCodeField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateLostReasonField</fullName>
        <description>SFDC1-5019 The Lost reason and lost code should be removed when Opportunity is reopened.</description>
        <field>LostReasonDescription__c</field>
        <name>UpdateLostReasonField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NewOppySalesstage1</fullName>
        <actions>
            <name>NewOppySalesstage1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>New Business</value>
        </criteriaItems>
        <description>SFDC1-171; Sales Stage should default to Sales Stage 1 on New Business.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NotifyOwnerWhenTMCStatusIsInactive</fullName>
        <actions>
            <name>EmailAlertNotifyOwnerWhenTMCStatusIsInactive</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.TMCStatus__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <description>SFDC1-7001:Notify Opportunity owner when TMC status is Inactive</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityCloseDateBehavior</fullName>
        <actions>
            <name>OpportunityCloseDateToday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>lessThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-488;The close date to change to today&apos;s date when an Opportunity is set to 6L or 6W and the Close date was in the past</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityCloseDateBehaviourForLostBusiness</fullName>
        <actions>
            <name>ClosedDateSetToToday</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.CloseDate</field>
            <operation>greaterThan</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6L-Renewal Lost,6L-Closed Lost</value>
        </criteriaItems>
        <description>SFDC1-488;If the Opportunity is set to 6L and the Close Date is in the Future - the Date should update with the Current Date.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityClosedLossNotification</fullName>
        <actions>
            <name>OpportunityClosedLostEmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6L-Renewal Lost,6L-Closed Lost,6L-Forecasting Placeholder</value>
        </criteriaItems>
        <description>SFDC1-468;Email Alert for Salesperson, Account Team member or Opportunity Team member when Opportunity is closed lost</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityStage6WEmailNotification</fullName>
        <actions>
            <name>Opportunity6WEmailAlert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR (2 AND 3) OR 4</booleanFilter>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6W-Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6W-Renewal Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsThisRenewalAutoClosed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>6W-Forecasting Placeholder</value>
        </criteriaItems>
        <description>SFDC1-41;Email to Owner, Opportunity Team, Account Team when Sales Stage is set to 6W</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityWonCloseDateBehavior</fullName>
        <actions>
            <name>OpportunityCloseDateRemainUnchanged</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.IsWon</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-488;The close date is remain unchanged/future if opportunity stage will be in future.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Probabitly calculation</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Probability</field>
            <operation>lessThan</operation>
            <value>50</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RenewalOpportunityAtRisk</fullName>
        <actions>
            <name>RenewalOpportunityAtRiskNotification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Countofrenewalatrisk__c</field>
            <operation>greaterOrEqual</operation>
            <value>1</value>
        </criteriaItems>
        <description>SFDC1-471;Email to the Account Team or Opportunity Team when an Opportunity is put at risk</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TotalOpptyAmountUpdateByAmount</fullName>
        <actions>
            <name>TotalOpptyAmountUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-7045:Overlay spit type amount is calculated from Total Opportunity Amount field</description>
        <formula>ISCHANGED( Amount )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateLostCodeandReasonwhenOpportunityReopen</fullName>
        <actions>
            <name>UpdateLostCodeField</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateLostReasonField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5019 The Lost reason and lost code need to be removed when Opportunity is reopened.</description>
        <formula>AND (  	OR( 	ISPICKVAL(PRIORVALUE(StageName),&quot;6L-Closed Lost&quot;), 	ISPICKVAL(PRIORVALUE(StageName),&quot;6L-Forecasting Placeholder&quot;), 	ISPICKVAL(PRIORVALUE(StageName),&quot;6L-Renewal Lost&quot;) ), 	ISCHANGED(StageName)  	)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WorkflowsForTMCFieldsSetToActive</fullName>
        <actions>
            <name>OpportunityOwnerEmailTMCActive</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.TMCStatus__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.NextReview__c</field>
            <operation>greaterOrEqual</operation>
            <value>TODAY</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>SFDC1-6911;This workflow is sent when TMC team sets the Opportunity to TMC Status field to Active, this emails Oppy Owner that his/her oppy is now TMC Active (scheduled for TMC review)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
