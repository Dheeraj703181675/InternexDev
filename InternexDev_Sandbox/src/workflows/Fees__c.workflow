<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Fees_Transaction_Date_Update</fullName>
        <field>Business_Transaction_Date__c</field>
        <formula>$Setup.BusinessTransactionDate__c.Business_Transaction_Date__c</formula>
        <name>Fees Transaction Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Fee_Balance</fullName>
        <field>Fee_Balance__c</field>
        <formula>Fee_Amount__c</formula>
        <name>Update the Fee Balance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Fees Transaction Date Update</fullName>
        <actions>
            <name>Fees_Transaction_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL($Setup.BusinessTransactionDate__c.Business_Transaction_Date__c))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update the Fee Balance</fullName>
        <actions>
            <name>Update_the_Fee_Balance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Fees__c.Fee_Amount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
