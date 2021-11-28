public with sharing class PostsCommentsController {
    @AuraEnabled(cacheable=true)
    public static String getPosts() {
        System.debug('getposts');
        String response;
        try {
            response = sendRequest('https://jsonplaceholder.typicode.com/posts');
            System.debug('response: ' + response);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return response;
    }

    @AuraEnabled(cacheable=true)
    public static String getComments() {
        System.debug('getcomments');
        String response;
        try {
            response = sendRequest('https://jsonplaceholder.typicode.com/comments');
            System.debug('response: ' + response);
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
