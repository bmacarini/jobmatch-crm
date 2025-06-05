import { LightningElement, api, wire } from 'lwc';
import getJobs from '@salesforce/apex/Service_FetchJobs.getJobs';

export default class JobList extends LightningElement {
    jobs;
    error;

    @wire(getJobs)
    wiredJobs({ error, data }) {
        if (data) {
            this.jobs = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.jobs = undefined;
        }
    }
}