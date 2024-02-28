library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_misc.all;

entity top_wrapper is
    port(
        i_clk_125    : in std_logic;
        i_clk_156_25_p : in std_logic;
        i_clk_156_25_n : in std_logic;
        i_clk_312_5_p  : in std_logic;
        i_clk_312_5_n  : in std_logic;
    
        txp_32 : OUT STD_LOGIC;
        txn_32 : OUT STD_LOGIC;
        rxp_32 : IN STD_LOGIC;
        rxn_32 : IN STD_LOGIC;
    
        txp_64 : OUT STD_LOGIC;
        txn_64 : OUT STD_LOGIC;
        rxp_64 : IN STD_LOGIC;
        rxn_64 : IN STD_LOGIC

    );
end top_wrapper;

architecture arc of top_wrapper is

    signal s00_axi_awaddr  :  std_logic_vector(6-1 downto 0);
    signal s00_axi_awprot  :  std_logic_vector(2 downto 0);
    signal s00_axi_awvalid :  std_logic;
    signal s00_axi_awready :  std_logic;
    signal s00_axi_wdata   :  std_logic_vector(32-1 downto 0);
    signal s00_axi_wstrb   :  std_logic_vector((32/8)-1 downto 0);
    signal s00_axi_wvalid  :  std_logic;
    signal s00_axi_wready  :  std_logic;
    signal s00_axi_bresp   :  std_logic_vector(1 downto 0);
    signal s00_axi_bvalid  :  std_logic;
    signal s00_axi_bready  :  std_logic;
    signal s00_axi_araddr  :  std_logic_vector(6-1 downto 0);
    signal s00_axi_arprot  :  std_logic_vector(2 downto 0);
    signal s00_axi_arvalid :  std_logic;
    signal s00_axi_arready :  std_logic;
    signal s00_axi_rdata   :  std_logic_vector(32-1 downto 0);
    signal s00_axi_rresp   :  std_logic_vector(1 downto 0);
    signal s00_axi_rvalid  :  std_logic;
    signal s00_axi_rready  :  std_logic;

    signal clk_125    :std_logic;
    signal clk_156_25 :std_logic;
    signal clk_312_5  :std_logic;

    signal tx_clk0 :  STD_LOGIC;
    signal reset :  STD_LOGIC;

    signal tx_axis_aresetn :  STD_LOGIC;
    signal tx_axis_tdata :  STD_LOGIC_VECTOR(63 DOWNTO 0);
    signal tx_axis_tvalid :  STD_LOGIC;
    signal tx_axis_tlast :  STD_LOGIC;
    signal tx_axis_tuser :  STD_LOGIC_VECTOR(0 DOWNTO 0);
    signal tx_ifg_delay :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal tx_axis_tkeep :  STD_LOGIC_VECTOR(7 DOWNTO 0);
        signal tx_axis_tready :  STD_LOGIC;
        signal tx_statistics_vector :  STD_LOGIC_VECTOR(25 DOWNTO 0);
        signal tx_statistics_valid :  STD_LOGIC;

    signal rx_axis_aresetn :  STD_LOGIC;
        signal rx_axis_tdata :  STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal rx_axis_tvalid :  STD_LOGIC;
        signal rx_axis_tuser :  STD_LOGIC;
        signal rx_axis_tlast :  STD_LOGIC;
        signal rx_axis_tkeep :  STD_LOGIC_VECTOR(3 DOWNTO 0);
        signal rx_statistics_vector :  STD_LOGIC_VECTOR(29 DOWNTO 0);
        signal rx_statistics_valid :  STD_LOGIC;

    signal pause_val :  STD_LOGIC_VECTOR(15 DOWNTO 0);
    signal pause_req :  STD_LOGIC;
    signal tx_configuration_vector :  STD_LOGIC_VECTOR(79 DOWNTO 0);
    signal rx_configuration_vector :  STD_LOGIC_VECTOR(79 DOWNTO 0);
        signal status_vector :  STD_LOGIC_VECTOR(2 DOWNTO 0);
    signal tx_dcm_locked :  STD_LOGIC;
        signal xgmii_txd :  STD_LOGIC_VECTOR(31 DOWNTO 0);
        signal xgmii_txc :  STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal rx_clk0 :  STD_LOGIC;
    signal rx_dcm_locked :  STD_LOGIC;
    signal xgmii_rxd :  STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal xgmii_rxc :  STD_LOGIC_VECTOR(3 DOWNTO 0);

    signal xgmii_txd_32 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal xgmii_txc_32 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
    signal xgmii_rxd_32 :  STD_LOGIC_VECTOR(31 DOWNTO 0);
    signal xgmii_rxc_32 :  STD_LOGIC_VECTOR(3 DOWNTO 0);
    
    signal xgmii_txd_64 :  STD_LOGIC_VECTOR(63 DOWNTO 0);
    signal xgmii_txc_64 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal xgmii_rxd_64 :  STD_LOGIC_VECTOR(63 DOWNTO 0);
    signal xgmii_rxc_64 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    
