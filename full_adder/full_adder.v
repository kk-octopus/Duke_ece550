module full_adder(a,b,cin,sum,cout);
input a,b,cin;
output sum,cout;

wire ab_high,ab_low,carry_sum;

xor(ab_high,a,b);
and(carry_sum,ab_high,cin);
and(ab_low,a,b);

xor(sum,ab_high,cin);
or(cout,ab_low,carry_sum);

endmodule


