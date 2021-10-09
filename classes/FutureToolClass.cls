global class FutureToolClass {
    @future(callout=true)
    public static void createResource(String description,String developerName,String isExposed,String includeCSS,List<String> targets,String sourceHTML,String sourceJS,String sourceMETA)
    {
        system.debug(targets);
        String sb = 'services/data/v49.0/tooling/sobjects/LightningComponentBundle';
        HttpRequest reqSB = new HttpRequest(); 
        String trag = '';
        String targForMetafile='';
        for(integer i=0;i<targets.size();i++){
            if(i==targets.size()-1){
                trag = trag+'"'+targets.get(i)+'"';
            }else{
                trag = trag+'"'+targets.get(i)+'",';
            }
            targForMetafile = targForMetafile+' \n <target>'+targets.get(i)+'</target>';
        }
        String targ = '"targets": {"target": ['+trag+']}';
        //String targ = '"targets": {"target": ["lightning__RecordPage","lightning__AppPage","lightning__HomePage"]}';
        
        String bodySB = '{"FullName":"'+developerName+'","Metadata":{"apiVersion":48,"description": null,"isExplicitImport": false,"isExposed": '+isExposed+',"masterLabel": "'+developerName+'",'+targ+'}}';
        system.debug('body : '+bodySB);    
        reqSB.setEndpoint('callout:LWCToolingAPI/'+sb);
        reqSB.setMethod('POST');
        reqSB.setBody(bodySB);
        reqSB.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(reqSB);
        system.debug(res.getBody());
        //{"id":"0Rb7F000000XzcqSAC","success":true,"errors":[],"warnings":[],"infos":[]}
        JSONParser parser = JSON.createParser(res.getBody());
        System.JSONToken jt;
        String bundleId;
        //system.debug(resMc.getBody());
        while (parser.nextToken() != null) {   
            if(parser.getCurrentToken()==JSONToken.FIELD_NAME && parser.getText() == 'id'){
                jt = parser.nextToken();
            }   
            if(parser.getCurrentToken()==JSONToken.VALUE_STRING && jt== parser.getCurrentToken()){
                bundleId = parser.getText();
            }
        }
        String source;
        String fpath;
        String format;
        
        system.debug('source');
        system.debug(source);
        system.debug('bundleId');
        system.debug(bundleId);
        
        
        //create js file
        //se format
        format = 'js';
        //se format
        //create FilePath
        fpath = 'lwc/'+developerName+'/'+developerName+'.'+format;
        //create FilePath
        //set Dummy Source
        source = sourceJS;
        //source = '"import { LightningElement } from \'lwc\'; \n export default class Empty extends LightningElement { \n }"';
        //set Dummy Source
        String s = 'services/data/v49.0/tooling/sobjects/LightningComponentResource';
        HttpRequest reqJS = new HttpRequest();
        
        String body = '{"FilePath": "'+fpath+'","LightningComponentBundleId":"'+bundleId+'","Format":"'+format+'", "Source" : ' + source + '}';
        system.debug('body : '+body);    
        reqJS.setEndpoint('callout:LWCToolingAPI/'+s);
        reqJS.setMethod('POST');
        reqJS.setBody(body);
        reqJS.setHeader('Content-Type', 'application/json');
        http = new Http();
        res = http.send(reqJS);
        System.debug(res.getBody());
        //create js file
        //
        
        //create html file
        //create FilePath
        fpath = 'lwc/'+developerName+'/'+developerName+'.html';
        //create FilePath
        //se format
        format = 'html';
        //se format
        //set Dummy Source
        source = sourceHTML;
        //source = '"<!-- @description: \n @author: ChangeMeIn@UserSettingsUnder.SFDoc \n @last modified on: '+system.today()+' \n @last modified by: ChangeMeIn@UserSettingsUnder.SFDoc-->\n<template>\n</template>"';
        //set Dummy Source
        s = 'services/data/v49.0/tooling/sobjects/LightningComponentResource';
        HttpRequest reqHtml = new HttpRequest();
        
        body = '{"FilePath": "'+fpath+'","LightningComponentBundleId":"'+bundleId+'","Format":"'+format+'", "Source" : ' + source + '}';
        system.debug('body : '+body);    
        reqHtml.setEndpoint('callout:LWCToolingAPI/'+s);
        reqHtml.setMethod('POST');
        reqHtml.setBody(body);
        reqHtml.setHeader('Content-Type', 'application/json');
        Http httpH = new Http();
        res = httpH.send(reqHtml);
        System.debug(res.getBody());
        //create html file
        
        //create meta file
        //se format
        format = 'js-meta.xml';
        //se format
        //create FilePath
        fpath = 'lwc/'+developerName+'/'+developerName+'.'+format;
        //create FilePath
        //set Dummy Source
        source = sourceMETA;
        //source = '"<?xml version="1.0"?>\n <LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata"> \n <apiVersion>50</apiVersion> \n <isExposed>'+isExposed+'</isExposed> \n 	<targets> '+targForMetafile+'\n </targets> \n </LightningComponentBundle>"';
        //set Dummy Source
        s = 'services/data/v49.0/tooling/sobjects/LightningComponentResource';
        HttpRequest reqMeta = new HttpRequest();
        
        body = '{"FilePath": "'+fpath+'","LightningComponentBundleId":"'+bundleId+'","Format":"'+format+'", "Source" : ' + source + '}';
        system.debug('body : '+body);    
        reqMeta.setEndpoint('callout:LWCToolingAPI/'+s);
        reqMeta.setMethod('POST');
        reqMeta.setBody(body);
        reqMeta.setHeader('Content-Type', 'application/json');
        http = new Http();
        res = http.send(reqMeta);
        System.debug(res.getBody());
        //create meta file
        if(includeCSS == 'true' || includeCSS == 'TRUE' || includeCSS == 'True'){
            //create css file if needed
        //se format
        format = 'css';
        //se format
        //create FilePath
        fpath = 'lwc/'+developerName+'/'+developerName+'.'+format;
        //create FilePath
        //set Dummy Source
        source = '"#dummy css"';
        //set Dummy Source
        s = 'services/data/v49.0/tooling/sobjects/LightningComponentResource';
        HttpRequest reqCSS = new HttpRequest();
        
        body = '{"FilePath": "'+fpath+'","LightningComponentBundleId":"'+bundleId+'","Format":"'+format+'", "Source" : ' + source + '}';
        system.debug('body : '+body);    
        reqCSS.setEndpoint('callout:LWCToolingAPI/'+s);
        reqCSS.setMethod('POST');
        reqCSS.setBody(body);
        reqCSS.setHeader('Content-Type', 'application/json');
        http = new Http();
        res = http.send(reqCSS);
        System.debug(res.getBody());
        //create css file if needed
        }
        
        
        /*
        String s = 'services/data/v49.0/tooling/sobjects/LightningComponentResource';
        HttpRequest req = new HttpRequest();
        
        String body = '{"FilePath": "'+fpath+'","LightningComponentBundleId":"'+bundleId+'","Format":"'+format+'", "Source" : ' + source + '}';
        system.debug('body : '+body);    
        req.setEndpoint('callout:LWCToolingAPI/'+s);
        req.setMethod('POST');
        req.setBody(body);
        req.setHeader('Content-Type', 'application/json');
        http = new Http();
        res = http.send(req);
        while (res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        System.debug(res.getBody());*/
        //return res.getBody();
    }
    @future(callout=true)
    public static void updateResource(String id,String fpath,String bundleId,String format, String source)
    {   
        system.debug('source');
        system.debug(source);
        system.debug('bundleId');
        system.debug(bundleId);
        /*
String metContainerId='';
HttpRequest reqMc = new HttpRequest();
reqMc.setEndpoint('callout:LWCToolingAPI/'+'services/data/v37.0/tooling/sobjects/MetadataContainer/');
reqMc.setBody('{"Name":"TestContainer"}');
reqMc.setMethod('POST');
reqMc.setHeader('Content-Type', 'application/json');
Http httpMc = new Http();
HTTPResponse resMc = httpMc.send(reqMc);
JSONParser parser = JSON.createParser(resMc.getBody());
//system.debug(resMc.getBody());
System.JSONToken jt;
while (parser.nextToken() != null) {            
if(parser.getCurrentToken()==JSONToken.FIELD_NAME && parser.getText() == 'Id'){
jt = parser.nextToken();
}   
if(parser.getCurrentToken()==JSONToken.VALUE_STRING && jt== parser.getCurrentToken()){
metContainerId = parser.getText();
}
system.debug(metContainerId);
}
if(metContainerId==''){
String query1='SELECT+Id+FROM+MetadataContainer+WHERE+name=\'TestContainer\'';
String s1 = 'services/data/v49.0/tooling/query/?q='+query1;
HttpRequest reqMc1 = new HttpRequest();
reqMc1.setEndpoint('callout:LWCToolingAPI/'+s1);
reqMc1.setMethod('GET');
resMc = httpMc.send(reqMc1);
//system.debug(resMc.getBody());
parser = JSON.createParser(resMc.getBody());
//system.debug(resMc.getBody());
while (parser.nextToken() != null) {   
if(parser.getCurrentToken()==JSONToken.FIELD_NAME && parser.getText() == 'Id'){
jt = parser.nextToken();
}   
if(parser.getCurrentToken()==JSONToken.VALUE_STRING && jt== parser.getCurrentToken()){
metContainerId = parser.getText();
}
system.debug(metContainerId);
}
}
//reqMc.setEndpoint('http://***instance***.salesforce.com/services/data/v37.0/tooling/sobjects/MetadataContainer/ + containerID + '/');
//reqMc.setMethod('GET');
*/
        String s = 'services/data/v49.0/tooling/sobjects/LightningComponentResource/'+id;
        HttpRequest req = new HttpRequest();
        
        String body = '{"Source" : ' + source + '}';
        system.debug('body : '+body);    
        req.setEndpoint('callout:LWCToolingAPI/'+s);
        req.setMethod('PATCH');
        req.setBody(body);
        req.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HTTPResponse res = http.send(req);
        while (res.getStatusCode() == 302) {
            req.setEndpoint(res.getHeader('Location'));
            res = new Http().send(req);
        }
        System.debug(res.getBody());
        //return res.getBody();
    }
}