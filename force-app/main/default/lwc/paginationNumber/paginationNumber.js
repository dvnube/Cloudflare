import { LightningElement, api } from "lwc";

export default class PaginationNumber extends LightningElement {
  @api pageNumber;
  @api selectedPage;

  get paginationClass() {
    if (this.pageNumber == this.selectedPage) {
      return "active";
    }
    return "";
  }

  changePagination() {
    this.dispatchEvent(
      new CustomEvent("changepagination", {
        detail: this.pageNumber
      })
    );
  }
}
