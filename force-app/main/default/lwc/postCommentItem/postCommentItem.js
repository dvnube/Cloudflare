import SystemModstamp from '@salesforce/schema/Account.SystemModstamp';
import { LightningElement, api } from 'lwc';

export default class PostCommentItem extends LightningElement {
    @api postComment;

    get post() {
        console.log('postcomment: ' + JSON.stringify(this.postComment));
        return this.postComment.post;
    }

    get comments() {
        console.log('comments: ' + JSON.stringify(this.postComment.comments));
        return this.postComment.comments;
    }
}