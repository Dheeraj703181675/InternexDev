<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_for_Funding_Request_Verification</fullName>
        <description>Email Alert for Funding Request Verification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Akritiv_Internex/Funding_Request_verification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Checkbox_Workflow_Fired</fullName>
        <field>Workflow_Fired__c</field>
        <literalValue>1</literalValue>
        <name>Update Checkbox Workflow Fired?</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Funding Request is fully funded</fullName>
        <actions>
            <name>Update_Checkbox_Workflow_Fired</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Funding_Request_is_Fully_Funded</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Fully Funded</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Workflow_Fired__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Funding Request verification</fullName>
        <actions>
            <name>Email_Alert_for_Funding_Request_Verification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Funding_Request_Verification</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.CaseNumber</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Funding_Request_Verification</fullName>
        <assignedTo>Account_Manager</assignedTo>
        <assignedToType>role</assignedToType>
        <description>Client made a valid Draw Request. Please verify it.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Funding Request Verification</subject>
    </tasks>
    <tasks>
        <fullName>Funding_Request_is_Fully_Funded</fullName>
        <assignedTo>CEO</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Funding Request is Fully Funded</subject>
    </tasks>
</Workflow>
