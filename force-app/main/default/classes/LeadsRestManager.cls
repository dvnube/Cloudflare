@RestResource(urlMapping='/Leads/*')
global with sharing class LeadsRestManager {
    
    FINAL Map<Schema.SObjectField, Object> mapFieldsToUpdate = new Map<Schema.SObjectField, Object> {
        Lead.OwnerId => Ids__c.getOrgDefaults().LeadPartnerOwner__c
    };
    
    @HttpPost
    global static String createLead(String firstName, String lastName, String phone, String email, String draftLeadSource) {
        ResponseWrapper rw = new ResponseWrapper();

        Boolean firstNameValid = String.isNotBlank(firstName);
        Boolean lastNameValid = String.isNotBlank(lastName);
        Boolean phoneValid = (String.isNotBlank(phone) && phone.length() == 10);
        Boolean emailValid = validEmail(email);

        if (firstNameValid && lastNameValid && phoneValid && emailValid) {
            Lead record = createUpdate(new LeadWrapper(firstName, lastName, phone, email, draftLeadSource));
            rw.LeadId = record.Id;
            rw.Status = Label.Success;
        } else {
            rw.Status = Label.Fail;
            handleError(rw, firstNameValid, Label.ErrorFirstNameNullBlank);
            handleError(rw, lastNameValid, Label.ErrorLastNameNullBlank);
            handleError(rw, phoneValid, Label.ErrorPhoneCharacters);
            handleError(rw, emailValid, Label.ErrorEmailFormat);
        }
        
        return JSON.serialize(rw);
    }

    static Boolean validEmail(String email) {
        //There is no perfect regex expression for matching an email address since there is no formal definition of what constitutes a valid email address.
        //There is an interesting discussion of the issue at http://www.regular-expressions.info/email.html.
        //So, I am using this code from Salesforce doc: https://developer.salesforce.com/docs/atlas.en-us.noversion.mc-apis.meta/mc-apis/using_regular_expressions_to_validate_email_addresses.htm
        //Feel free to send me the pattern you want :)
        String expression = '^\\(([a-zA-Z0-9 _\\-\\.\\+]+)\\)\\ ([a-zA-Z0-9\n' +
               '_\\!\\#\\$\\%\\&amp;\\"\\*\\-\\/\\=\\?\\^\\`\\{\\|\\}\\~\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\\n' +
                '.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\w\n' +
                '_\\!\\#\\$\\%\\&amp;\\"\\*\\-\\/\\=\\?\\^\\`\\{\\|\\}\\~]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3}\n' +
                ')$|^([a-zA-Z0-9 \\w\n' +
                '_\\!\\#\\$\\%\\&amp;\\"\\*\\-\\/\\=\\?\\^\\`\\{\\|\\}\\~\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\\n' +
                '.[0-9]{1,3}\\.)|(([a-zA-Z0-9_\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})$';
        
        Pattern pat = Pattern.compile(expression);
        Matcher matcher = pat.matcher(email);

        return matcher.matches();
    }

    static Lead createUpdate(LeadWrapper lw) {
        List<Lead> leads = LeadsSelector.selectByNamePhoneEmail(lw.firstName, lw.lastName, lw.email);
        Lead record;

        if (!exists(leads)) { //create
            record = createRecord(lw);
            insert record;
        } else { //update
            record = updateFields(leads.get(0), lw);
            update record;
        }

        return record;
    }

    static Boolean exists(List<Lead> leads) {
        return leads != null && !leads.isEmpty();
    }

    static Lead createRecord(LeadWrapper lw) {
        return new Lead(
            FirstName = lw.firstName,
            LastName = lw.lastName,
            Phone = lw.phone,
            Email = lw.email,
            DraftSource__c = lw.draftLeadSource
        );
    }

    static Lead updateFields(Lead record, LeadWrapper lw) {
        Map<Schema.SObjectField, Object> mapFieldsToUpdate = new Map<Schema.SObjectField, Object> {
            Lead.Phone => lw.phone
        };

        return (LeadsService.updateFields(new List<Lead>{record}, mapFieldsToUpdate)).get(0);
    }

    static void handleError(ResponseWrapper rw, Boolean valid, String message) {
        if (!valid) {
            rw.ErrorsMessages.add(message);
        }
    }

    class LeadWrapper {
        String firstName {get; private set;}
        String lastName {get; private set;}
        String phone {get; private set;}
        String email {get; private set;}
        String draftLeadSource {get; private set;}

        public LeadWrapper(String firstName, String lastName, String phone, String email, String draftLeadSource) {
            this.firstName = firstName;
            this.lastName = lastName;
            this.phone = phone;
            this.email = email;
            this.draftLeadSource = draftLeadSource;
        }
    }

    class ResponseWrapper {
        String LeadId {get;set;}
        String Status {get;set;}
        List<String> ErrorsMessages {get;set;}
    }

}
