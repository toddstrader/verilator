// $Id$
// DESCRIPTION: Verilator: Verilog Test module
//
// This file ONLY is placed into the Public Domain, for any use,
// without warranty, 2007 by Wilson Snyder.

module t (/*AUTOARG*/
   // Inputs
   clk
   );
   input clk;

   integer 	cyc=0;
   reg [63:0] 	crc;
   reg [63:0] 	sum;

   // Take CRC data and apply to testblock inputs
   wire [33:0]  in = crc[33:0];

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire [31:0]		code;			// From test of Test.v
   wire [4:0]		len;			// From test of Test.v
   wire			next;			// From test of Test.v
   // End of automatics

   Test test (/*AUTOINST*/
	      // Outputs
	      .next			(next),
	      .code			(code[31:0]),
	      .len			(len[4:0]),
	      // Inputs
	      .clk			(clk),
	      .in			(in[33:0]));

   // Aggregate outputs into a single result vector
   wire [63:0] result = {26'h0, next, len, code};

   // What checksum will we end up with
`define EXPECTED_SUM 64'h5537fa30d49bf865

   // Test loop
   always @ (posedge clk) begin
`ifdef TEST_VERBOSE
      $write("[%0t] cyc==%0d crc=%x result=%x\n",$time, cyc, crc, result);
`endif
      cyc <= cyc + 1;
      crc <= {crc[62:0], crc[63]^crc[2]^crc[0]};
      sum <= result ^ {sum[62:0],sum[63]^sum[2]^sum[0]};
      if (cyc==0) begin
	 // Setup
	 crc <= 64'h5aef0c8d_d70a4497;
      end
      else if (cyc<10) begin
	 sum <= 64'h0;
      end
      else if (cyc<90) begin
      end
      else if (cyc==99) begin
	 $write("[%0t] cyc==%0d crc=%x sum=%x\n",$time, cyc, crc, sum);
	 if (crc !== 64'hc77bb9b3784ea091) $stop;
	 if (sum !== `EXPECTED_SUM) $stop;
	 $write("*-* All Finished *-*\n");
	 $finish;
      end
   end

endmodule

module Test (/*AUTOARG*/
   // Outputs
   next, code, len,
   // Inputs
   clk, in
   );

   input clk;
   input  [33:0] in;   
   output 	 next;
   output [31:0] code;
   output [4:0]	 len;

   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg [31:0]		code;
   reg [4:0]		len;
   reg			next;
   // End of automatics

