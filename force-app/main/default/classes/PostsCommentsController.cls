public with sharing class PostsCommentsController {
    @AuraEnabled
    public static String getPosts() {
        String response;
        try {
            response = sendRequest('https://jsonplaceholder.typicode.com/posts');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return response;
    }

    @AuraEnabled
    public static String getComments() {
        String response;
        try {
            response = sendRequest('https://jsonplaceholder.typicode.com/comments');
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return response;
    }


    static String sendRequest(String endpoint) {
        HttpResponse resp;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');

            resp = (new Http()).send(req);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return resp.getBody();
    }
}
