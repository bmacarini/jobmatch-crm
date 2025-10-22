import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMatches from '@salesforce/apex/Service_JobMatch.getMatches';

import POSITION_FIELD from '@salesforce/schema/Job__c.Position__c';
import EXPERIENCE_LEVEL_FIELD from '@salesforce/schema/Job__c.Experience_Level__c';
import EMPLOYMENT_TYPE_FIELD from '@salesforce/schema/Job__c.Employment_Type__c';
import OFFERED_SALARY_FIELD from '@salesforce/schema/Job__c.Offered_Salary__c';
import SKILLS_FIELD from '@salesforce/schema/Job__c.Skills__c';
import LOCATION_FIELD from '@salesforce/schema/Job__c.Location__c';
import IS_REMOTE_FIELD from '@salesforce/schema/Job__c.Is_Remote__c';
import IS_ACTIVE_FIELD from '@salesforce/schema/Job__c.Is_Active__c';


export default class JobDetail extends LightningElement {
        @api job;
        matches;
        error;

        isModalOpen = false;
        modalRecordId;

        get positionAndExperienceLevel() {
                return `${this.job.Position__c} ${this.job.Experience_Level__c}`;
        }

        handleBack() {
                this.dispatchEvent(new CustomEvent('back'));
        }

        fields = [
                POSITION_FIELD,
                EXPERIENCE_LEVEL_FIELD,
                EMPLOYMENT_TYPE_FIELD,
                OFFERED_SALARY_FIELD,
                SKILLS_FIELD,
                LOCATION_FIELD,
                IS_REMOTE_FIELD,
                IS_ACTIVE_FIELD
        ];

        handleSuccess() {
        const evt = new ShowToastEvent({
            title: 'Job updated successfully.',
            variant: 'success',
        });
        this.dispatchEvent(evt);
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

        get hasMatches() {
                return Array.isArray(this.matches) && this.matches.length > 0;
        }

        handleCandidateSelected(event) {
                console.log('Evento recebido no jobDetail. ID:', event.detail);
                this.modalRecordId = event.detail;
                this.isModalOpen = true;
        }

        handleCloseModal() {
                this.isModalOpen = false;
        }

}