public without sharing class VFC01_Team {
    public decimal SumOders{
        get{
			AggregateResult groupedResults = [SELECT SUM(TotalAmount) total FROM Order where status = 'Ordered'];
			return (decimal)groupedResults.get('total');

        }
        set;
    }
}