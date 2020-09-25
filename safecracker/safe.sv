module safe (
    input clk,
    input reset,
    input [7:0] din,
    input din_valid,
    output wire unlocked
  );

  typedef enum {
    PIN_0,
    PIN_1,
    PIN_2,
    PIN_3,
    LOCKOUT,
    UNLOCKED
  } state_t;

  state_t state = PIN_0;

  assign unlocked = state == UNLOCKED;

  always @(posedge clk) begin
    if (reset) begin
      state <= PIN_0;
    end else begin
      if (din_valid) begin
        case (state)
          PIN_0: begin
            if (din == 8'hba)
              state <= PIN_1;
            else
              state <= LOCKOUT;
          end
          PIN_1: begin
            if (din == 8'had)
              state <= PIN_2;
            else
              state <= LOCKOUT;
          end
          PIN_2: begin
            if (din == 8'hc0)
              state <= PIN_3;
            else
              state <= LOCKOUT;
          end
          PIN_3: begin
            if (din == 8'hde)
              state <= UNLOCKED;
            else
              state <= LOCKOUT;
          end
          default: ;
        endcase
      end
    end
  end
endmodule