begin

    inst_clk_pll_125:entity work.clk_pll_125
    Port map(
        clk_out1 => clk_125,
        reset => '0',
        locked => reset,
        clk_in1 => i_clk_125
    );

    inst_mac_input :entity work.mac_input
    PORT MAP (
        tx_clk0 => '0',
        rx_clk0 => clk_312_5,
        reset => not reset,
        tx_axis_aresetn => '0',
        tx_axis_tdata => (others => '0'),
        tx_axis_tvalid => '0',
        tx_axis_tlast => '0',
        tx_axis_tuser => (others => '0'),
        tx_axis_tkeep => (others => '0'),
        tx_axis_tready => open,

        tx_ifg_delay => (others=>'0'),
        tx_statistics_vector => open,
        tx_statistics_valid => open,

        rx_axis_aresetn => rx_axis_aresetn,
        rx_axis_tdata => rx_axis_tdata,
        rx_axis_tvalid => rx_axis_tvalid,
        rx_axis_tuser => rx_axis_tuser,
        rx_axis_tlast => rx_axis_tlast,
        rx_axis_tkeep => rx_axis_tkeep,

        rx_statistics_vector => open,
        rx_statistics_valid => open,

        pause_val => (others => '0'),
        pause_req => '0',
        tx_configuration_vector => (others=>'0'),
        rx_configuration_vector => (others=>'0'),
        status_vector => open,
        tx_dcm_locked => '1',

        rx_dcm_locked => '1',
        xgmii_txd => xgmii_txd_32,
        xgmii_txc => xgmii_txc_32,
        xgmii_rxd => xgmii_rxd_32,
        xgmii_rxc => xgmii_rxc_32
    );

    inst_mac_output :entity work.mac_output
    PORT MAP (
        tx_clk0 => clk_156_25,
        rx_clk0 => '0',
        reset => not reset,

        tx_axis_aresetn => tx_axis_aresetn,
        tx_axis_tdata => tx_axis_tdata,
        tx_axis_tvalid => tx_axis_tvalid,
        tx_axis_tlast => tx_axis_tlast,
        tx_axis_tuser(0) => tx_axis_tlast,
        tx_axis_tkeep => tx_axis_tkeep,
        tx_axis_tready => tx_axis_tready,

        tx_ifg_delay => (others=>'0'),
        tx_statistics_vector => open,
        tx_statistics_valid => open,

        rx_axis_aresetn => '0',
        rx_axis_tdata => open,
        rx_axis_tvalid => open,
        rx_axis_tuser => open,
        rx_axis_tlast => open,
        rx_axis_tkeep => open,

        rx_statistics_vector => open,
        rx_statistics_valid => open,

        pause_val => (others => '0'),
        pause_req => '0',
        tx_configuration_vector => (others=>'0'),
        rx_configuration_vector => (others=>'0'),
        status_vector => open,
        tx_dcm_locked => '1',

        rx_dcm_locked => '1',
        xgmii_txd => xgmii_txd_64,
        xgmii_txc => xgmii_txc_64,
        xgmii_rxd => xgmii_rxd_64,
        xgmii_rxc => xgmii_rxc_64
    );
    
    inst_ten_gig_eth_pcs_pma_0 :entity work.ten_gig_eth_pcs_pma_0
    PORT MAP (
        refclk_p => i_clk_156_25_p,
        refclk_n => i_clk_156_25_p,
        reset => '0',
        resetdone_out => open,
        coreclk_out => open,
        rxrecclk_out => clk_156_25,
        dclk => clk_125,
        txp => txp_32,
        txn => txn_32,
        rxp => rxp_32,
        rxn => rxn_32,
        sim_speedup_control => '0',
        txusrclk_out => open,
        txusrclk2_out => open,
        areset_coreclk_out => open,
        areset_datapathclk_out => open,
        gttxreset_out => open,
        gtrxreset_out => open,
        txuserrdy_out => open,
        reset_counter_done_out => open,
        qpll0lock_out => rx_axis_aresetn,
        qpll0outclk_out => open,
        qpll0outrefclk_out => open,
        xgmii_txd => xgmii_txd_32,
        xgmii_txc => xgmii_txc_32,
        xgmii_rxd => xgmii_rxd_32,
        xgmii_rxc => xgmii_rxc_32,
        configuration_vector => (others=>'0'),
        status_vector => open,
        core_status => open,
        signal_detect => '1',
        tx_fault => '0',
        drp_req => open,
        drp_gnt => '1',
        core_to_gt_drpen => open,
        core_to_gt_drpwe => open,
        core_to_gt_drpaddr => open,
        core_to_gt_drpdi => open,
        gt_drprdy => open,
        gt_drpdo => open,
        gt_drpen => '0',
        gt_drpwe => '0',
        gt_drpaddr => (others=>'0'),
        gt_drpdi => (others=>'0'),
        core_to_gt_drprdy => '0',
        core_to_gt_drpdo => (others=>'0'),
        tx_disable => open,
        pma_pmd_type => (others=>'0')
    );
    
    inst_ten_gig_eth_pcs_pma_64 :entity work.ten_gig_eth_pcs_pma_64
    PORT MAP (
        refclk_p => i_clk_312_5_p,
        refclk_n => i_clk_312_5_n,
        reset => '0',
        resetdone_out => open,
        coreclk_out => open,
        rxrecclk_out => open,
        dclk => clk_125,
        txp => txp_64,
        txn => txn_64,
        rxp => rxp_64,
        rxn => rxn_64,
        sim_speedup_control => '0',
        txusrclk_out => open,
        txusrclk2_out => clk_312_5,
        areset_coreclk_out => open,
        areset_datapathclk_out => open,
        gttxreset_out => open,
        gtrxreset_out => open,
        txuserrdy_out => open,
        reset_counter_done_out => open,
        qpll0lock_out => tx_axis_aresetn,
        qpll0outclk_out => open,
        qpll0outrefclk_out => open,
        xgmii_txd => xgmii_txd_64,
        xgmii_txc => xgmii_txc_64,
        xgmii_rxd => xgmii_rxd_64,
        xgmii_rxc => xgmii_rxc_64,
        configuration_vector => (others=>'0'),
        status_vector => open,
        core_status => open,
        signal_detect => '1',
        tx_fault => '0',
        drp_req => open,
        drp_gnt => '1',
        core_to_gt_drpen => open,
        core_to_gt_drpwe => open,
        core_to_gt_drpaddr => open,
        core_to_gt_drpdi => open,
        gt_drprdy => open,
        gt_drpdo => open,
        gt_drpen => '0',
        gt_drpwe => '0',
        gt_drpaddr => (others=>'0'),
        gt_drpdi => (others=>'0'),
        core_to_gt_drprdy => '0',
        core_to_gt_drpdo => (others=>'0'),
        tx_disable => open,
        pma_pmd_type => (others=>'0')
    );
    inst_l2_network_encryptor:entity work.l2_network_encryptor
        port map(
            s00_axi_aclk    => clk_125,
            s00_axi_aresetn => reset,
    
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
     
            s00_axis_aclk   => clk_312_5,
            s00_axis_aresetn=> rx_axis_aresetn,
            s00_axis_tready => open,
            s00_axis_tdata  => rx_axis_tdata,
            s00_axis_tkeep  => rx_axis_tkeep,
            s00_axis_tlast  => rx_axis_tlast,
            s00_axis_tvalid => rx_axis_tvalid,
     
            m00_axis_aclk   => clk_156_25,
            m00_axis_aresetn=> tx_axis_aresetn,
            m00_axis_tvalid => tx_axis_tvalid,
            m00_axis_tdata  => tx_axis_tdata,
            m00_axis_tkeep  => tx_axis_tkeep,
            m00_axis_tlast  => tx_axis_tlast,
            m00_axis_tready => tx_axis_tready
        );
    
    proc_gen_ip_table:process (clk_125, reset)
    begin
        if reset = '0' then
            s00_axi_awaddr  <= (others =>'0');
            s00_axi_awprot  <= (others =>'0');
            s00_axi_awvalid <= '0';
            s00_axi_wdata   <= (others =>'0');
            s00_axi_wstrb   <= (others =>'0');
            s00_axi_wvalid  <= '0';
            s00_axi_bready  <= '0';
            s00_axi_araddr  <= (others =>'0');
            s00_axi_arprot  <= (others =>'0');
            s00_axi_arvalid <= '0';
            s00_axi_arready <= '0';
            s00_axi_rvalid  <= '0';
            s00_axi_rready  <= '0';
        elsif rising_edge(clk_125) then
            s00_axi_awaddr <= std_logic_vector(unsigned(s00_axi_awaddr)+1);
            s00_axi_wdata <= std_logic_vector(unsigned(s00_axi_wdata)+3);
            s00_axi_wstrb <= std_logic_vector(unsigned(s00_axi_wstrb)+5);
            s00_axi_araddr <= std_logic_vector(unsigned(s00_axi_araddr)+1);
            s00_axi_awvalid <= s00_axi_wdata(0);
            s00_axi_wvalid <= s00_axi_wdata(1);
            s00_axi_bready <= s00_axi_wdata(2);
            s00_axi_arvalid <= s00_axi_wdata(3);
            s00_axi_arready <= s00_axi_wdata(4);
            s00_axi_rvalid <= s00_axi_wdata(5);
            s00_axi_rready <= s00_axi_wdata(6);
        end if;
    end process;
end arc;
