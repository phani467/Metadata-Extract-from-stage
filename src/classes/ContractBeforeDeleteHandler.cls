/**
* @author: Prachi Bhasin
* @date: 26 Feb 2018
* @description: SFDC1-4739. Creating this class ot handle before delete event.
* @companyname: VERTIBA
*/
public class ContractBeforeDeleteHandler extends TriggerHandlerBase {
    /** 
  * @author: Prachi Bhasin
  * @date: 26 Feb 2018
  * @description: SFDC1-4739. Handler class called by the trigger framework to carry out the specific actions on
  *    Contract object before insert
  * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
  * @companyname: VERTIBA
  * @return: void
  */
  public override void mainEntry(TriggerParameters tp) {
      ContractMethods.preventContractDeletion(tp);
  }
}