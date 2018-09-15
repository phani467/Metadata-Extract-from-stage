//
// @author Paras Dhingra
// @date: 17th Aug 2017 
// @description : SFDC1-1837, SFDC1-2043 wrapper class for product selector
// @company : IHS Markit
//
public class ProductSelectorWrapperClass {
	
    @AuraEnabled public boolean isSelected;
    @AuraEnabled public String productName;
    @AuraEnabled public String productId;
    @AuraEnabled public Product2 product;
    
}