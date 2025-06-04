import { LightningElement } from 'lwc';

export default class JobCard extends LightningElement {
    position = 'Salesforce Developer';
    company = 'Test Company';
    location = 'São Paulo';
    experience_level = 'Senior'

    get cardTitle() {
        return `${this.position} ${this.experience_level}`;
    }
}