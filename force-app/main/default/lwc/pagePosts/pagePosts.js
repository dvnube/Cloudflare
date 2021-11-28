import { LightningElement, api } from 'lwc';

export default class PagePosts extends LightningElement {
    @api page;

    get postComments() {
        return this.page.postComments;
    }
}