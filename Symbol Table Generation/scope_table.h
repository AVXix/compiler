#include "symbol_info.h"

class scope_table
{
private:
    int bucket_count;
    int unique_id;
    scope_table *parent_scope = NULL;
    vector<list<symbol_info *>> table;

    int hash_function(string name)
    {
        int sum = 0;
        for(char c : name) sum += c;
        return sum % bucket_count;
    }

public:
    scope_table(int bucket_count, int unique_id, scope_table *parent_scope);
    scope_table *get_parent_scope();
    int get_unique_id();
    symbol_info *lookup_in_scope(symbol_info* symbol);
    bool insert_in_scope(symbol_info* symbol);
    bool delete_from_scope(symbol_info* symbol);
    void print_scope_table(ofstream& outlog);
    ~scope_table();
};

scope_table::scope_table(int bucket_count, int unique_id, scope_table *parent_scope) {
    this->bucket_count = bucket_count;
    this->unique_id = unique_id;
    this->parent_scope = parent_scope;
    table.resize(bucket_count);
}

scope_table* scope_table::get_parent_scope() {
    return parent_scope;
}

int scope_table::get_unique_id() {
    return unique_id;
}

symbol_info* scope_table::lookup_in_scope(symbol_info* symbol) {
    int idx = hash_function(symbol->get_name());
    for(auto sym : table[idx]) {
        if(sym->get_name() == symbol->get_name()) return sym;
    }
    return NULL;
}

bool scope_table::insert_in_scope(symbol_info* symbol) {
    if(lookup_in_scope(symbol) != NULL) return false;
    int idx = hash_function(symbol->get_name());
    table[idx].push_back(symbol);
    return true;
}

bool scope_table::delete_from_scope(symbol_info* symbol) {
    int idx = hash_function(symbol->get_name());
    for(auto it = table[idx].begin(); it != table[idx].end(); ++it) {
        if((*it)->get_name() == symbol->get_name()) {
            table[idx].erase(it);
            return true;
        }
    }
    return false;
}

void scope_table::print_scope_table(ofstream& outlog)
{
    outlog << "ScopeTable # " << unique_id << endl;
    for(int i = 0; i < bucket_count; i++) {
        if(!table[i].empty()) {
            outlog << i << " --> " << endl;
            for(auto sym : table[i]) {
                outlog << "< " << sym->get_name() << " : " << sym->get_type() << " >" << endl;
                outlog << sym->get_symbolType() << endl;
                if(sym->get_symbolType() == "Variable") {
                    outlog << "Type: " << sym->get_dataType() << endl;
                } else if(sym->get_symbolType() == "Array") {
                    outlog << "Type: " << sym->get_dataType() << endl;
                    outlog << "Size: " << sym->get_arraySize() << endl;
                } else if(sym->get_symbolType() == "Function Definition" || sym->get_symbolType() == "Function Declaration") {
                    outlog << "Return Type: " << sym->get_dataType() << endl;
                    outlog << "Number of Parameters: " << sym->get_parameters().size() << endl;
                    outlog << "Parameter Details: ";
                    auto params = sym->get_parameters();
                    for(int j = 0; j < params.size(); j++) {
                        outlog << params[j].first;
                        if(params[j].second != "") outlog << " " << params[j].second;
                        if(j < params.size() - 1) outlog << ", ";
                    }
                    outlog << endl;
                }
                outlog << endl;
            }
        }
    }
}

scope_table::~scope_table() {
    table.clear();
}