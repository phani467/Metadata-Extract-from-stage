<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CustomerCareNewCommentEmailNotification</fullName>
        <description>Customer Care New Comment / Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CorporateMailTemplates/NewCaseEmail</template>
    </alerts>
    <alerts>
        <fullName>JoinerTransferLeaverNewEmailAlert</fullName>
        <ccEmails>outboundemailtracking@21z8xofo0ebdgfmc8mgzkx2lpp7fxva27co1i135p3tibn4vnm.m-diwweaw.cs20.apex.sandbox.salesforce.com</ccEmails>
        <description>SFDC1-6292 JTL new email alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CorporateMailTemplates/NewCaseEmailTracked</template>
    </alerts>
    <alerts>
        <fullName>NewCaseCommentEmailNotification</fullName>
        <description>SFDC1-6294 New Case Comment Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CorporateMailTemplates/CustomerCareCaseComment</template>
    </alerts>
    <alerts>
        <fullName>Notificationforasalespersonwhenemailinquiryisturnedintoacase</fullName>
        <description>SFDC1-6027: Notification for a sales person when email inquiry is turned into a case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/TemplateforSalessupporttocreateEmailnotification</template>
    </alerts>
    <alerts>
        <fullName>NotifyCaseContactsOfClosedSalesforceHelpdeskCase</fullName>
        <description>SFDC1-9013: Notify Case Contacts of &quot;Closed&quot; Salesforce Helpdesk Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/SalesforceHelpdeskCaseClose</template>
    </alerts>
    <alerts>
        <fullName>NotifyCaseContactsOfNewSalesforceHelpdeskCase</fullName>
        <description>SFDC1-9013: Notify Case Contacts of &quot;New&quot; Salesforce Helpdesk Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/SalesforceHelpdeskCaseCreation</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsClosedCustomerCareCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;Closed&quot; Customer Care Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/CustomerCareCaseClose</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsClosedOnboardingCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;Closed&quot; Onboarding Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/OnboardingCaseClose</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsClosedResponseManagementCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;Closed&quot; Response Management Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/ResponseManagementCaseClose</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsNewInProgressCustomerCareCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;new&quot; or &quot;In progress&quot; Customer Care Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/CustomerCareCaseCreations</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsNewInProgressOnboardingCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;new&quot; or &quot;In progress&quot; Onboarding Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/OnboardingCaseCreation</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsNewInProgressResponseManagementCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;new&quot; or &quot;In progress&quot; Response Management Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/ResponseManagementCaseCreation</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsReopenedCustomerCareCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;Reopened&quot; Customer Care Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/CustomerCareCasereopen</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsReopenedOnboardingCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;Reopend&quot; Onboarding Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/OnboardingCasereopen</template>
    </alerts>
    <alerts>
        <fullName>NotifyContactsReopenedResponseManagementCase</fullName>
        <description>SFDC1-6897: Notify Contacts of &quot;Reopened&quot; Response Management Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/ResponseManagementCasereopen</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactNewCustomerCareCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of New Customer Care Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/CustomerCareCaseCreations</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactNewOnboardingCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of New Onboarding Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/OnboardingCaseCreation</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactNewResponseManagementCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of New Response Management Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/ResponseManagementCaseCreation</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactsClosedCustomerCareCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of &quot;Closed&quot; Customer Care Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/CustomerCareCaseClose</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactsClosedOnboardingCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of &quot;Closed&quot; Onboarding Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/OnboardingCaseClose</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactsClosedResponseManagementCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of &quot;Closed&quot; Response Management Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/ResponseManagementCaseClose</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactsReopenedCustomerCareCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of &quot;Reopened&quot; Customer Care Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/CustomerCareCasereopen</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactsReopenedOnboardingCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of &quot;Reopend&quot; Onboarding Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/OnboardingCasereopen</template>
    </alerts>
    <alerts>
        <fullName>NotifyCreatorAndContactsReopenedResponseManagementCase</fullName>
        <description>SFDC1-3643: Notify Case Creator and Contacts of &quot;Reopened&quot; Response Management Case</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CorporateMailTemplates/ResponseManagementCasereopen</template>
    </alerts>
    <alerts>
        <fullName>NotifyOwnerThatCaseIsReopened</fullName>
        <description>Notify Owner that Case is Reopened</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>unfiled$public/CaseReopenedSendToCaseOwner</template>
    </alerts>
    <alerts>
        <fullName>NotifyasalespersonwhencasestatusisClosedORResolved</fullName>
        <description>SFDC1-6028: Notify a sales person when case status is &quot;Closed&quot; OR &quot;Resolved&quot;</description>
        <protected>false</protected>
        <recipients>
            <field>ContactId</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>no-replycrm@ihsmarkit.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>unfiled$public/TemplateforSalessupportwhencasestatusissettoResolvedORClosed</template>
    </alerts>
    <alerts>
        <fullName>OnboardingNewCommentEmailNotification</fullName>
        <description>Onboarding New Comment / Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CorporateMailTemplates/NewCaseEmail</template>
    </alerts>
    <alerts>
        <fullName>ResponseManagementNewCommentEmailNotification</fullName>
        <description>Response Management New Comment / Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>CorporateMailTemplates/NewCaseEmail</template>
    </alerts>
    <fieldUpdates>
        <fullName>AssignCustomerCommunityCaseGoldfire</fullName>
        <description>For Customer Support Community.  Assigns cases from Goldfire users to the appropriate queue.</description>
        <field>OwnerId</field>
        <lookupValue>CSGoldfireSupport</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AssignCustomerCommunityCaseGoldfire</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssignCustomerCommunityCaseKingdom</fullName>
        <description>For Customer Support Community.  Assigns cases from Kingdom users to appropriate queue.</description>
        <field>OwnerId</field>
        <lookupValue>CSEnergyKingdom</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>AssignCustomerCommunityCaseKingdom</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssignDeliveryHelpdeskCase</fullName>
        <description>SFDC1-6470 assign case to &quot;CS | Delivery&quot;</description>
        <field>OwnerId</field>
        <lookupValue>CSDelivery</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Delivery Helpdesk Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssignOrderManagementHelpdeskCase</fullName>
        <description>SFDC1-6470 assign case to &quot;CS | Order Management&quot; queue</description>
        <field>OwnerId</field>
        <lookupValue>CSOrderManagement</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Order Management Helpdesk Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AssignRetailCase</fullName>
        <description>SFDC1-7096 assign case to &quot;CS | Retail&quot;</description>
        <field>OwnerId</field>
        <lookupValue>CSRetail</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Assign Retail Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CaseOwnerToQueue</fullName>
        <description>SFDC1-5583 Change the Case owner to FM | Customer Care Queue when created from Lead</description>
        <field>OwnerId</field>
        <lookupValue>FMCustomerCare</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner To Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CaseOwnerUpdateToSalesforceHelpdesk</fullName>
        <description>SFDC1-8267
