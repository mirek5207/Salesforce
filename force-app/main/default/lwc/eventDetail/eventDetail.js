import { LightningElement,api } from 'lwc';
import EVENT_NAME from '@salesforce/schema/Event__c.Name__c';

export default class EventDetail extends LightningElement {
    @api recordId
    @api objectApiName;
    recordName = EVENT_NAME;

}