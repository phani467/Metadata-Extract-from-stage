//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This test class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest
public class TestGenericHistoryComponentController {
//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    @isTest public static void testHistoryController() {
        //instantiate object just to make sure the controller is reading it properly
        //Note: History is not tracked during tests, so this is kind of redundant

        AdClaim__c ac = TestUtility.newAdClaim();
        
        //instantiate controller and point it towards the created object
        GenericHistoryComponentController con = new GenericHistoryComponentController();
        con.myObject = ac;
        GenericHistoryComponentController.objectLabel = 'AdClaim__c';
        con.scroll = false;
        
        //Retrieve history with controller
        List<GenericHistoryComponentController.objectHistoryLine> history = con.getObjectHistory();
        //this should be empty, so assert that
        System.assertEquals(0, history.size());
        
        //mock a history list
        List<sObject> historyList = new List<AdClaim__History>();
        AdClaim__History historyLine = new AdClaim__History(Field='Name');
        historyList.add(historyLine);
        historyLine = new AdClaim__History(Field='Created');
        historyList.add(historyLine);
        history = con.processHistoryLines(historyList);
        //Make sure it processed something
        System.assertEquals(2, history.size());
        printHistory(history); //for debugging purposes
        //check history item 1 - changing name
        GenericHistoryComponentController.objectHistoryLine line = history[0];
        System.assertEquals('Null', line.theDate);
        System.assertEquals(null, line.who);
        System.assertEquals(null, line.userId);
        System.assert(line.action.contains('Changed') && line.action.contains('Ad Claim Number'));
        
        //check history item 2 - creation
        line = history[1];
        System.assertEquals('', line.theDate);
        System.assertEquals('', line.who);
        System.assertEquals(null, line.userId);
        System.assert(line.action.contains('Created'));
    }
    //-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    private static void printHistory(List<GenericHistoryComponentController.objectHistoryLine> history) {
        System.debug('Object History: ');
        for(GenericHistoryComponentController.objectHistoryLine line : history) {
            List<String> fillers = new String[] {line.theDate, line.who, line.userId, line.action};
            System.debug(String.format('{0} | {1} | {2} | {3}', fillers));
        }
    }
}