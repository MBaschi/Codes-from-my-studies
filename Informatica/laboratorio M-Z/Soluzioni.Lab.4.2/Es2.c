//
//  main.c
//  Lab
//
//  Created by Anna Maria Nestorov on 09/12/17.
//  Copyright © 2017 Anna Maria Nestorov. All rights reserved.
//

#include<stdio.h>

int moltiplica(int a, int b);

int main(int argc, const char * argv[]) {
    int a,b;
    
    do{
        printf("inserisci a : ");
        scanf("%d",&a);
        printf("inserisci b : ");
        scanf("%d",&b);
    }while(a < 0 || b < 0);
    
    printf("%d\n",moltiplica(a,b));
    return 0;
}

int moltiplica(int a, int b){
    if (b == 0 || a == 0)
        return 0;
    
    if(a == 1)
        return b;
    
    if(b == 1)
        return a;
    
    return a+moltiplica(a,--b);
}




