//-----------------------------
// @author: Ankita Singh
// @date: 11 April 2018
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
// 
// @modifiedDate: 20 July 2018
// @modifiedBy: Tran-Vu Tran
// @description: SFDC1-7947 Add logic to convert document to file and link to the Contract Attachment upon signature complete
//-----------------------------
public class dsfsDocuSignRecipientStatusMethods {

    //-----------------------------
    // @author: Ankita Singh
    // @date: 11 April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7213 : When a customer signs a Contract in docusign,the Contract Status should automatically be updated 
    //                            to "Signed by Customer".
    // @return: None
    //------------------------------ 
    
    public static void changeContractStatus(TriggerParameters tp) {
        Map<Id, dsfs__DocuSign_Recipient_Status__c> mapNewDocSignRS = (Map<Id, dsfs__DocuSign_Recipient_Status__c>)tp.newMap;
        Map<Id, dsfs__DocuSign_Recipient_Status__c> mapOldDocSignRS = (Map<Id, dsfs__DocuSign_Recipient_Status__c>)tp.oldMap;
        List<Id> DocuSignStatusIDs = new List<Id>();
        List<Contract> contractListToUpdate = new List<Contract>();

        for(dsfs__DocuSign_Recipient_Status__c drs : mapNewDocSignRS.values() ) {

            if (tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {   
                String oldDocSignRSStatus = mapOldDocSignRS.get(drs.id).dsfs__Recipient_Status__c;
            	if(drs.dsfs__Recipient_Status__c == 'Completed' && drs.dsfs__Recipient_Status__c != oldDocSignRSStatus && drs.dsfs__Parent_Status_Record__c != null) {
            		// retrieving docuSignStatus ids in case of update
                    DocuSignStatusIDs.add(drs.dsfs__Parent_Status_Record__c) ;   
            	}
            } else {
              	if(drs.dsfs__Recipient_Status__c == 'Completed' && drs.dsfs__Parent_Status_Record__c != null) {
                    // retrieving docuSignStatus ids in case of insert
            		DocuSignStatusIDs.add(drs.dsfs__Parent_Status_Record__c) ;   
            	} 
            }      
        }
		
        // List of document files to be converted from the standard attachments above
        List<ContentVersion> filesToInsert = new List <ContentVersion>();
        Set<Id> parentIDs = new Set<Id>(); 
        
        //System.debug('DocuSignStatusIDs: ' + DocuSignStatusIDs);
        if (DocuSignStatusIDs != null && DocuSignStatusIDs.size() > 0) {
            // fetching related contract id 
			List<dsfs__DocuSign_Status__c> listDocuSignStatusToUpdate =
                [Select dsfs__Contract__c, dsfs__DocuSign_Envelope_ID__c, dsfs__Envelope_Status__c
                 from dsfs__DocuSign_Status__c
                 where Id in : DocuSignStatusIDs and dsfs__Contract__r.ContractStatus__c != 'Signed By Customer'];
            //System.debug('listDocuSignStatusToUpdate: ' + listDocuSignStatusToUpdate);
            
            for(dsfs__DocuSign_Status__c dss : listDocuSignStatusToUpdate) { 
                // changing the status of the related contract
                contractListToUpdate.add(new Contract(Id = dss.dsfs__Contract__c, ContractStatus__c = 'Signed By Customer'));
            }
            
            // @modifiedDate: 20 July 2018
            // @modifiedBy: Tran-Vu Tran
            // @description: SFDC1-7947 Add logic to convert document to file to be linked to the Contract Attachment upon signature complete
			List<dsfs__DocuSign_Status__c> listDocuSignStatusToAttachFile =
                [Select dsfs__Contract__c, dsfs__DocuSign_Envelope_ID__c, dsfs__Envelope_Status__c
                 from dsfs__DocuSign_Status__c
                 where Id in : DocuSignStatusIDs];
            //System.debug('listDocuSignStatusToAttachFile: ' + listDocuSignStatusToAttachFile);

            Set<String> DocuSignEnvelopeIDs = new Set<String>();
            for(dsfs__DocuSign_Status__c dss : listDocuSignStatusToAttachFile) {
                // get the Envelope IDs of the DocuSign Status to find the matching Contract Attachment records for linking files 
                DocuSignEnvelopeIDs.add(dss.dsfs__DocuSign_Envelope_ID__c);
            }
            //System.debug('DocuSignEnvelopeIDs: ' + DocuSignEnvelopeIDs);

            // get all Contract Attachment records with the matching DocuSign Envelop ID and put into a Map, using DocuSign Envelope ID as the key
            Map<String, ContractAttachment__c> caMap = new Map<String, ContractAttachment__c> ();
            
            for (ContractAttachment__c conAtt : 
                 [select DocuSignEnvelopeId__c, Id, Name, AttachmentType__c from ContractAttachment__c 
                  where DocuSignEnvelopeId__c in : DocuSignEnvelopeIDs 
                  	and AttachmentType__c in ('Client Signed Contract', 'Countersigned Contract') ] ) {
                      
		        caMap.put(conAtt.DocuSignEnvelopeId__c, conAtt);
            }
            //System.debug('Contract Attachment Map: ' + caMap);
            
            // get all standard Attachment records for the DocuSign Status records and put into a Map, using DocuSign Status record Id as the key
            Map<Id, Attachment> attMap = new Map<Id, Attachment>();
            for (Attachment att : [Select Id, Name, Body, OwnerId, ParentId From Attachment where ParentId in : DocuSignStatusIDs]) {
                
                attMap.put(att.ParentId, att);
            }
            //System.debug('Attachment Map: ' + attMap);

            for (dsfs__DocuSign_Status__c dss: listDocuSignStatusToAttachFile) {

                if (dss.dsfs__Contract__c != null && dss.dsfs__DocuSign_Envelope_ID__c != null
                    && dss.dsfs__Envelope_Status__c == 'Completed') {

                    // get the Attachment that needs to be converted to the file
                    Attachment att = attMap.get(dss.Id);
                    //System.debug('processing Attachment: ' + att);

                    // get the Contract Attachment that the file needs to be associated to
                    ContractAttachment__c ca = caMap.get(dss.dsfs__DocuSign_Envelope_ID__c);
                    //System.debug('processing Contract Attachment: ' + ca);

                    if (att != null && ca != null) {
                        ContentVersion cv = new ContentVersion();
                        cv.ContentLocation = 'S';
                        cv.PathOnClient = att.Name;
                        //cv.Origin = 'H';
                        //cv.DocumentType__c = 'Contract Attachment';
                        cv.Title = att.Name;
                        cv.OwnerId = att.OwnerId;
                        cv.VersionData = att.Body;
                        // this hold the Contract Attachment Id to be linked back once the document file has been inserted
                        cv.ParentID__c = ca.Id;
                        cv.FirstPublishLocationId = cv.ParentID__c;

                        ParentIDs.add(ca.Id); // keep the list of Parent IDs to retrieve data after records have been inserted 

                        //System.debug('adding ContentVersion: ' + cv);
                        
                        filesToInsert.add(cv);
                    }
                }
            }
        }

        try {
            if(contractListToUpdate.size()>0 || contractListToUpdate != null) {
                // updating contract
            	update contractListToUpdate ;   
            }
        }
        catch(Exception e) {
            UtilityClass.createApexLogRecord(e, 'dsfsDocuSignRecipientStatusMethods', 'changeContractStatus');
        }
   
        addContractAttachmentFiles(filesToInsert, parentIDs);
    }

    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 20 July 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7947 Add logic to insert document as a file and link to the Contract Attachment
    // @return: None
    //------------------------------ 
    public static void addContractAttachmentFiles(List<ContentVersion> filesToInsert, Set<Id> parentIDs) {
        try {
            if (filesToInsert != null && filesToInsert.size() > 0) {
                //System.debug('Document files to insert: ' + filesToInsert);
                insert filesToInsert;
    
                //System.debug('parentIDs: ' + parentIDs);
                
                // reading back these files to get the new ContentDocumentId values
                List<ContentVersion> newFiles = [select Id, ContentDocumentId, ParentID__c from ContentVersion where ParentID__c in : parentIDs];
                //System.debug('New Document files created: ' + newFiles);
                
                List<ContentDocumentLink> docLinks = new List<ContentDocumentLink>();
                for (ContentVersion cv : newFiles) {
                    
                    // creating Content Document Link from the parent Contract Attachment to the new document file
                    ContentDocumentLink cl = new ContentDocumentLink(
                        ContentDocumentId = cv.ContentDocumentId,
                        LinkedEntityId = cv.ParentID__c, // this one stores the Contract Attachment Id where the file needs to be linked to
                        ShareType = 'I',
                        Visibility = 'InternalUsers'
                    );
                    //System.debug('Content Document Link : ' + cl);
                    docLinks.add(cl);
                }
                
                insert docLinks;
            }
        }
        catch(Exception e) {
            UtilityClass.createApexLogRecord(e, 'dsfsDocuSignRecipientStatusMethods', 'addContractAttachmentFiles');
        }
    }
    
    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 30 July 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7947 after DocuSign Status record is created, update the matching Contract Attachment
    // 				Type to Countersigned Attachment if the recipient's email address is internal.
    // @return: None
    //------------------------------ 
    public static void updateContractAttachmentType(TriggerParameters tp) {
        //System.debug('Executing updateContractAttachmentType...');
        List <ContractAttachment__c> contractAttachmentsToUpdate = new List <ContractAttachment__c>();
        
        // getting all Envelope IDs for the recipients
        Set<String> envelopeIDs = new Set<String>();
        for (dsfs__DocuSign_Recipient_Status__c drs: (List<dsfs__DocuSign_Recipient_Status__c>) tp.newList) {
            if (drs.dsfs__Envelope_Id__c != null) {
                envelopeIDs.add(drs.dsfs__Envelope_Id__c);
            }
        }
        
        // retrieving all Contract Attachment records with the matching envelope IDs for the recipients
        Map<String, ContractAttachment__c> caMap = new Map<String, ContractAttachment__c>();

        for (ContractAttachment__c ca: 
             [select DocuSignEnvelopeId__c, AttachmentType__c
              from ContractAttachment__c where DocuSignEnvelopeId__c in :envelopeIDs]) {
                  caMap.put(ca.DocuSignEnvelopeId__c, ca);
              }
        //System.debug('caMap = ' + caMap);

        for(dsfs__DocuSign_Recipient_Status__c drs : (List<dsfs__DocuSign_Recipient_Status__c>)tp.newList) {
            
            if (tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
                //System.debug('drs.dsfs__DocuSign_Recipient_Email__c = ' + drs.dsfs__DocuSign_Recipient_Email__c);
                if (drs.dsfs__DocuSign_Recipient_Email__c != null &&
                    drs.dsfs__DocuSign_Recipient_Email__c.containsIgnoreCase('@ihsmarkit.com')) {
                        //System.debug('drs.dsfs__Envelope_Id__c = ' + drs.dsfs__Envelope_Id__c);
                        ContractAttachment__c ca = caMap.get(drs.dsfs__Envelope_Id__c);
                        //System.debug('ContractAttachment = ' + ca);
                        if (ca != null && ca.AttachmentType__c != 'Countersigned Contract') {
                            ca.AttachmentType__c = 'Countersigned Contract';
                            contractAttachmentsToUpdate.add(ca);
                        }
                    }
            }
        }        

        try {
            if (contractAttachmentsToUpdate != null && contractAttachmentsToUpdate.size() > 0) {
                //System.debug('Contract Attachments to update: ' + contractAttachmentsToUpdate);
                update contractAttachmentsToUpdate;
            }
        }
        catch(Exception e) {
            UtilityClass.createApexLogRecord(e, 'dsfsDocuSignRecipientStatusMethods', 'updateContractAttachmentType');
        }

    }
}