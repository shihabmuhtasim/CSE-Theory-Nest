yacc -d -y --debug --verbose 21301610.y
g++ -w -c -o y.o y.tab.c
flex 21301610.l
g++ -fpermissive -w -c -o l.o lex.yy.c
g++ y.o l.o
./a.exe input.txt




