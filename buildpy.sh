#! /bin/sh
swig -Wall -python pysbrl.i
gcc -c `python3 -c "import numpy; print('-I'+numpy.get_include())"` `python3-config --cflags` train.c rulelib.c predict.c pysbrl.c pysbrl_wrap.c
# gcc -v -bundle -lgsl -L/Users/mingyao/anaconda/envs/iml/lib/python3.6/config-3.6m-darwin -lpython3.6m -ldl -framework CoreFoundation train.o rulelib.o predict.o pysbrl_wrap.o -o pysbrl.so
gcc -v -bundle -lgsl -lgslcblas -lgmp -lm `python3-config --ldflags` train.o rulelib.o predict.o pysbrl.o pysbrl_wrap.o -o _pysbrl.so
