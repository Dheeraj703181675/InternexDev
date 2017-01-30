<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_alert_for_New_Customer_to_be_Verified_from_Portal</fullName>
        <description>Email alert for New Customer to be Verified (from Portal)</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Akritiv_Internex/Debtor_Pending_Verification</template>
    </alerts>
    <alerts>
        <fullName>Email_alert_for_Pending_Invoices_for_Debtor</fullName>
        <description>Email alert for Pending Invoices for Debtor</description>
        <protected>false</protected>
        <recipients>
            <recipient>Account_Manager</recipient>
            <type>role</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Akritiv_Internex/Pending_Invoices_for_Debtor</template>
    </alerts>
    <fieldUpdates>
        <fullName>Client_Product_Debtor_Unique</fullName>
        <field>Client_Product_Counterparty_Uniqueness__c</field>
        <formula>Client_Product_Counterparty__c</formula>
        <name>Client Product Debtor Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Client Product Debtor Unique</fullName>
        <actions>
            <name>Client_Product_Debtor_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL(Client_Account__c))&amp;&amp;NOT(ISNULL(Counterparty__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Customer to be Verified %28from Portal%29</fullName>
        <actions>
            <name>Email_alert_for_New_Customer_to_be_Verified_from_Portal</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>New_Customer_Identified</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>OR(And(ISNEW(),ISPICKVAL( Debtor_Status__c , &quot;Pending Verification&quot;)),And(Not(ISPICKVAL(PRIORVALUE(Debtor_Status__c),&quot;Pending Verification&quot;)),ISPICKVAL( Debtor_Status__c , &quot;Pending Verification&quot;) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pending Invoices</fullName>
        <actions>
            <name>Email_alert_for_Pending_Invoices_for_Debtor</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Pending_Invoices</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <formula>And(ISPICKVAL(PRIORVALUE(Debtor_Status__c),&quot;Pending&quot;), OR(ISPICKVAL( Debtor_Status__c , &quot;Eligible&quot;),ISPICKVAL( Debtor_Status__c , &quot;Ineligible&quot;)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>New_Customer_Identified</fullName>
        <assignedTo>Account_Manager</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>New Customer Identified</subject>
    </tasks>
    <tasks>
        <fullName>Pending_Invoices</fullName>
        <assignedTo>Account_Manager</assignedTo>
        <assignedToType>role</assignedToType>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Pending Invoices</subject>
    </tasks>
</Workflow>
