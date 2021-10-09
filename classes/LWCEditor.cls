public class LWCEditor {
    @AuraEnabled
    public static String getLWCs() {
        String query='SELECT+Id,Description,DeveloperName,IsExposed,TargetConfigs+FROM+LightningComponentBundle';
        String s = 'services/data/v49.0/tooling/query/?q='+query;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LWCToolingAPI/'+s);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        while (res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        System.debug(res.getBody());
        /*
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
        req.setHeader('Content-Type', 'application/json');
        String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        String query='SELECT+Id,DeveloperName+FROM+LightningComponentBundle';
        //string query='Select+id,Name+from+WorkflowRule'; //use this query to get Workflow Rule
        req.setEndpoint(SFdomainUrl+'/services/data/v49.0/tooling/query/?q='+query);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse response = h.send(req);
        system.debug(response.getBody());*/
        return res.getBody();
    }
    
    @AuraEnabled
    public static String getLWCResource(String bundleId) {
        String query='SELECT+Id,LightningComponentBundleId,Format,FilePath,Source+FROM+LightningComponentResource+WHERE+LightningComponentBundleId=\'' + bundleId +  '\'';
        String s = 'services/data/v49.0/tooling/query/?q='+query;
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:LWCToolingAPI/'+s);
        req.setMethod('GET');
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        while (res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        System.debug(res.getBody());
        /*
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID()); //Get user Session ID
        req.setHeader('Content-Type', 'application/json');
        String SFdomainUrl=URL.getSalesforceBaseUrl().toExternalForm();
        String query='SELECT+Id,DeveloperName+FROM+LightningComponentBundle';
        //string query='Select+id,Name+from+WorkflowRule'; //use this query to get Workflow Rule
        req.setEndpoint(SFdomainUrl+'/services/data/v49.0/tooling/query/?q='+query);
        req.setMethod('GET');
        Http h = new Http();
        HttpResponse response = h.send(req);
        system.debug(response.getBody());*/
        return res.getBody();
    }
    @AuraEnabled
    public static String getLWCList() {
        //List<LightningComponentBundle> lwcList = [SELECT Id, DeveloperName, CreatedBy.Name, CreatedDate, LastModifiedDate FROM LightningComponentBundle];
        //system.debug('lwcList : '+lwcList.size());
        return '';
    }
    
    @AuraEnabled
    public static String updateLWCResource(String id,String fpath,String bundleId,String format, String source) {
        //FutureToolClass.createResource(fpath, bundleId, format, source);
        FutureToolClass.updateResource(id,fpath, bundleId, format, source);
        
        return 'update call sent';
        //return '';
    }
    @AuraEnabled
    public static String createLWCResource(String description,String developerName,String isExposed,String includeCSS,List<String> targets,String sourceHTML,String sourceJS,String sourceMETA) {
        //FutureToolClass.createResource(fpath, bundleId, format, source);
        //FutureToolClass.createResource(fpath, bundleId, format, source);
        FutureToolClass.createResource(description, developerName, isExposed, includeCSS, targets,sourceHTML,sourceJS,sourceMETA);
        return 'update call sent';
        //return '';
    }

}