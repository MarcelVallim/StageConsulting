trigger SurveyQuestionResponseTrigger on SurveyQuestionResponse (after insert) {
    UpdateOpportunityWithSurveyResponseValue.updateOpportunityWithSurveyResponseValue();
}