global class IntegracaoBrasilAPI {
    @future(callout=true)
    public static void processLeads(List<Id> leadIds) {
        List<Lead> leadsToUpdate = [SELECT Id, CNPJ__c, RazaoSocial__c, NomeFantasia__c FROM Lead WHERE Id IN :leadIds];

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

                    if (jsonResponse.containsKey('errors')) {
                        List<Object> errors = (List<Object>)jsonResponse.get('errors');
                        if (!errors.isEmpty()) {
                            Map<String, Object> error = (Map<String, Object>)errors[0];
                            String errorMessage = (String)error.get('message');
                            lead.NomeFantasia__c = 'Erro no CNPJ, Favor Verificar: ' + errorMessage;
                            continue; 
                        }
                    }

                    if (jsonResponse.containsKey('razao_social')) {
                        lead.RazaoSocial__c = (String) jsonResponse.get('razao_social');
                        System.debug('Razão Social atualizada para ' + lead.RazaoSocial__c + ' para o Lead com ID: ' + lead.Id);
                    }

                    if (jsonResponse.containsKey('nome_fantasia')) {
                        lead.NomeFantasia__c = (String) jsonResponse.get('nome_fantasia');
                        System.debug('Nome Fantasia atualizado para ' + lead.NomeFantasia__c + ' para o Lead com ID: ' + lead.Id);
                    }
                } else {
                    lead.NomeFantasia__c = 'Erro na consulta do CNPJ, Status: ' + response.getStatusCode();
                    lead.RazaoSocial__c = 'Erro na consulta do CNPJ, Status: ' + response.getStatusCode();
                }
            }
        }

        if (!leadsToUpdate.isEmpty()) {
            update leadsToUpdate;
            System.debug('Leads atualizados com sucesso: ' + leadsToUpdate);
        }
    }
}
