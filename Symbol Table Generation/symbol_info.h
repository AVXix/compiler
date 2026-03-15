#include<bits/stdc++.h>
using namespace std;

class symbol_info
{
private:
    string name;
    string type;

    string symbolType; 
    string dataType; 
    int arraySize;
    vector<pair<string, string>> parameters; 

public:
    // This is used to pass lists of variables/parameters up the parse tree in YACC
    vector<symbol_info*> decl_list;

    symbol_info(string name, string type)
    {
        this->name = name;
        this->type = type;
        this->symbolType = "";
        this->dataType = "";
        this->arraySize = 0;
    }
    
    string get_name() { return name; }
    string get_type() { return type; }
    void set_name(string name) { this->name = name; }
    void set_type(string type) { this->type = type; }
    
    string get_symbolType() { return symbolType; }
    void set_symbolType(string symbolType) { this->symbolType = symbolType; }
    
    string get_dataType() { return dataType; }
    void set_dataType(string dataType) { this->dataType = dataType; }
    
    int get_arraySize() { return arraySize; }
    void set_arraySize(int arraySize) { this->arraySize = arraySize; }
    
    vector<pair<string, string>>& get_parameters() { return parameters; }
    void add_parameter(string type, string name) { parameters.push_back({type, name}); }

    ~symbol_info() {}
};