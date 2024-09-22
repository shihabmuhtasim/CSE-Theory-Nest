flex lexAnalyzer.l
g++ lex.yy.c -o out
./out.exe input.txt
cat my_log.txt