`timescale 1ns / 1ps

module sequence_detector(
    input clk, 
    input rst,
    input din,
    output reg dout
);

    // State encoding
    parameter s0 = 3'd0;  // Start
    parameter s1 = 3'd1;  // 1
    parameter s2 = 3'd2;  // 11
    parameter s3 = 3'd3;  // 110
    parameter s4 = 3'd4;  // 1101 detected

    reg [2:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= s0;
            dout <= 1'b0;
        end else begin
            case (state)
                s0: begin
                    dout <= 1'b0;
                    if (din)
                        state <= s1;
                    else
                        state <= s0;
                end

                s1: begin
                    dout <= 1'b0;
                    if (din)
                        state <= s2;
                    else
                        state <= s0;
                end

                s2: begin
                    dout <= 1'b0;
                    if (!din)
                        state <= s3;
                    else
                        state <= s2;
                end

                s3: begin
                    dout <= 1'b0;
                    if (din)
                        state <= s4;
                    else
                        state <= s0;
                end

                s4: begin
                    dout <= 1'b1;       // Sequence detected
                    state <= s0;        // Reset to s0 to avoid overlap
                end

                default: begin
                    state <= s0;
                    dout <= 1'b0;
                end
            endcase
        end
    end
endmodule
