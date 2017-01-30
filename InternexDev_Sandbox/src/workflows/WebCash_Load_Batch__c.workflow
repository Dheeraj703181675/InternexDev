<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_for_New_Invoice_Batch_Uploaded_in_Akritiv</fullName>
        <description>Email Alert for New Invoice Batch Uploaded in Akritiv</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Akritiv_Internex/Pending_Invoices</template>
    </alerts>
    <rules>
        <fullName>New Inoice Batch Uploaded</fullName>
        <actions>
            <name>Email_Alert_for_New_Invoice_Batch_Uploaded_in_Akritiv</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Invoice_Batch_Uploaded_in_Akritiv</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WebCash_Load_Batch__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>New_Invoice_Batch_Uploaded_in_Akritiv</fullName>
        <assignedTo>Account_Manager</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Invoice Batch Uploaded in Akritiv</subject>
    </tasks>
</Workflow>
