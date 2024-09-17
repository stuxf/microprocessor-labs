module fractional_clk_div(
    input logic clk,
    input logic reset,
    output logic out_clk
);

    logic [15:0] counter;  

    always_ff @(posedge clk) begin
        if (reset == 0) begin
            counter <= '0;
            out_clk <= 0;
        end else begin
            if (counter >= 16'd24999) begin 
                out_clk <= ~out_clk;
                counter <= '0;
            end else begin
                counter <= counter + 16'd1;
            end
        end
    end
    
endmodule