/*
#!/usr/bin/perl -w
srand(5);
my @used;
pat:
  for (my $pat=0; 1; ) {
    last if $pat > 196;
    my $len = int($pat / (6 + $pat/50)) + 4;  $len=20 if $len>20;
    my ($try, $val, $mask);
  try:
    for ($try=0; ; $try++) {
	next pat if $try>50;
	$val = 0;
	for (my $bit=23; $bit>(23-$len); $bit--) {
	    my $b = int(rand()*2);
	    $val |= (1<<$bit) if $b;
	}
	$mask = (1<<(23-$len+1))-1;
	for (my $testval = $val; $testval <= ($val + $mask); $testval ++) {
	    next try if $used[$testval];
	}
	last;
    }
    my $bits = "";
    my $val2 = 0;
    for (my $bit=23; $bit>(23-$len); $bit--) {
	my $b = ($val & (1<<$bit));
	$bits .= $b?'1':'0';
    }
    for (my $testval = $val; $testval <= ($val + $mask); $testval++) {
	$used[$testval]= 1; #printf "U%08x\n", $testval;
    }
    if ($try<90) {
	printf +("     24'b%s: {next, len, code} = {in[%02d], 5'd%02d, 32'd%03d};\n"
		 ,$bits.("?"x(24-$len)), 31-$len, $len, $pat);
	$pat++;
    }
}
*/

   always @* begin
      next = 1'b0;
      code = 32'd0;
      len  = 5'b11111;
      casez (in[31:8])
	24'b1010????????????????????: {next, len, code} = {in[27], 5'd04, 32'd000};
	24'b1100????????????????????: {next, len, code} = {in[27], 5'd04, 32'd001};
	24'b0110????????????????????: {next, len, code} = {in[27], 5'd04, 32'd002};
	24'b1001????????????????????: {next, len, code} = {in[27], 5'd04, 32'd003};
	24'b1101????????????????????: {next, len, code} = {in[27], 5'd04, 32'd004};
	24'b0011????????????????????: {next, len, code} = {in[27], 5'd04, 32'd005};
	24'b0001????????????????????: {next, len, code} = {in[27], 5'd04, 32'd006};
	24'b10001???????????????????: {next, len, code} = {in[26], 5'd05, 32'd007};
	24'b01110???????????????????: {next, len, code} = {in[26], 5'd05, 32'd008};
	24'b01000???????????????????: {next, len, code} = {in[26], 5'd05, 32'd009};
	24'b00001???????????????????: {next, len, code} = {in[26], 5'd05, 32'd010};
	24'b11100???????????????????: {next, len, code} = {in[26], 5'd05, 32'd011};
	24'b01011???????????????????: {next, len, code} = {in[26], 5'd05, 32'd012};
	24'b100001??????????????????: {next, len, code} = {in[25], 5'd06, 32'd013};
	24'b111110??????????????????: {next, len, code} = {in[25], 5'd06, 32'd014};
	24'b010010??????????????????: {next, len, code} = {in[25], 5'd06, 32'd015};
	24'b001011??????????????????: {next, len, code} = {in[25], 5'd06, 32'd016};
	24'b101110??????????????????: {next, len, code} = {in[25], 5'd06, 32'd017};
	24'b111011??????????????????: {next, len, code} = {in[25], 5'd06, 32'd018};
	24'b0111101?????????????????: {next, len, code} = {in[24], 5'd07, 32'd020};
	24'b0010100?????????????????: {next, len, code} = {in[24], 5'd07, 32'd021};
	24'b0111111?????????????????: {next, len, code} = {in[24], 5'd07, 32'd022};
	24'b1011010?????????????????: {next, len, code} = {in[24], 5'd07, 32'd023};
	24'b1000000?????????????????: {next, len, code} = {in[24], 5'd07, 32'd024};
	24'b1011111?????????????????: {next, len, code} = {in[24], 5'd07, 32'd025};
	24'b1110100?????????????????: {next, len, code} = {in[24], 5'd07, 32'd026};
	24'b01111100????????????????: {next, len, code} = {in[23], 5'd08, 32'd027};
	24'b00000110????????????????: {next, len, code} = {in[23], 5'd08, 32'd028};
	24'b00000101????????????????: {next, len, code} = {in[23], 5'd08, 32'd029};
	24'b01001100????????????????: {next, len, code} = {in[23], 5'd08, 32'd030};
	24'b10110110????????????????: {next, len, code} = {in[23], 5'd08, 32'd031};
	24'b00100110????????????????: {next, len, code} = {in[23], 5'd08, 32'd032};
	24'b11110010????????????????: {next, len, code} = {in[23], 5'd08, 32'd033};
	24'b010011101???????????????: {next, len, code} = {in[22], 5'd09, 32'd034};
	24'b001000000???????????????: {next, len, code} = {in[22], 5'd09, 32'd035};
	24'b010101111???????????????: {next, len, code} = {in[22], 5'd09, 32'd036};
	24'b010101010???????????????: {next, len, code} = {in[22], 5'd09, 32'd037};
	24'b010011011???????????????: {next, len, code} = {in[22], 5'd09, 32'd038};
	24'b010100011???????????????: {next, len, code} = {in[22], 5'd09, 32'd039};
	24'b010101000???????????????: {next, len, code} = {in[22], 5'd09, 32'd040};
	24'b1111010101??????????????: {next, len, code} = {in[21], 5'd10, 32'd041};
	24'b0010001000??????????????: {next, len, code} = {in[21], 5'd10, 32'd042};
	24'b0101001101??????????????: {next, len, code} = {in[21], 5'd10, 32'd043};
	24'b0010010100??????????????: {next, len, code} = {in[21], 5'd10, 32'd044};
	24'b1011001110??????????????: {next, len, code} = {in[21], 5'd10, 32'd045};
	24'b1111000011??????????????: {next, len, code} = {in[21], 5'd10, 32'd046};
	24'b0101000000??????????????: {next, len, code} = {in[21], 5'd10, 32'd047};
	24'b1111110000??????????????: {next, len, code} = {in[21], 5'd10, 32'd048};
	24'b10110111010?????????????: {next, len, code} = {in[20], 5'd11, 32'd049};
	24'b11110000011?????????????: {next, len, code} = {in[20], 5'd11, 32'd050};
	24'b01001111011?????????????: {next, len, code} = {in[20], 5'd11, 32'd051};
	24'b00101011011?????????????: {next, len, code} = {in[20], 5'd11, 32'd052};
	24'b01010010100?????????????: {next, len, code} = {in[20], 5'd11, 32'd053};
	24'b11110111100?????????????: {next, len, code} = {in[20], 5'd11, 32'd054};
	24'b00100111001?????????????: {next, len, code} = {in[20], 5'd11, 32'd055};
	24'b10110001010?????????????: {next, len, code} = {in[20], 5'd11, 32'd056};
	24'b10000010000?????????????: {next, len, code} = {in[20], 5'd11, 32'd057};
	24'b111111101100????????????: {next, len, code} = {in[19], 5'd12, 32'd058};
	24'b100000111110????????????: {next, len, code} = {in[19], 5'd12, 32'd059};
	24'b100000110010????????????: {next, len, code} = {in[19], 5'd12, 32'd060};
	24'b100000111001????????????: {next, len, code} = {in[19], 5'd12, 32'd061};
	24'b010100101111????????????: {next, len, code} = {in[19], 5'd12, 32'd062};
	24'b001000001100????????????: {next, len, code} = {in[19], 5'd12, 32'd063};
	24'b000001111111????????????: {next, len, code} = {in[19], 5'd12, 32'd064};
	24'b011111010100????????????: {next, len, code} = {in[19], 5'd12, 32'd065};
	24'b1110101111101???????????: {next, len, code} = {in[18], 5'd13, 32'd066};
	24'b0100110101110???????????: {next, len, code} = {in[18], 5'd13, 32'd067};
	24'b1111111011011???????????: {next, len, code} = {in[18], 5'd13, 32'd068};
	24'b0101011011001???????????: {next, len, code} = {in[18], 5'd13, 32'd069};
	24'b0010000101100???????????: {next, len, code} = {in[18], 5'd13, 32'd070};
	24'b1111111101101???????????: {next, len, code} = {in[18], 5'd13, 32'd071};
	24'b1011110010110???????????: {next, len, code} = {in[18], 5'd13, 32'd072};
	24'b0101010111010???????????: {next, len, code} = {in[18], 5'd13, 32'd073};
	24'b1111011010010???????????: {next, len, code} = {in[18], 5'd13, 32'd074};
	24'b01010100100011??????????: {next, len, code} = {in[17], 5'd14, 32'd075};
	24'b10110000110010??????????: {next, len, code} = {in[17], 5'd14, 32'd076};
	24'b10111101001111??????????: {next, len, code} = {in[17], 5'd14, 32'd077};
	24'b10110000010101??????????: {next, len, code} = {in[17], 5'd14, 32'd078};
	24'b00101011001111??????????: {next, len, code} = {in[17], 5'd14, 32'd079};
	24'b00100000101100??????????: {next, len, code} = {in[17], 5'd14, 32'd080};
	24'b11111110010111??????????: {next, len, code} = {in[17], 5'd14, 32'd081};
	24'b10110010100000??????????: {next, len, code} = {in[17], 5'd14, 32'd082};
	24'b11101011101000??????????: {next, len, code} = {in[17], 5'd14, 32'd083};
	24'b01010000011111??????????: {next, len, code} = {in[17], 5'd14, 32'd084};
	24'b101111011001011?????????: {next, len, code} = {in[16], 5'd15, 32'd085};
	24'b101111010001100?????????: {next, len, code} = {in[16], 5'd15, 32'd086};
	24'b100000111100111?????????: {next, len, code} = {in[16], 5'd15, 32'd087};
	24'b001010101011000?????????: {next, len, code} = {in[16], 5'd15, 32'd088};
	24'b111111100100001?????????: {next, len, code} = {in[16], 5'd15, 32'd089};
	24'b001001011000010?????????: {next, len, code} = {in[16], 5'd15, 32'd090};
	24'b011110011001011?????????: {next, len, code} = {in[16], 5'd15, 32'd091};
	24'b111111111111010?????????: {next, len, code} = {in[16], 5'd15, 32'd092};
	24'b101111001010011?????????: {next, len, code} = {in[16], 5'd15, 32'd093};
	24'b100000110000111?????????: {next, len, code} = {in[16], 5'd15, 32'd094};
	24'b0010010000000101????????: {next, len, code} = {in[15], 5'd16, 32'd095};
	24'b0010010010101001????????: {next, len, code} = {in[15], 5'd16, 32'd096};
	24'b1111011010110010????????: {next, len, code} = {in[15], 5'd16, 32'd097};
	24'b0010010001100100????????: {next, len, code} = {in[15], 5'd16, 32'd098};
	24'b0101011101110100????????: {next, len, code} = {in[15], 5'd16, 32'd099};
	24'b0101011010001111????????: {next, len, code} = {in[15], 5'd16, 32'd100};
	24'b0010000110011111????????: {next, len, code} = {in[15], 5'd16, 32'd101};
	24'b0101010010000101????????: {next, len, code} = {in[15], 5'd16, 32'd102};
	24'b1110101011000000????????: {next, len, code} = {in[15], 5'd16, 32'd103};
	24'b1111000000110010????????: {next, len, code} = {in[15], 5'd16, 32'd104};
	24'b0111100010001101????????: {next, len, code} = {in[15], 5'd16, 32'd105};
	24'b00100010110001100???????: {next, len, code} = {in[14], 5'd17, 32'd106};
	24'b00100010101101010???????: {next, len, code} = {in[14], 5'd17, 32'd107};
	24'b11111110111100000???????: {next, len, code} = {in[14], 5'd17, 32'd108};
	24'b00100000111010000???????: {next, len, code} = {in[14], 5'd17, 32'd109};
	24'b00100111011101001???????: {next, len, code} = {in[14], 5'd17, 32'd110};
	24'b11111110111000011???????: {next, len, code} = {in[14], 5'd17, 32'd111};
	24'b11110001101000100???????: {next, len, code} = {in[14], 5'd17, 32'd112};
	24'b11101011101011101???????: {next, len, code} = {in[14], 5'd17, 32'd113};
	24'b01010000100101011???????: {next, len, code} = {in[14], 5'd17, 32'd114};
	24'b00100100110011001???????: {next, len, code} = {in[14], 5'd17, 32'd115};
	24'b01001110010101000???????: {next, len, code} = {in[14], 5'd17, 32'd116};
	24'b010011110101001000??????: {next, len, code} = {in[13], 5'd18, 32'd117};
	24'b111010101110010010??????: {next, len, code} = {in[13], 5'd18, 32'd118};
	24'b001001001001111000??????: {next, len, code} = {in[13], 5'd18, 32'd119};
	24'b101111000110111101??????: {next, len, code} = {in[13], 5'd18, 32'd120};
	24'b101101111010101001??????: {next, len, code} = {in[13], 5'd18, 32'd121};
	24'b111101110010111110??????: {next, len, code} = {in[13], 5'd18, 32'd122};
	24'b010100100011010000??????: {next, len, code} = {in[13], 5'd18, 32'd123};
	24'b001001001111011001??????: {next, len, code} = {in[13], 5'd18, 32'd124};
	24'b010100110010001001??????: {next, len, code} = {in[13], 5'd18, 32'd125};
	24'b111010110000111000??????: {next, len, code} = {in[13], 5'd18, 32'd126};
	24'b111010110011000101??????: {next, len, code} = {in[13], 5'd18, 32'd127};
	24'b010100001000111001??????: {next, len, code} = {in[13], 5'd18, 32'd128};
	24'b1000001011000110100?????: {next, len, code} = {in[12], 5'd19, 32'd129};
	24'b0010010111001110110?????: {next, len, code} = {in[12], 5'd19, 32'd130};
	24'b0101011001000001101?????: {next, len, code} = {in[12], 5'd19, 32'd131};
	24'b0101000010010101011?????: {next, len, code} = {in[12], 5'd19, 32'd132};
	24'b1111011111101001101?????: {next, len, code} = {in[12], 5'd19, 32'd133};
	24'b1011001000101010110?????: {next, len, code} = {in[12], 5'd19, 32'd134};
	24'b1011000001000100001?????: {next, len, code} = {in[12], 5'd19, 32'd135};
	24'b1110101100010011001?????: {next, len, code} = {in[12], 5'd19, 32'd136};
	24'b0010010111010111110?????: {next, len, code} = {in[12], 5'd19, 32'd137};
	24'b0010010001100111100?????: {next, len, code} = {in[12], 5'd19, 32'd138};
	24'b1011001011100000101?????: {next, len, code} = {in[12], 5'd19, 32'd139};
	24'b1011000100010100101?????: {next, len, code} = {in[12], 5'd19, 32'd140};
	24'b1111111001000111011?????: {next, len, code} = {in[12], 5'd19, 32'd141};
	24'b00100010111101101101????: {next, len, code} = {in[11], 5'd20, 32'd142};
	24'b10000010101010101101????: {next, len, code} = {in[11], 5'd20, 32'd143};
	24'b10110010100101001101????: {next, len, code} = {in[11], 5'd20, 32'd144};
	24'b01010110111100010000????: {next, len, code} = {in[11], 5'd20, 32'd145};
	24'b10110111110011001001????: {next, len, code} = {in[11], 5'd20, 32'd146};
	24'b11111101101100100101????: {next, len, code} = {in[11], 5'd20, 32'd147};
	24'b10110000010100100001????: {next, len, code} = {in[11], 5'd20, 32'd148};
	24'b10110010011010110110????: {next, len, code} = {in[11], 5'd20, 32'd149};
	24'b01111001010000011000????: {next, len, code} = {in[11], 5'd20, 32'd150};
	24'b11110110001011011011????: {next, len, code} = {in[11], 5'd20, 32'd151};
	24'b01010000100100001011????: {next, len, code} = {in[11], 5'd20, 32'd152};
	24'b10110001100101110111????: {next, len, code} = {in[11], 5'd20, 32'd153};
	24'b10111100110111101000????: {next, len, code} = {in[11], 5'd20, 32'd154};
	24'b01010001010111010000????: {next, len, code} = {in[11], 5'd20, 32'd155};
	24'b01010100111110001110????: {next, len, code} = {in[11], 5'd20, 32'd156};
	24'b11111110011001100111????: {next, len, code} = {in[11], 5'd20, 32'd157};
	24'b11110111111101010001????: {next, len, code} = {in[11], 5'd20, 32'd158};
	24'b10110000010111100000????: {next, len, code} = {in[11], 5'd20, 32'd159};
	24'b01001111100001000101????: {next, len, code} = {in[11], 5'd20, 32'd160};
	24'b01010010000111010110????: {next, len, code} = {in[11], 5'd20, 32'd161};
	24'b11101010101011101111????: {next, len, code} = {in[11], 5'd20, 32'd162};
	24'b11111110010011100011????: {next, len, code} = {in[11], 5'd20, 32'd163};
	24'b01010111001111101111????: {next, len, code} = {in[11], 5'd20, 32'd164};
	24'b10110001111111111101????: {next, len, code} = {in[11], 5'd20, 32'd165};
	24'b10110001001100110000????: {next, len, code} = {in[11], 5'd20, 32'd166};
	24'b11110100011000111101????: {next, len, code} = {in[11], 5'd20, 32'd167};
	24'b00101011101110100011????: {next, len, code} = {in[11], 5'd20, 32'd168};
	24'b01010000011011111110????: {next, len, code} = {in[11], 5'd20, 32'd169};
	24'b00000111000010000010????: {next, len, code} = {in[11], 5'd20, 32'd170};
	24'b00101010000011001000????: {next, len, code} = {in[11], 5'd20, 32'd171};
	24'b01001110010100101110????: {next, len, code} = {in[11], 5'd20, 32'd172};
	24'b11110000000010000000????: {next, len, code} = {in[11], 5'd20, 32'd173};
	24'b01001101011001111001????: {next, len, code} = {in[11], 5'd20, 32'd174};
	24'b11110111000111010101????: {next, len, code} = {in[11], 5'd20, 32'd175};
	24'b01111001101001110110????: {next, len, code} = {in[11], 5'd20, 32'd176};
	24'b11110000101011101111????: {next, len, code} = {in[11], 5'd20, 32'd177};
	24'b00100100100110101010????: {next, len, code} = {in[11], 5'd20, 32'd178};
	24'b11110001011011000011????: {next, len, code} = {in[11], 5'd20, 32'd179};
	24'b01010111001000110011????: {next, len, code} = {in[11], 5'd20, 32'd180};
	24'b01111000000100010101????: {next, len, code} = {in[11], 5'd20, 32'd181};
	24'b00100101101011001101????: {next, len, code} = {in[11], 5'd20, 32'd182};
	24'b10110010110000111001????: {next, len, code} = {in[11], 5'd20, 32'd183};
	24'b10110000101010000011????: {next, len, code} = {in[11], 5'd20, 32'd184};
	24'b00100100111110001101????: {next, len, code} = {in[11], 5'd20, 32'd185};
	24'b01111001101001101011????: {next, len, code} = {in[11], 5'd20, 32'd186};
	24'b01010001000000010001????: {next, len, code} = {in[11], 5'd20, 32'd187};
	24'b11110101111111101110????: {next, len, code} = {in[11], 5'd20, 32'd188};
	24'b10000010111110110011????: {next, len, code} = {in[11], 5'd20, 32'd189};
	24'b00000100011110100111????: {next, len, code} = {in[11], 5'd20, 32'd190};
	24'b11111101001111101100????: {next, len, code} = {in[11], 5'd20, 32'd191};
	24'b00101011100011110000????: {next, len, code} = {in[11], 5'd20, 32'd192};
	24'b00100100111001011001????: {next, len, code} = {in[11], 5'd20, 32'd193};
	24'b10000010101000000100????: {next, len, code} = {in[11], 5'd20, 32'd194};
	24'b11110001001000111100????: {next, len, code} = {in[11], 5'd20, 32'd195};
	24'b10111100011010011001????: {next, len, code} = {in[11], 5'd20, 32'd196};
	24'b000000??????????????????: begin
	   casez (in[33:32])
	     2'b1?:   {next, len, code} = {1'b0, 5'd18, 32'd197};
	     2'b01:   {next, len, code} = {1'b0, 5'd19, 32'd198};
	     2'b00:   {next, len, code} = {1'b0, 5'd19, 32'd199};
	     default: ;
	   endcase
	end
	default: ;
      endcase
   end
endmodule
