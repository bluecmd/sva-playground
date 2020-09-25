module safe (
    input clk,
    input reset,
    input [3:0] din,
    input din_valid,
    output wire unlocked
  );

  /*
    Aldec enum fsm_enc CURRENT = state
    Aldec enum fsm_enc STATES = PIN_0, PIN_1, PIN_2, PIN_3, LOCKOUT, UNLOCKED
    Aldec enum fsm_enc TRANS = PIN_0 -> PIN_0, PIN_0 -> LOCKOUT, PIN_0 -> PIN_1
    Aldec enum fsm_enc TRANS = PIN_1 -> PIN_1, PIN_1 -> LOCKOUT, PIN_1 -> PIN_2
    Aldec enum fsm_enc TRANS = PIN_2 -> PIN_2, PIN_2 -> LOCKOUT, PIN_2 -> PIN_3
    Aldec enum fsm_enc TRANS = PIN_3 -> PIN_3, PIN_3 -> LOCKOUT, PIN_3 -> UNLOCKED
    Aldec enum fsm_enc TRANS = LOCKOUT -> LOCKOUT, LOCKOUT -> PIN_0
  */
  // NOTE: Yosys requires these to be explicitly numbered
  typedef enum {
    PIN_0 = 0,
    PIN_1 = 1,
    PIN_2 = 2,
    PIN_3 = 3,
    LOCKOUT = 4,
    UNLOCKED = 5
  } state_t;

  state_t state;

  assign unlocked = state == UNLOCKED;

  initial begin
    state <= PIN_0;
  end

  always @(posedge clk) begin
    if (reset) begin
      state <= PIN_0;
    end else begin
      if (din_valid) begin
        case (state)
          PIN_0: begin
            if (din == 4'hc)
              state <= PIN_1;
            else
              state <= LOCKOUT;
          end
          PIN_1: begin
            if (din == 4'h0)
              state <= PIN_2;
            else
              state <= LOCKOUT;
          end
          PIN_2: begin
            if (din == 4'hd)
              state <= PIN_3;
            else
              state <= LOCKOUT;
          end
          PIN_3: begin
            if (din == 4'he)
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
