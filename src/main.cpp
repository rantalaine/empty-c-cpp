#include <iostream>


int main() 
{
    std::cout << "Hello world!\n";

    do 
    {
        std::cout << '\n' << "Press a key to continue...";
    } while (std::cin.get() != '\n');
    
    return 0;
}