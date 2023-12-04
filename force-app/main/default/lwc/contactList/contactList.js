import { LightningElement,wire,api } from 'lwc';
import CONTACT_FIRSTNAME from '@salesforce/schema/Contact.FirstName';
import CONTACT_LASTNAME from '@salesforce/schema/Contact.LastName';
import CONTACT_EMAIL from '@salesforce/schema/Contact.Email';
import getContacts from '@salesforce/apex/ContactController.getContacts';
import { reduceErrors } from 'c/ldsUtils';

const COLUMNS = [
    { label: 'FirstName', fieldName: CONTACT_FIRSTNAME.fieldApiName, type: 'text' },
    { label: 'LastName', fieldName: CONTACT_LASTNAME.fieldApiName, type: 'text' },
    { label: 'Email', fieldName: CONTACT_EMAIL.fieldApiName, type: 'text' }
];
export default class ContactList extends LightningElement {
    columns = COLUMNS;
    @wire(getContacts)
    contacts

    get errors() {
        return (this.contacts.error) ?
            reduceErrors(this.contacts.error) : [];
    }
}