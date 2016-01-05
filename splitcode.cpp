//
//  splitcode.cpp
//  
//
//  Created by localization on 16/1/4.
//
//

#include <fstream>
#include <iostream>
#include <cstring>
#include <vector>
#include <stdlib.h>
using namespace std;


ofstream fout("InterCodetmp.txt");
ifstream fin("InterCode.txt");

int next_quad = 0;
int *quad,*used;
int inFunc = 0;
char *funcName;

vector<char*> toMain;
vector<char*> defList;

void resetInput(ifstream &fin)
{
    fin.close();
    fin.open("InterCode.txt");
}

char *itoa(int num, char *str, int radix)
{
    char  string[] = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    char* ptr = str;
    int denom = 0;
    int count = -1;
    int i;
    int j;
    
    if(num==0)
    {
        str[0]='0';
        str[1]='\0';
        return str;
    }
    while (num >= radix)
    {
        denom   = num % radix;
        num    /= radix;
        
        *ptr++  = string[denom];
        count++;
    }
    
    if (num)
    {
        *ptr++ = string[num];
        count++;
    }
    
    *ptr = '\0';
    j    = count;
    
    for (i = 0; i < (count + 1) / 2; i++)
    {
        int temp = str[i];
        str[i]   = str[j];
        str[j--] = temp;
    }
    
    return str;
}

int getRowNum(ifstream &fin)//get the total row number of input file
{
    int rowNum = 0;
    char tmp;
    while((tmp = fin.get())!=EOF)
    {
        if (tmp == '\n')rowNum++;
    }
    resetInput(fin);
    return rowNum;
}

int newquad()
{
    next_quad++;
    return next_quad;
}

vector<char*> split(char *str,char spliter)
{
    char **tmp;
    vector<char*> toReturn;
    int count = 1;
    for(int i = 0;i<strlen(str);++i)
    {
        if (str[i]==spliter)count++;
    }
    tmp = new char*[count];

    int j = 0;
    int pointer = 0;
    while(j<count)
    {
        int k=0;
        tmp[j] = new char[100];
        for(;pointer<strlen(str);++pointer)
        {
            if (str[pointer]==spliter)break;
            tmp[j][k]=str[pointer];
            k++;
        }
        tmp[j][k]='\0';
        k=0;
        pointer++;
        j++;
    }
    for(int i=0;i<count;++i)toReturn.push_back(tmp[i]);
    return toReturn;
}

char *append(char * origin,char * add)
{
    char *tmp;
    tmp = new char[100];
    int i=0;
    for(;i<strlen(origin);++i)tmp[i]=origin[i];
    for(;i<strlen(add)+strlen(origin);++i)tmp[i]=add[i-strlen(origin)];
    tmp[i] = '\0';
    return tmp;
}

char *cut(char *toCut,int start,int end)
{
    char *tmp;
    tmp = new char[100];
    int i=0;
    for(;i<end-start;++i)tmp[i]=toCut[start+i];
    tmp[i]='\0';
    return tmp;
}

bool is_if(char *t)
{
    bool tmp = (strcmp(t,"beq")==0)||(strcmp(t,"bne")==0)||(strcmp(t,"blt")==0)||(strcmp(t,"ble")==0)||(strcmp(t,"bgt")==0)||(strcmp(t,"bge")==0);
    
    return tmp;
}

char * getLabel(int x)
{
    char *m = new char[20];
    strcpy(m,"Label L");
    char *n = new char[20];
    itoa(x,n,10);
    m = append(m,n);
    char semi[5];
    semi[0] = ':';
    semi[1] = '\0';
    m = append(m,semi);
    return m;
    
}

char * getL(int x)
{
    char *m = new char[20];
    strcpy(m,"L");
    char *n = new char[20];
    itoa(x,n,10);
    m = append(m,n);
    return m;
}

void extend(vector<char*> & origin,vector<char*> & vec)
{
    for(int i=0;i<vec.size();++i)origin.push_back(vec[i]);
    
}

char * join(vector<char*>arr,char *a)
{
    char *str;
    str = arr[0];
    str = append(str,a);
    for(int i =1;i<arr.size();++i)
    {
        str = append(str,arr[i]);
        if(i!=arr.size()-1)str = append(str,a);
    }
    return str;
}


