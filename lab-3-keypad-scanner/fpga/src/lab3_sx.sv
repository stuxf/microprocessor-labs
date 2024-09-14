/* 
 * Stephen Xu
 * September 14th, 2024
 * stxu@g.hmc.edu
 * This is the top level module for the third lab
 * Its purpose is to allow for us to take keypad input
 * It displays those onto two seven segment displays
 */

module lab3_sx(
    // Reset Input
    input logic reset,
    // Outputs for the seven segment
    // Indicates whether or not one of the displays is on
    output logic on1,
    // Indicates whether or not the other display is on
    output logic on2,
    // What the segments are
    output logic [6:0] seg,
    // For keypad matrix
    input logic [3:0] rows,
    output logic [3:0] cols
 );

 endmodule