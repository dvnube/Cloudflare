import { LightningElement, api } from 'lwc';

export default class CommentItem extends LightningElement {
    @api post;
    @api comment;
}