<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NotifyCampaignOwnerForDeactivationCampaignAfter60DaysOfEndDate</fullName>
        <description>SFDC1-6635;Notify Campaign Owner For Deactivation Campaign 7 days before end date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DeactivateCampaignsNotificationHTML</template>
    </alerts>
    <alerts>
        <fullName>NotifyCampaignOwnerForDeactivationCampaignbefore7daysOfEndDate</fullName>
        <description>SFDC1-6635;Notify Campaign Owner For Deactivation Campaign before 7 days Of End Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DeactivateCampaignsNotification</template>
    </alerts>
    <alerts>
        <fullName>otifyCampaignOwnerForDeactivationCampaignAfter60DaysOfEndDate</fullName>
        <description>SFDC1-6635;Notify Campaign Owner For Deactivation Campaign After 60 Days Of End Date</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/DeactivateCampaignsNotificationHTML</template>
    </alerts>
    <fieldUpdates>
        <fullName>CampaignActiveCheckBoxUpdate</fullName>
        <description>Active field should default to &quot;Yes&quot;/ the box should be checked</description>
        <field>IsActive</field>
        <literalValue>1</literalValue>
        <name>CampaignActiveCheckBoxUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CampaignTypeSalesLedUpdate</fullName>
        <description>SFDC1 -63; &quot;Type&quot; field is updated with Sales Led (Not Marketing Related) when Campaign record type selected as Sales campaign
SFDC1 - 1952;  &quot;Type&quot; field is updated with Sales Led when Campaign record type selected as Sales campaign</description>
        <field>Type</field>
        <literalValue>Sales Led</literalValue>
        <name>CampaignTypeSalesLedUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UncheckActiveBox</fullName>
        <description>SFDC1-6635;Deactivate Campaigns 60 Days After the End Date and Notify Campaign Owner</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Uncheck Active box Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UncheckActiveboxCampaign</fullName>
        <description>SFDC1-6635;Deactivate Campaigns 60 Days After the End Date and Notify Campaign Owner</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Uncheck Active box Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UncheckActiveboxOfCampaign</fullName>
        <description>SFDC1-6635;Deactivate Campaigns 60 Days After the End Date and Notify Campaign Owner</description>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Uncheck Active box Of Campaign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CampaignActiveCheckBoxTrue</fullName>
        <actions>
            <name>CampaignActiveCheckBoxUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Marketing Campaign,Sales Campaign</value>
        </criteriaItems>
        <description>SFDC1- 63 ; Active field should default to &quot;Yes&quot;/ the box should be checked</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CampaignRecordtypeUpdate</fullName>
        <actions>
            <name>CampaignTypeSalesLedUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Campaign.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Campaign</value>
        </criteriaItems>
        <description>SFDC1 - 63 ;When the Sales Campaign is created - the Type should default to &quot;Sales Led(Not Marketing Related)
SFDC1 - 1952; Change the Campaign Type to &apos;Sales Led&apos; for a Sales Campaign</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>DeactivateCampaigns60DaysAfterEndDate</fullName>
        <active>true</active>
        <description>SFDC1-6635;Deactivate Campaigns 60 Days After the End Date and Notify Campaign Owner</description>
        <formula>NOT(ISNULL(EndDate))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NotifyCampaignOwnerForDeactivationCampaignAfter60DaysOfEndDate</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>-7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>UncheckActiveBox</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>DeactivateCampaigns60DaysAftertheEndDate</fullName>
        <actions>
            <name>UncheckActiveBox</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>SFDC1-6635;Deactivate Campaigns 60 Days After the End Date and Notify Campaign Owner</description>
        <formula>( TODAY()- EndDate  ) &gt; 60</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>NotifyCampaignOwnerForDeactivationCampaignAfter60DaysOfEndDate</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Campaign.EndDate</offsetFromField>
            <timeLength>52</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
