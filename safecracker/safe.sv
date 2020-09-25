module safe (
    input clk,
    input reset,
    input [3:0] din,
    input din_valid,
    output wire unlocked
  );

 `ifdef YOSYS
  // TODO: Yosys seems to not like SV state enums
  localparam PIN_0 = 0,
             PIN_1 = 1,
             PIN_2 = 2,
             PIN_3 = 3,
             LOCKOUT = 4,
             UNLOCKED = 5;

  reg [2:0] state = PIN_0;
`else
  /*
    Aldec enum fsm_enc CURRENT = state
    Aldec enum fsm_enc STATES = PIN_0, PIN_1, PIN_2, PIN_3, LOCKOUT, UNLOCKED
    Aldec enum fsm_enc TRANS = PIN_0 -> PIN_0, PIN_0 -> LOCKOUT, PIN_0 -> PIN_1
    Aldec enum fsm_enc TRANS = PIN_1 -> PIN_1, PIN_1 -> LOCKOUT, PIN_1 -> PIN_2
    Aldec enum fsm_enc TRANS = PIN_2 -> PIN_2, PIN_2 -> LOCKOUT, PIN_2 -> PIN_3
    Aldec enum fsm_enc TRANS = PIN_3 -> PIN_3, PIN_3 -> LOCKOUT, PIN_3 -> UNLOCKED
    Aldec enum fsm_enc TRANS = LOCKOUT -> LOCKOUT, LOCKOUT -> PIN_0
  */
  typedef enum {
    PIN_0,
    PIN_1,
    PIN_2,
    PIN_3,
    LOCKOUT,
    UNLOCKED
  } state_t;

  state_t state = PIN_0;
`endif

  assign unlocked = state == UNLOCKED;

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
