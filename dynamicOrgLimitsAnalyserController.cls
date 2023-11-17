public with sharing class dynamicOrgLimitsAnalyserController {

    @AuraEnabled
    public decimal usedLimit;

    @AuraEnabled
    public String name, maxLimit;

    @AuraEnabled(Cacheable=true)
    public static List<Object> fetchLimits(){
        List<Object> orgLimits = new List<Object>();
        String edition = ([Select OrganizationType from Organization][0].OrganizationType).deleteWhitespace();

        dynamicOrgLimitsAnalyserController staticResource = new dynamicOrgLimitsAnalyserController();
        staticResource.name = 'Static Resources (in MB)';
        staticResource.maxLimit = '250 MB';
        staticResource.usedLimit = ((((decimal)([SELECT SUM(BodyLength)totalSize FROM StaticResource][0]).get('totalSize'))*0.000001)*100/250.0).setScale(2);
        orgLimits.add(staticResource);


        dynamicOrgLimitsAnalyserController customObject = new dynamicOrgLimitsAnalyserController();
        Map<String, Schema.SObjectType> globalDescribe = Schema.getGlobalDescribe();
        Integer customObjectCount = 0;
        for (String objName : globalDescribe.keySet()) {
            if (objName.endsWith('__c')) {
                customObjectCount++;
            }
        }
        customObject.name = 'Custom Objects';
        if (edition == 'EssentialsEdition' || edition == 'ProfessionalEdition') {
            customObject.maxLimit = '0';
            customObject.usedLimit = 0.0;
        }
        else if (edition == 'EnterpriseEdition') {
            customObject.maxLimit = '200';
            customObject.usedLimit = (customObjectCount*100/200.0).setScale(2);
        }
        else if (edition == 'UnlimitedEdition') {
            customObject.maxLimit = '2000';
            customObject.usedLimit = (customObjectCount*100/2000.0).setScale(2);
        }
        else if (edition == 'DeveloperEdition') {
            customObject.maxLimit = '400';
            customObject.usedLimit = (customObjectCount*100/400.0).setScale(2);
        }
        orgLimits.add(customObject);


        dynamicOrgLimitsAnalyserController totalScreenFlow = new dynamicOrgLimitsAnalyserController();
        List<FlowDefinitionView> totalScreenFlowLimit = new List<FlowDefinitionView>([SELECT Count() FROM FlowDefinitionView WHERE ProcessType = 'Flow']);
        totalScreenFlow.name = 'Total Screen Flows';
        if (edition == 'EssentialsEdition' || edition == 'ProfessionalEdition') {
            totalScreenFlow.maxLimit = '5';
            totalScreenFlow.usedLimit = (totalScreenFlowLimit.size()*100/5.0).setScale(2);
        }
        else if (edition == 'EnterpriseEdition' || edition == 'UnlimitedEdition' || edition == 'DeveloperEdition') {
            totalScreenFlow.maxLimit = '4000';
            totalScreenFlow.usedLimit = (totalScreenFlowLimit.size()*100/4000.0).setScale(2);
        }
        orgLimits.add(totalScreenFlow);


        dynamicOrgLimitsAnalyserController activeScreenFlow = new dynamicOrgLimitsAnalyserController();
        List<FlowDefinitionView> activeScreenFlowLimit = new List<FlowDefinitionView>([SELECT Count() FROM FlowDefinitionView WHERE ProcessType = 'Flow' AND IsActive = true]);
        activeScreenFlow.name = 'Active Screen Flows';
        if (edition == 'EssentialsEdition' || edition == 'ProfessionalEdition') {
            activeScreenFlow.maxLimit = '5';
            activeScreenFlow.usedLimit = (activeScreenFlowLimit.size()*100/5.0).setScale(2);
        }
        else if (edition == 'EnterpriseEdition' || edition == 'UnlimitedEdition' || edition == 'DeveloperEdition') {
            activeScreenFlow.maxLimit = '2000';
            activeScreenFlow.usedLimit = (activeScreenFlowLimit.size()*100/2000.0).setScale(2);
        }
        orgLimits.add(activeScreenFlow);


        dynamicOrgLimitsAnalyserController totalAutoLaunchedFlow = new dynamicOrgLimitsAnalyserController();
        List<FlowDefinitionView> totalAutoLaunchedFlowLimit = new List<FlowDefinitionView>([SELECT Count() FROM FlowDefinitionView WHERE ProcessType = 'AutoLaunchedFlow' AND IsActive = true]);
        totalAutoLaunchedFlow.name = 'Total Auto Launched Flows';
        if (edition == 'EssentialsEdition' || edition == 'ProfessionalEdition') {
            totalAutoLaunchedFlow.maxLimit = '5';
            totalAutoLaunchedFlow.usedLimit = (totalAutoLaunchedFlowLimit.size()*100/5.0).setScale(2);
        }
        else if (edition == 'EnterpriseEdition' || edition == 'UnlimitedEdition' || edition == 'DeveloperEdition') {
            totalAutoLaunchedFlow.maxLimit = '4000';
            totalAutoLaunchedFlow.usedLimit = (totalAutoLaunchedFlowLimit.size()*100/4000.0).setScale(2);
        }
        orgLimits.add(totalAutoLaunchedFlow);
        

        dynamicOrgLimitsAnalyserController activeAutoLaunchedFlow = new dynamicOrgLimitsAnalyserController();
        List<FlowDefinitionView> activeAutoLaunchedFlowLimit = new List<FlowDefinitionView>([SELECT Count() FROM FlowDefinitionView WHERE ProcessType = 'AutoLaunchedFlow' AND IsActive = true]);
        activeAutoLaunchedFlow.name = 'Total Auto Launched Flows';
        if (edition == 'EssentialsEdition' || edition == 'ProfessionalEdition') {
            activeAutoLaunchedFlow.maxLimit = '5';
            activeAutoLaunchedFlow.usedLimit = (activeAutoLaunchedFlowLimit.size()*100/5.0).setScale(2);
        }
        else if (edition == 'EnterpriseEdition' || edition == 'UnlimitedEdition' || edition == 'DeveloperEdition') {
            activeAutoLaunchedFlow.maxLimit = '2000';
            activeAutoLaunchedFlow.usedLimit = (activeAutoLaunchedFlowLimit.size()*100/2000.0).setScale(2);
        }
        orgLimits.add(activeAutoLaunchedFlow);

        List<System.OrgLimit> limits = name();
        for (System.OrgLimit var : limits) {
            if (var.getLimit() <> 0) {
                dynamicOrgLimitsAnalyserController otherLimits = new dynamicOrgLimitsAnalyserController();
                otherLimits.name = var.getName();
                otherLimits.maxLimit = String.valueOf(var.getLimit());
                otherLimits.usedLimit = (var.getValue()*100.0/var.getLimit()).setScale(2);
                orgLimits.add(otherLimits);   
            }
        }




        




        
        
        
        
        
        if (edition == 'EssentialsEdition') {
            
        } 
        else if (edition == 'ProfessionalEdition') {
            
        }
        else if (edition == 'EnterpriseEdition') {
            
        }
        else if (edition == 'UnlimitedEdition') {
            
        }
        else if (edition == 'DeveloperEdition') {
            
        }


        return orgLimits;
    }

    public static List<System.OrgLimit> name() {
        return OrgLimits.getAll();
    }

}
