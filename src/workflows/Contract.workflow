<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>OrderFormRejectionEmail</fullName>
        <description>SFDC1-8895 Rejection Reason email should be sent to Contract Owner) when order form is rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/OrderFormRejectionEmail</template>
    </alerts>
    <alerts>
        <fullName>SendEmailtoOpportunityOwneronContractCancellation</fullName>
        <description>SendEmailtoOpportunityOwneronContractCancellation</description>
        <protected>false</protected>
        <recipients>
            <field>OpptyOwnerEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/OpptyOwnerEmailonContractCancellation</template>
    </alerts>
    <fieldUpdates>
        <fullName>ContractDefaultNamingForNDAAndMasterAgre</fullName>
        <description>SFDC1-7518: Update Name on Contract for NDA and MasterAgreement Contracts
SFDC1-7582: Updating date format to include month in text value.
SFDC1-8270: limiting characters to 80
SFDC1-8523: updated formula to show blank for blank date</description>
        <field>Name</field>
        <formula>LEFT(Account.Name + &apos; &apos; + RecordType.Name +&apos; &apos;+ IF(NOT(ISBLANK(EffectiveDate__c )), (TEXT(DAY(EffectiveDate__c ))+&apos;-&apos;+(CASE(MONTH(EffectiveDate__c ), 
1, &quot;Jan&quot;, 
2, &quot;Feb&quot;, 
3, &quot;Mar&quot;, 
4, &quot;Apr&quot;, 
5, &quot;May&quot;, 
6, &quot;Jun&quot;, 
7, &quot;Jul&quot;, 
8, &quot;Aug&quot;, 
9, &quot;Sep&quot;, 
10, &quot;Oct&quot;, 
11, &quot;Nov&quot;, 
12, &quot;Dec&quot;, 
&quot;None&quot;))+&apos;-&apos;+TEXT(YEAR(EffectiveDate__c ))), &apos;&apos;), 80)</formula>
        <name>ContractDefaultNamingForNDAAndMasterAgre</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ContractNameUpdate</fullName>
        <description>SFDC1-5827: Populate contract name field on contracts by default
SFDC1-7582: Updating date format to include month in text value.
SFDC1-8270: limiting characters to 80
SFDC1-8523: updated formula to show blank for blank date</description>
        <field>Name</field>
        <formula>LEFT(Account.Name + &apos; &apos; + RecordType.Name +&apos; &apos;+ IF(NOT(ISBLANK(StartDate)), (TEXT(DAY(StartDate))+&apos;-&apos;+(CASE(MONTH(StartDate), 
1, &quot;Jan&quot;, 
2, &quot;Feb&quot;, 
3, &quot;Mar&quot;, 
4, &quot;Apr&quot;, 
5, &quot;May&quot;, 
6, &quot;Jun&quot;, 
7, &quot;Jul&quot;, 
8, &quot;Aug&quot;, 
9, &quot;Sep&quot;, 
10, &quot;Oct&quot;, 
11, &quot;Nov&quot;, 
12, &quot;Dec&quot;, 
&quot;None&quot;))+&apos;-&apos;+TEXT(YEAR(StartDate))), &apos;&apos;), 80)</formula>
        <name>ContractNameUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ContractStatusUpdateToSubmitted</fullName>
        <description>SFDC1-8018:Update Contract Status to Submitted when Stage is moved to “Ready for Processing”</description>
        <field>ContractStatus__c</field>
        <literalValue>Submitted</literalValue>
        <name>ContractStatusUpdateToSubmitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetContractStageAsComplete</fullName>
        <description>SFDC1-8533 Convert Process Builder flow 1) &quot;Contract Update&quot; created in SFDC1-6503 on Contract object to a trigger/workflow. Status Field Update.</description>
        <field>Status</field>
        <literalValue>Complete</literalValue>
        <name>SetContractStageAsComplete</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetContractStageAsCreation</fullName>
        <description>SFDC1-8533 Convert Process Builder flow &quot;UpdateContractStagebasedOnContractStatus&quot; created in SFDC1-5403+SFDC1-7187 on Contract object to a trigger/workflow. Field Update.</description>
        <field>Status</field>
        <literalValue>Creation</literalValue>
        <name>SetContractStageAsCreation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetCumulativeContractValueOnContract</fullName>
        <description>SFDC1-8533: Convert Process Flow &quot;Update Cumulative Contract Field with Default To Total Contract Value&quot; to trigger/Workflow. Parent Story SFDC1-5864. Field update to set Cumulative Contract Value on contract.</description>
        <field>AllAssociatedTotalOpportunityValue__c</field>
        <formula>TotalContractValue__c</formula>
        <name>SetCumulativeContractValueOnContract</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateAgreementEffectiveDate</fullName>
        <description>SFDC1-5851 If &quot;General Agreement&quot; is populated on order form contract pull effective date from that contract and populate as &quot;Agreement Effective date&quot; on order form</description>
        <field>GeneralAgreementDate__c</field>
        <formula>GeneralAgreement__r.EffectiveDate__c</formula>
        <name>UpdateAgreementEffectiveDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateContractRejectionPastDueCheck</fullName>
        <description>SFDC1-7488 : Update ContractRejectionPastDue__c checkbox</description>
        <field>ContractRejectionPastDue__c</field>
        <literalValue>1</literalValue>
        <name>Update Contract Rejection Past Due Check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateContractStatus</fullName>
        <description>SFDC1-6504 Update the Contract Status to &quot;Sent to OM/Delivery&quot;
