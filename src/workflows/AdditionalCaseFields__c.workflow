<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CaseResponsibleNotificationNew</fullName>
        <description>An email should be sent to the ’case responsible’ user when a Case is created and a user is selected. SFDC1-8278: Changing recipient to new Field</description>
        <protected>false</protected>
        <recipients>
            <field>CaseResponsibleNew__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/CaseResponsibleNotificationforNewandTransfer</template>
    </alerts>
    <alerts>
        <fullName>EmailAlertCaseResponsibleNotificationTransfer</fullName>
        <description>SFDC1-6591: An email should be sent to the ’case responsible’ user when the ‘case responsible’ user has changed. SFDC1-8278: Changing receipient to new Field</description>
        <protected>false</protected>
        <recipients>
            <field>CaseResponsibleNew__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/CaseResponsibleNotificationforNewandTransfer</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedAPPNA</fullName>
        <ccEmails>aftmk00@ihs.com</ccEmails>
        <description>Team Responsible Assigned APPNA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedASPNA</fullName>
        <ccEmails>suppa00@ihs.com</ccEmails>
        <description>Team Responsible Assigned ASPNA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedATPNA</fullName>
        <ccEmails>autosalessupport@ihsmarkit.com</ccEmails>
        <description>Team Responsible Assigned ATPNA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedCAN</fullName>
        <ccEmails>canap00@ihs.com</ccEmails>
        <description>Team Responsible Assigned CAN</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedCPPNA</fullName>
        <ccEmails>cappr00@ihs.com</ccEmails>
        <description>Team Responsible Assigned CPPNA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedDATA</fullName>
        <ccEmails>product_helpdesk@ihs.com</ccEmails>
        <description>Team Responsible Assigned DATA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedDBA</fullName>
        <ccEmails>Polk-USDBASupport@ihs.com</ccEmails>
        <description>Team Responsible Assigned DBA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedDF</fullName>
        <ccEmails>prsma00@ihs.com</ccEmails>
        <description>Team Responsible Assigned DF</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedDPNA</fullName>
        <ccEmails>devna00@ihs.com</ccEmails>
        <description>Team Responsible Assigned DPNA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedEU</fullName>
        <ccEmails>automotive_support@ihsmarkit.com</ccEmails>
        <description>Team Responsible Assigned EU</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedGE</fullName>
        <ccEmails>support-IMR@ihsmarkit.com</ccEmails>
        <description>Team Responsible Assigned GE</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedGPHD</fullName>
        <ccEmails>product_helpdesk@ihs.com</ccEmails>
        <description>Team Responsible Assigned GPHD</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedNAPL</fullName>
        <ccEmails>loyal00@ihs.com</ccEmails>
        <description>Team Responsible Assigned NAPL</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedNAPM</fullName>
        <ccEmails>product_helpdesk@ihs.com</ccEmails>
        <description>Team Responsible Assigned NAPM</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedNAPMR</fullName>
        <ccEmails>oemst01@ihs.com</ccEmails>
        <description>Team Responsible Assigned NAPMR</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedNAPV</fullName>
        <ccEmails>swspr00@ihs.com</ccEmails>
        <description>Team Responsible Assigned NAPV</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>TeamResponsibleAssignedNAPVA</fullName>
        <ccEmails>tableau.automotive@ihs.com</ccEmails>
        <description>Team Responsible Assigned NAPVA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/TeamResponsibleAssigned</template>
    </alerts>
    <alerts>
        <fullName>UsedtoAlertPRSwhenPicklistvalueisaddedOrcreated</fullName>
        <description>SFDC1-6588 : Used to alert ‘PRS’ when picklist value is added or created</description>
        <protected>false</protected>
        <recipients>
            <recipient>PolkPRS</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CSPolk/ProductReleaseSpecialistEmailPRS</template>
    </alerts>
    <fieldUpdates>
        <fullName>RemoveProductVersion</fullName>
        <description>SFDC1-6721: Remove Product Version when Delivery Mechanism is File, Adapter, API, Web and record type is Legacy Distribution</description>
        <field>ProductVersion__c</field>
        <name>Remove Product Version</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseWithACFLastModifiedDate</fullName>
        <description>SFDC1-5513: When additional Case field is modified and is satisfying certain conditions, then update Last ACF Modified Date with current time.</description>
        <field>LastACFModifiedDate__c</field>
        <formula>NOW()</formula>
        <name>Update Case With ACF Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateEnvironment</fullName>
        <description>SFDC1-3444: Update Environment to Production as default value</description>
        <field>Environment__c</field>
        <literalValue>Production</literalValue>
        <name>UpdateEnvironment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Case Responsible Notification New</fullName>
        <actions>
            <name>CaseResponsibleNotificationNew</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SFDC1-6589: Case Responsible Notification New. SFDC1-8278: Changing to point to new Field</description>
        <formula>NOT ( ISNULL( CaseResponsibleNew__c ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CaseResponsibleNotificationTransfer</fullName>
        <actions>
            <name>EmailAlertCaseResponsibleNotificationTransfer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>SFDC1-6591: Used to notify an individual that they have been assigned responsibility for a case. SFDC1-8278: Changing to point to new Field</description>
        <formula>CaseResponsibleNew__c &lt;&gt; PRIORVALUE(CaseResponsibleNew__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CustomerCaseColdCaseACFChange</fullName>
        <actions>
            <name>UpdateCaseWithACFLastModifiedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SFDC1:5513- When ACF and case satisfies a certain criteria and any field in the ACF gets changed, then Last modified date in case should be updated. So, that time based WF will be updated.</description>
        <formula>AND( Case__r.RecordType.Name == &apos;Customer Care&apos;, LEFT( Case__r.OwnerId,3) = &apos;00G&apos; , NOT(Case__r.IsClosed), NOT(ISPICKVAL(LongTermProjectType__c ,&apos;Yes&apos;)), NOT(OR( ISPICKVAL( Case__r.Subtype__c ,&apos;Bug Report&apos;), ISPICKVAL( Case__r.Subtype__c ,&apos;Product Enhancement&apos;))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>DefaultEnvironmentValue</fullName>
        <actions>
            <name>UpdateEnvironment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AdditionalCaseFields__c.Environment__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>SFDC1-3444: Set default value of Environment field to Production</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>ProductReleaseSpecialistEmail</fullName>
        <actions>
            <name>UsedtoAlertPRSwhenPicklistvalueisaddedOrcreated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AdditionalCaseFields__c.ProductReleaseSpecialist__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>SFDC1-6588 : Used to alert ‘PRS’ when picklist value is added or created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>RemoveProductVersionForFewDeliveryMechanism</fullName>
        <actions>
            <name>RemoveProductVersion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AdditionalCaseFields__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>Legacy Distribution</value>
        </criteriaItems>
        <criteriaItems>
            <field>AdditionalCaseFields__c.DeliveryMechanism__c</field>
            <operation>contains</operation>
            <value>Adaptors,API,File,Web</value>
        </criteriaItems>
        <description>SFDC1-6721:Product Version should not appear for some Delivery Mechanisms in Legacy Distribution</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
