/**
* @author Hari Krishnan
* @date 07/16/2013
* @description This class has helper methods.
* @lastModifiedSprint: Sprint 12 SFDC1-710 -  Added method addBusinessDays
* @lastModifiedBy : Prachi Bhasin in Sprint 12
*/

public with sharing class UtilityClass {
    
    /**
    * @author Hari Krishnan
    * @date 07/16/2013
    * @description Gets the type name of the SObject.
    * @param SObject The SObject for which the name to be obtained.
    * @return String - The type name.
    */
    public static String getSObjectTypeName(SObject so) {
        return so.getSObjectType().getDescribe().getName();
    }

    static List<Country__c> countries = [SELECT Id, Name, CountryCode__c, Region__c FROM Country__c];
        
    /**
     * @author Paras Dhingra
     * @date 26th Jun 2017
     * @description Method to return a map of all countries
     * @return Map <Name,country>
     **/

    public static Map<String,Country__c> countryMap{
         get {
             if(countryMap == null) {
                countryMap = new Map<string, Country__c>();
                for (Country__c c:countries) {
                    countryMap.put(c.Name, c);
                } 
             }
             return countryMap;
         }
    
        set;
    }
    
    /**
     * @author Tran-Vu Tran
     * @date 26th Jun 2017
     * @description Method to return a country object from the specified country name
     * @param name Country Name
     * @return Country__c
     **/
    public static Country__c getCountry(string name) {
         return countryMap.get(name);
    }

    public static Map<String,Country__c> countryIdMap{
         get {
             if(countryIdMap == null) {
                countryIdMap = new Map<string, Country__c>();
                for (Country__c c:countries) {
                    countryIdMap.put(c.Id, c);
                } 
             }
             return countryIdMap;
         }
    
        set;
    }    

    /**
     * @author Tran-Vu Tran
     * @date 31st Aug 2017
     * @description Method to return a country object from the specified country Id
     * @param name Country Id
     * @return Country__c
     **/
    public static Country__c getCountryById(string Id) {
        return countryIdMap.get(Id);
    }
    
    public static Map<String,Country__c> countryCodeMap{
         get {
             if(countryCodeMap == null) {
                countryCodeMap = new Map<string, Country__c>();
                for (Country__c c:countries) {
                    countryCodeMap.put(c.CountryCode__c, c);
                } 
             }
             return countryCodeMap;
         }
        set;
    }    

    /**
     * @author Tran-Vu Tran
     * @date 12th Sep 2017
     * @description Method to return a country object from the specified country code
     * @param name Country code
     * @return Country__c
     **/
    public static Country__c getCountryByIsoCode(string code) {
        return countryCodeMap.get(code);
    }
    
    /**
     * @author Tran-Vu Tran
     * @date 18th July 2017
     * @description SFDC1-204 Get Account by Name
     */
    public static Account getAccountByName(String accountName) {
        
        List<Account> accounts = [Select Id, Name from Account where Name =: accountName];
        if (accounts != null && !accounts.isEmpty()) {
            return accounts[0];
        }
        return null;
    }
    
    /**
     * @author Tran-Vu Tran
     * @date 18th July 2017
     * @description SFDC1-204 Get Contact by Email
     */
    public static Contact getContactByEmail(String contactEmail) {
        
        List<Contact> contacts = [Select Id, Name, Email, AccountId from Contact where Email =: contactEmail];
        if (contacts != null && !contacts.isEmpty()) {
            return contacts[0];
        }
        
        return null;
    }

    /**
     * @author Tran-Vu Tran
     * @date 18th July 2017
     * @description SFDC1-204 Get User by Id
     */
    public static User getUserById(String userId) {
        
        List<User> users = [Select Id, Name, Email, ADID__c from User where Id =: userId];
        if (users != null && !users.isEmpty()) {
            return users[0];
        }

        return null;
    }

    /**
     * @author Tran-Vu Tran
     * @date 20th July 2017
     * @description SFDC1-204 Get Object Record Type Id
     */
    public static String getObjectRecordTypeId(String objectTypeName, String recordTypeName) {

        List<RecordType> recordTypes = [SELECT Id FROM RecordType WHERE SObjectType =: objectTypeName AND Name =: recordTypeName];
        if (recordTypes != null && !recordTypes.isEmpty()) {
            return recordTypes[0].Id;
        }
        
        return null;
    }
    
    public static String getObjectRecordTypeId(SObjectType sObjectType, String recordTypeName) {
        return getObjectRecordTypeId(sObjectType.getDescribe().getName(), recordTypeName);
    }
    
   /**
     * @author Paras Dhingra
     * @date 31st July 2017
     * @description SFDC1-1168 create apex log record using an exception
     * @param Exception
     * @return void
     * @companyname IHS Markit
     */
     public static void createApexLogRecord(Exception ex, String className, String methodName) {
         String description = '\n Cause: '+ex.getCause()+'\n Line number : '+ ex.getLineNumber()+ '\n Message: '+ ex.getMessage()+ '\n stackTrace: '+ex.getStackTraceString();
         ApexLogger__c apexLogRecord = new ApexLogger__c(ClassName__c=className,ErrorDescription__c=description,FunctionName__c=methodName);
         insert apexLogRecord;
     }
     
    /**
     * @author Paras Dhingra
     * @date 25th Sep 2017
     * @description SFDC1-4353 generic method to return picklist options of an sObject
     * @param sObject,string
     * @return List<String>
     * @companyname IHS Markit
     */
     public static List <String> getselectOptions(sObject objObject, string fld) {
      system.debug('--objObject--' + objObject);
      system.debug('--fld--' + fld);
      List < String > allOpts = new list < String > ();
      // Get the object type of the SObject.
      Schema.sObjectType objType = objObject.getSObjectType();
     
      // Describe the SObject using its object type.
      Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
     
      // Get a map of fields for the SObject
      map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
     
      // Get the list of picklist values for this field.
      list < Schema.PicklistEntry > values = fieldMap.get(fld).getDescribe().getPickListValues();
     
      // Add these values to the selectoption list.
      for (Schema.PicklistEntry a: values) {
          allOpts.add(a.getValue());
      }
      system.debug('--allOpts--' + allOpts);
      allOpts.sort();
      return allOpts;
     }
     
     /**
     * @author Paras Dhingra
     * @date 27th Sep 2017
     * @description SFDC1-4353 Method to return currency code mapping
     * @param sObject,string
     * @return List<String>
     * @companyname IHS Markit
     */
     public static Map<String,Decimal> mapCurrencyIsoCodeConversionRate {
         get {
             if(mapCurrencyIsoCodeConversionRate==null) {
                System.debug('--currency query--');
                mapCurrencyIsoCodeConversionRate = new Map<String,Decimal>();
                List<CurrencyType> lstCurrencyType = [Select Id, IsoCode, ConversionRate from CurrencyType where IsActive=true];
                if(lstCurrencyType != null && lstCurrencyType.size() > 0) {
                    for(CurrencyType currencyType : lstCurrencyType) {
                        mapCurrencyIsoCodeConversionRate.put(currencyType.IsoCode, currencyType.ConversionRate);
                    }
                }
        
             }
              return mapCurrencyIsoCodeConversionRate;
             
         }
         set;
     }
     
     /**
     * @author : Mohit Modi
     * @date : 06 Nov 2017
     * @description : SFDC1-4790 Method to return the key prefix of an Object
     * @param : string Object Name
     * @return : String Object Keyprefix
     * @companyname : Vertiba
     */
     public static String getObjectKeyPrefix(String object_name) {
            Map<String, Schema.SObjectType> m  = Schema.getGlobalDescribe() ;
            system.debug('==>m is==>'+m);
            if(m.get(object_name) != NULL) {
                Schema.SObjectType s = m.get(object_name) ;
                system.debug('==>Sobject Type is ==>'+s);
                Schema.DescribeSObjectResult r = s.getDescribe() ;
                String keyPrefix = r.getKeyPrefix();
                return keyPrefix;
            }
            return NULL;
     }
     
    /**
     * @author : Prachi Bhasin
     * @date : 10 Nov 2017
     * @description : SFDC1-710 Method to add business days to date
     * @param : date to which business days should be added
     * @param : integer NumberOfBusinessDays
     * @return : date
     * @companyname : Vertiba
     */
     public static Date addBusinessDays(Date startDate, Integer NumberOfBusinessDays) {
            Integer businessDaysAdded = 0;
            Date currentDate = startDate;
            while (businessDaysAdded < NumberOfBusinessDays) {
                currentDate = currentDate.addDays(1);
                Datetime d = datetime.newInstance(currentDate.year(), currentDate.month(),currentDate.day());
        
                if (d.format('E') != 'Sat' && d.format('E') != 'Sun') {
                    // it's a business day, so add 1 to the counter that works towards the amount of days to add
                    businessDaysAdded = businessDaysAdded + 1;
                } 
            }       
            return currentDate;
     }
     
     /**
     * @author : Mohit Modi
     * @date : 14 Nov 2017
     * @description : SFDC1-5723 Method to check the Edit access for the given user on the given Record
     * @param : User Id, Record Id
     * @return : Boolean
     * @companyname : Vertiba
     */
     public static Boolean checkRecordAccessforUser (Id usrId, id recordId) {
         system.debug('usrId----'+usrId);
         system.debug('recordId----'+recordId);
         
         list<UserRecordAccess> recordAccessVal =  [SELECT RecordId FROM UserRecordAccess
              WHERE UserId =: usrId AND RecordId =: recordId AND HasEditAccess = true ];
         system.debug('inside recordAccessVal '+recordAccessVal );    
        
         return recordAccessVal.isEmpty() ? false : true;
     }
     
          /**
     * @author : Hemant Shukla
     * @date : 15-NOV-2017
     * @description : SFDC1-5809, Method to subtract business days to date
     * @param : date to which business days should be subtracted
     * @param : integer NumberOfBusinessDays
     * @return : date
     * @companyname : Vertiba
     */
     public static Date subtractBusinessDays(Date startDate, Integer NumberOfBusinessDays) {
            Integer businessDaysRemoved = 0;
            Date currentDate = startDate;
            while (businessDaysRemoved < NumberOfBusinessDays) {
                currentDate = currentDate.addDays(-1);
                Datetime d = datetime.newInstance(currentDate.year(), currentDate.month(),currentDate.day());
        
                if (d.format('E') != 'Sat' && d.format('E') != 'Sun') {
                    // it's a business day, so add 1 to the counter that works towards the amount of days to add
                    businessDaysRemoved += 1;
                } 
            }       
            return currentDate;
     }
     
     //================================
     // @author: Paras Dhingra
     // @date: 27th Sep 2017
     // @description: SFDC1-4353 Method to return currency code mapping
     // @param: sObject,string
     // @return: List<String>
     // @companyname: IHS Markit
     //================================
      public static boolean isCommunity() {
          
        Id siteId = Site.getSiteId(); 
        if (siteId != null) {
            return true;
        }
        return false;
          
      }
     //================================
     // @author: Paras Dhingra
     // @date: 15th Feb 2018
     // @description: SFDC1-6856 This method returns a feedItemInput element to be posted using connect API
     // @param: String recordId(Id of record or group for chatter feed) 
     // @param: List<String> list of userIds/GroupIds to be @mentioned
     // @param: String Message - Message to be posted on chatter
     // @return: List<String>
     // @companyname: IHS Markit
     //================================
     public static ConnectApi.FeedItemInput getChatterFeedItemInput (String recorId, List<String> lstAtMentions, String message) {
        ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        ConnectApi.TextSegmentInput textSegmentInput = new ConnectApi.TextSegmentInput();
        textSegmentInput.text = message;
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();
        messageBodyInput.messageSegments.add(textSegmentInput);
        for(Id userGroupId: lstAtMentions) {
            ConnectApi.MentionSegmentInput atMentions = new ConnectApi.MentionSegmentInput();
            atMentions.Id = userGroupId;
            messageBodyInput.messageSegments.add(atMentions);
        }
        feedItemInput.body = messageBodyInput;
        feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;
        feedItemInput.subjectId = recorId;
        return feedItemInput;
     }
     //
      // @author: Paras Dhingra
      // @date: 15th Feb 2018
      // @description: SFDC1-6856 method returns a map of split type names and ids
      // @param: null
      // @return:  Map<String,Id>
      // @companyname: IHS Markit
      //
    public static Map<String,Id> getSplitTypeIds() {
        List<OpportunitySplitType> lstOppySplitTypes = [Select Id, DeveloperName from OpportunitySplitType where IsActive=true];
        Map<String,Id> mapSplitTypes = new Map<String,Id>();
        for(OpportunitySplitType oppySplitType :lstOppySplitTypes) {
            mapSplitTypes.put(oppySplitType.DeveloperName, oppySplitType.Id);
        }
        return mapSplitTypes;
    }
    //
      // @author: Paras Dhingra
      // @date: 28th Feb 2018
      // @description: SFDC1-7048 property returns channel partner community Id
      // @param: null
      // @return:  Map<String,Id>
      // @companyname: IHS Markit
      //
    public static String ChannelPartnerId {
        get {
            if(ChannelPartnerId==null) {
                ChannelPartnerId = getCommunityNetworkId('Channel Partners');
            }
            return ChannelPartnerId;
        }
        set;
    }
     //
      // @author: Paras Dhingra
      // @date: 28th Feb 2018
      // @description: SFDC1-7048 method returns a network id of community
      // @param: null
      // @return:  Map<String,Id>
      // @companyname: IHS Markit
      //
    public static String getCommunityNetworkId(String CommunityName) {
        List<Network> lstNetwork = [Select Id, Name from Network where Name =:CommunityName limit 1];
        return lstNetwork[0].ID;
    }
    //
    // @author: Prachi Bhasin
    // @date: 3 May 2018
    // @description: SFDC1-7574 method returns a query with all fields of sobject
    // @param: String - name of object
    // @return:  String
    // @companyname: Vertiba
    //
    public static String queryBuilder(String SobjectApiName) {

        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();

        String commaSepratedFields = '';
        for(String fieldName : fieldMap.keyset()) {
            if(commaSepratedFields == null || commaSepratedFields == '') {
                commaSepratedFields = fieldName;
            }else{
                commaSepratedFields = commaSepratedFields + ', ' + fieldName;
            }
        }

       String  queryStr = 'select ' + commaSepratedFields + ' from ' + SobjectApiName ;
       
       return queryStr;
      
    }
    //
      // @author: Paras Dhingra
      // @date: 26th Apr 2018
      // @description: SFDC1-7082 method to replicate dates360 method of excel
      // @param: DateTime StartDate, DateTime EndDate
      // @return:  Double dayCount
      // @companyname: IHS Markit
      //
    public static Double getDays360(Date startDate, Date endDate) {
        Integer startMonthDays = 0;
        Integer endMonthDays = 0;
        double diff = 0;

        Date dtStartDate = startDate;
        Date dtEndDate = endDate;

        dtStartDate = dtStartDate.AddDays(-1);

        if (Date.DaysInMonth(Integer.valueOf(dtStartDate.year()), Integer.valueOf(dtStartDate.month())) == dtStartDate.day())
        {
            startMonthDays = 0;
        }
        else if (dtStartDate.month() == 2)
        {
            if (Date.DaysInMonth(dtStartDate.year(), dtStartDate.month()) == 29 && dtStartDate.day() == 28)
            {
                startMonthDays = (30 - (dtStartDate.day() + 2));
            }
            else if (Date.DaysInMonth(dtStartDate.year(), dtStartDate.month()) == 28 && dtStartDate.day() == 27)
            {
                startMonthDays = (30 - (dtStartDate.day() + 3));
            }
            else
            {
                startMonthDays = (30 - dtStartDate.day());
            }
        }
        else
        {
            startMonthDays = (30 - dtStartDate.day());
        }

        if (Date.DaysInMonth(dtEndDate.year(), dtEndDate.month()) == dtEndDate.day())
        {
            endMonthDays = CalculateEndMonthdays(endMonthDays, dtStartDate, dtEndDate);
        }
        else
        {
            endMonthDays = dtEndDate.day();
        }

        diff = (dtEndDate.year() - dtStartDate.year()) * 360 +
                    (dtEndDate.month() - dtStartDate.month() - 1) * 30 +
                    startMonthDays + endMonthDays;

        return diff;

    }
      //
      // @author: Paras Dhingra
      // @date: 26th Apr 2018
      // @description: SFDC1-7082 helper method for day360 to calculate endmonthdays
      // @param: Integer endMonthDays, Date startDatem Dateime endDate
      // @return:  Integer endMonthDays
      // @companyname: IHS Markit
      //
    private static Integer CalculateEndMonthdays(Integer endMonthDays, Date dtStartDate, Date dtEndDate)
        {
            if (dtStartDate.day() < Date.DaysInMonth(dtStartDate.year(), dtStartDate.month()) - 1)
            {
                if (dtEndDate.month() == 2 && Date.DaysInMonth(dtEndDate.year(), dtEndDate.month()) == dtEndDate.day())
                {
                    endMonthDays = Date.DaysInMonth(dtEndDate.year(), dtEndDate.month());
                }
                else if (Date.DaysInMonth(dtEndDate.year(), dtEndDate.month()) > 30)
                {
                    endMonthDays = Date.DaysInMonth(dtEndDate.year(), dtEndDate.month());
                }
                else
                {
                    endMonthDays = dtEndDate.day();
                }
            }
            else
            {
                if (Date.DaysInMonth(dtEndDate.year(), dtEndDate.month()) == dtEndDate.day())
                {
                    endMonthDays = 30;
                }
                else
                {
                    endMonthDays = dtEndDate.day();
                }

                //// 1 day() issue 
                if (dtEndDate.day() == 31 && dtStartDate.day() == 30 && dtEndDate.month() == dtStartDate.month() && dtEndDate.year() == dtStartDate.year())
                {
                    endMonthDays = endMonthDays + 1;
                }
                else if (dtEndDate.month() == 2)
                {
                    if (Date.DaysInMonth(dtEndDate.year(), dtEndDate.month()) == 29)
                    {
                        if (dtEndDate.day() == 29 && dtStartDate.day() == 28 && dtEndDate.month() == dtStartDate.month() && dtEndDate.year() == dtStartDate.year())
                        {
                            endMonthDays = endMonthDays + 1;
                        }
                    }
                    else
                    {
                        if (dtEndDate.day() == 28 && dtStartDate.day() == 27 && dtEndDate.month() == dtStartDate.month() && dtEndDate.year() == dtStartDate.year())
                        {
                            endMonthDays = endMonthDays + 1;
                        }
                    }
                }
            }

            return endMonthDays;
        }
        //
      // @author: Paras Dhingra
      // @date: 20th Jun 2018
      // @description: SFDC1-8222 method to identify fiscal year based on date
      // @param: DateTime dateTobeCompared, Integer fiscalStartMonth
      // @return:  Integer fiscalyear
      // @companyname: IHS Markit
      //
      public static Integer calculateFYFromDate(DateTime dateToBeCompared, Integer fiscalStartMonth) {
          Integer fiscalYear=0;
          if(dateToBeCompared!=null) {
              if(dateToBeCompared.month()>=fiscalStartMonth) {
              fiscalYear = dateToBeCompared.year()+1;
              }
              if(dateToBeCompared.month()<fiscalStartMonth) {
                  fiscalYear = dateToBeCompared.year();
              }
          }
          
          return fiscalYear;
      }
      //
      // @author: Paras Dhingra
      // @date: 20th Jun 2018
      // @description: SFDC1-8222 method to identify fiscal year based on date
      // @param: DateTime dateTobeCompared, Integer fiscalStartMonth
      // @return:  Integer fiscalyear
      // @companyname: IHS Markit
      //
      public static Integer FiscalStartMonth {
        get {
            if(FiscalStartMonth==null) {
                FiscalStartMonth = [Select FiscalYearStartMonth FROM Organization].FiscalYearStartMonth; 
            }
            return FiscalStartMonth;
        }
          set;
      }

      // @author: Paras Dhingra
      // @date: 29th Jun 2018
      // @description: SFDC1-9022 method to return overlay recordtype Id
      // @param: none
      // @return:  Id
      // @companyname: IHS Markit
	  public static Id OverlayId {
			get {
				if(OverlayId==null) {                
					List<OpportunitySplitType> lstOverlayId =  [Select Id from OpportunitySplitType where DeveloperName= 'Overlay' limit 1];
					if(lstOverlayId!=null && !lstOverlayId.isEmpty()) {
						OverlayId = lstOverlayId[0].Id;
					}
				}
				return OverlayId;
			}
			set;
	  }
		   
      // @author: Mohit Modi
      // @date: 6 Jul 2018
      // @description: SFDC1-9133 : Provides the Global State picklist Values
      // @param: NA
      // @return: Schema Picklist Entry for Global StateCode
      // @companyname: Vertiba
      public static List<Schema.PicklistEntry> GlobalStatePicklist {
        get {
            if(GlobalStatePicklist == NULL || GlobalStatePicklist.isempty()) {
                GlobalStatePicklist = new List<Schema.PicklistEntry> ();
                Schema.DescribeFieldResult fieldResult = Account.BillingStateCode.getDescribe();
                List<Schema.PicklistEntry> GlobalStatePicklist = fieldResult.getPicklistValues();
                System.debug('@@@UA GlobalStatePicklist: ' + GlobalStatePicklist);
                return GlobalStatePicklist;
                
           }
           return GlobalStatePicklist;
        }
          set;
      }
      
      // @author: Mohit Modi
      // @date: 6 Jul 2018
      // @description: SFDC1-9133 : Provides the Global State Name and Code Values in form of map
      // @param: NA
      // @return: map of StateCode and StateName
      // @companyname: Vertiba
      public static Map<String,String> mapGlobalStateCodeStateName {
        get {
            if(mapGlobalStateCodeStateName == NULL) {
                mapGlobalStateCodeStateName = new Map<String,String>();
                System.debug('GlobalStatePicklistinside-----'+GlobalStatePicklist);
                for( Schema.PicklistEntry tempPicklistEntry : GlobalStatePicklist) {
                     if(tempPicklistEntry != NULL) {
                        mapGlobalStateCodeStateName.put(tempPicklistEntry.getValue().tolowerCase(),tempPicklistEntry.getLabel().tolowerCase());
                    }
                }
                return mapGlobalStateCodeStateName;
            }
            return mapGlobalStateCodeStateName;
        }
          set;
      }
      
      // @author: Mohit Modi
      // @date: 6 Jul 2018
      // @description: SFDC1-9133 : Provides the Global State Name and Code Values in form of map
      // @param: NA
      // @return: map of StateName and StateCode
      // @companyname: Vertiba
      public static Map<String,String> mapGlobalStateNameStateCode {
        get {
            if(mapGlobalStateNameStateCode == NULL) {
                mapGlobalStateNameStateCode = new Map<String,String>();
                for( Schema.PicklistEntry tempPicklistEntry : GlobalStatePicklist) {
                   if(tempPicklistEntry != NULL) {
                        mapGlobalStateNameStateCode.put(tempPicklistEntry.getLabel().tolowerCase(),tempPicklistEntry.getValue().tolowerCase());
                   }
                }
                return mapGlobalStateNameStateCode;
            }
            return mapGlobalStateNameStateCode;
        }
          set;
      }
      
      // @author: Mohit Modi
      // @date: 6 Jul 2018
      // @description: SFDC1-9133 : This method will validate the Correct State String from the Global State Picklists
      // @param: String of State in form of StateCode or StateName
      // @return: String Value of StateName if Correct value is provided else Blank Value.
      // @companyname: Vertiba
      public static String validateAndGetStateNameValue (String stateStringValue) {
          String stateName = '';
          if(stateStringValue != '' && stateStringValue != NULL) {
              System.debug('stateStringValue------'+stateStringValue);
              System.debug('mapGlobalStateNameStateCode ------'+mapGlobalStateNameStateCode );
              System.debug('mapGlobalStateCodeStateName ------'+mapGlobalStateCodeStateName );
              if(mapGlobalStateNameStateCode != NULL && !mapGlobalStateNameStateCode.isEmpty() && mapGlobalStateNameStateCode.containskey(stateStringValue.tolowerCase())) {
                  stateName = stateStringValue;
              }
              else if(mapGlobalStateCodeStateName != NULL && !mapGlobalStateCodeStateName.isEmpty() && mapGlobalStateCodeStateName.containskey(stateStringValue.tolowerCase())) {
                  stateName = mapGlobalStateCodeStateName.get(stateStringValue.tolowerCase());
              }
          }
          return stateName;
      }
      // @author: Paras Dhingra
      // @date: 20th Jul 2018
      // @description: SFDC1-9240 creating a map to hold globalSobject describe call
      // @param: none
      // @return:  Id
      // @companyname: IHS Markit
      public static Map<String,DescribeSobjectResult> mapGlobalSObjects {
          get {
              if(mapGlobalSObjects==null) {
                  mapGlobalSObjects = new Map<String,DescribeSobjectResult>();
              }
            return mapGlobalSObjects;      
        }
          set;
      }
      // @author: Paras Dhingra
      // @date: 20th Jul 2018
      // @description: SFDC1-9240 creating a map to hold globalSobject describe call
      // @param: none
      // @return:  Id
      // @companyname: IHS Markit
      public static Schema.DescribeSobjectResult getSobjectSchema(String sobjectName) {
          if(!mapGlobalSObjects.containskey(sobjectName)) {
            String[] types = new String[] {sobjectName};
            Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
            mapGlobalSObjects.put(sobjectName,results[0]);
          }
          return mapGlobalSObjects.get(sobjectName);
      }
      // @author: Paras Dhingra
      // @date: 20th Jul 2018
      // @description: SFDC1-9240 creating a map to hold globalSobject describe call
      // @param: none
      // @return:  Id
      // @companyname: IHS Markit
      public static string LoggedInUserProfileName {
          get {
            if(String.isBlank(LoggedInUserProfileName)) {
                LoggedInUserProfileName =[Select Id, Name from Profile where Id=:UserInfo.getProfileId() limit 1].Name;
            }
            return LoggedInUserProfileName;
          }
          set;
      }
      // @author: Prachi Bhasin
      // @date: 24 Jul 2018
      // @param: none
      // @return:  Id
      // @companyname: Vertiba
      public static Id OrderManagementQueueId {
          get {
            if(OrderManagementQueueId == NULL || String.isBlank(OrderManagementQueueId)) {
                OrderManagementQueueId =[select Id from Group where DeveloperName = 'OrderManagement' and Type = 'Queue' LIMIT 1].Id;
            }
            return OrderManagementQueueId;
          }
          set;
      }
    //-----------------------------
    // @author: Paras Dhingra
    // @date: 21st July 2018
    // @param: TriggerParameters
    // @description: SFDC1-9240, SFDC1-9181 - method to get list of currency fields for give sobject
    // @return: None
    //------------------------------
    public static Set<String> getCurrencyFieldNames(String objName) {
        Set<String> setCurrencyFieldNames = new Set<String>();
        //describe the object and get it's field map
        Map <String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map <String, Schema.SObjectField> fieldMap = schemaMap.get(objName).getDescribe().fields.getMap();
        //iterate the map and fetch currency field
        for(Schema.SObjectField sobjField : fieldMap.values()) {
            schema.describefieldresult describeField = sobjField.getDescribe();
            //check for currency type field
            if(describeField.getType()== Schema.DisplayType.Currency) {
                setCurrencyFieldNames.add(describeField.getName());
            }
        }
        return setCurrencyFieldNames;
        
    }
}