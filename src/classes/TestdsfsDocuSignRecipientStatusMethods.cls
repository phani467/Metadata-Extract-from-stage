//-----------------------------
// @author: Ankita Singh
// @date: 11 April 2018
// @param: NA
// @description: Test class for Docu Sign Recipient Status trigger methods 
// @return: NA
//-----------------------------

@isTest
private class TestdsfsDocuSignRecipientStatusMethods{
    //-----------------------------
    // @author: Ankita Singh 
    // @date: 11 April 2018
    // @param: NA
    // @description:SFDC1-7213 test coverage for changeContractStatus method on dsfsDocuSignRecipientStatusMethods class 
    //-----------------------------
    private static testMethod void testchangeContractStatusForInsert() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
        
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Id trailRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,FALSE);
        List<Contract> contracts = new List<Contract>();
        contracts.add(contract1);
        insert contracts;
        contract1.RecordTypeId = trailRecordTypeId;
        contract1.Fastrack__c = TRUE;
        contracts = new List<Contract>();
        contracts.add(contract1);
        update contracts;
        //creating docusign status and docusign Recipient status object record
        Test.startTest();
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Subject__c = 'Please sign the document';
        ds.dsfs__Sender__c = 'xyz';
        ds.dsfs__Contract__c = contract1.id;
        ds.dsfs__Company__c = a.id;
        insert ds;
        List<dsfs__DocuSign_Recipient_Status__c> listdrs = new List<dsfs__DocuSign_Recipient_Status__c>();
        dsfs__DocuSign_Recipient_Status__c drs = new dsfs__DocuSign_Recipient_Status__c();
        drs.dsfs__Parent_Status_Record__c = ds.id;
        drs.dsfs__Recipient_Status__c = 'Completed';
        drs.Name='abc';
        drs.dsfs__DocuSign_Recipient_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E49'; 
        dsfs__DocuSign_Recipient_Status__c drs2 = new dsfs__DocuSign_Recipient_Status__c();
        drs2.dsfs__Parent_Status_Record__c = ds.id;
        drs2.dsfs__Recipient_Status__c = 'Sent';
        drs2.Name='abc2';
        drs2.dsfs__DocuSign_Recipient_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E48';
        listdrs.add(drs);
        listdrs.add(drs2);
        insert listdrs;
        String conStatus= [Select ContractStatus__c from contract where ID=: contract1.id].ContractStatus__c;
        System.assertEquals('Signed By Customer',conStatus);
        Test.stopTest();
    }

    //-----------------------------
    // @author: Ankita Singh 
    // @date: 11 April 2018
    // @param: NA
    // @description:SFDC1-7213 test coverage for changeContractStatus method on dsfsDocuSignRecipientStatusMethods class 
    //-----------------------------
    private static testMethod void testchangeContractStatusForUpdate() {
        
        Account a = TestUtility.createTestAccount('Account testSetCaseAdditionalFieldsObject', true);
        Contact c = TestUtility.createContact(a.Id,'1test.2test@3test.com' ,true,'Test', 'testSetCaseAdditionalFieldsObject');
        
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity','USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Id trailRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId,FALSE);
        List<Contract> contracts = new List<Contract>();
        contracts.add(contract1);
        insert contracts;
        contract1.RecordTypeId = trailRecordTypeId;
        contract1.Fastrack__c = TRUE;
        contracts = new List<Contract>();
        contracts.add(contract1);
        update contracts;
        //creating docusign status and docusign Recipient status object record
        Test.startTest();
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__Subject__c = 'Please sign the document';
        ds.dsfs__Sender__c = 'xyz';
        ds.dsfs__Contract__c = contract1.id;
        ds.dsfs__Company__c = a.id;
        insert ds;
        List<dsfs__DocuSign_Recipient_Status__c> listdrs = new List<dsfs__DocuSign_Recipient_Status__c>();
        dsfs__DocuSign_Recipient_Status__c drs = new dsfs__DocuSign_Recipient_Status__c();
        drs.dsfs__Parent_Status_Record__c = ds.id;
        drs.dsfs__Recipient_Status__c = 'Sent';
        drs.Name='abc';
        drs.dsfs__DocuSign_Recipient_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E49'; 
        dsfs__DocuSign_Recipient_Status__c drs2 = new dsfs__DocuSign_Recipient_Status__c();
        drs2.dsfs__Parent_Status_Record__c = ds.id;
        drs2.dsfs__Recipient_Status__c = 'Sent';
        drs2.Name='abc2';
        drs2.dsfs__DocuSign_Recipient_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E48';
        listdrs.add(drs);
        listdrs.add(drs2);
        insert listdrs;
        
        drs2.dsfs__Recipient_Status__c = 'Completed';
        update drs2;
        String conStatus= [Select ContractStatus__c from contract where ID=: contract1.id].ContractStatus__c;
        System.assertEquals('Signed By Customer',conStatus);
        Test.stopTest();
    }

	//-----------------------------
    // @author: Tran-Vu Tran 
    // @date: 1 August 2018
    // @param: NA
    // @description: SFDC1-7947 Test method for DocuSign Status trigger methods updateContractAttachmentType
    // @return: NA
    //-----------------------------
    private static testMethod void testUpdateContractAttachmentType() {
        
        Account a = TestUtility.createTestAccount('Account testUpdateContractAttachmentType', true);
        Contact c = TestUtility.createContact(a.Id,'Test.UpdateContractAttachmentType@ihsmarkit.com', true,
                                              'Test', 'testUpdateContractAttachmentType');
        
        //creating contract
        Product2 testProd = TestUtility.createProduct('Test Product', true);
        Id standardId = Test.getStandardPricebookId();
        PricebookEntry testPBE = TestUtility.createPriceBookEntry(standardId, testProd.Id, true);
        
        LegalEntity__c legalEntity = TestUtility.createLegalEntity('testLegalEntity', 'USD');
        List<Country__c> lstCountry = TestUtility.loadCountryData();
        Country__c country = lstCountry.get(0);
        Id trialRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Trial').getRecordTypeId();
        
        Contract contract1 = TestUtility.createContractWithInsertOptional(a.Id, legalEntity.Id, country.Id, standardId, FALSE);
        List<Contract> contracts = new List<Contract>();
        contracts.add(contract1);
        insert contracts;
        contract1.RecordTypeId = trialRecordTypeId;
        contract1.Fastrack__c = TRUE;
        contracts = new List<Contract>();
        contracts.add(contract1);
        update contracts;
        
        //creating docusign status and docusign Recipient status object record
        Test.startTest();
        
        dsfs__DocuSign_Status__c ds = new dsfs__DocuSign_Status__c();
        ds.dsfs__DocuSign_Envelope_ID__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E50';
        ds.dsfs__Subject__c = 'Please sign the document';
        ds.dsfs__Sender__c = 'xyz';
        ds.dsfs__Contract__c = contract1.id;
        ds.dsfs__Company__c = a.id;
        insert ds;
        
        List<dsfs__DocuSign_Recipient_Status__c> listdrs = new List<dsfs__DocuSign_Recipient_Status__c>();
        
        dsfs__DocuSign_Recipient_Status__c drs = new dsfs__DocuSign_Recipient_Status__c();
        drs.dsfs__Envelope_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E50';
        drs.dsfs__Parent_Status_Record__c = ds.id;
        drs.dsfs__Recipient_Status__c = 'Sent';
        drs.Name='Customer';
        drs.dsfs__DocuSign_Recipient_Email__c='external.recipient@yahoo.com';
        drs.dsfs__DocuSign_Recipient_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E49';
        listdrs.add(drs);
        
        dsfs__DocuSign_Recipient_Status__c drs2 = new dsfs__DocuSign_Recipient_Status__c();
        drs2.dsfs__Envelope_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E50';
        drs2.dsfs__Parent_Status_Record__c = ds.id;
        drs2.dsfs__Recipient_Status__c = 'Sent';
        drs2.Name='OM Rep';
        drs2.dsfs__DocuSign_Recipient_Email__c='internal.recipient@ihsmarkit.com';
        drs2.dsfs__DocuSign_Recipient_Id__c = 'B1F8E324-D40E-415B-8CCD-185EAF4D6E48';
        listdrs.add(drs2);

        insert listdrs;
        
        drs2.dsfs__Recipient_Status__c = 'Completed';
        update drs2;

        String conStatus= [Select ContractStatus__c from contract where ID=: contract1.id].ContractStatus__c;
        System.assertEquals('Signed By Customer', conStatus);
        
        String conAttType= [Select AttachmentType__c from ContractAttachment__c 
                            where DocuSignEnvelopeId__c='B1F8E324-D40E-415B-8CCD-185EAF4D6E50'].AttachmentType__c;
        System.assertEquals('Countersigned Contract', conAttType);
        
        Test.stopTest();
    }
}