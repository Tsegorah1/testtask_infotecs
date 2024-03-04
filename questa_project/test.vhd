library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

use STD.textio.all;
use ieee.std_logic_textio.all;

use work.types_pack_old.all;
use work.types_pack.all;
use work.test_pack.all;

entity test is
generic (
    -- Parameters of Axi Slave Bus Interface S00_AXI
    C_S00_AXI_DATA_WIDTH    : integer   := 32;
    C_S00_AXI_ADDR_WIDTH    : integer   := 6;

    -- Parameters of Axi Slave Bus Interface S00_AXIS
    C_S00_AXIS_TDATA_WIDTH  : integer   := 32;

    -- Parameters of Axi Master Bus Interface M00_AXIS
    C_M00_AXIS_TDATA_WIDTH  : integer   := 64
);
end test;
architecture arc of test is

    constant c_ip_table_row_count:positive:= 8;
    constant c_byte_size:positive:= 8;
    constant c_ip_addr_size:positive:= 4;
    constant c_bytes_rw:positive:= C_S00_AXI_DATA_WIDTH/c_byte_size;
    constant c_bytes_stream_slave:positive:= C_S00_AXIS_TDATA_WIDTH/c_byte_size;
    constant c_bytes_stream_master:positive:= C_M00_AXIS_TDATA_WIDTH/c_byte_size;
    constant c_buffer_depth:positive:= 7;
    constant c_input_fifo_depth:positive:= 16;

    signal clk, clk_axis_m, clk_axis_s:std_logic:='0';
    signal rst, rst_axis_m, rst_axis_s:std_logic:='0';

    signal m00_transmit : std_logic := '0';
    
    signal
        ip_table
    :std_matrix(c_ip_table_row_count*c_ip_addr_size*2-1 downto 0)(c_byte_size-1 downto 0) := (others=>(others=>'0'));

    signal s00_axi_awaddr  : std_logic_vector(6-1 downto 0) := ((others => '0') );
    signal s00_axi_awprot  : std_logic_vector(3-1 downto 0) := ((others => '0') );
    signal s00_axi_awvalid : std_logic := '0';
    signal s00_axi_awready : std_logic := '0';
    signal s00_axi_wdata   : std_logic_vector(32-1 downto 0) := ((others => '0') );
    signal s00_axi_wstrb   : std_logic_vector(32/8-1 downto 0) := ((others => '0') );
    signal s00_axi_wvalid  : std_logic := '0';
    signal s00_axi_wready  : std_logic := '0';
    signal s00_axi_bresp   : std_logic_vector(2-1 downto 0) := ((others => '0') );
    signal s00_axi_bvalid  : std_logic := '0';
    signal s00_axi_bready  : std_logic := '0';
    signal s00_axi_araddr  : std_logic_vector(6-1 downto 0) := ((others => '0') );
    signal s00_axi_arprot  : std_logic_vector(3-1 downto 0) := ((others => '0') );
    signal s00_axi_arvalid : std_logic := '0';
    signal s00_axi_arready : std_logic := '0';
    signal s00_axi_rdata   : std_logic_vector(32-1 downto 0) := ((others => '0') );
    signal s00_axi_rresp   : std_logic_vector(2-1 downto 0) := ((others => '0') );
    signal s00_axi_rvalid  : std_logic := '0';
    signal s00_axi_rready  : std_logic := '0';

    signal s00_axis_tvalid : std_logic := '0';
    signal s00_axis_tdata  : std_logic_vector(32-1 downto 0) := ((others => '0') );
    signal s00_axis_tkeep  : std_logic_vector(32/8-1 downto 0) := ((others => '0') );
    signal s00_axis_tlast  : std_logic := '0';
    signal s00_axis_tready : std_logic := '0';

    signal m00_axis_tvalid : std_logic := '0';
    signal m00_axis_tdata  : std_logic_vector(64-1 downto 0) := ((others => '0') );
    signal m00_axis_tkeep  : std_logic_vector(64/8-1 downto 0) := ((others => '0') );
    signal m00_axis_tlast  : std_logic := '0';
    signal m00_axis_tready : std_logic := '0';

    file file_ips : text;
    file file_messages : text;
    file file_output : text;

    constant c_ip_table_filename:string:= "ip_table.txt";
    constant c_messages_filename:string:= "messages.txt";
    constant c_output_filename:string:= "output.txt";

    constant c_expected_messages:integer:=1000;
