function xedeStyle(){
   j$ = jQuery.noConflict();
   var isV = {!isView};
   if(!(isV)){ 
       j$(".requiredField").css("border","1px solid red");
   }
   j$(".changeTab").css({"color":"red!important", "font-weight":"bold!important"});
   if(isV){
       j$("[id$=mainBlock] :input").attr('disabled','true'); 
        j$("[id$=mainBlock] .dataCol").attr('disabled','true');
        j$("[id$=mainBlock] #output").attr('disabled','true').attr('multiple','');
        j$("[id$=mainBlock] option").attr('disabled','true');
    }
    j$("[id$=mainBlock] .viewBtn").removeAttr('disabled');
    j$("[id$=approveBlock] option").removeAttr('disabled');
    j$("[id$=approveBlock] *").removeAttr('disabled'); 
    j$("[id$=OrderRequest] option").removeAttr('disabled');
    j$("[id$=OrderRequest] *").removeAttr('disabled'); 
     j$("[id$=mainBlock] .autogrow").autosize();         
}