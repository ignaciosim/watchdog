module dump();
    initial begin
        $dumpfile ("watchdog.vcd");
        $dumpvars (0, watchdog);
        #1;
    end
endmodule
