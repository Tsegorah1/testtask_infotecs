create_clock -period 6.400 -name clk_156_25 -waveform {0.000 3.200} -add [get_ports i_clk_156_25_p]
create_clock -period 3.200 -name clk_312_5 -waveform {0.000 1.600} -add [get_ports i_clk_312_5_p]
create_clock -period 8.000 -name clk_125 -waveform {0.000 4.000} -add [get_ports i_clk_125]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks clk_156_25] -group [get_clocks -include_generated_clocks i_clk_156_25_p]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks {rxoutclk_out[0]}] -group [get_clocks -include_generated_clocks {rxoutclk_out[0]_2}]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks {txoutclk_out[0]}] -group [get_clocks -include_generated_clocks {txoutclk_out[0]_2}]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks qpll0outclk_out] -group [get_clocks -include_generated_clocks qpll0outclk_out_2]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks qpll0outrefclk_out] -group [get_clocks -include_generated_clocks qpll0outrefclk_out_2]

set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks clk_125] -group [get_clocks -include_generated_clocks i_clk_125]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks clk_out1_clk_pll_125] -group [get_clocks -include_generated_clocks clk_out1_clk_pll_125_1]

set_clock_groups -group [get_clocks *312_5*] -group [get_clocks clk_156_25] -group [get_clocks clk*125*] -group [get_clocks rxoutclk*] -group [get_clocks txoutclk*]
set_clock_groups -group [get_clocks *312*] -group [get_clocks rxoutclk*]
set_clock_groups -group [get_clocks *312*] -group [get_clocks txoutclk*]

set_false_path -from [get_clocks clk_312_5] -to [get_clocks {rxoutclk_out[0]}]
set_false_path -from [get_clocks clk_312_5] -to [get_clocks {rxoutclk_out[0]_2}]
set_clock_groups -asynchronous -group [get_clocks {rxoutclk_out[0]}] -group [get_clocks clk_312_5]
set_clock_groups -asynchronous -group [get_clocks {rxoutclk_out[0]_2}] -group [get_clocks clk_312_5]
set_clock_groups -asynchronous -group [get_clocks {txoutclk_out[0]}] -group [get_clocks clk_312_5]
set_clock_groups -asynchronous -group [get_clocks {txoutclk_out[0]_2}] -group [get_clocks clk_312_5]

#set_max_delay -from [get_cells src_gray_ff_reg*] -to [get_cells dest_graysync_ff_reg[0]*] $src_clk_period -datapath_only
#set_bus_skew  -from [get_cells src_gray_ff_reg*] -to [get_cells dest_graysync_ff_reg[0]*] [expr min ($src_clk_period, $dest_clk_period)]
