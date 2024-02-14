library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;
 
use work.types_pack_old.all;
use work.types_pack.all;

entity l2_network_encryptor is
    generic (
        -- Parameters of Axi Slave Bus Interface S00_AXI
        C_S00_AXI_DATA_WIDTH    : integer   := 32;
        C_S00_AXI_ADDR_WIDTH    : integer   := 6;
 
        -- Parameters of Axi Slave Bus Interface S00_AXIS
        C_S00_AXIS_TDATA_WIDTH  : integer   := 32;
 
        -- Parameters of Axi Master Bus Interface M00_AXIS
        C_M00_AXIS_TDATA_WIDTH  : integer   := 64
    );
    port (
        -- Ports of Axi Slave Bus Interface S00_AXI
        s00_axi_aclk    : in std_logic;
        s00_axi_aresetn : in std_logic;

        s00_axi_awaddr  : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_awprot  : in std_logic_vector(2 downto 0);
        s00_axi_awvalid : in std_logic;
        s00_axi_awready : out std_logic;
        s00_axi_wdata   : in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_wstrb   : in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
        s00_axi_wvalid  : in std_logic;
        s00_axi_wready  : out std_logic;
        s00_axi_bresp   : out std_logic_vector(1 downto 0);
        s00_axi_bvalid  : out std_logic;
        s00_axi_bready  : in std_logic;

        s00_axi_araddr  : in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
        s00_axi_arprot  : in std_logic_vector(2 downto 0);
        s00_axi_arvalid : in std_logic;
        s00_axi_arready : out std_logic;
        s00_axi_rdata   : out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
        s00_axi_rresp   : out std_logic_vector(1 downto 0);
        s00_axi_rvalid  : out std_logic;
        s00_axi_rready  : in std_logic;
 
        -- Ports of Axi Slave Bus Interface S00_AXIS
        s00_axis_aclk   : in std_logic;
        s00_axis_aresetn    : in std_logic;
        s00_axis_tready : out std_logic;
        s00_axis_tdata  : in std_logic_vector(C_S00_AXIS_TDATA_WIDTH-1 downto 0);
        s00_axis_tkeep  : in std_logic_vector((C_S00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        s00_axis_tlast  : in std_logic;
        s00_axis_tvalid : in std_logic;
 
        -- Ports of Axi Master Bus Interface M00_AXIS
        m00_axis_aclk   : in std_logic;
        m00_axis_aresetn    : in std_logic;
        m00_axis_tvalid : out std_logic;
        m00_axis_tdata  : out std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0);
        m00_axis_tkeep  : out std_logic_vector((C_M00_AXIS_TDATA_WIDTH/8)-1 downto 0);
        m00_axis_tlast  : out std_logic;
        m00_axis_tready : in std_logic
    );
end l2_network_encryptor;
architecture arc of l2_network_encryptor is

    constant c_ip_table_row_count:positive:= 8;
    constant c_byte_size:positive:= 8;
    constant c_ip_addr_size:positive:= 4;
    constant c_bytes_rw:positive:= C_S00_AXI_DATA_WIDTH/c_byte_size;
    constant c_bytes_stream_slave:positive:= C_S00_AXIS_TDATA_WIDTH/c_byte_size;
    constant c_bytes_stream_master:positive:= C_M00_AXIS_TDATA_WIDTH/c_byte_size;
    constant c_buffer_depth:positive:= 6;
    constant c_input_fifo_depth:positive:= 16;

    -- ======= axi4 lite read / write signals ==============

    type axi4_wr_states is(
        ST_WR_WAIT,
        ST_WR_BLOCK,
        ST_WR_READY,
        ST_WR_BREADY
    );
    signal
        axi4_wr_state
    :axi4_wr_states:= ST_WR_WAIT;

    type axi4_rd_states is(
        ST_RD_WAIT,
        ST_RD_DATA
    );
    signal
        axi4_rd_state
    :axi4_rd_states:= ST_RD_WAIT;

    signal
        ip_table
    :std_matrix(c_ip_table_row_count*c_ip_addr_size*2-1 downto 0)(c_byte_size-1 downto 0) := (others=>(others=>'0'));

    signal
        axi4lite_addr_locked_wr,
        axi4lite_addr_locked_rd
    :std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0) := (others=>'0');

    signal
        be_locked_wr
    :std_logic_vector(C_S00_AXI_DATA_WIDTH/c_byte_size-1 downto 0) := (others=>'0');

    signal
        ip_wr_block
    :std_logic := '0';

    -- ======= domain crossing signals =================

    signal
        fifo_dout
    :std_logic_vector(s00_axis_tdata'length + s00_axis_tkeep'length + 1 - 1 downto 0);

    signal
        fifo_empty
    :std_logic;

    -- ======= aligning signals =================

    signal
        align_buffer
    :std_logic_vector(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others=>'0');
    
    signal
        align_buffer_be
    :std_logic_vector(C_M00_AXIS_TDATA_WIDTH/c_byte_size-1 downto 0) := (others=>'0');
    
    signal
        align_buffer_pointer,
        align_buffer_last
    :std_logic := '0';

    -- ======= input buffer signals ==============
    
    signal
        header_buffer
    :std_matrix(c_buffer_depth-1 downto 0)(C_M00_AXIS_TDATA_WIDTH-1 downto 0) := (others=>(others=>'0'));

    signal
        header_buffer_be
    :std_matrix(c_buffer_depth-1 downto 0)(C_M00_AXIS_TDATA_WIDTH/c_byte_size-1 downto 0) := (others=>(others=>'0'));

    signal
        header_buffer_last,
        header_buffer_first
    :std_logic_vector(c_buffer_depth-1 downto 0) := (others=>'0');

    signal
        axis_slave_first
    :std_logic := '1';

    signal
        buffer_to_align_pointer
    :natural := 0;

    -- ======= ip checker signals ==============
    
    signal
        ip_sender,
        ip_receiver
    :std_logic_vector(c_ip_addr_size*c_byte_size-1 downto 0) := (others=>'0');

    signal
        ip_sender_table,
        ip_receiver_table
    :std_matrix(c_ip_table_row_count-1 downto 0)(c_ip_addr_size*c_byte_size-1 downto 0) := (others=>(others=>'0'));

    signal
        ip_match
    :std_logic := '1';

    signal
        pair_num
    :integer range 0 to c_ip_table_row_count-1 := 0;

    -- ======= output signals ==============
    
    type output_states is(
        ST_OUT_H1,
        ST_OUT_H2,
        ST_OUT_H3,
        ST_OUT_INSERT,
        ST_OUT_DATA
    );
    signal
        output_state
    :output_states := ST_OUT_H1;

    signal
        header_buffer_bytes
    :std_matrix(header_buffer'length*header_buffer(0)'length/c_byte_size downto 0)(c_byte_size-1 downto 0);

    signal
        header_buffer_bytes_last
    :std_logic_vector(header_buffer'length*header_buffer(0)'length/c_byte_size downto 0);

    signal
        ip_match_d
    :std_logic := '1';

    -- ======= other signals ==============
    
    signal
        pipeline_move
    :std_logic := '0';