SFDC1-7584 Update the Contract Status to &quot;Submitted&quot;</description>
        <field>ContractStatus__c</field>
        <literalValue>Submitted</literalValue>
        <name>UpdateContractStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateGlobalAllianceCity</fullName>
        <description>SFDC1-8533 Convert Process Builder flow &quot;Update Global Alliance Information on Contract&quot; on Contract object created in SFDC1-5260(Update Global Alliance Information on Contract from Opportunity Channel Partner) to a trigger/workflow. Field update.</description>
        <field>GlobalAllianceAddressCity__c</field>
        <formula>Opportunity__r.ChannelPartner__r.BillingCity</formula>
        <name>UpdateGlobalAllianceCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateGlobalAllianceCountry</fullName>
        <description>SFDC1-8533 Convert Process Builder flow &quot;Update Global Alliance Information on Contract&quot; on Contract object created in SFDC1-5260(Update Global Alliance Information on Contract from Opportunity Channel Partner) to a trigger/workflow. Field update.</description>
        <field>GlobalAllianceAddressCountry__c</field>
        <formula>Opportunity__r.ChannelPartner__r.BillingCountry</formula>
        <name>UpdateGlobalAllianceCountry</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateGlobalAllianceState</fullName>
        <description>SFDC1-8533 Convert Process Builder flow &quot;Update Global Alliance Information on Contract&quot; on Contract object created in SFDC1-5260(Update Global Alliance Information on Contract from Opportunity Channel Partner) to a trigger/workflow. Field update.</description>
        <field>GlobalAllianceAddressStateProvince__c</field>
        <formula>Opportunity__r.ChannelPartner__r.BillingState</formula>
        <name>UpdateGlobalAllianceState</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateGlobalAllianceStreet</fullName>
        <description>SFDC1-8533 Convert Process Builder flow &quot;Update Global Alliance Information on Contract&quot; on Contract object created in SFDC1-5260(Update Global Alliance Information on Contract from Opportunity Channel Partner) to a trigger/workflow. Field update.</description>
        <field>GlobalAllianceAddressStreet__c</field>
        <formula>Opportunity__r.ChannelPartner__r.BillingStreet</formula>
        <name>UpdateGlobalAllianceStreet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateGlobalAllianceZipcode</fullName>
        <description>SFDC1-8533 Convert Process Builder flow &quot;Update Global Alliance Information on Contract&quot; on Contract object created in SFDC1-5260(Update Global Alliance Information on Contract from Opportunity Channel Partner) to a trigger/workflow. Field update.</description>
        <field>GlobalAllianceAddressPostalZipCode__c</field>
        <formula>Opportunity__r.ChannelPartner__r.BillingPostalCode</formula>
        <name>UpdateGlobalAllianceZipcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contract Rejection Past Due Check</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Contract.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order Form</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.ContractRejectionPastDue__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.ContractStatus__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>SFDC1-7488 # : count # of days since Contract Status = Rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>UpdateContractRejectionPastDueCheck</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>ContractDefaultNaming</fullName>
        <actions>
            <name>ContractNameUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5827: Populate contract name field on contracts by default
