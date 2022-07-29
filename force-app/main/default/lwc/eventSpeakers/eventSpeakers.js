import { LightningElement,api, wire } from 'lwc';
import speakerData from '@salesforce/apex/EventSpeakerController.getEventSpeakerList'
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';

const column = [
    {label: 'Speaker name', fieldName : 'Name'},
    {label: 'Speaker Phone', fieldName : 'Phone__c'},
    {label: 'Speaker Email', fieldName : 'Email__c'},
]
export default class EventSpeakers extends NavigationMixin(LightningElement) {
    speakerArray= [];
    column1 = column
    @api recordId;

    @wire(speakerData)
    connectedCallback(){
        speakerData({eventId : this.recordId}).then(res=>{
            this.speakerArray = res;
        }).catch(error=>{
            console.error(JSON.stringify(error))
        })
    }
    navigateToNewEventSpeakerPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Event_Speaker__c',
                actionName: 'new'
            },
            state: {
                defaultFieldValues: encodeDefaultFieldValues({Event__c: this.recordId})
            }
        });
    }
    
}