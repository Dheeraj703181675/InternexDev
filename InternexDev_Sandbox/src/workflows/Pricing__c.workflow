<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Date_Rate_Unique_Combination</fullName>
        <field>Date_Index_Uniqueness__c</field>
        <formula>Date_Index__c</formula>
        <name>Date Rate Unique Combination</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Pricing_Transaction_Date_Update</fullName>
        <field>Business_Transaction_Date__c</field>
        <formula>$Setup.BusinessTransactionDate__c.Business_Transaction_Date__c</formula>
        <name>Pricing Transaction Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Date Rate Unique Combination</fullName>
        <actions>
            <name>Date_Rate_Unique_Combination</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Pricing__c.Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Pricing__c.Index__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Pricing Transaction Date Update</fullName>
        <actions>
            <name>Pricing_Transaction_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISNULL($Setup.BusinessTransactionDate__c.Business_Transaction_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
