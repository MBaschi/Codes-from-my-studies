//
//  main.c
//  stringhe

#include <stdio.h>

int count(char ch, const char *str);

int main(void) {
    char str[80];
    char target;
    int my_count;
    printf("Enter up to 79 characters.\n");
    gets(str);
    printf("Enter the character you want to count-> ");
    scanf("%c", &target);
    my_count = count(target, str);
    printf("The number of occurrences of %c in the string '%s' is %d\n", target, str, my_count);
    return 0;
}

int count(char ch, const char *str) {
    int ans;
    if (str[0] == '\0') {
        ans = 0;
    }
    else if (ch == str[0]) {
        ans = 1 + count(ch, &str[1]);
    }
    else ans = count(ch, &str[1]);
    return ans;
}




