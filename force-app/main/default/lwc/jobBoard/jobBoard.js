import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class JobBoard extends LightningElement {
    showDetail = false;
    selectedJob = null;

    handleJobSelected(event) {
        this.selectedJob = event.detail;
        this.showDetail = true;
    }

    handleBack() {
        this.selectedJob = null;
        this.showDetail = false;
    }
}