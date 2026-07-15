`timescale 1ns / 1ps
module tb_booth_multiplier_selector;
    localparam integer WIDTH = 8;
    localparam integer NUM_RANDOM = 1000;
    reg  signed [WIDTH-1:0] multiplicand;
    reg  signed [WIDTH-1:0] multiplier;
    wire signed [2*WIDTH-1:0] product;
    wire signed [2*WIDTH-1:0] expected;
    integer pass_count;
    integer fail_count;
    integer i;
    assign expected = multiplicand * multiplier;
    booth_multiplier_selector #(.WIDTH(WIDTH)) dut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );
    task automatic check_case(
        input string name,
        input signed [WIDTH-1:0] a,
        input signed [WIDTH-1:0] b
    );
        reg signed [2*WIDTH-1:0] exp;
        begin
            multiplicand = a;
            multiplier   = b;
            exp = a * b;
            #1;
            if (product !== exp) begin
                $display("FAIL [%s] a=%0d b=%0d exp=%0d got=%0d", name, a, b, exp, product);
                fail_count = fail_count + 1;
            end else begin
                $display("PASS [%s] %0d x %0d = %0d", name, a, b, exp);
                pass_count = pass_count + 1;
            end
        end
    endtask
    initial begin
        pass_count = 0;
        fail_count = 0;
        $display("=== Booth Multiplier Testbench ===");
        check_case("zero",     0, 0);
        check_case("one",      1, 1);
        check_case("neg_one", -1, -1);
        check_case("pos_neg",  5, -3);
        check_case("capstone", 12, 14);
        check_case("max_pos",  8'h7F, 1);
        check_case("min_neg",  8'h80, 1);
        check_case("max_max",  8'h7F, 8'h7F);
        check_case("min_min",  8'h80, 8'h80);
        for (i = 0; i < NUM_RANDOM; i = i + 1) begin
            multiplicand = $random;
            multiplier   = $random;
            #1;
            if (product !== expected) begin
                fail_count = fail_count + 1;
            end else begin
                pass_count = pass_count + 1;
            end
        end
        $display("=== SUMMARY: PASS=%0d FAIL=%0d ===", pass_count, fail_count);
        if (fail_count == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED");
        $finish;
    end
endmodule
