<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Populate_Load_key_field</fullName>
        <field>Load_key__c</field>
        <formula>Company_Name__c &amp; Check_Number__c  &amp;  Invoice_Number__c &amp; TEXT(Invoice_Amount__c )</formula>
        <name>Populate Load key field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Populate Load key field</fullName>
        <actions>
            <name>Populate_Load_key_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>LoadWebCash__c.Batch_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Populate Load key field which will be the unique identifier for each record in bank file</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
