module booth_encoder_stage #(
    parameter WIDTH = 8
) (
    input  wire [2:0]            booth_bits,
    input  wire signed [WIDTH:0] multiple_0,
    input  wire signed [WIDTH:0] multiple_1,
    input  wire signed [WIDTH:0] multiple_2,
    input  wire signed [WIDTH:0] minus_multiple_1,
    input  wire signed [WIDTH:0] minus_multiple_2,
    output reg signed [WIDTH:0]  partial_product
);
    always @(*) begin
        case (booth_bits)
            3'b000: partial_product = multiple_0;
            3'b001: partial_product = multiple_1;
            3'b010: partial_product = multiple_1;
            3'b011: partial_product = multiple_2;
            3'b100: partial_product = minus_multiple_2;
            3'b101: partial_product = minus_multiple_1;
            3'b110: partial_product = minus_multiple_1;
            3'b111: partial_product = multiple_0;
            default: partial_product = multiple_0;
        endcase
    end
endmodule
