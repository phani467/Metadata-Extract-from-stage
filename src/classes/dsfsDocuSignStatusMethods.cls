//-----------------------------
// @author: Tran-Vu Tran
// @date: 16 July 2018
// @param: NA
// @description: Class to hold trigger methods 
// @return: NA
//-----------------------------
public class dsfsDocuSignStatusMethods {

    //-----------------------------
    // @author: Tran-Vu Tran
    // @date: 16 July 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7947 when DocuSign Status is created, insert one record for the Contract Attachment and one for the Certificate.
    // @return: None
    //------------------------------ 
    
    public static void createContractAttachment(TriggerParameters tp) {
        
        if (tp.tEvent == TriggerParameters.TriggerEvent.beforeInsert) {
            
            //System.debug('Executing createContractAttachment - tp.newList.size() = ' + tp.newList.size());

            Set<Id> contractIDs = new Set<Id>();
            
            for (dsfs__DocuSign_Status__c dss: (List<dsfs__DocuSign_Status__c>) tp.newList) {
                if (dss.dsfs__Contract__c != null) {
                    contractIDs.add(dss.dsfs__Contract__c);
                }
            }
            
            Map<Id, Contract> contractMap = new Map<Id,Contract>(
                [select Id, Status, OwnerID, Account.Name, RecordType.DeveloperName from Contract where Id in :contractIDs]
            );
            
            List <ContractAttachment__c> contractAttachmentsToInsert = new List <ContractAttachment__c>();  
            
            for (dsfs__DocuSign_Status__c dss: (List<dsfs__DocuSign_Status__c>) tp.newList){
                
                Contract contr = contractMap.get(dss.dsfs__Contract__c);
                //System.debug('Contract Account = ' + contr.Account.Name);
                //System.debug('Contract RecordType = ' + contr.RecordType.DeveloperName);
                //System.debug('Contract DocuSignEnvelopeId = ' + dss.dsfs__DocuSign_Envelope_ID__c);
                
                ContractAttachment__c ca = new ContractAttachment__c();

                ca.AttachmentType__c = 'Client Signed Contract';

                ca.Contract__c = dss.dsfs__Contract__c;
                ca.DocuSignEnvelopeId__c = dss.dsfs__DocuSign_Envelope_ID__c;
                ca.IsDocuSignCert__c = false;
                ca.Name = contr.Account.Name + ' - ' + contr.RecordType.DeveloperName;          
                contractAttachmentsToInsert.add(ca);
                
                // getting the matching Contract Attachment Certificates
                ContractAttachment__c caCertificate = new ContractAttachment__c();
                
                /* Since there is no requirement for the  DocuSign Certificates, comment out the code for now
                //if (caRecordTypeId != null)
                //	caCertificate.RecordType.DeveloperName = caRecordTypeId;
                caCertificate.AttachmentType__c = 'DocuSign Certificate';
                caCertificate.Contract__c = dss.dsfs__Contract__c;
                caCertificate.DocuSignEnvelopeId__c = dss.dsfs__DocuSign_Envelope_ID__c;
                caCertificate.IsDocuSignCert__c = true;
                caCertificate.Name = contr.Account.Name + ' - ' + contr.RecordType.DeveloperName + ' (DocuSign Certificate)';
    
                contractAttachmentsToInsert.add(caCertificate);
				*/
            }
    
           insert contractAttachmentsToInsert;
    
        }
    }
}