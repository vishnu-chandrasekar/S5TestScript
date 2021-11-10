global class AP_CreateTestCaseExecution {
    @InvocableMethod(label='Insert Test Case Execution')
    global static List<List<Project_Defect__c>> invokeTCE(invocableRequest[] reqList){
        List<Test_Step_Execution__c> tse1 = new List<Test_Step_Execution__c>();
        List<Project_Defect__c> def1 = new List<Project_Defect__c>();
        List<List<Project_Defect__c>> wrapper = new List<List<Project_Defect__c>>();
        System.debug('hello'+ reqList[0].def);
        System.debug('hello tse'+ reqList[0].tse);
        tse1 = reqList[0].tse;
        def1 = reqList[0].def;
        if(tse1 != null &&  def1 != null){
        Map<Id,Test_Step_Execution__c> a = new Map<Id,Test_Step_Execution__c>();
        for(Test_Step_Execution__c t : tse1){
            a.put(t.Test_Step__c,t);
        }
        for(Project_Defect__c d : def1){
            System.debug('defect before value'+d);
            Test_Step_Execution__c var = a.get(d.Test_Step__c);
            if(var!= null){
                d.Test_Step_Execution_Id__c = var.Id;
                d.Test_Case_Execution_Id__c = var.Test_Case_Execution__c;
            }
            System.debug('defect after value'+d);
        }
        List<Project_Defect__c> responseList=new List<Project_Defect__c>();
        for (Project_Defect__c defect: def1 ){       
        responseList.add(defect);       
    	}
        wrapper.add(responseList);
    	
        }
		return wrapper;
    }
    global class invocableRequest{
        @InvocableVariable
        global List<Test_Step_Execution__c> tse;
        
        @InvocableVariable
        global List<Project_Defect__c> def;
    }

}