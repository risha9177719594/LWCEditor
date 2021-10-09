import { LightningElement } from 'lwc';
import getLWCs from '@salesforce/apex/LWCEditor.getLWCs';
import getResources from '@salesforce/apex/LWCEditor.getLWCResource';
import updateResources from '@salesforce/apex/LWCEditor.updateLWCResource';
import createLWCResource from '@salesforce/apex/LWCEditor.createLWCResource';

export default class LWCEditor extends LightningElement {
		
    listLWCs;
		listResources;
		error;
		successMessage;
		bundleId = '';
		resourceId = '';
		filePath='';
		source = '';
		format = '';
		isModalOpen = false;
		targetsList = '';
		
		//new LWC component variables
		developerName;
		includeCSS=false;
		isExposed=false;
		targets = [];
		//new LWC component variables
		formats = ['font', 'size', 'bold', 'italic', 'underline', 'strike', 'list', 'indent', 'align', 'link', 'clean', 'table', 'header', 'color','code'];
		
		connectedCallback() {
				this.loadLWCs();
		}
	loadLWCs() {
		getLWCs()
			.then(result => {
				console.log(result);
				let parsedValue = JSON.parse(result)
				this.listLWCs = parsedValue.records;
			})
			.catch(error => {
				this.error = error;
			});
	}
		
	loadResources(event) {
			if(event.target.name!==undefined){
					this.bundleId = event.target.name;
					getResources({bundleId:event.target.name})
							.then(result => {
							console.log(result);
							let parsedValue1 = JSON.parse(result)
							this.listResources = parsedValue1.records;
					})
							.catch(error => {
							console.log(error);
							this.error = error;
					});
			}		
	}
		loadSource(event) {
				for(let acc of this.listResources){
						if(acc.Id ===  event.target.id.substring(0,18)){
								console.log('334455' );
								console.log(acc.FilePath );
								console.log(acc.Source );
								this.resourceId = acc.Id;
								this.filePath = acc.FilePath;
								this.source = acc.Source;
								this.format = acc.Format;
						}else{
								console.log('error');
								console.log('else');
						}
				}
		}
		
		handleSaveLWC() {
				console.log('111222' );
				console.log(this.bundleId );
				console.log(this.filePath );	
				console.log('111222' );		
				updateResources({id:this.resourceId ,fpath:this.filePath,bundleId:this.bundleId,format:this.format, source:JSON.stringify(this.source)})
							.then(result => {
							console.log(result);
							//let parsedValue1 = JSON.parse(result)
							//this.listResources = parsedValue1.records;
					})
							.catch(error => {
							console.log(error);
							this.error = error;
					});
		}
		
		updateSource(event) {
				console.log('update' );
				console.log(event.target.value );
				this.source = event.target.value;
		}
		sCheckboxValue(event) {
				console.log('setCheckboxValue' );
				console.log(event.target.name );
				
				if(event.target.name === 'cssOption'){
						this.includeCSS = true;
				}
				if(event.target.name === 'exposedOption'){
						this.isExposed = true;
				}
				
				if(event.target.name === 'lightning__HomePage' || event.target.name === 'lightning__RecordPage' || event.target.name === 'lightning__AppPage' || event.target.name === 'lightning__Tab'){
						this.targets.push(event.target.name);
						this.targetsList =  this.targetsList + '\n <target>'+event.target.name+'</target>';
				}
		}
		sCompName(event) {
				console.log('sCompName' );
				this.developerName = event.target.value;
		}
		
		handleNewLWC() {
				this.isModalOpen = true;
		}
		closeModal() {
				this.isModalOpen = false;
		}
		submitDetails() {
				const d = new Date();
				let sourceHTML = '<!-- @description: \n @author: ChangeMeIn@UserSettingsUnder.SFDoc \n @last modified on: '+d.toDateString()+' \n @last modified by: ChangeMeIn@UserSettingsUnder.SFDoc-->\n<template>\n</template>';
				let sourceJS = 'import { LightningElement } from \'lwc\'; \n export default class Empty extends LightningElement { \n }';
				let sourceMETA = '<?xml version="1.0"?>\n <LightningComponentBundle xmlns="http://soap.sforce.com/2006/04/metadata"> \n <apiVersion>50</apiVersion> \n <isExposed>'+this.isExposed+'</isExposed> \n 	<targets> '+this.targetsList+'\n </targets> \n </LightningComponentBundle>';
				createLWCResource({description:'' ,developerName:this.developerName,isExposed:this.isExposed,includeCSS:this.includeCSS,targets:this.targets,sourceHTML:JSON.stringify(sourceHTML),sourceJS:JSON.stringify(sourceJS),sourceMETA:JSON.stringify(sourceMETA) })
							.then(result => {
							console.log(result);
						this.successMessage = result;
								setTimeout(function () {
										window.location.reload();
								}, 5000);
							
							//let parsedValue1 = JSON.parse(result)
							//this.listResources = parsedValue1.records;
					})
							.catch(error => {
							console.log(error);
							this.error = error;
					});
				//createLWCResource(String description,String developerName,String isExposed,List<String> targets
				this.isModalOpen = false;
		}
}