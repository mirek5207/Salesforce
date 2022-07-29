import { LightningElement,api, wire } from 'lwc';
import attendeeData from '@salesforce/apex/EventAttendeeController.getEventAttendeeList'

const column = [
    {label: 'Attendee name', fieldName : 'name'},
    {label: 'Attendee email', fieldName : 'email'},
    {label: 'Company name', fieldName : 'companyName'},
    {label: 'Location(city)', fieldName : 'city'},
]

export default class EventAttendee extends LightningElement {
    attendeeArray= [];
    column1 = column
    @api recordId;

    @wire(attendeeData)
    connectedCallback(){
        attendeeData({eventId : this.recordId}).then(res=>{
            console.log(res)
            this.attendeeArray = res;
            console.log(this.attendeeArray)
        }).catch(error=>{
            console.error(JSON.stringify(error))
        })
    }
}