#include "scope_table.h"

class symbol_table
{
private:
    // here *current scope  is a pointer to the current scope
    scope_table *current_scope;
    // bucket_count is the number of buckets in the hash table
    int bucket_count;
    int current_scope_id;
    ofstream& outlog;

public:
    public: 
    // Constructor
    symbol_table(int bucket_count, ofstream& log_stream) 
        : bucket_count(bucket_count), current_scope_id(0), outlog(log_stream) 
    {
        current_scope = new scope_table(bucket_count, ++current_scope_id, nullptr);
        cout << "First ScopeTable with ID "<< current_scope->get_unique_id()<<" created"<<endl;
        outlog << "First ScopeTable with ID " << current_scope->get_unique_id() << " created" << endl;
        
    }

    //jokhon new scope create korbe tokhon eta call korbe
    void enter_scope() {
    scope_table* new_scope = new scope_table(bucket_count, ++current_scope_id, current_scope); // Create a new scope
    current_scope = new_scope; // Make the new scope the current scope
    cout << "New ScopeTable with ID"<< current_scope->get_unique_id()<<" created"<<endl;
    outlog << "New ScopeTable with ID " << current_scope->get_unique_id() << " created" << endl;
    
    
    
}

    //jokhon scope theke ber hobe tokhon eta call korbe
    void exit_scope(){
        if (current_scope == nullptr){
            return;
        }
        cout << "ScopeTable with ID"<< current_scope->get_unique_id()<<" removed"<<endl;
        outlog << "ScopeTable with ID " << current_scope->get_unique_id() << " removed" << endl;
        scope_table* parent_scope = current_scope->get_parent_scope();
        delete current_scope;
        //current_scope_id--;
        current_scope = parent_scope;   
    }
    

    //jokhon new symbol pabe tokhon eta call korbe
    bool insert(symbol_info* symbol) {
        if (current_scope == nullptr) {
            // No scope to insert the symbol
            return false;
        }
        // Insert the symbol in the current scope
        //calls this function of scope_table
        return current_scope->insert_in_scope(symbol);
    }
    
	
    int getCurrentScopeID(){
        return current_scope->get_unique_id();
    }

   
    
    // this function will print all the scopes by calling scope table print function iteratively
    void print_all_scopes(ofstream& outlog){
        outlog<<"################################"<<endl<<endl;
        scope_table *temp = current_scope;
        while (temp != NULL)
        {   int id= temp->get_unique_id();
            temp->print_scope_table(outlog,id);
            temp = temp->get_parent_scope();
        }
        outlog<<"################################"<<endl<<endl;
    }

};

    