begin

    s00_axi_awprot <= (others=>'0');

    s00_axi_araddr <= (others=>'0');
    s00_axi_arprot <= (others=>'0');
    s00_axi_arvalid <= '0';
    s00_axi_rready <= '1';

    proc_clk:process
    begin
        clk <= not clk;
        wait for 5 ns;
    end process;

    proc_clk_axis_m:process
    begin
        clk_axis_m <= not clk_axis_m;
        wait for 5 ns;
    end process;

    proc_clk_axis_s:process
    begin
        clk_axis_s <= not clk_axis_s;
        wait for 5 ns;
    end process;

    proc_rst:process
    begin
        rst <= '0';
        wait for 10*10 ns;
        rst <= '1';
        wait for 10*10 ns;
        rst <= '0';
        wait for 10*10 ns;

        wait;
    end process;

    proc_ip_table_rd:process
        variable v_ILINE     : line;
        variable v_readen_byte : integer;
        variable v_ADD_TERM1 : std_logic_vector(32-1 downto 0);
        variable v_ADD_TERM2 : std_logic_vector(32-1 downto 0);
        variable v_SPACE     : character;
        variable i:integer:=0;
    begin
        s00_axi_awvalid <= '0';
        s00_axi_wvalid <= '0';
        file_open(file_ips, c_ip_table_filename,  read_mode);
        wait until falling_edge(rst);
        wait for 10*10 ns;
        while not endfile(file_ips) loop
            readline(file_ips, v_ILINE);
            for i in 0 to 3 loop
                if v_ILINE'length = 0 then
                    exit;
                else
                    read(v_ILINE, v_readen_byte);
                end if;
                v_ADD_TERM1(((3-i)+1)*8-1 downto (3-i)*8) := std_logic_vector(to_unsigned(v_readen_byte, 8));
                if v_ILINE'length = 0 then
                    exit;
                else
                    read(v_ILINE, v_SPACE);
                end if;
            end loop;
                for i in 0 to 3 loop
                    if v_ILINE'length = 0 then
                        exit;
                    else
                        read(v_ILINE, v_readen_byte);
                    end if;
                    v_ADD_TERM2(((3-i)+1)*8-1 downto (3-i)*8) := std_logic_vector(to_unsigned(v_readen_byte, 8));
                    if v_ILINE'length = 0 then
                        exit;
                    else
                        read(v_ILINE, v_SPACE);
                    end if;
                end loop;

            wait until rising_edge(clk);

            wait until rising_edge(clk);
            s00_axi_awvalid <= '1';
            s00_axi_wvalid <= '0';
            s00_axi_awaddr <= std_logic_vector(to_unsigned(i*2*4, s00_axi_awaddr'length));
            wait_one_before_clk(clk, s00_axi_awready);
            
            s00_axi_awvalid <= '0';
            s00_axi_wvalid <= '1';
            s00_axi_wdata <= v_ADD_TERM1;
            s00_axi_wstrb <= (others=>'1');
            wait_one_before_clk(clk, s00_axi_wready);

            s00_axi_awvalid <= '0';
            s00_axi_wvalid <= '0';
            wait until rising_edge(clk);

            s00_axi_awvalid <= '1';
            s00_axi_wvalid <= '0';
            s00_axi_awaddr <= std_logic_vector(to_unsigned((i*2+1)*4, s00_axi_awaddr'length));
            wait_one_before_clk(clk, s00_axi_awready);
            
            s00_axi_awvalid <= '0';
            s00_axi_wvalid <= '1';
            s00_axi_wdata <= v_ADD_TERM2;
            s00_axi_wstrb <= (others=>'1');
            wait_one_before_clk(clk, s00_axi_wready);

            i := i+1;
        end loop;
        file_close(file_ips);
        wait;
    end process;

    proc_send_messages:process
        variable v_ILINE     : line;
        variable v_readen_vector : std_logic_vector(32-1 downto 0);
        variable v_readen_byte : integer;
        variable v_delimiter : character := '0';
        variable v_byte_readings:integer:=0;
        variable v_rand_vector:std_logic_vector(15 downto 0);
        variable rand_v1, rand_v2:integer:= 1;
    begin
        s00_axis_tvalid <= '0';
        file_open(file_messages, c_messages_filename,  read_mode);
        wait until falling_edge(rst);
        wait for 10*100 ns;
        while not endfile(file_messages) loop
            readline(file_messages, v_ILINE);
            while v_ILINE'length > 0 loop
                for i in 0 to 3 loop
                    if v_ILINE'length = 0 then
                        exit;
                    else
                        read(v_ILINE, v_readen_byte);
                    end if;
                    v_readen_vector((i+1)*8-1 downto i*8) := std_logic_vector(to_unsigned(v_readen_byte, 8));
                    v_byte_readings := i;
                    if v_ILINE'length = 0 then
                        exit;
                    else
                        read(v_ILINE, v_delimiter);
                    end if;
                end loop;
                
                wait until rising_edge(clk_axis_s);
                s00_axis_tvalid <= '1';
                s00_axis_tdata <= v_readen_vector;
                s00_axis_tkeep <= (others=>'0');
                for i in 0 to v_byte_readings loop
                    s00_axis_tkeep(i) <= '1';
                end loop;
                if v_ILINE'length = 0 then
                    s00_axis_tlast <= '1';
                else
                    s00_axis_tlast <= '0';
                end if;
                wait_one_before_clk(clk_axis_s, s00_axis_tready);
                rand_vec(v_rand_vector'length, rand_v1, rand_v2, v_rand_vector);
                for i in v_rand_vector'range loop
                    if v_rand_vector(i) then
                        exit;
                    else
                        wait until rising_edge(clk_axis_s);
                        s00_axis_tvalid <= '0';
                    end if;
                end loop;
            end loop;
            wait until rising_edge(clk_axis_s);
            s00_axis_tvalid <= '0';
            wait until rising_edge(clk_axis_s);
            wait until rising_edge(clk_axis_s);
        end loop;
        file_close(file_messages);
        wait;
    end process;

    m00_transmit <= m00_axis_tvalid and m00_axis_tready;

    proc_save_output:process
        variable v_ILINE     : line;
        variable v_delimiter : character := ' ';
        variable v_endmsg:boolean:=false;
    begin
        file_open(file_output, c_output_filename,  write_mode);
        wait until falling_edge(rst);
        wait for 10*100 ns;
        for i in 0 to c_expected_messages-1 loop
            while not v_endmsg loop
                v_endmsg := false;
                wait_one(clk_axis_m, m00_transmit);
                for i in 0 to 7 loop
                    if m00_axis_tkeep(i) then
                        write(v_ILINE, m00_axis_tdata((i+1)*8-1 downto i*8));
                        if i<7 then
                            if m00_axis_tkeep(i+1) then
                                write(v_ILINE, v_delimiter);
                            elsif m00_axis_tlast then
                                write(v_ILINE, LF);
                                v_endmsg := true;
                                exit;
                            end if;
                        else
                            write(v_ILINE, v_delimiter);
                            if m00_axis_tlast then
                                write(v_ILINE, LF);
                                v_endmsg := true;
                                exit;
                            end if;
                        end if;
                    end if;
                end loop;
            end loop;
            writeline(file_output, v_ILINE);
        end loop;
        file_close(file_output);
        wait;
    end process;

    proc_ready:process
        variable rand_v1, rand_v2:integer:= 1;
    begin
        vec_stim_rand(rand_v1, rand_v2, clk_axis_m, m00_axis_tready);
    end process;
    -- m00_axis_tready <= '1';

    rst_axis_m <= rst;
    rst_axis_s <= rst;

    s00_axi_bready <= '1';

    inst_l2_network_encryptor:entity work.l2_network_encryptor
        port map(
            -- Ports of Axi Slave Bus Interface S00_AXI
            s00_axi_aclk    => clk,
            s00_axi_aresetn => not rst,
            s00_axi_awaddr  => s00_axi_awaddr  ,
            s00_axi_awprot  => s00_axi_awprot  ,
            s00_axi_awvalid => s00_axi_awvalid ,
            s00_axi_awready => s00_axi_awready ,
            s00_axi_wdata   => s00_axi_wdata   ,
            s00_axi_wstrb   => s00_axi_wstrb   ,
            s00_axi_wvalid  => s00_axi_wvalid  ,
            s00_axi_wready  => s00_axi_wready  ,
            s00_axi_bresp   => s00_axi_bresp   ,
            s00_axi_bvalid  => s00_axi_bvalid  ,
            s00_axi_bready  => s00_axi_bready  ,
            s00_axi_araddr  => s00_axi_araddr  ,
            s00_axi_arprot  => s00_axi_arprot  ,
            s00_axi_arvalid => s00_axi_arvalid ,
            s00_axi_arready => s00_axi_arready ,
            s00_axi_rdata   => s00_axi_rdata   ,
            s00_axi_rresp   => s00_axi_rresp   ,
            s00_axi_rvalid  => s00_axi_rvalid  ,
            s00_axi_rready  => s00_axi_rready  ,

            s00_axis_aclk   => clk_axis_s,
            s00_axis_aresetn=> not rst_axis_s,
            s00_axis_tvalid => s00_axis_tvalid,
            s00_axis_tdata  => s00_axis_tdata,
            s00_axis_tkeep  => s00_axis_tkeep,
            s00_axis_tlast  => s00_axis_tlast,
            s00_axis_tready => s00_axis_tready,

            m00_axis_aclk   => clk_axis_m,
            m00_axis_aresetn=> not rst_axis_m,
            m00_axis_tvalid => m00_axis_tvalid,
            m00_axis_tdata  => m00_axis_tdata,
            m00_axis_tkeep  => m00_axis_tkeep,
            m00_axis_tlast  => m00_axis_tlast,
            m00_axis_tready => m00_axis_tready
        );
end arc;
