import { LightningElement, api } from 'lwc';

export default class PostCommentItem extends LightningElement {
    @api postComment;

    get post() {
        return this.postComment.post;
    }

    get comments() {
        return this.postComment.comments;
    }
}