int main()
{
    char space[5];
    space[0] = ' ';
    space[1] = '\0';
    
    //get input code
    int rowNum = getRowNum(fin);
    char **s = new char*[rowNum];
    for(int i = 0;i<rowNum;++i)
    {
        s[i] = new char[100];
        fin.getline(s[i],100);
       
    }
   
    //get lnum and rnum
    resetInput(fin);
    int lnum,rnum;
    char tmp[5];
    fin.getline(tmp,5,' ');
    lnum = atoi(tmp);
    fin.getline(tmp,5,' ');
    rnum = atoi(tmp);
    
    //initialize quad and used
    quad = new int[lnum+4];
    used = new int[lnum+4];
    for (int i=0;i<lnum+4;++i)
    {
        quad[i] = 0;
        used[i] = 0;
    }
    
    vector<char*> tmps;
    for(int i=1;i<=lnum;++i)
    {
       
        tmps = split(s[i],' ');
        
        if (inFunc==0)
        {
            if(strcmp(tmps[0],"deffunc")==0)
            {
                quad[i] = newquad();
                if(strcmp(tmps[1],"main")==0)next_quad+=toMain.size();
                funcName = tmps[1];
                inFunc = 1;
            }
            else
            {
                if(strcmp(tmps[0],"def")==0)
                {
                    char tmp[10];
                    char *tmp2;
                    strcpy(tmp,"global");
                    tmp2 = append(tmp,s[i]);
                    defList.push_back(tmp2);
                    quad[i] = next_quad+1;
                }
                else if(strcmp(tmps[0],"defarr")==0)
                {
                    char tmp[10];
                    char *tmp2;
                    strcpy(tmp,"global");
                    tmp2 = append(tmp,s[i]);
                    defList.push_back(tmp2);
                    quad[i] = next_quad+1;
                }
                else toMain.push_back(s[i]);
                
            }
        }
        else
        {
            if(strcmp(tmps[0],"def")==0)
            {
                char *tmp;
                tmp = cut(s[i],0,3);
                tmp = append(tmp,space);
                tmp = append(tmp,funcName);
                tmp = append(tmp,cut(s[i],3,strlen(s[i])));
                delete s[i];
                s[i] = tmp;
                
                char tmp2[10];
                char *tmp3;
                strcpy(tmp2,"local");
                tmp3 = append(tmp2,s[i]);
                defList.push_back(tmp3);
                quad[i] = next_quad+1;
                
            }
            else if(strcmp(tmps[0],"defarr")==0)
            {
                char *tmp;
                tmp = cut(s[i],0,6);
                tmp = append(tmp,space);
                tmp = append(tmp,funcName);
                tmp = append(tmp,cut(s[i],6,strlen(s[i])));
                delete s[i];
                s[i] = tmp;
                
                char tmp2[10];
                char *tmp3;
                strcpy(tmp2,"local");
                tmp3 = append(tmp2,s[i]);
                defList.push_back(tmp3);
                quad[i] = next_quad+1;
            }
            else
            {
                quad[i] = newquad();
                if(strcmp(tmps[0],"endfunc")==0)
                {
                    inFunc = 0;
                }

            }
        }
        
    }
    
    for (int i =1;i<=lnum;++i)
    {
        tmps = split(s[i],' ');
        if(is_if(tmps[0]))used[quad[atoi(tmps[4])]] = 1;
        else if(strcmp(tmps[0],"goto")==0)used[quad[atoi(tmps[1])]] = 1;
    }
    
    
    vector<char*> tmps1;
    int originLnum = lnum;
    for(int i=1;i<=originLnum;++i)
    {
        tmps = split(s[i],' ');
        if(inFunc==0)
        {
            if(strcmp(tmps[0],"deffunc")==0)
            {
                tmps1.push_back(s[i]);
                quad[i] = newquad();
                if(strcmp(tmps[1],"main")==0)extend(tmps1,toMain);
                inFunc = 1;
            }
        }
        else
        {
            if((strcmp(tmps[0],"def")==0)||(strcmp(tmps[0],"defarr")==0)||(strcmp(tmps[0],"localdef")==0)||(strcmp(tmps[0],"localdefarr")==0)||(strcmp(tmps[0],"globaldef")==0)||(strcmp(tmps[0],"globaldef")==0)){}
            else
            {
                if(used[quad[i]]==1)
                {
                    lnum++;
                    tmps1.push_back(getLabel(quad[i]));
                }
                if(is_if(tmps[0]))
                {
                    tmps[4] = getL(quad[atoi(tmps[4])]);
                    vector<char*>::iterator it = tmps.begin()+3;
                    tmps.erase(it);
                    tmps1.push_back(join(tmps,space));
                }
                else if(strcmp(tmps[0],"goto")==0)
                {
                   
                    tmps[1] = getL(quad[atoi(tmps[1])]);
                    tmps1.push_back(join(tmps,space));
                }
                else tmps1.push_back(s[i]);
                
                if(strcmp(tmps[0],"endfunc")==0)inFunc = 0;
           }
        }
    }
    
    vector<char*> finalCode;
    char line1[20];
    char line2[20];
    char line3[20];
    char *firstLine;
    itoa(lnum-defList.size(),line1,10);
    itoa(rnum,line2,10);
    itoa(defList.size(),line3,10);
    firstLine = append(line1,space);
    firstLine = append(firstLine,line2);
    firstLine = append(firstLine,space);
    firstLine = append(firstLine,line3);
    
    
    finalCode.push_back(firstLine);
    for(int i=0;i<tmps1.size();++i)
    {
        finalCode.push_back(tmps1[i]);
    }
    
    for(int i=0;i<finalCode.size();++i)
    {
        for(int j=0;j<strlen(finalCode[i]);++j)
        {
            if(finalCode[i][j]==',')finalCode[i][j]=' ';
        }
        fout<<finalCode[i]<<endl;
    }
    for(int i=0;i<defList.size();++i)fout<<defList[i]<<endl;
    fout.close();
    //for(int i =0;i<5;++i)cout<<s[i]<<endl;
    
    
    return 0;
}