Assigns the case owner to Salesforce Helpdesk Queue.</description>
        <field>OwnerId</field>
        <lookupValue>FMSalesforceHelpdesk</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Case Owner update to Salesforce Helpdesk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DeleteCaseOwnerAssignment</fullName>
        <description>SFDC1-1039: Change case owner to delete queue when Status is changed to delete</description>
        <field>OwnerId</field>
        <lookupValue>DeleteQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Delete Case Owner Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DoNotSurveyFieldUpdate</fullName>
        <description>SFDC1-1352 When case contact is internal user, Do Not Survey Field is set to TRUE</description>
        <field>DoNotSurvey__c</field>
        <literalValue>1</literalValue>
        <name>DoNotSurveyFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DoNotSurveyReasonFieldUpdate</fullName>
        <description>SFDC1-1352 When a case is closed and contact is an internal user, Do Not Survey Reason Field is set to &apos;Internal Contact&apos;</description>
        <field>DoNotSurveyReason__c</field>
        <formula>&quot;Internal Contact&quot;</formula>
        <name>DoNotSurveyReasonFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DoNotSurveyReasonUpdate</fullName>
        <description>SFDC1-5513: Do Not Survey Reason to be changed to Ticket not actioned for cases that are not updated in long time</description>
        <field>DoNotSurveyReason__c</field>
        <formula>&quot;Ticket not actioned&quot;</formula>
        <name>Do Not Survey Reason Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DoNotSurveyToFalse</fullName>
        <description>SFDC1-5513: Set do not survey field to false.</description>
        <field>DoNotSurvey__c</field>
        <literalValue>0</literalValue>
        <name>Do Not Survey To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Do_Not_Survey_Reason_Update</fullName>
        <description>Test</description>
        <field>DoNotSurveyReason__c</field>
        <formula>&quot;Ticket not actioned&quot;</formula>
        <name>Do Not Survey Reason Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Do_Not_Survey_To_False</fullName>
        <field>DoNotSurvey__c</field>
        <literalValue>0</literalValue>
        <name>Do Not Survey To False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DuplicateCaseOwnerAssignment</fullName>
        <description>SFDC1-1930: When case status is changed to duplicate change the owner to duplicate queue</description>
        <field>OwnerId</field>
        <lookupValue>DuplicateQueue</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Duplicate Case Owner Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RunCustomCaseAssignmentLogic</fullName>
        <description>SFDC1-7574 When the standard case assignment rule assigns case to &apos;To Be Assigned&apos; queue, this workflow checks the custom checkbox field on case and executes the custom code.</description>
        <field>RunCaseAssignmentRule__c</field>
        <literalValue>1</literalValue>
        <name>RunCustomCaseAssignmentLogic</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDCHelpdeskCaseAssignment</fullName>
        <description>SFDC1-7866.
