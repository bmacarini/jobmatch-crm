import { LightningElement, api, wire } from 'lwc';

import { getRecord } from "lightning/uiRecordApi";

import FIRST_NAME_FIELD from '@salesforce/schema/Candidate__c.First_Name__c';
import LAST_NAME_FIELD from '@salesforce/schema/Candidate__c.Last_Name__c';
import LOCATION_FIELD from '@salesforce/schema/Candidate__c.Location__c';
import EMAIL_FIELD from '@salesforce/schema/Candidate__c.Email__c';
import POSITION_FIELD from '@salesforce/schema/Candidate__c.Position__c';
import EXPERIENCE_LEVEL_FIELD from '@salesforce/schema/Candidate__c.Experience_Level__c';
import SKILLS_FIELD from '@salesforce/schema/Candidate__c.Skills__c';
import RESUME_FIELD from '@salesforce/schema/Candidate__c.Resume_URL__c';
import IS_OPEN_TO_REMOTE_FIELD from '@salesforce/schema/Candidate__c.Is_Remote__c';

const FIELDS = [
    FIRST_NAME_FIELD,
    LAST_NAME_FIELD,
    LOCATION_FIELD,
    EMAIL_FIELD,
    POSITION_FIELD,
    EXPERIENCE_LEVEL_FIELD,
    SKILLS_FIELD,
    RESUME_FIELD,
    IS_OPEN_TO_REMOTE_FIELD
];

export default class CandidateDetail extends LightningElement {
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: ['Candidate__c.First_Name__c', 'Candidate__c.Last_Name__c'] })
    candidate;

    get candidateFullName() {
        return this.candidate.data ? `${this.candidate.data.fields.First_Name__c.value} ${this.candidate.data.fields.Last_Name__c.value}` : '';
    }

    fields = FIELDS;

    handleClose() {
        this.dispatchEvent(new CustomEvent('closemodal'));
    }
}