SFDC1-7518:  Skip default naming for NDA and MasterAgreement Contracts
SFDC1-8523: Skipping for DPA Contract</description>
        <formula>AND(NOT(ISBLANK(RecordTypeId)), NOT(CONTAINS(RecordType.DeveloperName, &quot;NDA&quot;)),  NOT(CONTAINS(RecordType.DeveloperName, &quot;DPA&quot;)),  NOT(CONTAINS(RecordType.DeveloperName, &quot;MasterAgreement&quot;)), NOT(CONTAINS(RecordType.DeveloperName, &quot;ManagedServiceTerms&quot;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ContractDefaultNamingForNDAAndMasterAgreement</fullName>
        <actions>
            <name>ContractDefaultNamingForNDAAndMasterAgre</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-7518: Default naming for NDA and MasterAgreement Contracts
SFDC1-8523: Added default naming for DPA contract</description>
        <formula>AND(NOT(ISBLANK(RecordTypeId)), OR(CONTAINS(RecordType.DeveloperName, &quot;NDA&quot;), CONTAINS(RecordType.DeveloperName, &quot;MasterAgreement&quot;),   CONTAINS(RecordType.Name, &quot;DPA&quot;),   CONTAINS(RecordType.DeveloperName, &quot;ManagedServiceTerms&quot;)))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>ContractStatusUpdateToSubmitted</fullName>
        <actions>
            <name>ContractStatusUpdateToSubmitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.Status</field>
            <operation>equals</operation>
            <value>ReadyForProcessing</value>
        </criteriaItems>
        <description>SFDC1-8018:Update Contract Status to Submitted when Stage is moved to “Ready for Processing”</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OrderFormContractStatusUpdate</fullName>
        <actions>
            <name>UpdateContractStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-6504 When an &apos;Order Form&apos; stage is put to Ready for Processing, update the &apos;Status&apos; to &apos;Sent to OM/Delivery&apos;</description>
        <formula>AND ( RecordType.Name == &apos;Order Form&apos;, ISCHANGED(Status), ISPICKVAL(Status, &apos;ReadyForProcessing&apos;)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PopulateAgreementEffectiveDateOnOrderForm</fullName>
        <actions>
            <name>UpdateAgreementEffectiveDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5851 If &quot;General Agreement&quot; is populated on order form contract pull effective date from that contract and populate as &quot;Agreement Effective date&quot; on order form</description>
        <formula>AND ( 	RecordType.Name == &apos;Order Form&apos;,  	NOT(ISBLANK(GeneralAgreement__c )), 	OR ( 		ISCHANGED(GeneralAgreement__c), 		ISNEW() 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Notification to Opportunity Owner on Contract Cancellation</fullName>
        <active>false</active>
        <description>SFDC1-802 Send Notification to Opportunity Owner when Cancel Request Received Date on  Contract is filled</description>
        <formula>AND( ISCHANGED(CancelRequestReceivedDate__c), NOT(ISBLANK(CancelRequestReceivedDate__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SendEmailToOppOwnerOnContractCancellationRule</fullName>
        <actions>
            <name>SendEmailtoOpportunityOwneronContractCancellation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SFDC1-8533 Convert Process Builder flow &quot;SendNotificationtoOpportunityOwneronContractCancellation&quot; on Contract object created in SFDC1-802 to a trigger. This workflow sends email to Opp Owner.</description>
        <formula>AND( NOT(ISNULL( Opportunity__c )), NOT(ISNULL( CancelRequestReceivedDate__c )),  ISCHANGED(CancelRequestReceivedDate__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SendRejectionMailToContractOwner</fullName>
        <actions>
            <name>OrderFormRejectionEmail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract.ContractStatus__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order Form</value>
        </criteriaItems>
        <description>SFDC1-8895 This workflow sends Rejection Reason email to Contract Owner when Order Form is rejected</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SetContractStageCompleteRule</fullName>
        <actions>
            <name>SetContractStageAsComplete</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Contract.ContractStatus__c</field>
            <operation>equals</operation>
            <value>Executed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contract.RecordTypeId</field>
            <operation>equals</operation>
            <value>NDA,Master Agreement</value>
        </criteriaItems>
        <description>SFDC1-8533 Convert Process Builder flow 1) &quot;Contract Update&quot; created in SFDC1-6503 on Contract object to a trigger/workflow.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateContractStageOnContractRejectionRule</fullName>
        <actions>
            <name>SetContractStageAsCreation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-8533 Convert Process Builder flow &quot;UpdateContractStagebasedOnContractStatus&quot; created in SFDC1-5403+SFDC1-7187 on Contract object to a trigger/workflow.</description>
        <formula>AND(  RecordType.DeveloperName = &quot;OrderForm&quot;,    ISPICKVAL(ContractStatus__c, &quot;Rejected&quot;),   OR(   Opportunity__r.RecordType.DeveloperName = &quot;NewBusiness&quot;,   Opportunity__r.RecordType.DeveloperName = &quot;Renewal&quot;  ) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateCumulativeContractValue</fullName>
        <actions>
            <name>SetCumulativeContractValueOnContract</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-8533: Convert Process Flow &quot;Update Cumulative Contract Field with Default To Total Contract Value&quot; to trigger/Workflow. Parent Story SFDC1-5864. Workflow rule to update Cumulative Contract Value on contract.</description>
        <formula>AND(    AutoRenewal__c,    ISPICKVAL(Status, &quot;Creation&quot;) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateGlobalAllianceInfoOnContractRule</fullName>
        <actions>
            <name>UpdateGlobalAllianceCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateGlobalAllianceCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateGlobalAllianceState</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateGlobalAllianceStreet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateGlobalAllianceZipcode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-8533 Convert Process Builder flow &quot;Update Global Alliance Information on Contract&quot; on Contract object created in SFDC1-5260(Update Global Alliance Information on Contract from Opportunity Channel Partner) to a trigger/workflow.</description>
        <formula>AND(   NOT(ISNULL( Opportunity__c )),   ISPICKVAL( Opportunity__r.SubType__c , &quot;Global Alliance&quot;),   NOT(ISNULL( Opportunity__r.ChannelPartner__c )) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
