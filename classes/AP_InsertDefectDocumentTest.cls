@isTest
//This test class is used for two apex classes AP_CreateTestCaseExecution and AP_InsertDefectDocument
global class AP_InsertDefectDocumentTest {
    @isTest
    static void invocableMethod(){
        Project2__c project = new Project2__c(Name = 'Test Project');
        insert project;
        Project2__c projectID = [SELECT Id FROM Project2__c WHERE Name='Test Project']; 
        Project_Release__c release = new Project_Release__c(Name = 'Release 1', StartDate__c =date.parse('09/02/2020'), ReleaseDate__c=date.parse('11/02/2020'), Project__c =projectID.Id);
        insert release;
        Project_Release__c releaseID = [SELECT Id FROM Project_Release__c WHERE Name='Release 1']; 
        Test_Scenario__c testScenario = new Test_Scenario__c(Scenario__c = 'Test Scenario');
        insert testScenario;
        Test_Case__c testCase = new Test_Case__c(Description__c = 'Test Case', Release__c = releaseID.id);
        insert testCase;
        Test_Case__c testCaseID = [SELECT Id FROM Test_Case__c WHERE Id=:testCase.Id]; 
        List<Test_Step__c> testStep = new List<Test_Step__c>{
            new Test_Step__c(
                     Test_Case__c=testCaseID.id,
                        Role__c='Human Resource',
                        Description__c= 'Login to salesforce', 
                        Expected_Result__c= 'Home page displayed'
                    )
                };
        insert testStep;
        Test_Step__c testStepID = [SELECT Id FROM Test_Step__c WHERE Test_Case__c=:testCaseID.id];
        Test_Case_Execution__c testCaseExecution = new Test_Case_Execution__c(Test_Case__c = testCaseID.id);
        insert testCaseExecution;
        Test_Case_Execution__c tceID = [SELECT Id FROM Test_Case_Execution__c WHERE Test_Case__c=:testCaseID.id]; 
        List<Test_Step_Execution__c> testStepExecution = new List<Test_Step_Execution__c>{
            new Test_Step_Execution__c(
                     Test_Step__c = testStepID.id,
                        Role__c = 'Human Resource',
                        Description__c = 'Login to salesforce', 
                        Expected_Result__c = 'Home page displayed',
                		Actual_Result__c = 'Home page not displayed',
                		Status_TSE__c = 'Failed',
                		Test_Case_Execution__c = tceID.id
                    )
                };
        insert testStepExecution;
        List<Project_Defect__c> defect = new List<Project_Defect__c>{
            new Project_Defect__c(
                     Test_Step__c = testStepID.id,
                        ActualResult__c = 'Human Resource',
                        StepToReproduce__c = 'Login to salesforce', 
                		DetectedEnvironment__c = 'DEV',
                		DetectionDate__c = date.parse('11/02/2020'),
                        ExpectedResult__c = 'Home page displayed',
                		Status__c = 'New',
                		Title__c = 'Unable to Login',
                		Type__c = 'Defect',
                		ShortDescription__c = 'Login to salesforce',
                		Severity__c = 'High'
                    )
                };
        insert defect;
        ContentVersion content=new ContentVersion(); 
        content.Title='Header_Picture1'; 
        content.PathOnClient='/' + content.Title + '.jpg'; 
        Blob bodyBlob=Blob.valueOf('Unit Test ContentVersion Body'); 
        content.VersionData=bodyBlob; 
        content.origin = 'H';
        insert content;
        List<String> conDoc = new List<String>();
        
        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=testStepID.id;
        contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid;
        conDoc.add(contentlink.contentdocumentid=[select contentdocumentid from contentversion where id =: content.id].contentdocumentid);
        contentlink.ShareType = 'V';
        contentlink.Visibility = 'AllUsers'; 
        insert contentlink;
        
        List<ContentVersion> conDocID = [SELECT ContentDocumentId FROM ContentVersion WHERE Title = 'Header_Picture1'];
        
        List<AP_CreateTestCaseExecution.invocableRequest> invocableReqList = new List<AP_CreateTestCaseExecution.invocableRequest>();
        AP_CreateTestCaseExecution.invocableRequest request = new AP_CreateTestCaseExecution.invocableRequest();
        request.tse = testStepExecution;
        request.def = defect;
        invocableReqList.add(request);
        
        List<AP_InsertDefectDocument.invocableRequest> invocableReqList2 = new List<AP_InsertDefectDocument.invocableRequest>();
        AP_InsertDefectDocument.invocableRequest request2 = new AP_InsertDefectDocument.invocableRequest();
        request2.defectedRecords = defect;
        request2.contentDocID = conDoc;
        invocableReqList2.add(request2);
        
        Test.startTest();
     	AP_CreateTestCaseExecution.invokeTCE(invocableReqList);
        AP_InsertDefectDocument.invokeTCE(invocableReqList2);
     	Test.stopTest();
    }

}