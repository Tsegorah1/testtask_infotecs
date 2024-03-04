onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group test /test/clk
add wave -noupdate -expand -group test /test/rst
add wave -noupdate -expand -group test /test/rst_axis_m
add wave -noupdate -expand -group test /test/rst_axis_s
add wave -noupdate -expand -group test /test/m00_transmit
add wave -noupdate -expand -group test /test/ip_table
add wave -noupdate -expand -group test /test/s00_axi_awaddr
add wave -noupdate -expand -group test /test/s00_axi_awprot
add wave -noupdate -expand -group test /test/s00_axi_awvalid
add wave -noupdate -expand -group test /test/s00_axi_awready
add wave -noupdate -expand -group test /test/s00_axi_wdata
add wave -noupdate -expand -group test /test/s00_axi_wstrb
add wave -noupdate -expand -group test /test/s00_axi_wvalid
add wave -noupdate -expand -group test /test/s00_axi_wready
add wave -noupdate -expand -group test /test/s00_axi_bresp
add wave -noupdate -expand -group test /test/s00_axi_bvalid
add wave -noupdate -expand -group test /test/s00_axi_bready
add wave -noupdate -expand -group test /test/s00_axi_araddr
add wave -noupdate -expand -group test /test/s00_axi_arprot
add wave -noupdate -expand -group test /test/s00_axi_arvalid
add wave -noupdate -expand -group test /test/s00_axi_arready
add wave -noupdate -expand -group test /test/s00_axi_rdata
add wave -noupdate -expand -group test /test/s00_axi_rresp
add wave -noupdate -expand -group test /test/s00_axi_rvalid
add wave -noupdate -expand -group test /test/s00_axi_rready
add wave -noupdate -expand -group test /test/clk_axis_s
add wave -noupdate -expand -group test /test/s00_axis_tvalid
add wave -noupdate -expand -group test /test/s00_axis_tdata
add wave -noupdate -expand -group test /test/s00_axis_tkeep
add wave -noupdate -expand -group test /test/s00_axis_tlast
add wave -noupdate -expand -group test /test/s00_axis_tready
add wave -noupdate -expand -group test /test/clk_axis_m
add wave -noupdate -expand -group test /test/m00_axis_tvalid
add wave -noupdate -expand -group test /test/m00_axis_tdata
add wave -noupdate -expand -group test /test/m00_axis_tkeep
add wave -noupdate -expand -group test /test/m00_axis_tlast
add wave -noupdate -expand -group test /test/m00_axis_tready
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_aclk
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_aresetn
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_awaddr
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_awprot
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_awvalid
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_awready
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_wdata
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_wstrb
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_wvalid
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_wready
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_bresp
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_bvalid
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_bready
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_araddr
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_arprot
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_arvalid
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_arready
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_rdata
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_rresp
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_rvalid
add wave -noupdate -group top /test/inst_l2_network_encryptor/s00_axi_rready
add wave -noupdate -group top -color Cyan -itemcolor Cyan /test/inst_l2_network_encryptor/s00_axis_aclk
add wave -noupdate -group top -color Cyan -itemcolor Cyan /test/inst_l2_network_encryptor/s00_axis_aresetn
add wave -noupdate -group top -color Cyan -itemcolor Cyan /test/inst_l2_network_encryptor/s00_axis_tready
add wave -noupdate -group top -color Cyan -itemcolor Cyan /test/inst_l2_network_encryptor/s00_axis_tdata
add wave -noupdate -group top -color Cyan -itemcolor Cyan /test/inst_l2_network_encryptor/s00_axis_tkeep
add wave -noupdate -group top -color Cyan -itemcolor Cyan /test/inst_l2_network_encryptor/s00_axis_tlast
add wave -noupdate -group top -color Cyan -itemcolor Cyan /test/inst_l2_network_encryptor/s00_axis_tvalid
add wave -noupdate -group top -color Gold -itemcolor Gold /test/inst_l2_network_encryptor/m00_axis_aclk
add wave -noupdate -group top -color Gold -itemcolor Gold /test/inst_l2_network_encryptor/m00_axis_aresetn
add wave -noupdate -group top -color Gold -itemcolor Gold /test/inst_l2_network_encryptor/m00_axis_tvalid
add wave -noupdate -group top -color Gold -itemcolor Gold /test/inst_l2_network_encryptor/m00_axis_tdata
add wave -noupdate -group top -color Gold -itemcolor Gold /test/inst_l2_network_encryptor/m00_axis_tkeep
add wave -noupdate -group top -color Gold -itemcolor Gold /test/inst_l2_network_encryptor/m00_axis_tlast
add wave -noupdate -group top -color Gold -itemcolor Gold /test/inst_l2_network_encryptor/m00_axis_tready
add wave -noupdate -group top /test/inst_l2_network_encryptor/axi4_wr_state
add wave -noupdate -group top /test/inst_l2_network_encryptor/axi4_rd_state
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_table
add wave -noupdate -group top /test/inst_l2_network_encryptor/axi4lite_addr_locked_wr
add wave -noupdate -group top /test/inst_l2_network_encryptor/axi4lite_addr_locked_rd
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_wr_block
add wave -noupdate -group top -color Yellow -itemcolor Yellow /test/inst_l2_network_encryptor/pipeline_move
add wave -noupdate -group top -color Yellow -itemcolor Yellow /test/inst_l2_network_encryptor/pipeline_stop
add wave -noupdate -group top -color Violet -itemcolor Violet /test/inst_l2_network_encryptor/fifo_din
add wave -noupdate -group top -color Violet -itemcolor Violet /test/inst_l2_network_encryptor/fifo_dout
add wave -noupdate -group top -color Violet -itemcolor Violet /test/inst_l2_network_encryptor/fifo_empty
add wave -noupdate -group top -color Violet -itemcolor Violet /test/inst_l2_network_encryptor/fifo_full
add wave -noupdate -group top /test/inst_l2_network_encryptor/align_buffer
add wave -noupdate -group top /test/inst_l2_network_encryptor/align_buffer_be
add wave -noupdate -group top /test/inst_l2_network_encryptor/align_buffer_pointer
add wave -noupdate -group top /test/inst_l2_network_encryptor/align_buffer_last
add wave -noupdate -group top -expand /test/inst_l2_network_encryptor/header_buffer
add wave -noupdate -group top /test/inst_l2_network_encryptor/header_buffer_be
add wave -noupdate -group top /test/inst_l2_network_encryptor/header_buffer_last
add wave -noupdate -group top /test/inst_l2_network_encryptor/header_buffer_first
add wave -noupdate -group top /test/inst_l2_network_encryptor/axis_slave_first
add wave -noupdate -group top /test/inst_l2_network_encryptor/buffer_to_align_pointer
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_sender
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_receiver
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_receiver_lhalf
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_receiver_hhalf
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_sender_table
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_receiver_table
add wave -noupdate -group top /test/inst_l2_network_encryptor/sender_matches
add wave -noupdate -group top /test/inst_l2_network_encryptor/receiver_matches
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_match
add wave -noupdate -group top /test/inst_l2_network_encryptor/pair_num
add wave -noupdate -group top /test/inst_l2_network_encryptor/crc_calc_state
add wave -noupdate -group top /test/inst_l2_network_encryptor/crc_temp
add wave -noupdate -group top /test/inst_l2_network_encryptor/new_length
add wave -noupdate -group top /test/inst_l2_network_encryptor/new_crc
add wave -noupdate -group top /test/inst_l2_network_encryptor/output_state
add wave -noupdate -group top /test/inst_l2_network_encryptor/header_buffer_bytes
add wave -noupdate -group top /test/inst_l2_network_encryptor/header_buffer_bytes_be
add wave -noupdate -group top /test/inst_l2_network_encryptor/header_buffer_bytes_last
add wave -noupdate -group top /test/inst_l2_network_encryptor/ip_match_d
add wave -noupdate -group top /test/inst_l2_network_encryptor/buffer_read_pointer
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Wr_clock
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Wr_reset
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/We
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Wr_data
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Rd_clock
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Rd_reset
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Re
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Rd_data
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Empty
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Full
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Almost_empty_thresh
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Almost_full_thresh
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Almost_empty
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/Almost_full
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/head
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/tail
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/head_rd
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/tail_wr
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/dpr_we
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/wraparound_wr
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/wraparound_rd
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/wrap_set
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/wrap_clr
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/wrap_set_rd
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/wrap_clr_wr
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/empty_loc
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/full_loc
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/head_sulv
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/head_rd_sulv
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/tail_sulv
add wave -noupdate -expand -group fifo /test/inst_l2_network_encryptor/inst_fifo/tail_wr_sulv
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1380 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 188
configure wave -valuecolwidth 134
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {950 ns} {1450 ns}
