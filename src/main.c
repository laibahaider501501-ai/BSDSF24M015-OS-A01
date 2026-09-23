#include <stdio.h>
#include <stdlib.h>

#include "../include/mystrfunctions.h"
#include "../include/myfilefunctions.h"

int main()
{
    char str1[100] = "Hello";
    char str2[] = " World";
    char copy[100];
    char limitedCopy[100];

    FILE* file;

    int lines;
    int words;
    int chars;

    char** matches;
    int matchCount;
    int i;

    printf("--- Testing String Functions ---\n");

    printf("mystrlen(\"%s\") = %d\n", str1, mystrlen(str1));

    mystrcpy(copy, str1);
    printf("mystrcpy = %s\n", copy);

    mystrncpy(limitedCopy, "Operating Systems", 9);
    limitedCopy[9] = '\0';
    printf("mystrncpy = %s\n", limitedCopy);

    mystrcat(str1, str2);
    printf("mystrcat = %s\n", str1);

    printf("\n--- Testing File Functions ---\n");

    file = fopen("test.txt", "r");

    if (file == NULL)
    {
        printf("Error: Could not open test.txt\n");
        return 1;
    }

    if (wordCount(file, &lines, &words, &chars) == 0)
    {
        printf("Lines      : %d\n", lines);
        printf("Words      : %d\n", words);
        printf("Characters : %d\n", chars);
    }
    else
    {
        printf("wordCount failed.\n");
    }

    matchCount = mygrep(file, "OS", &matches);

    if (matchCount >= 0)
    {
        printf("\nLines containing \"OS\": %d\n", matchCount);

        for (i = 0; i < matchCount; i++)
        {
            printf("%s", matches[i]);
            free(matches[i]);
        }

        free(matches);
    }
    else
    {
        printf("mygrep failed.\n");
    }

    fclose(file);

    return 0;
}
