public class TablePagination{

    // ---- Pagination fields
    
    public Integer pageNumber { get; set; }
    public Integer inputPageSize { get; set; }
    public Integer selectedPageSize {get; set;}


    //----- Pagination methods
    
    public Integer getMaxRecordsPerPage(){//marcamos 20 como tam de pagina
        return 10;
    }
    
    public Integer getMinViewedRecords() {
        return (pageNumber-1) * getMaxRecordsPerPage() + 1;
    }

    public Integer getMaxViewedRecords() {
        if ((pageNumber * getMaxRecordsPerPage()) > getResultSize()){
            return getResultSize();
        } else {
            return (pageNumber * getMaxRecordsPerPage());
        }
    }

    public void refreshSize() {
        pageNumber = 1;
    }
    
    public TablePagination(){
        pageNumber = 1;
    }
      public Integer getTotalPages() {
        return Integer.valueof(Math.ceil((Double) wrapContactList.size() /  getMaxRecordsPerPage()));
    }

    public Integer getResultSize() {
        return wrapContactList.size();
    }
    
    public Boolean getHasPrevious() {
        return(pageNumber != 1);
    }

    public Boolean getHasNext() {
        return(pageNumber != getTotalPages());
    }
    
    public Pagereference previous() {
        if (getHasPrevious()) pageNumber--;
        return null;
    }
    public Pagereference next() {
        if (getHasNext()) pageNumber++;
        return null;
    }

    public void first() {
        pageNumber = 1;
    }

    public void last() {
        pageNumber = getTotalPages();
    }

     public List <wrapContact> getPaginatedRecords() {
        List <wrapContact> paginated_records = new List<wrapContact>();
        Integer firstRecordPosition =  getMinViewedRecords() - 1;
        Integer lastRecordPosition =  getMaxViewedRecords() - 1;

        for (integer counter = firstRecordPosition; counter <= lastRecordPosition; counter++) {
            paginated_records.add(wrapContactList[counter]);
        }
        return paginated_records;
    }
     
     //------ Dummy methods
    
    public String getPostalCode(){
        return '';
    }
    
     public String getSelected(){
        return '';
    }
    
    public List<wrapContact> wrapContactList{
        get
        {
            wrapContactList = new List<wrapContact>();
            for(Contact c: [SELECT AccountId,Account.Name,Account.BillingCity ,Account.BillingState,Account.BillingCountry,Account.BillingStreet,Account.BillingPostalCode FROM contact] ){
                wrapContactList.add(new wrapContact(c));
            }
            return wrapContactList;
        }set;} 
   
    public boolean showContactSection {
        get{
        return true;
        }
        set;}
        
            // ---------- WRAPPERS ---------- //
    public class wrapContact {
        public Contact cnt {get; set;}
        public Boolean isSelected {get; set;}

        public wrapContact(Contact c) {
            cnt = c;
            isSelected = false;
        }
    }
    public class wrapAccount {
        public Account acc {get; set;}
        public Boolean isSelected {get; set;}

        public wrapAccount(Account a) {
            acc = a;
            isSelected = false;
        }
    }



}