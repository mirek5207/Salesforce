import { LightningElement, api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import EVENT_OBJECT from '@salesforce/schema/Event__c';
import EVENT_NAME from '@salesforce/schema/Event__c.Name__c';
import EVENT_ORGANIZER from '@salesforce/schema/Event__c.Organizer__c';
import EVENT_START_DATE from '@salesforce/schema/Event__c.Start_Date_Time__c';
import EVENT_END_DATE from '@salesforce/schema/Event__c.End_Date_Time__c';
import EVENT_MAX_ATTENDEES from '@salesforce/schema/Event__c.Max_Seats__c';
import EVENT_DETAIL from '@salesforce/schema/Event__c.Event_Detail__c';
import EVENT_LOCATION from '@salesforce/schema/Event__c.Location__c'

export default class EventForm extends NavigationMixin(LightningElement) {
    eventObject = EVENT_OBJECT;
    eventOrganizer = EVENT_ORGANIZER;
    eventLocation = EVENT_LOCATION;
    @api objectApiName;
    formFields = {
        Name:'',
        Organizer:'',
        Start_Date: '',
        End_Date: '',
        Max_Attendees: '',
        Location: '',
        Detail:''
    }
    changeHandler(event){
        const{value, name} = event.target
        this.formFields = { ...this.formFields, [name]:value}
    }
    changeHandlerOrganizer(event) {
        if(!event.preventDefault){
            event.preventDefault();
        }
        this.formFields.Organizer = event.target.value;
    }
    changeHandlerLocation(event){
        if(!event.preventDefault){
            event.preventDefault();
        }
        this.formFields.Location = event.target.value;
    }
    navigateToRecordPage() {
        console.log(this.recordId)
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Event__c',
                actionName: 'view'
            }
        });
    }

    handleSave(){
        const fields = {}
        fields[EVENT_NAME.fieldApiName] = this.formFields.Name
        fields[EVENT_ORGANIZER.fieldApiName] = this.formFields.Organizer
        fields[EVENT_START_DATE.fieldApiName] = this.formFields.Start_Date
        fields[EVENT_END_DATE.fieldApiName] = this.formFields.End_Date
        fields[EVENT_MAX_ATTENDEES.fieldApiName] = this.formFields.Max_Attendees
        fields[EVENT_LOCATION.fieldApiName] = this.formFields.Location
        fields[EVENT_DETAIL.fieldApiName] = this.formFields.Detail
        let recordInput = {apiName: EVENT_OBJECT.objectApiName, fields}
        createRecord(recordInput).then(event =>{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Event created',
                    variant: 'success',
                }),
            );
            console.log('after insert record')
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.id,
                    objectApiName: this.objectApiName,
                    actionName: 'view'
                }
            });
        }).catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: error.body.message,
                    variant: 'error',
                }),
            )
        });
        
    }

}