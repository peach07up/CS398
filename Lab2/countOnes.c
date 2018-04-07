// Don't put any code but your countOnes function in this file

// Your countOnes function should contain no loops or conditional statements

unsigned int //32bit, 8-digit hex
countOnes(unsigned int input) {
	input = ((input & 0xAAAAAAAA)>>1) + (input & 0x55555555);	//1010&0101
	input = ((input & 0xCCCCCCCC)>>2) + (input & 0x33333333);	//1100&0011
	input = ((input & 0xF0F0F0F0)>>4) + (input & 0x0F0F0F0F);	//1111&0000
	input = ((input & 0xFF00FF00)>>8) + (input & 0x00FF00FF);
	input = ((input & 0xFFFF0000)>>4) + (input & 0x0000FFFF);
	return input; /* works for input = 0 or input = 1  :) */
}

