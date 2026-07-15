// Top module — radix-4 Booth multiplier with precomputed multiples
module booth_multiplier_selector #(
    parameter WIDTH = 8
) (
    input  signed [WIDTH-1:0] multiplicand,
    input  signed [WIDTH-1:0] multiplier,
    output reg signed [2*WIDTH-1:0] product
);
    wire [WIDTH:0] extended_multiplier;
    wire signed [WIDTH:0] multiple_0, multiple_1, multiple_2;
    wire signed [WIDTH:0] minus_multiple_1, minus_multiple_2;
    wire signed [WIDTH:0] current_partial [0:((WIDTH+1)/2)-1];
    reg signed [2*WIDTH:0] partial_sum;
    assign extended_multiplier = {multiplier[WIDTH-1], multiplier};
    multiplicand_multiples #(.WIDTH(WIDTH)) mult_gen (
        .multiplicand(multiplicand),
        .multiple_0(multiple_0),
        .multiple_1(multiple_1),
        .multiple_2(multiple_2),
        .minus_multiple_1(minus_multiple_1),
        .minus_multiple_2(minus_multiple_2)
    );
    genvar i;
    generate
        for (i = 0; i < (WIDTH+1)/2; i = i + 1) begin : booth_stages
            booth_encoder_stage #(.WIDTH(WIDTH)) encoder (
                .booth_bits((i == 0) ? {extended_multiplier[1:0], 1'b0} :
                                       {extended_multiplier[2*i+1:2*i-1]}),
                .multiple_0(multiple_0),
                .multiple_1(multiple_1),
                .multiple_2(multiple_2),
                .minus_multiple_1(minus_multiple_1),
                .minus_multiple_2(minus_multiple_2),
                .partial_product(current_partial[i])
            );
        end
    endgenerate
    integer j;
    always @(*) begin
        partial_sum = 0;
        for (j = 0; j < (WIDTH+1)/2; j = j + 1)
            partial_sum = partial_sum + ($signed(current_partial[j]) << (2*j));
        product = partial_sum[2*WIDTH-1:0];
    end
endmodule
