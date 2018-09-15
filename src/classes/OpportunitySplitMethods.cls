//-----------------------------
// @author: Paras Dhingra
// @date: 12th Feb 2018
// @description: SFDC1-6857 Helper class for Opportunitysplit trigger
// @company: IHS Markit
//-----------------------------
public without sharing class  OpportunitySplitMethods  {

    //-----------------------------
    // @author: Paras Dhingra
    // @date: 12th Feb 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-6857Method to update Opportunity team member access rights
    // @return: None
    //----------------------------
    public static final string CHANNELPARTNERNETWORKID = UtilityClass.ChannelPartnerId;
    public static void updateOpportunityTeamAccess(TriggerParameters tp) {

        List<OpportunitySplit> lstOpportunitySplitToProcess = new List<OpportunitySplit>();
         if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
            lstOpportunitySplitToProcess = tp.newList;
            Set<Id> setOpportunityId = new Set<Id>();
            Set<Id> setSplitOwnerId = new Set<Id>();
            for(OpportunitySplit os : lstOpportunitySplitToProcess) {
                setOpportunityId.add(os.OpportunityId);
                setSplitOwnerId.add(os.SplitOwnerId);
            }
            if(!setOpportunityId.isEmpty() && !setSplitOwnerId.isEmpty()) {
                //query Opportunity split team access created before split creation
                List<OpportunityTeamMember> lstOpportunityTeamMember = [Select Id, OpportunityId, OpportunityAccessLevel, UserId
                                                                        from OpportunityTeamMember
                                                                        where OpportunityAccessLevel='Read' AND OpportunityId IN: setOpportunityId AND UserId IN: setSplitOwnerId];

                if(lstOpportunityTeamMember!=null && !lstOpportunityTeamMember.isEmpty()) {
                    for(OpportunityTeamMember otm : lstOpportunityTeamMember) {
                        //provide edit level access to opportunity splits added
                        otm.OpportunityAccessLevel = 'Edit';
                    }
                    update lstOpportunityTeamMember;
                }
            }
        }
    }
    //-----------------------------
    // @author: Paras Dhingra original code shared by Daniel Measures
    // @date: 13th Feb 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-6856 Method to post chatter updates on Opportunity split add/remove percentage update
    // @return: None
    // @companyname: IHS Markit, Salesforce.com
    //----------------------------
    public static void postChatterFeedItem(TriggerParameters tp) {

    Map<id,User> mUserIdToUser = new Map<id,User>();
    Set<id> userIds = new Set<Id>();
    Map<id,id> mOppIdToOwnerId = new Map<id,id>();
    Set<id> oppIds = new Set<id>();
    List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
    List<OpportunitySplit> lstOpportunitySplitToProcess = new List<OpportunitySplit>();
    // insert scenario (Note! update scenario is covered in this code without modification, if opp split user is changed the system deletes and re-creates the split)
    if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
        lstOpportunitySplitToProcess = tp.newList;
        for(OpportunitySplit os : lstOpportunitySplitToProcess) {
            userIds.add(os.SplitOwnerId);
            oppIds.add(os.OpportunityId);
        }
        for(Opportunity o : [select id, OwnerId from Opportunity where id IN :oppIds]) {
            userIds.add(o.OwnerId);
            mOppIdToOwnerId.put(o.id, o.OwnerId);
        }
        if(!userIds.isEmpty()) {
            mUserIdToUser = new Map<id,User>([select id, firstname, lastname from User where id IN:userIds]);
        }
        for(OpportunitySplit os : lstOpportunitySplitToProcess) {
            String message = 'A new opportunity split has been CREATED for user ' + mUserIdToUser.get(os.SplitOwnerId).firstName + ' ' + mUserIdToUser.get(os.SplitOwnerId).lastName + ' with split percentage ' +os.SplitPercentage + '%. ';
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(UtilityClass.getChatterFeedItemInput(os.OpportunityId,new List<String>{mOppIdToOwnerId.get(os.OpportunityId)},message));
            batchInputs.add(batchInput);
        }
    }
    // delete scenario
    if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete) {
        lstOpportunitySplitToProcess = tp.oldList;
        for(OpportunitySplit os : lstOpportunitySplitToProcess) {
            userIds.add(os.SplitOwnerId);
            oppIds.add(os.OpportunityId);
        }
        for(Opportunity o : [select id, OwnerId from Opportunity where id IN :oppIds]) {
            userIds.add(o.OwnerId);
            mOppIdToOwnerId.put(o.id, o.OwnerId);
        }
        if(!userIds.isEmpty()) {
            mUserIdToUser = new Map<id,User>([select id, firstname, lastname from User where id IN:userIds]);
        }
        for(OpportunitySplit os : lstOpportunitySplitToProcess) {
            String message = 'An opportunity split has been DELETED for user ' + mUserIdToUser.get(os.SplitOwnerId).firstName + ' ' + mUserIdToUser.get(os.SplitOwnerId).lastName + ' with split percentage ' +os.SplitPercentage + '%. ';
            ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(UtilityClass.getChatterFeedItemInput(os.OpportunityId,new List<String>{mOppIdToOwnerId.get(os.OpportunityId)},message));
            batchInputs.add(batchInput);
        }
    }
    //update scenario for percentage changes
    if(tp.tEvent == TriggerParameters.TriggerEvent.afterUpdate) {
        lstOpportunitySplitToProcess = tp.newList;
        for(OpportunitySplit os : lstOpportunitySplitToProcess) {
            OpportunitySplit oldOS = (OpportunitySplit)tp.oldMap.get(os.Id);
            if(os.SplitPercentage!=oldOS.SplitPercentage) {
                userIds.add(os.SplitOwnerId);
                oppIds.add(os.OpportunityId);
            }
        }
        for(Opportunity o : [select id, OwnerId from Opportunity where id IN :oppIds]) {
            userIds.add(o.OwnerId);
            mOppIdToOwnerId.put(o.id, o.OwnerId);
        }
        if(!userIds.isEmpty()) {
            mUserIdToUser = new Map<id,User>([select id, firstname, lastname from User where id IN:userIds]);
            for(OpportunitySplit os : lstOpportunitySplitToProcess) {
                
                if(mUserIdToUser!=null && mUserIdToUser.get(os.SplitOwnerId)!=null) {
                    OpportunitySplit oldOS = (OpportunitySplit)tp.oldMap.get(os.Id);
                    System.debug('--SplitOwnerId--' + os.SplitOwnerId);
                    System.debug('--mUserIdToUser--'+mUserIdToUser.get(os.SplitOwnerId));
                    String message = 'An opportunity split has been UPDATED for user ' + mUserIdToUser.get(os.SplitOwnerId).firstName;
                    message += + ' ' + mUserIdToUser.get(os.SplitOwnerId).lastName;
                    message+= ' with split percentage from ' +oldOS.SplitPercentage;
                    message+= '% to '+ os.SplitPercentage + '%. ';
                    ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(UtilityClass.getChatterFeedItemInput(os.OpportunityId,new List<String>{mOppIdToOwnerId.get(os.OpportunityId)},message));
                    batchInputs.add(batchInput);
                }
                
            }
        }

    }
    // insert the feedItems
    if(!batchInputs.isEmpty()) {
        if(!Test.isRunningTest()) {
            ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), batchInputs);
            }
        }

    }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 27th Feb 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7048 Method to add EntitySubscription record for Opportunity Split members
    // @return: None
    // @companyname: IHS Markit
    //----------------------------
    public static void autoFollowOpportunityOnInsert(TriggerParameters tp) {
        List<OpportunitySplit> lstOpportunitySplitToProcess = new List<OpportunitySplit>();
        System.debug('--Entering auto follow of opportunity--');
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
            lstOpportunitySplitToProcess = tp.newList;
            //Map of Opportunity splits and it's opportunity
            Map<Id,Set<Id>> mapOppySplitOwner = new Map<Id,Set<Id>>();
            Set<Id> setUserId = new Set<Id>();
            List<EntitySubscription> lstOppyFollowToInsert = new List<EntitySubscription>();
            //populated the map with splitowner id and it's opportunity record id
            for(OpportunitySplit os: lstOpportunitySplitToProcess) {
                if(mapOppySplitOwner.containsKey(os.OpportunityId)) {
                    mapOppySplitOwner.get(os.OpportunityId).add(os.SplitOwnerId);
    
                }
                else {
                    mapOppySplitOwner.put(os.OpportunityId,new Set<Id>{os.SplitOwnerId});
                }
                setUserId.add(os.SplitOwnerId);
            }
            system.debug('--mapOppySPlitOwner--'+mapOppySplitOwner);
            //query EntitySubscription record for Opportunity subscribers
            if(mapOppySplitOwner!=null && !mapOppySplitOwner.isEmpty()) {
                List<EntitySubscription> lstOppySubscribers = [Select Id,parentId, subscriberId 
                                                                from EntitySubscription 
                                                                where parentId IN: mapOppySplitOwner.keySet()];
                //update map if record already exist                                               
                if(lstOppySubscribers!=null && !lstOppySubscribers.isEmpty()) {
                    
                    for(EntitySubscription oppyFollower : lstOppySubscribers) {
                        
                        if(mapOppySplitOwner.containsKey(oppyFollower.parentId)) {
                            
                            if(mapOppySplitOwner.get(oppyFollower.parentId).contains(oppyFollower.subscriberId)) {
                                mapOppySplitOwner.get(oppyFollower.parentId).remove(oppyFollower.subscriberId);
                            }
                        }
                    }
                    
                }
                
                if(!setUserId.isEmpty()) {
                    //query community users
                    Map<Id,User> mapUserCommunity = new Map<Id,User>(
                                                    [Select Id, IsPortalEnabled
                                                    from User where IsPortalEnabled = true AND Id IN:setUserId]
                    );
                    //process map to prepare list to insert oppy subscription
                    for(Id oppyId: mapOppySplitOwner.keySet()) {
                        for(Id userId: mapOppySplitOwner.get(oppyId)) {
                            EntitySubscription oppyFollow = new EntitySubscription();
                            oppyFollow.parentId = oppyId;
                            oppyFollow.subscriberId = userId;
                            //check if user is community user
                            System.debug('Channerl Partner Network Id'+CHANNELPARTNERNETWORKID);
                            System.debug('mapUserCommunity' + mapUserCommunity);
                            if(mapUserCommunity.containsKey(userId)) {
                                oppyFollow.NetworkID = CHANNELPARTNERNETWORKID;
                            }
                            lstOppyFollowToInsert.add(oppyFollow);
                        }
                    }
                    if(lstOppyFollowToInsert!=null && !lstOppyFollowToInsert.isEmpty()) {
                        insert lstOppyFollowToInsert;
                    }
                }
            }
            
        }
    }
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 20th April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-8019 Method to validate overlay split amount for Opportunity Split members
    // @return: None
    // @companyname: Vertiba
    //----------------------------
    //SFDC1-7578-Due to limitation from SF end commenting this code for now.
    /*public static void validateOverlaySplitAmount(TriggerParameters tp) {
        Map<Id,Decimal> opptySplitOverlayMap = new Map<Id,Decimal>();
        Map<Id,OpportunitySplitType> splitTypeMap = new Map<Id,OpportunitySplitType>([SELECT DeveloperName,Id,MasterLabel,SplitField FROM OpportunitySplitType where SplitField = 'Amount']);
        set<Id> opptyIds = new set<Id>();
        //Map<opptyid,Map<splitid,splitpercentage>>
        Map<Id,Map<Id,Decimal>> opptyOverlaySplitPercentMap =  new Map<Id,Map<Id,Decimal>>();
        System.debug('---------splitTypeMap------'+splitTypeMap);
        if(tp.tEvent == TriggerParameters.TriggerEvent.beforeUpdate) {
            for(OpportunitySplit oSplit : (List<OpportunitySplit>)tp.newList) {
                opptyIds.add(oSplit.OpportunityId);
            }
            List<OpportunitySplit> splitList = [SELECT Id,OpportunityId,Split,SplitAmount,SplitNote,SplitPercentage,SplitTypeId FROM OpportunitySplit where OpportunityId in :opptyIds and SplitType.DeveloperName = 'Overlay'];
            //opptyOverlaySplitPercentMap
            for(OpportunitySplit oSplit : splitList) {
                if(opptyOverlaySplitPercentMap.get(oSplit.OpportunityId) == null) {
                    Map<Id,Decimal> spliPercentageMap = new Map<Id,Decimal>();
                    Decimal sPercentage = (Decimal)oSplit.SplitPercentage;
                    spliPercentageMap.put(oSplit.Id, sPercentage);
                    opptyOverlaySplitPercentMap.put(oSplit.OpportunityId,spliPercentageMap);
                } else {
                    Decimal sPercentage = (Decimal)oSplit.SplitPercentage;
                    opptyOverlaySplitPercentMap.get(oSplit.OpportunityId).put(oSplit.Id, sPercentage);
                }
            }
            //Update record percentage data from trigger.newList
            for(OpportunitySplit oSplit : (List<OpportunitySplit>)tp.newList) {
                if(opptyOverlaySplitPercentMap.get(oSplit.OpportunityId)!= null) {
                    String splitType = splitTypeMap.get(oSplit.SplitTypeId).DeveloperName;
                    if(splitType == 'Overlay') {
                        Decimal sPercentage = (Decimal)oSplit.SplitPercentage;
                        opptyOverlaySplitPercentMap.get(oSplit.OpportunityId).put(oSplit.Id, sPercentage);
                    }
                }
            }
            System.debug('----final Map 2 ----'+opptyOverlaySplitPercentMap);
            //Map<opptyid,totaloverlaysplitpertage>
            Map<Id,Decimal> opptyOverlayPercentMap = new Map<Id,Decimal>();
            for (Id opptyId : opptyOverlaySplitPercentMap.keySet()) {  
                for(Decimal per : opptyOverlaySplitPercentMap.get(opptyId).values()) {
                    if(opptyOverlayPercentMap.get(opptyId) == null) {
                        opptyOverlayPercentMap.put(opptyId,0.00);
                    }
                    Decimal totalPer = opptyOverlayPercentMap.get(opptyId)+per;
                    opptyOverlayPercentMap.put(opptyId,totalPer);
                }           
            }
            System.debug('-- final oppty Percentage --'+opptyOverlayPercentMap);
            for(OpportunitySplit oSplit : (List<OpportunitySplit>)tp.newList) {
                if(opptyOverlayPercentMap.get(oSplit.OpportunityId) != null && opptyOverlayPercentMap.get(oSplit.OpportunityId) != 100.00) {
                    oSplit.addError(System.Label.OpptyOverlayAmountValidationMsg);
                }
            }
        }
    }*/
    //-----------------------------
    // @author: Jagadesh Kumar
    // @date: 27th April 2018
    // @param: TriggerParameters tp
    // @description: SFDC1-7037 Roll up SplitOwner name for Fields Sales Specialists, Account Managers and Overlay 
    // @return: None
    // @companyname: Vertiba
    //----------------------------
    public static void updateOpptySplitTeamName(TriggerParameters tp) {
        set<Id> opptyIds = new set<Id>();
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterInsert) {
            for(OpportunitySplit oSplit : (List<OpportunitySplit>)tp.newList) {
                opptyIds.add(oSplit.OpportunityId);
            }
        }
        // delete scenario
        if(tp.tEvent == TriggerParameters.TriggerEvent.afterDelete) {
            for(OpportunitySplit oSplit : (List<OpportunitySplit>)tp.oldList) {
                opptyIds.add(oSplit.OpportunityId);
            }
        }
        if(!opptyIds.isEmpty()) {
            List<Opportunity> opptyList = [SELECT Id,AccountManagers__c,SalesSpecialists__c,Overlay__c,
                                           (SELECT Id,SplitOwner.Name,SplitType.MasterLabel FROM OpportunitySplits ORDER BY SplitOwner.Name ASC)    
                                           FROM Opportunity where Id in :opptyIds];
            for(Opportunity opp : opptyList) {
                String salesSpecialists = '';
                String accountManagers = '';
                String overlay = '';
                for(OpportunitySplit split : opp.OpportunitySplits) {
                    if(split.SplitType.MasterLabel == 'Sales Specialists') { 
                        salesSpecialists = salesSpecialists + split.SplitOwner.Name + ', ';
                    }
                    if(split.SplitType.MasterLabel == 'Account Managers') { 
                        accountManagers = accountManagers + split.SplitOwner.Name + ', ';
                    }
                    if(split.SplitType.MasterLabel == 'Overlay') {
                        overlay = overlay + split.SplitOwner.Name + ', ';
                    }
                }
                opp.SalesSpecialists__c = salesSpecialists.removeEnd(', ');
                opp.AccountManagers__c = accountManagers.removeEnd(', ');
                opp.Overlay__c = overlay.removeEnd(', '); 
            }
            System.debug('-----opptyList--'+opptyList);
            update opptyList;
        }
    }
}