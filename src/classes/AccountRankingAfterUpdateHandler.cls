//******************************************************************************
// @author Tran-Vu Tran, adapted from Uttam's code
// @date 02nd April 2018
// @description SFDC1-7592 Account Ranking Lift & Shift from Legacy Markit
//******************************************************************************

public class AccountRankingAfterUpdateHandler extends TriggerHandlerBase {
    
    public override void mainEntry(TriggerParameters tp) {
        AccountRankingMethods.CalculateRanking(tp);
    }

}