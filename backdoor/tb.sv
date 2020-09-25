`timescale 1ns/1ns
module testbench;

  logic clk = 0;
  logic reset;
  logic unlocked;

  logic [3:0] din;
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
  logic       new_try = 0;     // Unused in formal verification
  always @(posedge clk) begin
    if (reset_cnt != 0) begin
      reset_cnt <= reset_cnt - 1;
    end
    if (new_try) begin
      reset_cnt <= 2;
    end
  end

  assign reset = reset_cnt != 0;

  // Allow yosys to select the password to try freely
  (* anyconst *) reg [15:0] password;

  integer i = 0;
  always @(posedge clk) begin
    if (reset) begin
      i <= 0;
      din_valid <= 0;
    end else begin
      din_valid <= 1;
      case(i)
        0: din <= password[15:12];
        1: din <= password[11:8];
        2: din <= password[7:4];
        3: din <= password[3:0];
        4: din_valid <= 0;
      endcase
      if (i < 4) begin
        i <= i + 1;
      end
    end
  end

  // For formal verification, this is all we need.
  // This will tell the verifier to try to find a path to where unlocked == 1
  always @(posedge clk) begin
    // Assert that there are no other hidden codes than c0de
    // We want to be sure that the expensive IP we bought does not have any
    // hidden backdoors
    assert(!unlocked || password == 16'hc0de);
  end
endmodule
