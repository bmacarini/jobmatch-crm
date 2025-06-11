import { LightningElement, api } from 'lwc';

export default class JobDetail extends LightningElement {
        @api job;

        get positionAndExperienceLevel() {
                return `${this.job.Position__c} ${this.job.Experience_Level__c}`;
        }

        handleBack() {
                this.dispatchEvent(new CustomEvent('back'));
        }

        get skillList() {
                return this.job?.Skills__c ? this.job.Skills__c.split(';').map(s => s.trim()) : [];
        }


}