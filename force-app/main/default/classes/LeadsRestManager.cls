@RestResource(urlMapping='/Leads/*')
global with sharing class LeadsRestManager {
    
    FINAL Map<Schema.SObjectField, Object> mapFieldsToUpdate = new Map<Schema.SObjectField, Object> {
        Lead.OwnerId => Ids__c.getOrgDefaults().LeadPartnerOwner__c
    };
    
    @HttpPost
    global static List<Lead> createLead(String firstName, String lastName, String phone, String email, String draftLeadSource) {
        List<Lead> leadsCreate = new List<Lead>();
        List<Lead> leadsUpdate = new List<Lead>();
        List<Lead> returnValue = new List<Lead>();

        if (isValid(firstName, lastName, phone, email)) {
            List<Lead> leads = LeadsSelector.selectByNamePhoneEmail(firstName, lastName, email);
            handleCreateUpdate(new LeadWrapper(firstName, lastName, phone, email, draftLeadSource), leads, leadsCreate, leadsUpdate);
        }
        
        insert leadsCreate;
        update leadsUpdate;

        returnValue.addAll(leadsCreate);
        returnValue.addAll(leadsUpdate);

        return returnValue;
    }

    static Boolean isValid(String firstName, String lastName, String phone, String email) {
        return 
                String.isNotBlank(firstName)
            &&  String.isNotBlank(lastName)
            &&  (String.isNotBlank(phone) && phone.length() == 10)
            &&  validEmail(email);
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

    static void handleCreateUpdate(LeadWrapper lw, List<Lead> leads, List<Lead> leadsCreate, List<Lead> leadsUpdate) {
        if (!exists(leads)) { //create
            leadsCreate.add(createRecord(lw.firstName, lw.lastName, lw.phone, lw.email, lw.draftLeadSource));
        } else { //update
            leadsUpdate.addAll(updateFields(leads, lw));
        }
    }

    static Boolean exists(List<Lead> leads) {
        return leads != null && !leads.isEmpty();
    }

    static Lead createRecord(String firstName, String lastName, String phone, String email, String draftLeadSource) {
        return new Lead(
            FirstName = firstName,
            LastName = lastName,
            Phone = phone,
            Email = email,
            DraftSource__c = draftLeadSource
        );
    }

    static List<Lead> updateFields(List<Lead> leads, LeadWrapper lw) {
        Map<Schema.SObjectField, Object> mapFieldsToUpdate = new Map<Schema.SObjectField, Object> {
            Lead.Phone => lw.phone
        };

        return LeadsService.updateFields(leads, mapFieldsToUpdate);
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

}
