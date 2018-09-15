//-----------------------------
// @author: Uttam Arya
// @date: unknown
// @param: NA
// @description: Class to hold unit test methods for Account Ranking
// @return: NA
// @updated: 30 March 2018
// @updated by: Tran-Vu Tran
// @update reason: SFDC1-7592 migrated from Markit legacy codes
//-----------------------------

@isTest
public class TestAccountRankings {
    
    static testMethod void TestAccountRankingCalculation() {

        Test.startTest();
        
        Account acc1 = TestUtility.createTestAccountWithStreet('One', 'Street One', true);
        Account acc2 = TestUtility.createTestAccountWithStreet('Two', 'Lane Two', true);
        Account acc3 = TestUtility.createTestAccountWithStreet('Three', 'Blvd Three', true);
        Account acc4 = TestUtility.createTestAccountWithStreet('Four', 'Drive Four', true);
        
        list <Account> AccountList = [Select id from account];
        
        list <AccountRanking__c> rrListToUpdate = new list <AccountRanking__c>();
        
        AccountRanking__c rr1 = createAccountRanking(acc1.id, 'India', 'AUM', 100000); 
        AccountRanking__c rr2 = createAccountRanking(acc1.id, 'Nepal', 'Assets', 100000); 
        AccountRanking__c rr3 = createAccountRanking(acc1.id, 'Japan', 'Assets', 200000); 
        AccountRanking__c rr4 = createAccountRanking(acc1.id, 'Belgium', 'AUM', 100000); 
        AccountRanking__c rr5 = createAccountRanking(acc1.id, 'Congo', 'AUM', 100000); 
        AccountRanking__c rr6 = createAccountRanking(acc1.id, 'United Kingdom', 'AUM', 100000); 
        AccountRanking__c rr7 = createAccountRanking(acc1.id, 'United States', 'AUM', 100000); 
        AccountRanking__c rr8 = createAccountRanking(acc2.id, 'India', 'AUM', 100000); 
        AccountRanking__c rr9 = createAccountRanking(acc3.id, 'India', 'AUM', 200000); 
        
        rr2.Value__c = 300000;
        
        rrListToUpdate.add(rr2);
        
        rr8.Value__c = 150000;
        
        rrListToUpdate.add(rr8);
        GlobalVariables.skipAccountRanking = false;
        update rrListToUpdate;
        Map<Id, AccountRanking__c> mapAccount = new Map<Id, AccountRanking__c>(rrListToUpdate);
        // assert Account ranking
        List<AccountRanking__c> acctRanking = [Select id, Rank__c from AccountRanking__c where Id in:mapAccount.keySet() ];
        Map<Id, Decimal> mapAccountRanking = new Map<Id, Decimal>();
        for (AccountRanking__c ar: acctRanking) {
            mapAccountRanking.put(ar.Id, ar.Rank__c);
        }
        System.assertEquals(1, mapAccountRanking.get(rr2.Id));
        System.assertEquals(2, mapAccountRanking.get(rr8.Id));
        
        Test.stopTest();
    }
    
    static AccountRanking__c createAccountRanking(Id accountID, String country, String criteria, Integer value) {
        AccountRanking__c rr = new AccountRanking__c();
        rr.Account__c = accountID; 
        rr.Value__c = value;
        rr.RankCountry__c = country;
        rr.Source__c = 'Factset';
        rr.Criteria__c = criteria;
        rr.ValueAsOf__c = Date.today();
        insert rr;
        return rr;
    }
     
}