Assign SFDC Helpdesk cases created from the quick actions to the associated queue.</description>
        <field>OwnerId</field>
        <lookupValue>FMSalesforceHelpdesk</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SFDC Helpdesk Case Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SalesforceSuggestionQueueUpdate</fullName>
        <description>SFDC1-8978; Case owner of Salesforce Suggestion record type changes</description>
        <field>OwnerId</field>
        <lookupValue>SalesforceSuggestion</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Salesforce Suggestion Queue Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetCasePrioritytoHigh</fullName>
        <description>SFDC1-1378: Update case priority to high Outage/Password/Login related issues</description>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>Set Case Priority to High</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetPreviousOwnerId</fullName>
        <description>SFDC1-5934, Set Previous Owner Id, if its user.</description>
        <field>PreviousOwnerUser__c</field>
        <formula>PRIORVALUE(OwnerId)</formula>
        <name>SetPreviousOwnerId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetStatusToAutoClosed</fullName>
        <description>SFDC1-5513 Set Status to Auto-Closed – No Action Taken</description>
        <field>Status</field>
        <literalValue>Auto-Closed – No Action Taken</literalValue>
        <name>Set Status To Auto Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SetStatusToInProgress</fullName>
        <description>SFDC1-5339, When the case is in status NEW and the owner is changed from a queue to an individual, the case status changes to IN PROGRESS.</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>SetStatusToInProgress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_To_Auto_Closed</fullName>
        <field>Status</field>
        <literalValue>Auto-Closed – No Action Taken</literalValue>
        <name>Set Status To Auto Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseOwner</fullName>
        <description>SFDC1-965 &amp; SFDC1-683 Update Case Owner to &quot;Data Governance&quot; queue
SFDC1-7673 remove criteria for Case record type as it has changed</description>
        <field>OwnerId</field>
        <lookupValue>DataGovernance</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseRecordType</fullName>
        <description>SFDC1-6470 update Case record type to &quot;Order Management/Delivery Help Desk&quot;</description>
        <field>RecordTypeId</field>
        <lookupValue>OrderManagementDeliveryHelpDesk</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Case Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseStatustoInProgress</fullName>
        <description>SFDC1-5258 This workflow will automatically update the status of a Data Governance&apos;s New Account case from &quot;New&quot; to &quot;In Progress&quot; once the &quot;Account Created/Associated&quot; field is populated. 
