## Virtues of a programmer (from Programming Perl, Wall, Schwartz and
## Christiansen)
## 
## Laziness - The quality that makes you go to great effort to reduce
## overall energy expenditure. It makes you write labor-saving programs
## that other people will find useful, and document what you wrote so you
## don't have to answer so many questions about it. 
## 
## 
## This function generates a circuit (albeit a slow one) to compute whether
## a bus is all zeros.
## 
## python example_generator.py

width = 32;

print "    input Cin, [%s;1] cin;" % (width-1)
print ""
print "    alu1 a0(out[0], cin[1], A[0], B[0], control[0], control);"
for i in range(1, width-1):
    print "    alu1 a%d(out[%d], cin[%d], A[%d], B[%d], cin[%d], control);" % (i, i, i+1, i, i, i)
print "    alu1 a%d(out[%d], cout, A[%d], B[%d], cin[%d], control);" % (width-1, width-1, width-1, width-1, width-1)
print "   wire  [%s:1] result;" % (width - 1)
print ""
print "    or o1(result[1], out[1], out[0]);"
for i in range(2, width):
    print "    or o%d(result[%d], out[%d], result[%d]);" % (i, i, i, i-1)

print "    not n0(zero, result[%d]);" % (width - 1);

