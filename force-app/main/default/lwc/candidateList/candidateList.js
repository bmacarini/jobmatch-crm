import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class CandidateList extends NavigationMixin(LightningElement) {
    @api match;

    get candidateFullName() {
        return `${this.match.Candidate__r.First_Name__c} ${this.match.Candidate__r.Last_Name__c}`;
    }

    handleCandidateSelect() {
        console.log('Botão clicado. Candidate ID:', this.match.Candidate__c);
        const selectedCandidateEvent = new CustomEvent('candidateselected', {
            detail: this.match.Candidate__c
        });
        this.dispatchEvent(selectedCandidateEvent);
    }

}