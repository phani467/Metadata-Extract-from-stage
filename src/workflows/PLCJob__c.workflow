<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>NegotiatedDateChange</fullName>
        <description>Negotiated Date Change</description>
        <protected>false</protected>
        <recipients>
            <field>PrimarySalesEmail__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SecondarySalesEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRFPLCTemplates/PLCNegotiatedDateChange</template>
    </alerts>
    <alerts>
        <fullName>NewPLCjob</fullName>
        <description>New PLC job</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRFPLCTemplates/NewPLCJob</template>
    </alerts>
    <alerts>
        <fullName>PLCJobCancelled</fullName>
        <description>PLC Job Cancelled</description>
        <protected>false</protected>
        <recipients>
            <field>PrimarySalesEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRFPLCTemplates/JobStatusCancelled</template>
    </alerts>
    <alerts>
        <fullName>PLCJobDelivered</fullName>
        <description>PLC Job Delivered</description>
        <protected>false</protected>
        <recipients>
            <field>PrimarySalesEmail__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WRFPLCTemplates/JobStatusDelivered</template>
    </alerts>
    <fieldUpdates>
        <fullName>Hold1</fullName>
        <field>DateOnHold1__c</field>
        <formula>TODAY()</formula>
        <name>Hold #1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hold2</fullName>
        <field>DateOnHold2__c</field>
        <formula>today()</formula>
        <name>Hold  #2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hold3</fullName>
        <field>DateOnHold3__c</field>
        <formula>today()</formula>
        <name>Hold #3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hold4</fullName>
        <field>DateOnHold4__c</field>
        <formula>today()</formula>
        <name>Hold #4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Hold5</fullName>
        <field>DateOnHold5__c</field>
        <formula>today()</formula>
        <name>Hold  #5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLCPrimarySales</fullName>
        <description>Updates Primary Sales Email field for Emailing Purposes</description>
        <field>PrimarySalesEmail__c</field>
        <formula>WorkRequestForm__r.PrimarySalesContact__r.Email</formula>
        <name>PLC Primary Sales Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLCSecondarySalesEmail</fullName>
        <field>SecondarySalesEmail__c</field>
        <formula>WorkRequestForm__r.SecondarySalesContact__r.Email</formula>
        <name>PLC Secondary Sales Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PLCSetCostFactor</fullName>
        <description>Sets cost factor whenever a PLC Job is created</description>
        <field>CostFactor__c</field>
        <formula>66</formula>
        <name>PLC Set Cost Factor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ProgrammerAssignedDate</fullName>
        <field>ProgrammerAssignedDate__c</field>
        <formula>Today()</formula>
        <name>Programmer Assigned Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release1</fullName>
        <field>DateReleasedFromHold1__c</field>
        <formula>TODAY()</formula>
        <name>Release #1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release2</fullName>
        <field>DateReleasedFromHold2__c</field>
        <formula>today()</formula>
        <name>Release #2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release3</fullName>
        <field>DateReleasedFromHold3__c</field>
        <formula>today()</formula>
        <name>Release #3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release4</fullName>
        <field>DateReleasedFromHold4__c</field>
        <formula>today()</formula>
        <name>Release  #4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Release5</fullName>
        <field>DateReleasedFromHold5__c</field>
        <formula>today()</formula>
        <name>Release #5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Alert when PLC Negotiated Date Changes</fullName>
        <actions>
            <name>NegotiatedDateChange</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Used to alert the Primary &amp; Secondary sales when a PLC Negotiated Date changes.</description>
        <formula>NegotiatedDate__c&lt;&gt; PRIORVALUE(NegotiatedDate__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDate1Empty</fullName>
        <actions>
            <name>Hold1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( JobStatusOverride__c , &quot;Job on Hold&quot;) &amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;ISNULL( DateOnHold1__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDate2Empty</fullName>
        <actions>
            <name>Hold2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( JobStatusOverride__c , &quot;Job on Hold&quot;) &amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;not(ISNULL( DateOnHold1__c ))&amp;&amp;ISNULL( DateOnHold2__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDate3Empty</fullName>
        <actions>
            <name>Hold3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( JobStatusOverride__c , &quot;Job on Hold&quot;) &amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;not(ISNULL( DateOnHold1__c ))&amp;&amp;not(ISNULL( DateOnHold2__c ))&amp;&amp;ISNULL( DateOnHold3__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDate4Empty</fullName>
        <actions>
            <name>Hold4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( JobStatusOverride__c , &quot;Job on Hold&quot;) &amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;not(ISNULL( DateOnHold1__c ))&amp;&amp;not(ISNULL( DateOnHold2__c ))&amp;&amp;not(ISNULL( DateOnHold3__c ))&amp;&amp;ISNULL( DateOnHold4__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDate5Empty</fullName>
        <actions>
            <name>Hold5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISPICKVAL( JobStatusOverride__c , &quot;Job on Hold&quot;) &amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;not(ISNULL( DateOnHold1__c ))&amp;&amp;not(ISNULL( DateOnHold2__c ))&amp;&amp;not(ISNULL( DateOnHold3__c ))&amp;&amp;not(ISNULL( DateOnHold4__c ))&amp;&amp;ISNULL( DateOnHold5__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDateReleasedFromHold1Empty</fullName>
        <actions>
            <name>Release1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT (ISPICKVAL( JobStatusOverride__c , &quot;Job On Hold&quot;) )&amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;  NOT (ISNULL( DateOnHold1__c))&amp;&amp;  ISNULL( DateReleasedFromHold1__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDateReleasedFromHold2Empty</fullName>
        <actions>
            <name>Release2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT (ISPICKVAL( JobStatusOverride__c , &quot;Job On Hold&quot;) )&amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;  NOT (ISNULL( DateOnHold1__c))&amp;&amp;  NOT (ISNULL( DateOnHold2__c))&amp;&amp;  not(ISNULL( DateReleasedFromHold1__c))&amp;&amp;  ISNULL( DateReleasedFromHold2__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDateReleasedFromHold3Empty</fullName>
        <actions>
            <name>Release3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT (ISPICKVAL( JobStatusOverride__c , &quot;Job On Hold&quot;) )&amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;  NOT (ISNULL( DateOnHold1__c))&amp;&amp;  NOT (ISNULL( DateOnHold2__c))&amp;&amp;  NOT (ISNULL( DateOnHold3__c))&amp;&amp;  not(ISNULL( DateReleasedFromHold1__c))&amp;&amp;  not(ISNULL( DateReleasedFromHold2__c))&amp;&amp;  ISNULL( DateReleasedFromHold3__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDateReleasedFromHold4Empty</fullName>
        <actions>
            <name>Release4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT (ISPICKVAL( JobStatusOverride__c , &quot;Job On Hold&quot;) )&amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp;  NOT (ISNULL( DateOnHold1__c))&amp;&amp;  NOT (ISNULL( DateOnHold2__c))&amp;&amp;  NOT (ISNULL( DateOnHold3__c))&amp;&amp;  NOT (ISNULL( DateOnHold4__c))&amp;&amp;  not(ISNULL( DateReleasedFromHold1__c))&amp;&amp;  not(ISNULL( DateReleasedFromHold2__c))&amp;&amp;  not(ISNULL( DateReleasedFromHold3__c))&amp;&amp;  ISNULL( DateReleasedFromHold4__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobOnHoldOverrideDateReleasedFromHold5Empty</fullName>
        <actions>
            <name>Release5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT (ISPICKVAL( JobStatusOverride__c , &quot;Job On Hold&quot;) )&amp;&amp; ISCHANGED(JobStatusOverride__c )&amp;&amp; NOT (ISNULL( DateOnHold1__c))&amp;&amp; NOT (ISNULL( DateOnHold2__c))&amp;&amp;  NOT (ISNULL( DateOnHold3__c))&amp;&amp; NOT (ISNULL( DateOnHold4__c))&amp;&amp;  NOT (ISNULL( DateOnHold5__c))&amp;&amp; not(ISNULL( DateReleasedFromHold1__c))&amp;&amp; not(ISNULL( DateReleasedFromHold2__c))&amp;&amp; not(ISNULL( DateReleasedFromHold3__c))&amp;&amp; not(ISNULL( DateReleasedFromHold4__c))&amp;&amp;   ISNULL( DateReleasedFromHold5__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobStatusIsCancelled</fullName>
        <actions>
            <name>PLCJobCancelled</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PLCPrimarySales</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PLCSecondarySalesEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to alert the Primary &amp; Secondary sales when a PLC Job is cancelled.</description>
        <formula>JobStatus__c  &lt;&gt; PRIORVALUE(JobStatus__c )&amp;&amp; JobStatus__c = &quot;Job Cancelled&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>JobStatusIsDelivered</fullName>
        <actions>
            <name>PLCJobDelivered</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PLCPrimarySales</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PLCSecondarySalesEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Used to alert the Primary &amp; Secondary sales when a PLC Job is delivered.</description>
        <formula>JobStatus__c  &lt;&gt; PRIORVALUE(JobStatus__c )&amp;&amp; JobStatus__c = &quot;Phase 6 - Delivered&quot;</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OwnerDoesNotContainQueue</fullName>
        <actions>
            <name>ProgrammerAssignedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PLCJob__c.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PLCJobIsCreated</fullName>
        <actions>
            <name>NewPLCjob</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PLCPrimarySales</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PLCSecondarySalesEmail</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PLCSetCostFactor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets cost factor, primary sales email, and secondary sales email upon creation of a job.</description>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
