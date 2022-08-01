import { LightningElement,api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

import EVENT_SPEAKER_OBJECT from '@salesforce/schema/Event_Speaker__c'
import SPEAKER_DATA from '@salesforce/apex/EventSpeakerController.getEventSpeakerList'

const COLUMN = [
    {label: 'Speaker name', fieldName : 'Name'},
    {label: 'Speaker Phone', fieldName : 'Phone__c'},
    {label: 'Speaker Email', fieldName : 'Email__c'},
]

const STANDART_TYPE_OF_OBJECT_PAGE = 'standard__objectPage';
const ACTION_NAME_NEW = 'new';
const NAVIGATION_LOCATION = 'RELATED_LIST';
const EVENT_SPEAKER_OBJECT_API_NAME = EVENT_SPEAKER_OBJECT.objectApiName;

export default class EventSpeakers extends NavigationMixin(LightningElement) {
    speakerArray= [];
    column1 = COLUMN
    @api recordId;
 
    @wire(SPEAKER_DATA)
    connectedCallback(){
        SPEAKER_DATA({eventId : this.recordId}).then(res=>{
            this.speakerArray = res;
        }).catch(error=>{
            console.error(JSON.stringify(error))
        })
    }
    navigateToNewEventSpeakerPage() {
        this[NavigationMixin.Navigate]({
            type: STANDART_TYPE_OF_OBJECT_PAGE,
            attributes: {
                objectApiName: EVENT_SPEAKER_OBJECT_API_NAME,
                actionName: ACTION_NAME_NEW
            },
            state: {
                defaultFieldValues: encodeDefaultFieldValues({Event__c: this.recordId}),
                navigationLocation: NAVIGATION_LOCATION
            }
        });
    }

}