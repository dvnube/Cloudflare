import { LightningElement, wire, track } from "lwc";
import getPosts from "@salesforce/apex/PostsCommentsController.getPosts";
import getCommentsMethod from "@salesforce/apex/PostsCommentsController.getComments";

export default class PostsCommentsContainer extends LightningElement {
  posts;
  postsComments;  
  loaded = false;
  error;

  @wire(getPosts)
  wiredPosts({ error, data }) {
    if (data) {
      this.posts = JSON.parse(data);
      this.getComments();
    } else if (error) {
      console.log("error: " + JSON.stringify(error));
      this.error = JSON.stringify(error);
    }
  }

  getComments() {
    getCommentsMethod()
      .then((result) => {
        const comments = JSON.parse(result);
        this.postsComments = [
          ...this.posts.map((post) => {
            return {
              post: post,
              comments: comments.filter((comment) => comment.postId == post.id)
            };
          })
        ];
        this.loaded = true;
      })
      .catch((error) => {
        this.error = error;
        console.log("error: " + error);
      });
  }
}
