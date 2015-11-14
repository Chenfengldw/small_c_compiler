#include <string.h>
#include <iostream>
using namespace std;

struct treeNode
{
    treeNode **son;

    string syn;

    treeNode()
    {
		son = new treeNode *[10];
		for(int i=0;i<10;++i)son[i] = NULL;
		syn = "";
    }

};
//treeNode *arr;
int counter=0;
char temp;
treeNode arr[100];

void addNode(string str)
{
	arr[counter].syn = str;
	counter++;
}

void makeTab(int n)
{
	for(int i=0;i<n;++i)cout<<'-';
}


void preOrder(treeNode *root,int tmp)
{
	makeTab(tmp);
	cout<<root->syn<<endl;
	if (root->son[0] == NULL)return;
	for (int i=0;i<10;++i)
	{
		if(root->son[i] == NULL)break;	
		preOrder(root->son[i],tmp+4);
	}
	
	
}
