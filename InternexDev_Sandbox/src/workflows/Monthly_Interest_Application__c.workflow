<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Monthly_Interest_Transaction_Date_Update</fullName>
        <field>Business_Transaction_Date__c</field>
        <formula>$Setup.BusinessTransactionDate__c.Business_Transaction_Date__c</formula>
        <name>Monthly Interest Transaction Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Month</fullName>
        <field>Month1__c</field>
        <formula>Month__c</formula>
        <name>Update Month</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Year</fullName>
        <field>Year1__c</field>
        <formula>Year__c</formula>
        <name>Update Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Monthly Interest App Transaction Date Update</fullName>
        <actions>
            <name>Monthly_Interest_Transaction_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL( $Setup.BusinessTransactionDate__c.Business_Transaction_Date__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Month and Date</fullName>
        <actions>
            <name>Update_Month</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Monthly_Interest_Application__c.Month__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Monthly_Interest_Application__c.Year__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
