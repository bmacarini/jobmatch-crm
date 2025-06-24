import { LightningElement, api, wire } from 'lwc';
import getMatches from '@salesforce/apex/Service_JobMatch.getMatches';

export default class JobDetail extends LightningElement {
        @api job;
        matches;
        error;

        get positionAndExperienceLevel() {
                return `${this.job.Position__c} ${this.job.Experience_Level__c}`;
        }

        handleBack() {
                this.dispatchEvent(new CustomEvent('back'));
        }

        get skillList() {
                return this.job?.Skills__c ? this.job.Skills__c.split(';').map(s => s.trim()) : [];
        }

        @wire(getMatches, { jobId: '$job.Id' })
        wiredJobs({ error, data }) {
                console.log('Wire fired. job.Id:', this.job?.Id);
                if (data) {
                        console.log('Matches carregados:', data);
                        this.matches = data;
                        this.error = undefined;
                } else if (error) {
                        console.log('Erro ao carregar match:', error);
                        this.error = error;
                        this.matches = undefined;
                }
        }

}