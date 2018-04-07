module blackbox(x, u, o, r);
   output x;
   input  u, o, r;
   wire   w11, w13, w18, w20, w26, w33, w39, w54, w56, w67, w81, w84, w91, w95, w98;

   or  o15(x, w26, w18);
   and a46(w26, w95, w67);
   or  o73(w67, w33, w11);
   not n6(w33, w11);
   and a97(w18, w81, w13);
   not n66(w13, w81);
   and a69(w81, u, w20);
   or  o50(w20, w91, w84);
   not n53(w91, r);
   and a72(w84, w56, r);
   not n89(w56, o);
   or  o14(w11, u, w98, o);
   not n8(w98, r);
   and a68(w95, r, w39);
   or  o5(w39, w54, o);
   not n61(w54, u);

endmodule // blackbox
