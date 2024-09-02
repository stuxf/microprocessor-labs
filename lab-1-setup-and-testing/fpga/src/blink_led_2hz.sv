module blink_led_2hz (
    output logic led
);

    // Use the internal high-speed oscillator
    logic clk_48mhz;
    HSOSC #(
        .CLKHF_DIV("0b00") // No division, full 48 MHz
    ) hsosc_inst (
        .CLKHF(clk_48mhz)
    );

    // Create a 23-bit counter to divide the clock
    // 48 MHz / 2^23 ≈ 5.72 Hz
    logic [22:0] counter;

    always_ff @(posedge clk_48mhz) begin
        counter <= counter + 1'b1;
    end

    // Toggle the LED every time the counter overflows
    // This will happen at approximately 2.86 Hz
    always_ff @(posedge clk_48mhz) begin
        if (counter == '1) begin
            led <= ~led;
        end
    end

endmodule