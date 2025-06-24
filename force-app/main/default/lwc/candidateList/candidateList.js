import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CandidateList extends NavigationMixin(LightningElement) {
    @api match;

    get candidateFullName() {
        return `${this.match.Candidate__r.First_Name__c} ${this.match.Candidate__r.Last_Name__c}`;
    }

    navigateNext() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.match.Candidate__c,
                objectApiName: 'Candidate__c',
                actionName: 'view'
            }
        })
    }
}