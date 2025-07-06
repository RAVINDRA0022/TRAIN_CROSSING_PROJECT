`timescale 1ns / 1ps

module Train_crossing(
    input clk,
    input rst,
    input train_sensor,
    input train_clear,
    output reg gate
);

    // State encoding
    parameter IDLE      = 2'b00;
    parameter APPROACH  = 2'b01;
    parameter CLOSED    = 2'b10;
    parameter CLEARING  = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic 
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (train_sensor)
                    next_state = APPROACH;
                else
                    next_state = IDLE;
            end

            APPROACH: begin
                next_state = CLOSED;
            end

            CLOSED: begin
                if (train_clear)
                    next_state = CLEARING;
                else
                    next_state = CLOSED;
            end

            CLEARING: begin
                next_state = IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic 
    always @(*) begin
        case (current_state)
            IDLE: gate = 0;
            APPROACH: gate = 1;
            CLOSED: gate = 1;
            CLEARING: gate = 0;
            default: gate = 0;
        endcase
    end

endmodule
