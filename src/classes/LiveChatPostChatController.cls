//-----------------------------
// @author: Uttam Arya
// @date: 22 June 2017
// @param: NA
// @description: SFDC1-834, SFDC1-281 iveChatPostChatController - visualforce controller for LiveChatPostChat page.  Saves survey results and
// @return: NA
//-----------------------------
public without sharing class LiveChatPostChatController {
    
    public String sendTranscript {get; set;}
    public List<SelectOption> sendTranscriptOptions {get;set;}
    public String email {get; set;}
    public Boolean emailExist {get; set;}
    public String buttonOrigin {get; set;}
    public String msfProductCode {get; set;}
    public String chatkey {get; set;}
    
    
    public PageReference redirect() {
        
        if(!emailExist) {
            PageReference pageRef = Page.LiveChatConfirmation;
            pageRef.getParameters().put('confirmationtitle','Thank you');
            pageRef.getParameters().put('confirmationmsg','Thank you for chatting with us today.');
            return pageRef;
        }
        else {
            return null;
        }
    } 
    
    public LiveChatPostChatController() {
        
        sendTranscriptOptions = new List<SelectOption>();
        sendTranscriptOptions.add(new SelectOption('Yes', 'Yes'));
        sendTranscriptOptions.add(new SelectOption('No', 'No'));
        emailExist = false;
        
        System.debug('@@@@UA');
        PageReference pageRef = ApexPages.currentPage(); 
        
        if (pageRef.getParameters() != null) {
            if(pageRef.getParameters().get('chatKey') != null) {
                this.chatkey = pageRef.getParameters().get('chatKey');
            }
            if (pageRef.getParameters().containsKey('chatDetails')) {
                if (pageRef.getParameters().get('chatDetails') != null) {
                    JSONParser parser = JSON.createParser(pageRef.getParameters().get('chatDetails'));
                    System.debug('@@@@UA chatDetails : ' + pageRef.getParameters().get('chatDetails'));
                    List<LiveAgentInput> laList = new List<LiveAgentInput>();
                    while (parser.nextToken() != null) { 
                        if (parser.getCurrentToken() == JSONToken.START_ARRAY) {     
                            while (parser.nextToken() != null) {   
                                System.debug('Current token: ' + parser.getCurrentToken());  
                                if (parser.getCurrentToken() == JSONToken.START_OBJECT) {
                                    LiveAgentInput laInput = (LiveAgentInput)parser.readValueAs(LiveAgentInput.class);
                                    laList.add(laInput);
                                    System.debug('@@@@UA laInput' + laInput);
                                }
                            }         
                            for (LiveAgentInput a : laList) {
                                System.debug('Label: ' + a.label + ', value: ' + a.value);
                                if(a.label == 'contactEmail') {
                                    //this.csurvey.Email__c = a.value;
                                    this.email = a.value;
                                    emailExist = true;
                                }
                                
                                if(a.label == 'msfProductCode') {
                                    System.debug('@@@@UA msfProductCode' + a.value);
                                    msfProductCode = a.value;
                                }
                                
                                if(a.label == 'buttonOrigin') {
                                    //this.csurvey.Email__c = a.value;
                                    buttonOrigin = a.value;
                                }
                            }
                        }
                    }
                }
            }
        } 
    }
    
    public PageReference submit() {
        try {
            
            System.debug('@@@@UA sendTranscript' + sendTranscript);
            
            list <LiveChatTranscript> chatTranscript = [Select Id, SendTranscript__c, SuppliedEmail__c,  CaseId, Case.AdditionalFields__c from LiveChatTranscript where ChatKey = :this.chatkey];
            
            if(chatTranscript != null && chatTranscript.size() > 0) {
                if(this.email != null) {
                    chatTranscript[0].SuppliedEmail__c = this.email;
                }
                if (sendTranscript == 'Yes') {
                    chatTranscript[0].SendTranscript__c = true;
                } else {
                    chatTranscript[0].SendTranscript__c = false;
                }
                update chatTranscript[0];
                System.debug('@@@UA msfProductCode' + msfProductCode );
                if(chatTranscript[0].CaseId != null && chatTranscript[0].Case.AdditionalFields__c != null && buttonOrigin == 'MSF' && msfProductCode != null) {
                    MSFPlatform__c msfPlatform = MSFPlatform__c.getInstance(msfProductCode);
                    if(msfPlatform != null) {
                        System.debug('@@@UA msfProductCode' + msfProductCode );
                        AdditionalCaseFields__c msfAdditionalCaseFields = new AdditionalCaseFields__c(Id = chatTranscript[0].Case.AdditionalFields__c, DeliveryMechanism__c = msfPlatform.DeliveryMechanism__c, Platform__c = msfPlatform.Platform__c);
                        update msfAdditionalCaseFields;                     
                    }
                }          
            }            
            // no exception thrown so redirect to confirmation page providing text to display
            PageReference pr = Page.LiveChatConfirmation;
            pr.getParameters().put('confirmationtitle','Thank you');
            pr.getParameters().put('confirmationmsg','Thank you for chatting with us today.');
            return pr;
            
        } catch(Exception e) {
            System.debug('@@@@UA' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, e.getMessage()));
        }
        return Page.LiveChatPostChat;
    }
    
    //****************************************************************
    //Live Agent Input JSON Structure
    //****************************************************************0
    
    public class LiveAgentInput {
        
        public String label {get; set;}
        public String value {get; set;}
        public String[] entityMaps;
        public String[] transcriptFields;
        public String displayToAgent;
        public Boolean doKnowledgeSearch;
        
        public LiveAgentInput(String label, String value, String[] entityMaps, String[] transcriptFields, String displayToAgent, String doKnowledgeSearch) {
            this.value = value;
            this.label = label;
        }
    }
}