#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <math.h>

int main(int argc, char* argv[]){
char cmd1[100];
char cmd2[100];
char prog_exe[100];
if (argc != 2) printf ("wrong number of argument\n");
else {
		sprintf (cmd1,"./assembler.bin/dlxasm.pl %s",argv[1]);
		sprintf (prog_exe,"%s.exe",argv[1]);
		sprintf (cmd2,"./assembler.bin/conv2memory %s > test.asm.mem",prog_exe);
		printf ("generating exe code from file %s\n",argv[1]);
		system (cmd1);
		printf ("generating mem code from file %s\n",prog_exe);
		system (cmd2);
		exit(0);
	  }
}
