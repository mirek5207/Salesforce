import { LightningElement } from 'lwc';

export default class Parent extends LightningElement {
    childValue = 0;
    handleClick(){
        this.childValue = this.template.querySelector("c-lwc-child").getValue;
    }
}