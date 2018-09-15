//---------------------------------
// @author: Paras Dhingra
// @date: 15th Mar 2018
// @Description: SFDC1-7564 Track email sent from workflows and attach it to parent record
// @Company: IHS Markit
//---------------------------------
global class OutBoundEmailTracking implements Messaging.InboundEmailHandler {
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 16 Mar 2018
    // @param: Messaging.InboundEmail,Messaging.InboundEnvelope
    // @description: Track email sent from workflows and attach it to parent record
    // @return: Messaging.InboundEmailResult 
    //------------------------------
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,Messaging.InboundEnvelope envelope) {
        
        //variable initializations
        String IdString='';
        String emailToAttachBody = '';
        Integer IdIndex;
        Id recordId;
        EmailMessage emailToAttach = new EmailMessage();
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();    
        result.success = false;
        try {
                
                System.debug('--Queries--'+Limits.getQueries());
                //Check for email body
                if(email.plainTextBody!=null) {
                    emailToAttachBody = email.plainTextBody;
                    emailToAttach.TextBody = email.plainTextBody;
                }
                else if(email.htmlBody!=null) {
                    emailToAttachBody = email.htmlBody;
                    emailToAttach.htmlBody = email.htmlBody;
                }
                
                //extract recordid from email
                IdIndex = emailToAttachBody.indexOf('[RECID:');
                IdString = emailToAttachBody.substring(IdIndex+7,IdIndex+22);
                System.debug('--IdString--'+IdString);
                if(IdString!=null && IdString.length()==15) {
                    recordId = (Id)IdString;
                }
                System.debug('--recordId--'+recordId);
                if(recordId!=null) {
                    //get details of related object
                    Schema.SObjectType sobjectType = recordId.getSObjectType();
                    String sobjectName = sobjectType.getDescribe().getName();
                    List<SObject> record = Database.query('Select Id From ' + sobjectName + ' Where Id = :recordId');
                    System.debug('--record--'+record);
                    if(record!=null && record.size()==1 && sobjectName!='Contact' && sobjectName!='Lead') {
                        //create email and attach it to the related record using RelatedToId Attribute
                        emailToAttach.FromAddress = email.fromAddress;
                        emailToAttach.Subject = email.subject;
                        emailToAttach.ToAddress = String.Join(email.toAddresses,',');
                        
                        //check if sobject type is lead or contact
                        
                        emailToAttach.RelatedToId = record[0].Id;
                        //set the status of email as sent
                        emailToAttach.Status = '3';
                        
                        //attach it to the record
                        insert emailToAttach;
                        //control reached successfully here
                        result.success = true;
                    }
                    
                } 
                else {
                   throw new GenericCustomException('RecordId Not Found');
                }
                
            }
            catch(Exception ex) {
                //exception caught
                result.message = 'Exception occurred while email tracking. Exception caught:' + ex;
                UtilityClass.createApexLogRecord(ex, 'OutBoundEmailTracking', 'handleInboundEmail');
            }

       
        return result;
    }
    
}