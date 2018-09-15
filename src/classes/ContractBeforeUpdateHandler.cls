/**
* @author: Mohit Modi
* @date: 27 September 2017
* @description: SFDC1-4363. Before Update dispatcher event handler class that calls the functions in ContractMethods.
* @companyname: VERTIBA
* @lastModifiedBy: Prachi Bhasin
* @lastModifiedSprint: Sprint 26 SFDC1-8056 added call to method updatePGIOwnerField
*/
public class ContractBeforeUpdateHandler extends TriggerHandlerBase {
    /** 
  * @author: Mohit Modi
  * @date: 27 September 2017
  * @description: SFDC1-4363. Handler class called by the trigger framework to carry out the specific actions on
  *    Contract object before Update
  * @param: TriggerParameters Contains the trigger parameters which includes the record(s) that got created.
  * @companyname: VERTIBA
  * 
  * @updated by: Harshit Singhal
  * @updated date:21 Jun 2018
  * @updated description: SFDC1-8533 Added call to setOpptyOwnerEmail() method
  * 
  * @return: void
  */
  public override void mainEntry(TriggerParameters tp) {
      ContractMethods.CopyPrimaryContactToContract(tp);
      ContractMethods.updatePGIOwnerField(tp);
      ContractMethods.updateCountersignatureFields(tp);
      ContractMethods.updateNoticeAddressFieldsOnContractFromLegalEntity(tp);
      ContractMethods.updateClientStateOfIncorporationFromClientLegalEntity(tp);
      ContractMethods.populateBillToFieldsonContractwithGlobalAllianceFields (tp); 
      ContractMethods.validateLegalEntityOnContract(tp);
      ContractMethods.setOpptyOwnerEmail(tp);
  }
}