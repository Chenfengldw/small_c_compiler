#!/bin/bash
g++ splitcode.cpp -o splitcode.exe
g++ compare.cpp -o compare.exe
./small testcases/arth/arth.sc
python splitcode.py
./splitcode.exe
./compare.exe
./small testcases/fib/fib.sc
python splitcode.py
./splitcode.exe
./compare.exe
./small testcases/gcd/gcd.sc
python splitcode.py
./splitcode.exe
./compare.exe
./small testcases/io/io.sc
python splitcode.py
./splitcode.exe
./compare.exe
./small testcases/if/if.sc
python splitcode.py
./splitcode.exe
./compare.exe
#./small testcases/queen/queen.sc
#python splitcode.py
#./splitcode.exe
#./compare.exe
./small testcases/struct/struct.sc
python splitcode.py
./splitcode.exe
./compare.exe