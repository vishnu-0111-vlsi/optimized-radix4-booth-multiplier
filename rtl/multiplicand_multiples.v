module multiplicand_multiples #(
    parameter WIDTH = 8
) (
    input  signed [WIDTH-1:0] multiplicand,
    output reg signed [WIDTH:0] multiple_0,
    output reg signed [WIDTH:0] multiple_1,
    output reg signed [WIDTH:0] multiple_2,
    output reg signed [WIDTH:0] minus_multiple_1,
    output reg signed [WIDTH:0] minus_multiple_2
);
    always @(*) begin
        multiple_0       = {(WIDTH+1){1'b0}};
        multiple_1       = {{1{multiplicand[WIDTH-1]}}, multiplicand};
        multiple_2       = {{1{multiplicand[WIDTH-1]}}, multiplicand} << 1;
        minus_multiple_1 = -{{1{multiplicand[WIDTH-1]}}, multiplicand};
        minus_multiple_2 = -({{1{multiplicand[WIDTH-1]}}, multiplicand} << 1);
    end
endmodule
