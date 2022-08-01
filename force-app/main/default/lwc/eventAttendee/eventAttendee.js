import { LightningElement,api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import ATTENDEE_DATA from '@salesforce/apex/EventAttendeeController.getEventAttendeeList';

import EVENT_ATTENDEE_OBJECT from '@salesforce/schema/Event_Attendee__c';

const COLUMN = [
    {label: 'Attendee name', fieldName : 'name'},
    {label: 'Attendee email', fieldName : 'email'},
    {label: 'Company name', fieldName : 'companyName'},
    {label: 'Location(city)', fieldName : 'city'},
]
const STANDART_TYPE_OF_OBJECT_PAGE = 'standard__objectPage';
const ACTION_NAME_NEW = 'new';
const NAVIGATION_LOCATION = 'RELATED_LIST';
const EVENT_ATTENDEE_OBJECT_API_NAME = EVENT_ATTENDEE_OBJECT.objectApiName;

export default class EventAttendee extends NavigationMixin(LightningElement) {
    @api recordId;
    column1 = COLUMN;
    attendeeArray = [];
    
    
    @wire(ATTENDEE_DATA)
    connectedCallback(){
        ATTENDEE_DATA({eventId : this.recordId}).then(res=>{
            this.attendeeArray = res;
        }).catch(error=>{
            console.error(JSON.stringify(error))
        })
    }
    navigateToNewEventAttendeePage() {
        this[NavigationMixin.Navigate]({
            type: STANDART_TYPE_OF_OBJECT_PAGE,
            attributes: {
                objectApiName: EVENT_ATTENDEE_OBJECT_API_NAME,
                actionName: ACTION_NAME_NEW
            },
            state: {
                defaultFieldValues: encodeDefaultFieldValues({Event__c: this.recordId}),
                navigationLocation: NAVIGATION_LOCATION
            }
        });
    }
}