begin

    assert C_S00_AXIS_TDATA_WIDTH /= 32
        report "The only supported value for C_S00_AXIS_TDATA_WIDTH is 32"
        severity error;
    
    assert C_M00_AXIS_TDATA_WIDTH /= 64
        report "The only supported value for C_M00_AXIS_TDATA_WIDTH is 64"
        severity error;
    
    pipeline_move <= not fifo_empty and m00_axis_tready;
    
    -- ============= axi 4 read / write ip table =================
    
    s00_axi_bresp <= "00";
    s00_axi_rresp <= "00";

    proc_table_wr:process (s00_axi_aclk, s00_axi_aresetn)
        variable bytes_to_wr:std_matrix(C_S00_AXI_DATA_WIDTH/c_byte_size-1 downto 0)(c_byte_size-1 downto 0);
    begin
        if not s00_axi_aresetn then
            axi4_wr_state <= ST_WR_WAIT;
            ip_wr_block <= '0';
            s00_axi_awready <= '0';
            s00_axi_wready <= '0';
            s00_axi_bvalid <= '0';
        elsif rising_edge(s00_axi_aclk) then
            case axi4_wr_state is
                when ST_WR_WAIT =>
                    if s00_axi_awvalid then
                        axi4_wr_state <= ST_WR_BLOCK;
                        s00_axi_awready <= '1';
                        axi4lite_addr_locked_wr <= s00_axi_awaddr;
                        be_locked_wr <= s00_axi_wstrb;
                    else
                        s00_axi_awready <= '0';
                    end if;
                    ip_wr_block <= '0';
                    s00_axi_wready <= '0';
                    s00_axi_bvalid <= '0';
                when ST_WR_BLOCK =>
                    if s00_axi_wvalid then
                        axi4_wr_state <= ST_WR_READY;
                        ip_wr_block <= '1';
                    else
                        ip_wr_block <= '0';
                    end if;
                    s00_axi_wready <= '0';
                    s00_axi_awready <= '0';
                    s00_axi_bvalid <= '0';
                when ST_WR_READY =>
                    axi4_wr_state <= ST_WR_BREADY;
                    bytes_to_wr := vector_to_matrix(s00_axi_wdata, c_byte_size);
                    for i in 0 to c_bytes_rw-1 loop
                        if be_locked_wr(i) then
                            ip_table(to_integer(unsigned(axi4lite_addr_locked_rd))) <= bytes_to_wr(i);
                        end if;
                    end loop;
                    ip_wr_block <= '1';
                    s00_axi_wready <= '1';
                    s00_axi_awready <= '0';
                    s00_axi_bvalid <= '0';
                when ST_WR_BREADY =>
                    if s00_axi_bready then
                        axi4_wr_state <= ST_WR_WAIT;
                        s00_axi_bvalid <= '1';
                    else
                        s00_axi_bvalid <= '0';
                    end if;
                    ip_wr_block <= '0';
                    s00_axi_awready <= '0';
                    s00_axi_wready <= '0';
                when others =>
                    ip_wr_block <= '0';
                    s00_axi_awready <= '0';
                    s00_axi_wready <= '0';
                    s00_axi_bvalid <= '0';
            end case;
        end if;
    end process;

    proc_table_rd:process (s00_axi_aclk, s00_axi_aresetn)
    begin
        if not s00_axi_aresetn then
            axi4_rd_state <= ST_RD_WAIT;
            s00_axi_arready <= '0';
            s00_axi_rvalid <= '0';
        elsif rising_edge(s00_axi_aclk) then
            case axi4_rd_state is
                when ST_RD_WAIT =>
                    if s00_axi_arvalid then
                        axi4_rd_state <= ST_RD_DATA;
                        axi4lite_addr_locked_rd <= s00_axi_araddr;
                        s00_axi_arready <= '1';
                    else
                        s00_axi_arready <= '0';
                    end if;
                    s00_axi_rvalid <= '0';
                when ST_RD_DATA =>
                    if s00_axi_rready then
                        axi4_rd_state <= ST_RD_WAIT;
                        s00_axi_rvalid <= '1';
                        s00_axi_rdata <= matrix_to_vector(ip_table(
                            to_integer(unsigned(axi4lite_addr_locked_rd)) + c_bytes_rw-1
                            downto to_integer(unsigned(axi4lite_addr_locked_rd))
                        ));
                    end if;
                    s00_axi_arready <= '0';
                when others=>
                    s00_axi_arready <= '0';
                    s00_axi_rvalid <= '0';
            end case;
        end if;
    end process;

    -- ============= domain crossing =================

    inst_afifo:entity work.afifo
    generic map(
        DSIZE => s00_axis_tdata'length + s00_axis_tkeep'length + 1,
        ASIZE => log2(c_input_fifo_depth)
    )
    port map(
        i_wclk   => s00_axis_aclk,
        i_wrst_n => s00_axis_aresetn,
        i_wr     => s00_axis_tvalid,
        i_wdata  => s00_axis_tdata & s00_axis_tkeep & s00_axis_tlast,
        o_wfull  => s00_axis_tready,

        i_rclk   => m00_axis_aclk,
        i_rrst_n => m00_axis_aresetn,
        i_rd     => m00_axis_tready,
        o_rdata  => fifo_dout,
        o_rempty => fifo_empty
    );

    -- ============= aligning =================

    process (m00_axis_aclk, m00_axis_aresetn)
    begin
        if not m00_axis_aresetn then
            align_buffer_pointer <= '0';
            align_buffer_be <= (others=>'0');
        elsif rising_edge(m00_axis_aclk) then
            if pipeline_move then
                align_buffer(
                    (bit_to_int(align_buffer_pointer)+1)*C_S00_AXIS_TDATA_WIDTH-1
                    downto (bit_to_int(align_buffer_pointer)*C_S00_AXIS_TDATA_WIDTH)
                ) <= fifo_dout(fifo_dout'high downto s00_axis_tkeep'length+1);
                align_buffer_be(
                    (bit_to_int(align_buffer_pointer)+1)*s00_axis_tkeep'length-1
                    downto (bit_to_int(align_buffer_pointer)*s00_axis_tkeep'length)
                ) <= fifo_dout(s00_axis_tkeep'length downto 1);
                align_buffer_last <= fifo_dout(0);
                if fifo_dout(0) then
                    align_buffer_pointer <= '0';
                else
                    align_buffer_pointer <= not align_buffer_pointer;
                end if;
            end if;
        end if;
    end process;

    -- ============= write to buffer =================

    proc_buf_wr:process (m00_axis_aclk, m00_axis_aresetn)
    begin
        if not m00_axis_aresetn then
            axis_slave_first <= '1';
            header_buffer_be <= (others=>(others=>'0'));
        elsif rising_edge(m00_axis_aclk) then
            if pipeline_move then
                if align_buffer_last then
                    axis_slave_first <= '1';
                else
                    axis_slave_first <= '0';
                end if;
                header_buffer <= header_buffer(header_buffer'high-1 downto 0) & align_buffer;
                header_buffer_be <= header_buffer_be(header_buffer_be'high-1 downto 0) & align_buffer_be;
                header_buffer_last <= header_buffer_last(header_buffer_last'high-1 downto 0) & align_buffer_last;
                header_buffer_first <= header_buffer_first(header_buffer_first'high-1 downto 0) & axis_slave_first;
            end if;
        end if;
    end process;

    -- ============= check table match =================

    ip_receiver <= header_buffer(0)(ip_receiver'length-1 downto 0);
    ip_sender <= header_buffer(1)(header_buffer'high downto header_buffer'high-ip_receiver'length+1);

    proc_table_form:process (all)
    begin
        ip_match <= '0';
        for i in 0 to c_ip_table_row_count-1 loop
            ip_sender_table(i) <= ip_table(i/2);
            ip_receiver_table(i) <= ip_table(i/2+1);
        end loop;
    end process;

    proc_match:process (m00_axis_aclk, m00_axis_aresetn)
    begin
        if not m00_axis_aresetn then
            ip_match <= '1';
        elsif rising_edge(m00_axis_aclk) then
            if pipeline_move then
                if header_buffer_first(0) then
                    ip_match <= '0';
                    for i in 0 to c_ip_table_row_count-1 loop
                        if ip_sender = ip_sender_table(i) and ip_receiver = ip_receiver_table(i) then
                            ip_match <= '1';
                            pair_num <= i+1;
                        end if;
                    end loop;
                end if;
            end if;
        end if;
    end process;

    -- ============= output =================

    header_buffer_bytes <= matrix_reverse_rows(matrix_reshape(header_buffer, c_byte_size));

    proc_mark_last_byte:process (all)
    begin
        for i in header_buffer_bytes_last'range loop
            if find_highest_1(header_buffer_be(i/4)) = i then
                header_buffer_bytes_last(i) <= '1';
            else
                header_buffer_bytes_last(i) <= '0';
            end if;
        end loop;
    end process;
    
    proc_output:process (m00_axis_aclk, m00_axis_aresetn)
        variable header_buffer_read_pointer : integer := 0;
        variable insert_position : integer := 0;
        variable output_half: std_matrix(3 downto 0)(c_byte_size-1 downto 0);
    begin
        if not m00_axis_aresetn then
            ip_match_d <= '0';
            m00_axis_tvalid <= '0';
        elsif rising_edge(m00_axis_aclk) then
            ip_match_d <= ip_match;
            if pipeline_move then
                if ip_match then
                    case output_state is
                        when ST_OUT_H1 =>
                            m00_axis_tdata <= header_buffer(3);
                            m00_axis_tkeep <= header_buffer_be(3);
                            m00_axis_tvalid <= or_reduce(header_buffer_be(3));
                            m00_axis_tlast <= header_buffer_last(3);
                        when ST_OUT_H2 =>
                            m00_axis_tdata <= header_buffer(3);
                            m00_axis_tkeep <= header_buffer_be(3);
                            m00_axis_tvalid <= or_reduce(header_buffer_be(3));
                            m00_axis_tlast <= header_buffer_last(3);
                        when ST_OUT_H3 =>
                            m00_axis_tdata(31 downto 0) <= header_buffer(3)(31 downto 0);
                            m00_axis_tkeep(3 downto 0) <= header_buffer_be(3)(3 downto 0);
                            if pair_num = 1 then
                                m00_axis_tdata(63 downto 32) <=
                                    matrix_to_vector(header_buffer_bytes(6 downto 4))
                                    & std_logic_vector(to_unsigned(pair_num, c_byte_size));
                                m00_axis_tkeep <= header_buffer_be(3)(6 downto 4) & '1';
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(6 downto 0));
                            elsif pair_num = 2 then
                                m00_axis_tdata(63 downto 32) <=
                                    matrix_to_vector(header_buffer_bytes(5 downto 4))
                                    & std_logic_vector(to_unsigned(pair_num, c_byte_size))
                                    & x"00";
                                m00_axis_tkeep(7 downto 4) <= header_buffer_be(3)(5 downto 4) & "11";
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(5 downto 0));
                            elsif pair_num = 3 then
                                m00_axis_tdata(63 downto 32) <=
                                    matrix_to_vector(header_buffer_bytes(4 downto 4))
                                    & std_logic_vector(to_unsigned(pair_num, c_byte_size))
                                    & x"00"
                                    & x"00";
                                m00_axis_tkeep(7 downto 4) <= header_buffer_be(3)(4 downto 4) & "111";
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(4 downto 0));
                            elsif pair_num = 4 then
                                m00_axis_tdata(63 downto 32) <=
                                    std_logic_vector(to_unsigned(pair_num, c_byte_size))
                                    & x"00"
                                    & x"00"
                                    & x"00";
                                m00_axis_tkeep(7 downto 4) <= (others=>'1');
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(3 downto 0));
                            else
                                m00_axis_tdata(63 downto 32) <= (others=>'0');
                                m00_axis_tkeep(7 downto 4) <= (others=>'1');
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= '0';
                            end if;
                        when ST_OUT_INSERT =>
                            if pair_num = 5 then
                                m00_axis_tdata <= 
                                    matrix_to_vector(header_buffer_bytes(10 downto 4))
                                    & std_logic_vector(to_unsigned(pair_num, c_byte_size));
                                m00_axis_tkeep <= header_buffer_be(3)(4 downto 4) & "111";
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(10 downto 4));
                            elsif pair_num = 6 then
                                m00_axis_tdata <= 
                                    matrix_to_vector(header_buffer_bytes(9 downto 4))
                                    & std_logic_vector(to_unsigned(pair_num, c_byte_size))
                                    & x"00";
                                m00_axis_tkeep <= header_buffer_be(3)(4 downto 4) & "111";
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(9 downto 4));
                            elsif pair_num = 7 then
                                m00_axis_tdata <= 
                                    matrix_to_vector(header_buffer_bytes(8 downto 4))
                                    & std_logic_vector(to_unsigned(pair_num, c_byte_size))
                                    & x"00"
                                    & x"00";
                                m00_axis_tkeep <= header_buffer_be(3)(4 downto 4) & "111";
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(8 downto 4));
                            elsif pair_num = 8 then
                                m00_axis_tdata <= 
                                    matrix_to_vector(header_buffer_bytes(7 downto 4))
                                    & std_logic_vector(to_unsigned(pair_num, c_byte_size))
                                    & x"00"
                                    & x"00"
                                    & x"00";
                                m00_axis_tkeep <= header_buffer_be(3)(4 downto 4) & "111";
                                m00_axis_tvalid <= '1';
                                m00_axis_tlast <= or_reduce(header_buffer_bytes_last(7 downto 4));
                            end if;
                            m00_axis_tvalid <= '1';
                        when ST_OUT_DATA =>
                            m00_axis_tdata <= matrix_to_vector();
                            m00_axis_tkeep <= ;
                            m00_axis_tvalid <= ;
                            m00_axis_tlast <= ;
                        when others =>
                            m00_axis_tvalid <= '0';
                    end case;
                else
                    m00_axis_tvalid <= '0';
                end if;
            end if;
        end if;
    end process;

end arc;