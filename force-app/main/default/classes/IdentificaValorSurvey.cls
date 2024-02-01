public class IdentificaValorSurvey {
    @AuraEnabled(cacheable=true)
    public static String retornaValorSurvey(String oppId) {
        System.debug('marcel2' + oppId);
        List<Opportunity> opp = [SELECT Id, AccountId FROM Opportunity WHERE Id = :oppId];
        List<Contact> contatos = [SELECT Id FROM Contact WHERE AccountId = :opp[0].AccountId];


        String choiceValue = null;

        
        if (!contatos.isEmpty()) {
            
            List<SurveyQuestionResponse> respostas = [
                SELECT ChoiceValue 
                FROM SurveyQuestionResponse 
                WHERE Response.SubmitterId IN :contatos 
                ORDER BY CreatedDate DESC 
                LIMIT 1
            ];

            
            if (!respostas.isEmpty()) {
                choiceValue = respostas[0].ChoiceValue;
            }
        }

    System.Debug(choiceValue);
        return choiceValue;
    }
}