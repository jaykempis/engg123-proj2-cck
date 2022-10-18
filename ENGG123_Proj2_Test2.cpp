#include <iostream>
#include <string>
#include <sstream>
#include <bitset>
#include <cstddef>
#include <cassert>


using namespace std;
//--------------------------------------------------------------------


int main(){
    
    //extraction
    int divisorIn = 21;
    int dividendIn = 74;
    int defaultQ = 0;
    int divisorW = divisorIn << 6; //move divisor to front half
    bitset<12> div(divisorW);
    bitset<12> dvd(dividendIn);
    bitset<6> quo(defaultQ);
    cout << "Divisor:\t| " << div.to_string() << endl;
    cout << "Dividend:\t| " << dvd.to_string() << endl;
    cout << "Quotient:\t| " << quo.to_string() << endl;
    cout << "------------------------------------------" << endl;
    long long int flag;


    while(dvd.to_ulong() >= divisorIn){
        flag = (int16_t)(dvd.to_ulong() - div.to_ulong());
        cout << "flag: " << flag << endl;
        if(flag < 0){
            quo = quo << 1;
            quo[0] = 0;
        }
        else if(flag == divisorIn){
            bitset<12> op(dvd.to_ulong() - divisorIn);
            dvd = op;
            bitset<6> sol(quo.to_ulong() +1);
            quo = sol;
        }
        else{
            bitset<12> op(dvd.to_ulong() - divisorIn);
            dvd = op;
            if((dvd.to_ulong() - divisorIn) > divisorIn){
                if((dvd.to_ulong() - divisorIn) > (2*divisorIn)){
                    bitset<6> sol(quo.to_ulong() +2);
                    quo = sol;
                }
                else{
                    bitset<6> sol2(quo.to_ulong() +1);
                    quo = sol2;
                }
            }
        }
        div = div >> 1;
        cout << "Divisor:\t| " << div.to_string() << endl;
        cout << "Dividend:\t| " << dvd.to_string() << endl;
        cout << "Quotient:\t| " << quo.to_string() << endl;
        cout << "------------------------------------------" << endl;
    }

    cout << "--ANSWER----------------------------------" << endl;
    cout << "Dividend:\t| " << dividendIn << endl;
    cout << "Divisor:\t| " << divisorIn << endl;
    cout << "Quotient:\t| " << quo.to_ulong() << endl;
    cout << "Remainder:\t| " << dvd.to_ulong() << endl;
    cout << "------------------------------------------" << endl;
}   