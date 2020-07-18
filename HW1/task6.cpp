#include <iostream>

using namespace std;

int main(int argc, char **argv)
{
	int n;
	n = atoi(argv[1]);
	for(int i = 0; i < n; i++) {
	    cout<< i << " ";
	}
	cout << n << endl;
	return 0;
}
