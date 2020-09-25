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
  logic       new_try = 0;
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
    cover(unlocked);
  end

`ifndef FORMAL
  // Describe the key constraints
  class keyclass;
    rand logic [3:0] key [4];
    constraint cs {
      key[0] inside {[0:15]};
      key[1] inside {[0:15]};
      key[2] inside {[0:15]};
      key[3] inside {[0:15]};
    }
  endclass

  keyclass key = new;

  // If the last key has been sent and we are not unlocked, we need to reset the lock
  always @(posedge clk) begin
    new_try <= 0;
    if (i == 4 && !unlocked) begin
      new_try <= 1;
    end
  end

  // Generate the key and finish the simulation if the correct one has been found
  always @(posedge clk) begin
    if (reset) begin
      void'(key.randomize());
      password <= {key.key[0], key.key[1], key.key[2], key.key[3]};
    end
    if (unlocked) begin
      $display("Safe unlocked with code %h", password);
      $finish;
    end
  end
`endif
endmodule
