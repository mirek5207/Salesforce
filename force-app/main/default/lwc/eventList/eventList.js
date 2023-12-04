import { LightningElement, wire } from 'lwc';
import EVENT_DATA from '@salesforce/apex/EventController.getLiveEventsList';
import EVENT_OBJECT from '@salesforce/schema/Event__c';
import EVENT_ID from '@salesforce/schema/Event__c.Id';

const COLUMN = [
    {label: 'Name', fieldName : 'name'},
    {label: 'Organizer Name', fieldName : 'organizerName'},
    {label: 'Location(city)', fieldName : 'city'},
    {label: 'Details', fieldName : 'eventDetail'},
]

export default class EventList extends LightningElement {
    column = COLUMN;
    eventArray = [];
    eventArrayFiltered = [];
    eventObject = EVENT_OBJECT;
    eventId = EVENT_ID;

    @wire(EVENT_DATA)
    connectedCallback(){
        EVENT_DATA().then(res=>{
            this.eventArray = res;
            this.eventArrayFiltered = res;
        }).catch(error=>{
            console.error(JSON.stringify(error))
        })
    }

    searchInput(event){
        const value = event.target.value.toLowerCase()
        const filteredEvents = [];
        this.eventArray.forEach(event => {
            if(event.name.toLowerCase().includes(value) || 
              (event.city != undefined && event.city.toLowerCase().includes(value)) ||
              (event.startDateTime.toLowerCase().toString().includes(value.toLowerCase().toString()))){    
                filteredEvents.push(event)
            }    
        });
        this.eventArrayFiltered = filteredEvents;
    }
}