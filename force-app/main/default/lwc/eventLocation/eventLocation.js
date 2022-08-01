import { LightningElement,api,wire} from 'lwc';

import locationData from '@salesforce/apex/EventLocationController.getLocationDataByEventId'

export default class EventLocation extends LightningElement {
    @api recordId;
    locationArray = [];
    locationIsEmpty = false;
    @wire(locationData)
    connectedCallback(){
        locationData({eventId : this.recordId}).then(res=>{
            console.log('Response:',JSON.stringify(res))
            if(res == null){
                this.locationIsEmpty = true;
            }
            else{
                this.locationIsEmpty = false;
                this.locationArray = res;
            }
        }).catch(error=>{
            console.error(JSON.stringify(error))
        })
    }

}