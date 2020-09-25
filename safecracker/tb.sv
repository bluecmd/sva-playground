`timescale 1ns/1ns
module testbench;

  logic clk = 0;
  logic reset;
  logic unlocked;

  logic [7:0] din;
  logic       din_valid = 0;

  safe uut (
    .clk(clk),
    .reset(reset),
    .din(din),
    .din_valid(din_valid),
    .unlocked(unlocked)
  );

  always #2 clk <= !clk;

  logic [2:0] reset_cnt = 2;
  always @(posedge clk) begin
    if (reset_cnt != 0) begin
      reset_cnt <= reset_cnt - 1;
    end
  end

  assign reset = reset_cnt != 0;

  (* anyconst *) reg [31:0] password;

  // TODO: yosys doesn't like int it seems?
  // base: tb.sv:25: ERROR: syntax error, unexpected TOK_INT
  logic [3:0] i = 0;
  always @(posedge clk) begin
    if (reset) begin
      i <= 0;
      din_valid <= 0;
    end else begin
      din_valid <= 1;
      case(i)
        0: din <= password[31:24];
        1: din <= password[23:16];
        2: din <= password[15:8];
        3: din <= password[7:0];
        4: din_valid <= 0;
      endcase
      if (i < 4) begin
        i <= i + 1;
      end
    end
  end

`ifdef FORMAL
  always @(posedge clk) begin
    cover(unlocked);
  end
`else
  always @(posedge clk) begin
    if (reset) begin
      password <= 32'hbaadc0de;
    end
    if (unlocked) begin
      $display("Safe unlocked with code %h", password);
      $finish;
    end
  end
`endif
endmodule
