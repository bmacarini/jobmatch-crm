import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import POSITION_FIELD from '@salesforce/schema/Job__c.Position__c';
import EXPERIENCE_LEVEL_FIELD from '@salesforce/schema/Job__c.Experience_Level__c';
import LOCATION_FIELD from '@salesforce/schema/Job__c.Location__c';
import COMPANY_FIELD from '@salesforce/schema/Job__c.Company__c';
import SKILLS_FIELD from '@salesforce/schema/Job__c.Skills__c';
import IS_REMOTE_FIELD from '@salesforce/schema/Job__c.Is_Remote__c';
import OFFERED_SALARY_FIELD from '@salesforce/schema/Job__c.Offered_Salary__c';
import EMPLOYMENT_TYPE_FIELD from '@salesforce/schema/Job__c.Employment_Type__c';
import IS_ACTIVE_FIELD from '@salesforce/schema/Job__c.Is_Active__c';

export default class JobCreate extends LightningElement {
    fields = [
        POSITION_FIELD,
        EXPERIENCE_LEVEL_FIELD,
        LOCATION_FIELD,
        COMPANY_FIELD,
        IS_REMOTE_FIELD,
        OFFERED_SALARY_FIELD,
        EMPLOYMENT_TYPE_FIELD,
        IS_ACTIVE_FIELD,
        SKILLS_FIELD
    ];

    handleSuccess() {
        const evt = new ShowToastEvent({
            title: 'Job created successfully.',
            variant: 'success',
        });
        this.dispatchEvent(evt);
    }
}