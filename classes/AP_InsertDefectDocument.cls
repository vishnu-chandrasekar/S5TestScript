global class AP_InsertDefectDocument {
    @InvocableMethod(label='Insert Defect Documents')
    global static void invokeTCE(invocableRequest[] reqList){
        System.debug('Defected Records'+ reqList[0].defectedRecords);
        System.debug('Content Document ID'+ reqList[0].contentDocID);
        List<Project_Defect__c> defectedRecordLst = new List<Project_Defect__c>();
        List<String> conDocIDLst = new List<String>();
        List<String> conDocID = new List<String>();
        defectedRecordLst = reqList[0].defectedRecords;
        conDocIDLst = reqList[0].contentDocID;
        System.debug('Content Document ID'+ conDocIDLst.Size());
        System.debug('Content'+ conDocIDLst);
        for(String c : conDocIDLst){
    		if(c != null){
     			conDocID.add(c);
    			}
			}
        System.debug('the list which has only id'+ conDocID);
        
        
        if((defectedRecordLst != null && !conDocID.isEmpty())){
        List<ContentDocumentLink> conDocLinkLst = [SELECT ContentDocumentId,LinkedEntityId,ShareType,Visibility FROM ContentDocumentLink WHERE ContentDocumentId IN: conDocIDLst];
		System.debug('Content Document Link'+ conDocLinkLst);
        List<ContentDocumentLink> cdlList = new List<ContentDocumentLink>();
        List<ContentDocumentLink> insertLink = new List<ContentDocumentLink>();
        List<ContentDocumentLink> deleteLink = new List<ContentDocumentLink>();
		for(ContentDocumentLink con : conDocLinkLst){
    		if(con.ShareType == 'V'){
     			cdlList.add(con);
    			}
			}
       	for(ContentDocumentLink cdl: cdlList){
            for(Project_Defect__c def: defectedRecordLst){
                if(def.Test_Step__c == cdl.LinkedEntityId){
  					ContentDocumentLink newclnk = cdl.clone();
  					newclnk.linkedentityid = def.Id ; 
                    insertLink.add(newclnk);
                    deleteLink.add(cdl);
                }
              }
        	}
        insert insertLink; //Insert the new ContentDocumentLink with new linkedEntity.
  		Delete deleteLink; //Delete the Old ContentDocumentLink with old linkedEntity.
        }  
    }
    
    
    global class invocableRequest{
        @InvocableVariable(
        Label='Defected Records' 
        Description='Defect records for which documents must be attached'
        Required=false)
    	global List<Project_Defect__c> defectedRecords;
        
    	@InvocableVariable(
        Label='Content Document ID' 
        Description='Content Document ID got from screen component'
        Required=false)
    	global List<String> contentDocID;
    }

}