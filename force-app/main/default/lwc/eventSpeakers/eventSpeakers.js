import { LightningElement,api, wire } from 'lwc';
import speakerData from '@salesforce/apex/EventSpeakerController.getEventSpeakerList'
//Parent(Account) to child(Contact & Account)
//Parent(Event) to Child(Event_Speaker & Speaker)
const column = [
    {label: 'Speaker id', fieldName : 'Id'},
    {label: 'Speaker name', fieldName : 'Name'},
    {label: 'Speaker Phone', fieldName : 'Phone__c'},
    {label: 'Speaker Email', fieldName : 'Email__c'},
]
export default class EventSpeakers extends LightningElement {
    @api recordId;
    speakerArray= [];
    column1 = column
    response;
    
    connectedCallback(){
        speakerData({eventId : this.recordId}).then(res=>{
            this.speakerArray = res;
            console.log(this.speakerArray)
        }).catch(error=>{
            console.error(JSON.stringify(error))
        })
    }
    
}