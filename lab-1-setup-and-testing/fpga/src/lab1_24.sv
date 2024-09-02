module lab1_24 (
    input logic [3:0] s,  // 4 DIP switches
    output logic [2:0] led,  // 3 LEDs
    output logic [6:0] seg  // 7-segment display
);

    // Instantiate the LED blinker
    blink_led_2hz blinker (
        .led(led[2])  // Connect to the third LED
    );

    // Logic for led[0] based on s[1:0]
    always_comb begin
        case (s[1:0])
            2'b01, 2'b10: led[0] = 1'b1;
            default: led[0] = 1'b0;
        endcase
    end

    // Logic for led[1] based on s[3:2]
    assign led[1] = &s[3:2];  // AND operation

    // 7-segment display decoder (you'll need to implement this)
    seven_segment_decoder decoder (
        .in(s),
        .out(seg)
    );

endmodule