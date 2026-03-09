#include "symbol_info.h"
#include <vector>
#include <list>
#include <string>
#include <fstream>
using namespace std;

class scope_table
{
private:
    int bucket_count;
    int unique_id;
    scope_table *parent_scope = NULL;
    vector<list<symbol_info *>> table;

    int hash_function(string name)
    {
        // write your hash function here
		int sum = 0;
        for (char c: name){
            sum += static_cast<int>(c);
        }
        return sum % bucket_count;
    }

public:
    scope_table(int bucket_count, int unique_id, scope_table *parent_scope) {
        this->bucket_count = bucket_count;
        this->unique_id = unique_id;
        this->parent_scope = parent_scope;
        table.resize(bucket_count);
    }

    scope_table *get_parent_scope() {
        return parent_scope;
    }

    int get_unique_id() {
        return unique_id;
    }

    symbol_info *lookup_in_scope(symbol_info* symbol) {
        int index = hash_function(symbol->getname());
        for (auto it = table[index].begin(); it != table[index].end(); ++it) {
            if ((*it)->getname() == symbol->getname()) {
                return *it;
            }
        }
        return nullptr;
    }

    bool insert_in_scope(symbol_info* symbol) {
        int index = hash_function(symbol->getname());
        if (lookup_in_scope(symbol) != nullptr) {
            return false;
        }
        table[index].push_back(symbol);
        return true;
    }

    bool delete_from_scope(symbol_info* symbol) {
        int index = hash_function(symbol->getname());
        for (auto it = table[index].begin(); it != table[index].end(); ++it) {
            if ((*it)->getname() == symbol->getname()) {
                table[index].erase(it);
                return true;
            }
        }
        return false;
    }
    void print_scope_table(ofstream& outlog);
    ~scope_table();

    // you can add more methods if you need
};

// complete the methods of scope_table class
void scope_table::print_scope_table(ofstream& outlog)
{
    outlog << "ScopeTable # "+ to_string(unique_id) << endl;

    //iterate through the current scope table and print the symbols and all relevant information
}