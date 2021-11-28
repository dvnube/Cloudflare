import { LightningElement, wire, api } from "lwc";
import getPosts from "@salesforce/apex/PostsCommentsController.getPosts";
import getCommentsMethod from "@salesforce/apex/PostsCommentsController.getComments";

export default class PostsCommentsContainer extends LightningElement {
  @api pagination;
  posts;
  postsComments;
  loaded = false;
  error;
  selectedPage;

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
          ...this.posts.map((post, index) => {
            return {
              post: post,
              page: Math.ceil((index + 1) / this.pagination),
              comments: comments.filter((comment) => comment.postId == post.id)
            };
          })
        ];
        this.selectedPage = 1;
        this.loaded = true;
      })
      .catch((error) => {
        this.error = error;
        console.log("error: " + error);
      });
  }

  get pages() {
    let pages = [];
    this.postsComments.forEach((postComments) => {
      if (!pages[postComments.page - 1]) {
        pages[postComments.page - 1] = {
          pageNumber: postComments.page,
          posts: []
        };
      }
      pages[postComments.page - 1].posts = [
        ...pages[postComments.page - 1].posts,
        { postComments: postComments }
      ];
    });
    return pages;
  }

  get pagesFiltered() {
    return this.pages.filter((page) => page.pageNumber == this.selectedPage);
  }

  get totalPages() {
    return this.pages.length;
  }

  changePagination(event) {
    this.selectedPage = event.detail;
  }

  nextPage(event) {
    let nextPage = this.selectedPage + 1;
    if (nextPage > this.totalPages) {
      this.selectedPage = 1;
    } else {
      this.selectedPage = nextPage;
    }
  }
  previousPage(event) {
    let previousPage = this.selectedPage - 1;
    if (previousPage < 1) {
      this.selectedPage = this.totalPages;
    } else {
      this.selectedPage = previousPage;
    }
  }
}
