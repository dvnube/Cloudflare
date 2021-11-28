public with sharing class LeadsRestResponseWrapper {
    public String LeadId;
    public String Status;
    public List<Error> ErrorsMessages;

    public class Error {
        public String FieldName {get; private set;}
        public String Message {get; private set;}

        public Error(String fieldName, String message) {
            this.FieldName = fieldName;
            this.Message = message;
        }
    }
}
