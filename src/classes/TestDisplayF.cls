//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This class is used in POLK WRF.
    // @return: NA
    //----------------------------- 
@isTest(seeAllData=false)
public class TestDisplayF {
//-----------------------------
    // @author: Legacy POLK Application
    // @company: VERTIBA/POLK
    // @date: 17 Oct 2017
    // @param: 
    // @description:  This method is used in POLK WRF.
    // @return: NA
    //----------------------------- 
    static testmethod void testDisplayF() {
        DisplayF displayf = new DisplayF('0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;30;31');
      
        List<SelectOption> so = displayf.getDF();
        System.assertEquals(true, displayf.gethasValues());
        
        so = displayf.getC1();
        so = displayf.getC2();
        so = displayf.getC3();
        so = displayf.getC4();
        so = displayf.getC5();
        so = displayf.getC6();
        so = displayf.getC7();
        so = displayf.getC8();
        so = displayf.getC9();
        so = displayf.getC10();
        so = displayf.getC11();
        so = displayf.getC12();
        so = displayf.getC13();
        so = displayf.getC14();
        so = displayf.getC15();
        so = displayf.getC16();
        so = displayf.getC17();
        so = displayf.getC18();
        so = displayf.getC19();
        so = displayf.getC20();
        so = displayf.getC21();
        so = displayf.getC22();
        so = displayf.getC23();
        so = displayf.getC24();
        so = displayf.getC25();
        so = displayf.getC26();
        so = displayf.getC27();
        so = displayf.getC28();
        so = displayf.getC29();
        so = displayf.getC30();
        so = displayf.getC31();
        so = displayf.getC32();
        
        DisplayF displayf2 = new DisplayF();
        System.assertNotEquals(false, displayf2.gethasValues());
        
   
   }

}