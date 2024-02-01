public with sharing class UpdateOpportunityWithSurveyResponseValue {

    public static void updateOpportunityWithSurveyResponseValue() {
        List<SurveyQuestionResponse> latestSurveyResponses = [SELECT Id, ResponseValue
                                                                   FROM SurveyQuestionResponse
                                                                   ORDER BY CreatedDate DESC
                                                                   LIMIT 1];

        if (!latestSurveyResponses.isEmpty() && latestSurveyResponses[0].ResponseValue != null) {
            List<Opportunity> opportunitiesToUpdate = [SELECT Id, SurveyQuestionResponse__c
                                                        FROM Opportunity
                                                        WHERE SurveyQuestionResponse__c != null];

            if (!opportunitiesToUpdate.isEmpty()) {
                for (Opportunity opportunityToUpdate : opportunitiesToUpdate) {
                    opportunityToUpdate.SurveyQuestionResponse__c = latestSurveyResponses[0].ResponseValue;
                }

                update opportunitiesToUpdate;
            }
        }
    }
}