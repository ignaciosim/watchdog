`timescale 1ns/1ns

module watchdog_tb;

    // Parameters
    parameter TIMEOUT_VALUE = 10; // Timeout value (in clock cycles)
    parameter CLK_PERIOD = 10; // Clock period (in ns)

    // Signals
    reg clk = 0;
    reg rst_n = 1;
    reg [7:0] ui_in;
    wire [7:0] uo_out;
    //reg [7:0] uio_in;
    //wire [7:0] uio_out;
    //wire [7:0] uio_oe;
    reg ena = 0;
    wire watchdog_expired;

    // Instantiate the watchdog module
    tt_um_watchdog watchdog_inst (
        .clk(clk),
        .rst_n(rst_n),
        .ui_in(ui_in),
        .uo_out(uo_out),
        //.uio_in(uio_in),
        //.uio_out(uio_out),
        //.uio_oe(uio_oe),
        .ena(ena),
        .watchdog_expired(watchdog_expired)
    );

    // Clock generation
    always #((CLK_PERIOD)/2) clk = ~clk;

    // Reset generation
    initial begin
        rst_n = 0;
        #20; // Hold reset for a while
        rst_n = 1;
    end

    // Dumping signals for GTKWave
    initial begin
        $dumpfile("watchdog_tb.vcd");
        $dumpvars(0, watchdog_tb);
    end

    // Test scenario
    initial begin
        #100; // Wait for some time
        // Enable the design
        ena = 1;

        // Test with no changes on uio_in
        #100; // Wait for some time
        if (watchdog_expired) begin
            $display("Watchdog expired as expected after full timeout period");
        end else begin
            $display("Watchdog did not expire after full timeout period");
        end

        // Test with changes on uio_in
        ui_in = 8'hAA;
        #1000; // Wait for some time
        if (watchdog_expired) begin
            $display("Watchdog expired as expected after full timeout period");
        end else begin
            $display("Watchdog did not expire after full timeout period");
        end

        ui_in = 8'hAB;
        #1000; // Wait for some time
        
        #200
        rst_n=0;
        #200
        rst_n=1;
        

        $finish;
    end

endmodule
