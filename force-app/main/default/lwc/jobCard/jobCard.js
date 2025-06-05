import { api, LightningElement } from 'lwc';

export default class JobCard extends LightningElement {
    @api job;

    get positionAndExperienceLevel(){
        return `${this.job.Position__c} ${this.job.Experience_Level__c}`;	
    }
}