SFDC1-7673 remove criteria for Case record type as it has changed</description>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Update Case Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCurrentQueue</fullName>
        <description>SFDC1-1389, Field will be updated with the Current Queue name.</description>
        <field>CurrentQueue__c</field>
        <formula>IF(LEFT(OwnerId,3)=&apos;00G&apos;,Owner:Queue.QueueName ,&apos;&apos;)</formula>
        <name>Update Current Queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateDataGovernanceCaseRecordType</fullName>
        <description>SFDC1-7673 update Data Governance case record type to GDSA</description>
        <field>RecordTypeId</field>
        <lookupValue>GDSA</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Data Governance Case Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatePINEmailCaseOwner</fullName>
        <description>SFDC1-4145: Update the case owner</description>
        <field>OwnerId</field>
        <lookupValue>FMCTIPIN</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update PIN Email Case Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatePreviousOwner</fullName>
        <description>SFDC1-1389, Field will be updated with the Previous Queue name</description>
        <field>PreviousQueue__c</field>
        <formula>IF(NOT(ISBLANK(PRIORVALUE(CurrentQueue__c))),PRIORVALUE(CurrentQueue__c), PreviousQueue__c)</formula>
        <name>Update Previous Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeToOnboarding</fullName>
        <description>SFDC1-3665, when case owner name contains Implementation or Onboarding, update the record type to Onboarding.</description>
        <field>RecordTypeId</field>
        <lookupValue>Onboarding</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateRecordTypeToOnboarding</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateRecordTypeToSalesforceHelp</fullName>
        <description>SFDC1-5799, update case record type to Salesforce Help whenever owner sets to FM | Salesforce Helpdesk</description>
        <field>RecordTypeId</field>
        <lookupValue>SalesforceHelpdesk</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateRecordTypeToSalesforceHelp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateStatusToNew</fullName>
        <description>SFDC1-5799, when case owner sets to FM | Salesforce Helpdesk, set the status to New.</description>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>UpdateStatusToNew</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateWebChatCaseDescription</fullName>
        <description>SFDC1-3537 Update Web Chat Case Description when contact is known to &quot;Web Chat – &lt;FirstName&gt; &lt;LastName&gt; at &lt;Account Name&gt;&quot;</description>
        <field>Description</field>
        <formula>&quot;Web Chat - &quot; + Contact.FirstName + &quot; &quot; + Contact.LastName + &quot; at &quot; + Account.Name</formula>
        <name>Update Web Chat Case Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateWebChatCaseSubject</fullName>
        <description>SFDC1-3537 Update Web Chat Case Subject when contact is known to &quot;Web Chat – &lt;FirstName&gt; &lt;LastName&gt; at &lt;Account Name&gt;&quot;</description>
        <field>Subject</field>
        <formula>&quot;Web Chat - &quot; + Contact.FirstName + &quot; &quot; + Contact.LastName + &quot; at &quot; + Account.Name</formula>
        <name>Update Web Chat Case Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatingCaseOwner</fullName>
        <description>SFDC1-3608:This is a field update to ensure that any case that has been raised from &apos;prmtmapp@mtmprodappg3.mserv.local&apos; and has a subject of &apos;Errored Dealer&apos;s trades for PIMCO due to trading permissions for the day&apos; is auto-updated</description>
        <field>OwnerId</field>
        <lookupValue>FMMWCPSOnboarding</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Updating CaseOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdatingCaseRecordType</fullName>
        <description>SFDC1-3608: This is a field update to ensure that any case that has been raised from &apos;prmtmapp@mtmprodappg3.mserv.local&apos; and has a subject of &apos;Errored Dealer&apos;s trades for PIMCO due to trading permissions for the day&apos; is auto-updated</description>
        <field>RecordTypeId</field>
        <lookupValue>Onboarding</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Updating Case RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AccountAssistanceCase</fullName>
        <actions>
            <name>UpdateCaseOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateDataGovernanceCaseRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Type</field>
            <operation>equals</operation>
            <value>Data Governance</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subtype__c</field>
            <operation>equals</operation>
            <value>New,Account Maintenance,New Account</value>
        </criteriaItems>
        <description>SFDC1-965 &amp; SFDC1-683 to make reassign data governance cases to data governance queue
