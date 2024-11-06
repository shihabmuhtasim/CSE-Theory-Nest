#include<bits/stdc++.h>
using namespace std;

class symbol_info
{
private:
//sym name- exact value 
//type- the tokeen name
    string sym_name;
    string sym_type;

public:

    symbol_info(string name, string type)
    {
        sym_name = name;
        sym_type = type;
    }
    //get used as the attributes are private of this class
    string getname()
    {
        return sym_name;
    }

    string gettype()
    {
        return sym_type;
    }

};