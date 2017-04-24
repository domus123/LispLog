#LispLog


#Dependencies
<p> Sbcl

*EARLY VERSION
*NOT MUCH

This lisplog :
```lisp
(module first_counter
	(input clock reset enable)
	(output (vec 3 0 counter_out))
	(wire clock reset enable)
	(reg (vec 3 0 counter_out)))
	
(verilog "always @ (enable or encoder_in)
	   begin
	     binary_out = 0;
	     if (enable) begin
	       if (encoder_in == 16'h0002) begin
	        binary_out = 1;
	       end  if (encoder_in == 16'h0004) begin
	        binary_out = 2;
	       end  if (encoder_in == 16'h0008) begin
	        binary_out = 3;
	       end  if (encoder_in == 16'h0010) begin
	        binary_out = 4;
	       end  if (encoder_in == 16'h0020) begin
	        binary_out = 5;
	       end  if (encoder_in == 16'h0040) begin
	        binary_out = 6;
	       end  if (encoder_in == 16'h0080) begin
	        binary_out = 7;
	       end  if (encoder_in == 16'h0100) begin
	        binary_out = 8;
	       end  if (encoder_in == 16'h0200) begin
	        binary_out = 9;
	       end if (encoder_in == 16'h0400) begin
	        binary_out = 10;
	       end  if (encoder_in == 16'h0800) begin
	        binary_out = 11;
	       end  if (encoder_in == 16'h1000) begin
	        binary_out = 12;
	       end  if (encoder_in == 16'h2000) begin
	        binary_out = 13;
	       end  if (encoder_in == 16'h4000) begin
	        binary_out = 14;
	       end if (encoder_in == 16'h8000) begin
	        binary_out = 15;
	       end
	    end
	  end
   endmodule")

```
Will generate

```verilog

module first_counter (
counter_out, 
enable, 
reset, 
clock
);

reg [3:0] counter_out ;
wire enable ;
wire reset ;
wire clock ;
output [3:0] counter_out ;
input enable ;
input reset ;
input clock ;
"always @ (enable or encoder_in)
	   begin
	     binary_out = 0;
	     if (enable) begin
	       if (encoder_in == 16'h0002) begin
	        binary_out = 1;
	       end  if (encoder_in == 16'h0004) begin
	        binary_out = 2;
	       end  if (encoder_in == 16'h0008) begin
	        binary_out = 3;
	       end  if (encoder_in == 16'h0010) begin
	        binary_out = 4;
	       end  if (encoder_in == 16'h0020) begin
	        binary_out = 5;
	       end  if (encoder_in == 16'h0040) begin
	        binary_out = 6;
	       end  if (encoder_in == 16'h0080) begin
	        binary_out = 7;
	       end  if (encoder_in == 16'h0100) begin
	        binary_out = 8;
	       end  if (encoder_in == 16'h0200) begin
	        binary_out = 9;
	       end if (encoder_in == 16'h0400) begin
	        binary_out = 10;
	       end  if (encoder_in == 16'h0800) begin
	        binary_out = 11;
	       end  if (encoder_in == 16'h1000) begin
	        binary_out = 12;
	       end  if (encoder_in == 16'h2000) begin
	        binary_out = 13;
	       end  if (encoder_in == 16'h4000) begin
	        binary_out = 14;
	       end if (encoder_in == 16'h8000) begin
	        binary_out = 15;
	       end
	    end
	  end
	 
	   endmodule"
```

* How to run


```lisp

&  sbcl --load lisplog.lsp
&  (compile-lisplog)
& ./lisplog "test.llog" "output.vl"

```

