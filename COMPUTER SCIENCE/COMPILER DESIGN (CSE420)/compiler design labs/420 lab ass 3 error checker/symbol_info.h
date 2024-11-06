#include<bits/stdc++.h>
using namespace std;

class symbol_info
{

private:
// define necessary private members
    string name;
    string type;
    string data_type;
    vector<string> param_types;
    vector<string> param_names; 
    int array_size;



public:
//public functions to pass data to other files

    // Constructor
    symbol_info(string name, string type, string data_type="", vector<string> param_types = vector<string>(), vector<string> param_names = vector<string>())
    {
        this->name = name;
        this->type = type;
        this->data_type=data_type;
        this->array_size=0;
        this->param_types = param_types;
        this->param_names = param_names;
        
    }
    //set
    void set_name(string name)
    {
        this->name = name;
    }
    void set_type(string type)
    {
        this->type = type;
    }
    void set_data_type(string data_type){
        this->data_type=data_type;
    }
    //gets the name of the symbol
    string get_name()
    {
        return name;
    }
    //gets the type of the symbol like function, variable, array
    string get_type()
    {
        return type;
    }
    // get the data type of the symbol like int, float, char
    string get_data_type(){
        return data_type;
    }
    // get the size of the array
    int get_array_size() { 
        return array_size; 
        }
    void set_array_size(int size) { 
        this->array_size = size; 
        }

    // get the parameter types and names of the function like int a, int b like a list
    vector<string> get_param_types() { 
        return param_types; 
        }
    vector<string> get_param_names() { 
        return param_names; 
        }
    // helper function to add parameter types and names
    void add_parameter(string type, string name) {
        param_types.push_back(type);
        param_names.push_back(name);
    }
    // set the parameter types and names
     void set_param_types(const vector<string>& types) { 
        param_types = types; 
        }
    void set_param_names(const vector<string>& names) { 
        param_names = names; 
        }
    ~symbol_info()
    {
        // Write necessary code to deallocate memory, if necessary
    }
};