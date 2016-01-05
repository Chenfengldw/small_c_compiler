#include <fstream>
#include <iostream>
using namespace std;

ifstream fin1("InterCodetmp.txt");
ifstream fin2("InterCode1.txt");

int main()
{
    
    char tmp1,tmp2;
    while((tmp1 = fin1.get())!=EOF)
    {
        tmp2 = fin2.get();
        if(tmp1!=tmp2)
        {
            cout<<false;
            return 0;
        }
    }
    tmp2 = fin2.get();
    if(tmp2!=EOF)
    {
        cout<<false;
        return 0;
    }
    cout<<true;
    return 0;
    
    
}