SFDC1-7673 changed Case record type for Data Governance cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Assign Salesforce Helpdesk Cases to associated queue</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Salesforce Helpdesk</value>
        </criteriaItems>
        <description>SFDC1-8267</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AssignCaseOwnerToDeleteQueue</fullName>
        <actions>
            <name>DeleteCaseOwnerAssignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Delete</value>
        </criteriaItems>
        <description>SFDC1:1039 - Assign case to delete queue when status is changed to Delete</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AssignCaseOwnerToDuplicateQueue</fullName>
        <actions>
            <name>DuplicateCaseOwnerAssignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Duplicate</value>
        </criteriaItems>
        <description>SFDC1:1039 - Assign case to duplicate queue when status is changed to Duplicate</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AssignCustomerCommunityCaseGoldfire</fullName>
        <actions>
            <name>AssignCustomerCommunityCaseGoldfire</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Customer Support Community.  Assigns new cases from Goldfire users to the appropriate queue.</description>
        <formula>CONTAINS($Profile.Name,&quot;Goldfire&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AssignCustomerCommunityCaseKingdom</fullName>
        <actions>
            <name>AssignCustomerCommunityCaseKingdom</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Customer Support Community.  Assigns new cases from Kingdom users to the Kingdom queue.</description>
        <formula>CONTAINS($Profile.Name,&quot;Kingdom&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>AssignDeliveryHelpdeskCase</fullName>
        <actions>
            <name>AssignDeliveryHelpdeskCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order Management/Delivery Help Desk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TeamSelect__c</field>
            <operation>equals</operation>
            <value>Delivery</value>
        </criteriaItems>
        <description>SFDC1-6470 assign Order Management/Delivery Help Desk case to &quot;CS | Delivery&quot; queue when Team Select = &quot;Delivery&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AssignOrderManagementHelpdeskCase</fullName>
        <actions>
            <name>AssignOrderManagementHelpdeskCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order Management/Delivery Help Desk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TeamSelect__c</field>
            <operation>equals</operation>
            <value>Order Management</value>
        </criteriaItems>
        <description>SFDC1-6470 assign Order Management/Delivery Help Desk case to &quot;CS | Order Management&quot; queue when Team Select = &quot;Order Management&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AssignRetailCase</fullName>
        <actions>
            <name>AssignRetailCase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Order Management/Delivery Help Desk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.TeamSelect__c</field>
            <operation>equals</operation>
            <value>Retail</value>
        </criteriaItems>
        <description>SFDC1-7096 assign Order Management/Delivery Help Desk case to &quot;CS | Retail&quot; queue when Team Select = &quot;Retail&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CaseFromLead</fullName>
        <actions>
            <name>CaseOwnerToQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5583 Owner of the Case should assigned to  FM | Customer Care Case queue when the case is created from the Lead. SFDC1-5970 Chanigng isNull to IsBlank as per the standards.
SFDC1-7609 Change rule to apply this logic only for Customer Care cases</description>
        <formula>NOT(ISBLANK( LeadReference__c)) &amp;&amp; RecordType.DeveloperName = &quot;Customer Care&quot;</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CustomerCaseColdCase</fullName>
        <active>true</active>
        <description>SFDC1-5513:When a case is assigned to queue and was not modified for more than a month then this workflow should trigger.</description>
        <formula>AND( 	RecordType.Name == &apos;Customer Care&apos;, 	LEFT(OwnerId,3) = &apos;00G&apos; , 	NOT(IsClosed), 	NOT(ISPICKVAL(AdditionalFields__r.LongTermProjectType__c ,&apos;Yes&apos;)), 	NOT(OR( 		ISPICKVAL( Subtype__c ,&apos;Bug Report&apos;), 		ISPICKVAL( Subtype__c ,&apos;Product Enhancement&apos;))))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>DoNotSurveyReasonUpdate</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>DoNotSurveyToFalse</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>SetStatusToAutoClosed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>InternalUserDoNotSurvey</fullName>
        <actions>
            <name>DoNotSurveyFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>DoNotSurveyReasonFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>contains</operation>
            <value>@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactValidation__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC-1352 When a case is closed, feedback survey should not be sent to internal users</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>MarkitWire CPS Onboarding Field Update</fullName>
        <actions>
            <name>UpdatingCaseOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdatingCaseRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>prmtmapp@mtmprodappg3.mserv.local</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>Errored Dealer&apos;s trades for PIMCO due to trading permissions for the day</value>
        </criteriaItems>
        <description>SFDC1-3608:This is a field update to ensure that any case that has been raised from &apos;prmtmapp@mtmprodappg3.mserv.local&apos; and has a subject of &apos;Errored Dealer&apos;s trades for PIMCO due to trading permissions for the day&apos; is auto-updated.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Move PIN Related Cases to Queue</fullName>
        <actions>
            <name>UpdatePINEmailCaseOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3)</booleanFilter>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
            <value>noreply@cti.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>Electronic Signature PIN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>equals</operation>
            <value>PIN de firma electronica</value>
        </criteriaItems>
        <description>SFDC1-4145: Change the PIN emails case owner</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Case Comment Email</fullName>
        <actions>
            <name>NewCaseCommentEmailNotification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SFDC1-6294
Sends an email to the Case Owner when a new case comment is created.</description>
        <formula>ISCHANGED( LatestCaseCommentDate__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenCustomerCareCaseStatusIsClosed</fullName>
        <actions>
            <name>NotifyCreatorAndContactsClosedCustomerCareCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Auto-Closed – No Action Taken</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify  contact and creator when Customer Care case status is &quot;Closed&quot;
SFDC1-9588: updated rule criteria</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenCustomerCareCaseStatusIsCreated</fullName>
        <actions>
            <name>NotifyCreatorAndContactNewCustomerCareCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify contact and creator when Customer Care case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenCustomerCareCaseStatusIsReopened</fullName>
        <actions>
            <name>NotifyCreatorAndContactsReopenedCustomerCareCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-opened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify contact and creator when Customer Care case status is &quot;Re-opened&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenOnboardingCaseIsCreated</fullName>
        <actions>
            <name>NotifyCreatorAndContactNewOnboardingCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify contact and creator when Onboarding case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenOnboardingCaseStatusIsClosed</fullName>
        <actions>
            <name>NotifyCreatorAndContactsClosedOnboardingCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Auto-Closed – No Action Taken</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify contact and creator when Onboarding case status is &quot;Closed&quot;
SFDC1-9588: updated rule criteria to avoid delete and duplicate status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenOnboardingCaseStatusIsReopened</fullName>
        <actions>
            <name>NotifyCreatorAndContactsReopenedOnboardingCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-opened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify  contact and creator when Onboarding case status is &quot;Re-opened&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenResponseManagementCaseIsCreated</fullName>
        <actions>
            <name>NotifyCreatorAndContactNewResponseManagementCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Response Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify  contact and creator when Response Management case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenResponseManagementCaseStatusIsClosed</fullName>
        <actions>
            <name>NotifyCreatorAndContactsClosedResponseManagementCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Auto-Closed – No Action Taken</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Response Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify  contact and creator when Response Management case status is &quot;Closed&quot;
SFDC1-9588: updated rule criteria to avoid delete and duplicate status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenResponseManagementCaseStatusIsReopened</fullName>
        <actions>
            <name>NotifyCreatorAndContactsReopenedResponseManagementCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-opened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Response Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-3643: Notify  contact and creator when Response Management case status is &quot;Re-opened&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenSalesforceHelpdeskCaseIsCreated</fullName>
        <actions>
            <name>NotifyCaseContactsOfNewSalesforceHelpdeskCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Salesforce Helpdesk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-9013: Notify contact and creator when Salesforce Helpdesk case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NotifyWhenSalesforceHelpdeskCaseStatusIsClosed</fullName>
        <actions>
            <name>NotifyCaseContactsOfClosedSalesforceHelpdeskCase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) AND 3 AND 4 AND 5 AND 6 AND 7 AND 8</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed - Canceled,Closed - Referral,Closed - Resolved,Closed - Resolved by 3rd Party,Closed - Resolved by Customer,Closed - Resolved by IHS Markit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Salesforce Helpdesk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@markit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>support@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihs.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.ContactEmail</field>
            <operation>notEqual</operation>
            <value>customercare@ihsmarkit.com</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-9013: Notify contact and creator when Salesforce Helpdesk case status is &quot;Closed&quot;
SFDC1-9588: Updated criteria</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RunCustomAssignmentRule</fullName>
        <actions>
            <name>RunCustomCaseAssignmentLogic</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-7574 When the standard case assignment rule assigns case to &apos;To Be Assigned&apos; queue, this workflow checks the custom checkbox field on case and executes the custom code.</description>
        <formula>CONTAINS (OwnerId ,$Label.ToBeAssignedQueueId )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SFDC Helpdesk Case Assignment</fullName>
        <actions>
            <name>SFDCHelpdeskCaseAssignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>SFDC Helpdesk</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <description>SFDC1-7866.
Because the Case assignment rule does not run off of quick actions a workflow rule will assign the newly created case to the SFDC Helpdesk queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales support - Email notification on Create</fullName>
        <actions>
            <name>Notificationforasalespersonwhenemailinquiryisturnedintoacase</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Internal</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Operations</value>
        </criteriaItems>
        <description>SFDC1-6027:  A sales person to be notified when my email inquiry is turned into a case. SFDC1-9677: Changing record type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales support - Email notification on resolution</fullName>
        <actions>
            <name>NotifyasalespersonwhencasestatusisClosedORResolved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Operations</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>contains</operation>
            <value>Closed</value>
        </criteriaItems>
        <description>SFDC1-6028: A sales person to be notified when a case is closed. SFDC1-9677. Renaming record type</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Salesforce Helpdesk Case Assignment</fullName>
        <actions>
            <name>CaseOwnerUpdateToSalesforceHelpdesk</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Salesforce Helpdesk</value>
        </criteriaItems>
        <description>SFDC1-8267
Assigns cases created from the global action to the Salesforce Helpdesk queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SalesforceSuggestioncases</fullName>
        <actions>
            <name>SalesforceSuggestionQueueUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Salesforce - Suggestion</value>
        </criteriaItems>
        <description>SFDC1-8978; cases need to go in Salesforce Suggestion queue by global action button</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SetStatusFromNewToInProgress</fullName>
        <actions>
            <name>SetStatusToInProgress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5339, When the case is in status NEW and the owner is changed from a queue to an individual, the case status changes to IN PROGRESS.</description>
        <formula>AND( ISCHANGED(OwnerId), LEFT(PRIORVALUE(OwnerId), 3) = &apos;00G&apos;, LEFT(OwnerId, 3) = &apos;005&apos;, TEXT(Status) = &apos;New&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>StorePreviousOwnerField</fullName>
        <actions>
            <name>SetPreviousOwnerId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5934, To store the value of Previous OwnerId if its user.</description>
        <formula>AND( ISCHANGED(OwnerId), LEFT(PRIORVALUE(OwnerId), 3) = &apos;005&apos; )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateCasePriorityForOutageAndLoginIssues</fullName>
        <actions>
            <name>SetCasePrioritytoHigh</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND (4 OR 5 OR 6 OR 7 OR 8)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>DeleteQueue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>DuplicateQueue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Outage</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Password Reset</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Login not Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Locked Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Login Issue</value>
        </criteriaItems>
        <description>SFDC1-1378: When a case is generated with subject containing, Outage/Password/Login then change the case priority.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UpdateCaseWhenOwnerSetsToSalesforceHelpdesk</fullName>
        <actions>
            <name>UpdateRecordTypeToSalesforceHelp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateStatusToNew</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | Salesforce Helpdesk</value>
        </criteriaItems>
        <description>SFDC1-5799, set the Record Type to Salesforce Help and status to New whenever owner is Salesforce Helpdesk queue.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateCurrentQueueAndPreviousQueueFields</fullName>
        <actions>
            <name>UpdateCurrentQueue</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdatePreviousOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-1389, This rule is to update two fields on case and hence we can track the previous queue owner on case record</description>
        <formula>OR(ISNEW(),  AND (ISCHANGED(OwnerId), RecordType.Name = &apos;Customer Care&apos; ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateDataGovernanceCaseStatuswhenAccountAssociated</fullName>
        <actions>
            <name>UpdateCaseStatustoInProgress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-5258 This workflow will automatically update the status of a Data Governance&apos;s New Account case from &quot;New&quot; to &quot;In Progress&quot; once the &quot;Account Created/Associated&quot; field is populated.
SFDC1-7673 update logic for Case record type change</description>
        <formula>AND( ISPICKVAL(Type,&apos;Data Governance&apos;), ISPICKVAL(Subtype__c, &apos;New Account&apos;), NOT(ISBLANK(AccountCreated__c)) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UpdateOrderManagementDeliveryHelpdeskCaseRecordType</fullName>
        <actions>
            <name>UpdateCaseRecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-6470 update case&apos;s record type to Order Management/Delivery Help Desk when Customer Care Initiate is true, and Team Select is &quot;Order Management&quot; or &quot;Delivery&quot;</description>
        <formula>CustomerCareInitiated__c = TRUE &amp;&amp; ( ISPICKVAL(TeamSelect__c, &apos;Order Management&apos;) || ISPICKVAL(TeamSelect__c, &apos;Delivery&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>UpdateRecordTypeToOnboarding</fullName>
        <actions>
            <name>UpdateRecordTypeToOnboarding</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8 OR 9</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | Data Delivery | Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | DS Match | Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | FRTB Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | KYCS | Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | MarkitSERV | MTM Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | MSERV FX | Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | MSERV FX | Onboarding | TradeSTP</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | MSERV MTM PR Implementation</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>FM | MW | CPS Onboarding</value>
        </criteriaItems>
        <description>SFDC1-7520 : Update record type value when case owners equals given queue</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UpdateWebChatCaseSubjectandDescription</fullName>
        <actions>
            <name>UpdateWebChatCaseDescription</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateWebChatCaseSubject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1-3537 Update Web Chat Case Subject and Description when contact is known to &quot;Web Chat – &lt;FirstName&gt; &lt;LastName&gt; at &lt;Account Name&gt;&quot;</description>
        <formula>(TEXT(Origin) = &apos;Web Chat&apos;) &amp;&amp;  (RecordType.DeveloperName = &apos;CustomerCare&apos;) &amp;&amp;  (Contact.Id &lt;&gt; null)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WhenCustomerCareCaseStatusIsClosed</fullName>
        <actions>
            <name>NotifyContactsClosedCustomerCareCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed - Canceled,Closed - Referral,Closed - Resolved,Closed - Resolved by 3rd Party,Closed - Resolved by Customer,Closed - Resolved by IHS Markit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Web Chat</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Customer Care case status is &quot;Closed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WhenCustomerCareCaseStatusIsNewOrInProgress</fullName>
        <actions>
            <name>NotifyContactsNewInProgressCustomerCareCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>notEqual</operation>
            <value>Web Chat</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: When Customer Care case status is &quot;New&quot; or &quot;In Progress&quot;, send email alerts</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WhenCustomerCareCaseStatusIsReopened</fullName>
        <actions>
            <name>NotifyContactsReopenedCustomerCareCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-opened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Customer Care case status is &quot;Re-opened&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WhenOnboardingCaseStatusIsClosed</fullName>
        <actions>
            <name>NotifyContactsClosedOnboardingCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed - Canceled,Closed - Referral,Closed - Resolved,Closed - Resolved by 3rd Party,Closed - Resolved by Customer,Closed - Resolved by IHS Markit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Onboarding case status is &quot;Closed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WhenOnboardingCaseStatusIsNewOrInProgress</fullName>
        <actions>
            <name>NotifyContactsNewInProgressOnboardingCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Onboarding case status is &quot;New&quot; or &quot;In Progress&quot;, send email alerts</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WhenOnboardingCaseStatusIsReopened</fullName>
        <actions>
            <name>NotifyContactsReopenedOnboardingCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-opened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Onboarding</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Onboarding case status is &quot;Re-opened&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WhenResponseManagementCaseStatusIsClosed</fullName>
        <actions>
            <name>NotifyContactsClosedResponseManagementCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed - Canceled,Closed - Referral,Closed - Resolved,Closed - Resolved by 3rd Party,Closed - Resolved by Customer,Closed - Resolved by IHS Markit</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Response Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Response Management case status is &quot;Closed&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WhenResponseManagementCaseStatusIsNewOrInProgress</fullName>
        <actions>
            <name>NotifyContactsNewInProgressResponseManagementCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>In Progress,New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Response Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Response Management case status is &quot;New&quot; or &quot;In Progress&quot;, send email alerts</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>WhenResponseManagementCaseStatusIsReopened</fullName>
        <actions>
            <name>NotifyContactsReopenedResponseManagementCase</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Re-opened</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Response Management</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.DoNotNotify__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>SFDC1-6897: Notify contacts when Response Management case status is &quot;Re-opened&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
