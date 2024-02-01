trigger LeadTriggerIntegracaoBrasilAPI on Lead (after insert) {
    List<Id> leadIdsToProcess = new List<Id>();

    for (Lead newLead : Trigger.new) {
        if (newLead.CNPJ__c != null) {
            leadIdsToProcess.add(newLead.Id);
        }
    }

    if (!leadIdsToProcess.isEmpty()) {
        System.debug('Novos leads a serem processados: ' + leadIdsToProcess);
        IntegracaoBrasilAPI.processLeads(leadIdsToProcess);
    }
}