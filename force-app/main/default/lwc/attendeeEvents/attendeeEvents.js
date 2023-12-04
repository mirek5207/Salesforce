import { LightningElement,api } from 'lwc';
import ATTENDEE_EVENTS_DATA from '@salesforce/apex/EventAttendeeController.getAttendeeEventsList' 

const COLUMN = [
    {label: 'Name', fieldName : 'name'},
    {label: 'Organizer Name', fieldName : 'organizerName'},
    {label: 'Event Date', fieldName : 'startDateTime'},
    {label: 'Location(city)', fieldName : 'city'}
]

export default class AttendeeEvents extends LightningElement {
    @api recordId
    column = COLUMN;
    upcomingEvents = [];
    pastEvents = [];
    
    connectedCallback(){
        ATTENDEE_EVENTS_DATA({attendeeId : this.recordId, isLive : true}).then(res=>{
            this.upcomingEvents = res;
        }).catch(error=>{
            console.error(JSON.stringify(error))
        });
        ATTENDEE_EVENTS_DATA({attendeeId : this.recordId, isLive : false}).then(res=>{
            this.pastEvents = res;
        }).catch(error=>{
            console.error(JSON.stringify(error))
        });
    }
}