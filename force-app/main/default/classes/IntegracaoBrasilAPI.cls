global class IntegracaoBrasilAPI {
    @future(callout=true)
    public static void processLeads(List<Id> leadIds) {
        List<Lead> leadsToUpdate = [SELECT Id, CNPJ__c FROM Lead WHERE Id IN :leadIds];

        for (Lead lead : leadsToUpdate) {
            if (lead.CNPJ__c != null) {
                String cnpj = lead.CNPJ__c;
                String apiUrl = 'https://brasilapi.com.br/api/cnpj/v1/' + cnpj;

                HttpRequest request = new HttpRequest();
                request.setEndpoint(apiUrl);
                request.setMethod('GET');

                Http http = new Http();
                HttpResponse response = http.send(request);

                if (response.getStatusCode() == 200) {
                    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());

                    if (jsonResponse.containsKey('razao_social')) {
                        lead.RazaoSocial__c = (String) jsonResponse.get('razao_social');
                        System.debug('Razão Social atualizada para ' + lead.RazaoSocial__c + ' para o Lead com ID: ' + lead.Id);
                    }

                    if (jsonResponse.containsKey('nome_fantasia')) {
                        lead.NomeFantasia__c = (String) jsonResponse.get('nome_fantasia');
                        System.debug('Nome Fantasia atualizado para ' + lead.NomeFantasia__c + ' para o Lead com ID: ' + lead.Id);
                    }
                }
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
            System.debug('Leads atualizados com sucesso: ' + leadsToUpdate);
        }
    }
}