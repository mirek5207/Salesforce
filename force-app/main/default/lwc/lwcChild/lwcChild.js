import { LightningElement, api } from 'lwc';

export default class LwcChild extends LightningElement {
    #value;

    handleValueChange(event){
        this.#value = event.target.value;
        console.log(this.#value)
    }

    @api get getValue(){
        return this.#value;
    }

}