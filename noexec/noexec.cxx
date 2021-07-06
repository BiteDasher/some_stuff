#include <libintl.h>
#include <locale.h>
#include <iostream>
int main ( int argc, char *argv[] ){
    setlocale(LC_ALL, "");
    bindtextdomain("noexec", "/usr/share/locale");
    textdomain("noexec");
    std::cout << gettext("This file is not executable. This is");
    int i;
    for(i=1;i<argc-1;i++)
    {
        printf(" %s",argv[i]);
    }
    std::cout << std::endl;
    return 1;
}
