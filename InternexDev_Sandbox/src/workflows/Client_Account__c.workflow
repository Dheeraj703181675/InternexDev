<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Client_Account_Unique</fullName>
        <field>Client_Account_Uniqueness_check__c</field>
        <formula>Client_Account__c</formula>
        <name>Client Account Unique</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FIU_Update_for_History_Tracking</fullName>
        <field>FIU_for_History_Tracking__c</field>
        <formula>FIU_Outstanding__c</formula>
        <name>FIU Update for History Tracking</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Interest_Initiation_Date_Update</fullName>
        <field>Interest_Initiation_Date__c</field>
        <formula>Actual_Interest_Initiation_Date__c</formula>
        <name>Interest Initiation Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prior_Value_of_FIU</fullName>
        <field>Prior_value_of_FIU__c</field>
        <formula>PRIORVALUE(FIU_Outstanding__c)</formula>
        <name>Prior Value of FIU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Client_Status</fullName>
        <field>Status__c</field>
        <literalValue>Delinquent</literalValue>
        <name>Update the Client Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_Client_Status_to_Current</fullName>
        <field>Status__c</field>
        <literalValue>Current</literalValue>
        <name>Update the Client Status to Current</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Client__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Client Account Unique</fullName>
        <actions>
            <name>Client_Account_Unique</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISNULL(Client__c))&amp;&amp;NOT(ISNULL(Product__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FIU History Tracking</fullName>
        <actions>
            <name>FIU_Update_for_History_Tracking</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Prior_Value_of_FIU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISCHANGED(Actual_IUF_Amount__c),ISCHANGED( Sum_of_Payments__c ),ISCHANGED( Sum_of_Received_funds__c),ISCHANGED(Payments__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Interest Initiation Date Update</fullName>
        <actions>
            <name>Interest_Initiation_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Client_Account__c.Interest_Initiation_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Removed because we are receiving the interest initiation date from Grade</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update the Client Status to Current</fullName>
        <actions>
            <name>Update_the_Client_Status_to_Current</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(AND(TEXT(Client__r.Status__c)==&apos;Delinquent&apos;,ISBLANK(Interest_Due_Since__c), ISBLANK(UL_Fee_Due_Since__c),Maturity_Date__c &gt;= $Setup.BusinessTransactionDate__c.Business_Transaction_Date__c &amp;&amp; FIU_Outstanding__c &gt; 0),TEXT(Client__r.Status__c)==&apos;Non-Compliant&apos; &amp;&amp; PRIORVALUE(  Invoice_Count__c) &lt; Invoice_Count__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the Client Status to Delinquent</fullName>
        <actions>
            <name>Update_the_Client_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Client__r.Status__c)!=&apos;Default&apos;,TEXT(Client__r.Status__c)!=&apos;Impaired&apos;,TEXT(Client__r.Status__c)!=&apos;Closed&apos;,OR(NOT( ISBLANK(Interest_Due_Since__c)), NOT(ISBLANK(UL_Fee_Due_Since__c)),Maturity_Date__c &lt;  $Setup.BusinessTransactionDate__c.Business_Transaction_Date__c &amp;&amp; FIU_Outstanding__c &gt; 0))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
