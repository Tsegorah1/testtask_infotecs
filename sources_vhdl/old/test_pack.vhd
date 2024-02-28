library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;
library work;
use work.types_pack_old.all;

package test_pack is
	
	type uddcp_data93 is record
		header:uddcp_heads;
		data  :std_matrix32(2**16-1 downto 0);
	end record;
	type uddcp_data93_array is array(natural range<>) of uddcp_data93;
	
	type uddcp_nohead_data93 is record
		len   :positive;
		data  :std_matrix32(2**16-1 downto 0);
	end record;
	type uddcp_nohead_data93_array is array(natural range<>) of uddcp_nohead_data93;
	
	procedure rand_vec(
		constant len : in    integer;
		variable s0  : inout integer;
		variable s1  : inout integer;
		variable vec : out   std_logic_vector
	);
	
	procedure rand_matrix32(
		constant len : in    integer;
		variable s0  : inout integer;
		variable s1  : inout integer;
		variable vec : out   std_matrix32
	);
	
	procedure vec_stim(
		constant Vector : in  std_logic_vector;
		signal Clk    : in  std_logic;
		signal Output : out std_logic
	);
	
	procedure vec_stim_rand(
		variable s0   : inout integer;
		variable s1   : inout integer;
		signal Clk    : in  std_logic;
		signal Output : out std_logic
	);
	
	constant	c_elbc_period:time:=20 ns;
	
	procedure ELBC_single_read(
		constant Period   : in    time;
		constant AddrIn   : in    Std_logic_vector(25 downto 0);
		variable DataOut  : out   Std_logic_vector(15 downto 0);
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal Addr       : out   Std_logic_vector(25 downto 0);
		signal DInOut     : inout Std_logic_vector(15 downto 0)
	);
	
	procedure ELBC_single_write(
		constant Period   : in    time;
		constant AddrIn   : in    Std_logic_vector(25 downto 0);
		constant DataIn   : in    Std_logic_vector(15 downto 0);
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal Addr       : out   Std_logic_vector(25 downto 0);
		signal DInOut     : inout Std_logic_vector(15 downto 0)
	);
	
	procedure ELBC_msg_read(
		constant Period   : in    time;
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal ELBCAddr   : out   Std_logic_vector(25 downto 0);
		signal ELBCDInOut : inout Std_logic_vector(15 downto 0)
	);
	
	procedure ELBC_msg_write(
		constant Period   : in    time;
		constant MSGLen   : in    integer;
		constant SendAddr : in    Std_logic_vector(15 downto 0);
		constant RecvAddr : in    Std_logic_vector(15 downto 0);
		constant DataIn   : in    std_matrix32(2**9-1 downto 0);
		constant NoWait   : in    boolean;
		constant Shift    : in    integer;
--		signal VarData    : in    Std_logic_vector(15 downto 0);
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal ELBCAddr   : out   Std_logic_vector(25 downto 0);
		signal ELBCDInOut : inout Std_logic_vector(15 downto 0)
	);
	
	procedure ELBC_msg_check(
		constant DataIn   : in    std_matrix32(2**16-1 downto 0);
		signal LOE 	      : in    std_logic;
		signal LBCTL      : in    std_logic;
		signal LCS 	      : in    std_logic_vector(1 downto 0);
		signal LWE        : in    std_logic_vector(1 downto 0);
		signal ELBCAddr   : in    Std_logic_vector(25 downto 0);
		signal ELBCDInOut : in    Std_logic_vector(15 downto 0);
		signal Error      : out   std_logic
	);
	
	procedure wait_one(--сначала ждать такт, потом проверять, не 1 ли
		signal C      : in    Std_logic;
		signal S      : in    Std_logic
	);
	
	procedure wait_one_before_clk(--если не 1, то ждать такт
		signal C      : in    Std_logic;
		signal S      : in    Std_logic
	);
	
	procedure uddcp_send(--послать УПСУЦ с заголовком с непрерывной валидностью
		constant MSG  : in    uddcp_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	);
	
	procedure uddcp_send_pauses(--послать УПСУЦ с заголовком с валидностью, соответствующей вектору Vec
		constant Vec  : in    std_logic_vector;
		constant MSG  : in    uddcp_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	);
	
	procedure uddcp_send_rand_pauses(--послать УПСУЦ с заголовком со случайными паузами
		variable s0   : inout integer;
		variable s1   : inout integer;
		constant MSG  : in    uddcp_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	);
	
	procedure uddcp_send_nohead(--послать УПСУЦ без заголовка, с длиной, с непрерывной валидностью
		constant MSG  : in    uddcp_nohead_data93;
		signal C      : in  Std_logic;
		signal R      : in  Std_logic;
		signal U      : out uddcp_lite
	);
	
	procedure uddcp_send_nohead_pauses(--послать УПСУЦ без заголовка, с длиной, с валидностью, соответствующей вектору Vec
		constant Vec  : in    std_logic_vector;
		constant MSG  : in    uddcp_nohead_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	);
	
	procedure uddcp_send_nohead_rand_pauses(--послать УПСУЦ без заголовка, с длиной, со случайными паузами
		variable s0   : inout integer;
		variable s1   : inout integer;
		constant MSG  : in    uddcp_nohead_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	);
	
	procedure uddcp_listener(--сравнить УПСУЦ с заголовком с тем, что приходит по интерфейсу, при несовпадении выдать ошибку в консоль
		constant MSG  : in  uddcp_data93;
		signal C      : in  Std_logic;
		signal R      : in  Std_logic;
		signal U      : in  uddcp_lite;
		signal Success: out boolean;
		constant noout: in  boolean:=false
	);
	
	procedure uddcp_arr_listener(--сравнить массив УПСУЦ с заголовком с тем, что приходит по интерфейсу, при несовпадении выдать ошибку в консоль
		constant messages: in  uddcp_data93_array;
		signal Success : out boolean;
		-- constant noorder : in  boolean;
		signal C : in  Std_logic;
		signal R : in  Std_logic;
		signal U : in  uddcp_lite
	);
	
	procedure uddcp_nohead_listener(--сравнить УПСУЦ без заголовка с тем, что приходит по интерфейсу, при несовпадении выдать ошибку в консоль
		constant MSG  : in  uddcp_nohead_data93;
		signal C      : in  Std_logic;
		signal R      : in  Std_logic;
		signal U      : in  uddcp_lite
	);
	
	procedure uddcp_nohead_arr_listener(--сравнить массив УПСУЦ без заголовка с тем, что приходит по интерфейсу, при несовпадении выдать ошибку в консоль
		constant messages: in  uddcp_nohead_data93_array;
		signal C : in  Std_logic;
		signal R : in  Std_logic;
		signal U : in  uddcp_lite
	);
	
	impure function read_file_char_hex_to_matrix32(--читать файл по адресу; формат файла - чаровские хексы, макс. 32 бита, по 1 числу в строке, без разделителей
		file_path :string
	)return std_matrix32;
	
end package;

package body test_pack is
	----------------------------------------------------------------------------------------------
	
	procedure rand_vec(
		constant len : in    integer;
		variable s0  : inout integer;
		variable s1  : inout integer;
		variable vec : out   std_logic_vector
	)is
		variable r:real;
		variable v:std_logic_vector(16-1 downto 0);
	begin
		for i in 0 to len/16-1 loop
			uniform(s0,s1,r);
			v := std_logic_vector(to_unsigned(integer(r*2.0**16),16));
			if vec'high<16*(i+1)-1 then
				vec(vec'high downto 16*i) := v(vec'high mod 16 downto 0);
			else
				vec(16*(i+1)-1 downto 16*i) := v(15 downto 0);
			end if;
		end loop;
	end procedure;
	
	procedure rand_matrix32(
		constant len : in    integer;
		variable s0  : inout integer;
		variable s1  : inout integer;
		variable vec : out   std_matrix32
	)is
	begin
		for i in 0 to len-1 loop
			rand_vec(32,s0,s1,vec(i));
		end loop;
	end procedure;
	
	procedure vec_stim(
		constant Vector : in  std_logic_vector;
		signal Clk    : in  std_logic;
		signal Output : out std_logic
	)is
	begin
		for i in 0 to Vector'high loop
			wait until rising_edge(Clk);
			Output <= Vector(i);
		end loop;
	end procedure;
	
	procedure vec_stim_rand(
		variable s0   : inout integer;
		variable s1   : inout integer;
		signal Clk    : in  std_logic;
		signal Output : out std_logic
	)is
		variable v:std_logic_vector(31 downto 0);
	begin
		while true loop
			rand_vec(32,s0,s1,v);
			vec_stim(v,Clk,Output);
		end loop;
	end procedure;
	----------------------------------------------------------------------------------------------
	procedure ELBC_single_read(
		constant Period   : in    time;
		constant AddrIn   : in    Std_logic_vector(25 downto 0);
		variable DataOut  : out   Std_logic_vector(15 downto 0);
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal Addr       : out   Std_logic_vector(25 downto 0);
		signal DInOut     : inout Std_logic_vector(15 downto 0)
	) is
	begin
		LOE <= '1';
		LBCTL <= '1';
		LCS <= "11";
		LWE <= "11";
		Addr <= AddrIn;
		
		wait for Period;
		LCS <= "01";
		LBCTL <= '0';
		
		wait for Period;
		LOE <= '0';
		
		wait for Period;
		DataOut := DInOut;
		LCS <= "11";
		LBCTL <= '1';
		LOE <= '1';
		
	end ELBC_single_read;
	----------------------------------------------------------------------------------------------
	procedure ELBC_single_write(
		constant Period   : in    time;
		constant AddrIn   : in    Std_logic_vector(25 downto 0);
		constant DataIn   : in    Std_logic_vector(15 downto 0);
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal Addr       : out   Std_logic_vector(25 downto 0);
		signal DInOut     : inout Std_logic_vector(15 downto 0)
	) is
	begin
		LOE <= '1';
		LBCTL <= '1';
		LCS <= "11";
		LWE <= "11";
		Addr <= AddrIn;
		DInOut <= DataIn;
		
		wait for Period;
		LCS <= "01";
--		LBCTL <= '0';
		
		wait for Period;
		LOE <= '0';
		LWE <= "00";
		
		wait for Period;
		LCS <= "11";
		LOE <= '1';
		LWE <= "11";
		DInOut <= (others => 'Z');
		
		wait for Period;
		LBCTL <= '1';
		
	end ELBC_single_write;
	----------------------------------------------------------------------------------------------
	procedure ELBC_msg_read(
		constant Period   : in    time;
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal ELBCAddr   : out   Std_logic_vector(25 downto 0);
		signal ELBCDInOut : inout Std_logic_vector(15 downto 0)
	) is
		variable a:Std_logic_vector(25 downto 0);
		variable d,dp,cnt_h,cnt_l:Std_logic_vector(15 downto 0);
		variable msg_count, cnt:Std_logic_vector(31 downto 0);
		variable b:bit:='0';
		variable msg_count_int:integer;
		variable shift:std_logic_vector(25 downto 0);
	begin
		wait for Period;
		
		ELBC_single_read(c_elbc_period,"00" & x"000006",d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		while b='0' loop
			dp := d;
			ELBC_single_read(c_elbc_period,"00" & x"000006",d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
			if dp/=d then
				b := '1';
			end if;
		end loop;
		
		--read msg_count
		ELBC_single_read(c_elbc_period,"00" & x"000018",cnt_h,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_read(c_elbc_period,"00" & x"00001A",cnt_l,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		
		msg_count := cnt_h & cnt_l;
		msg_count_int := to_integer(unsigned(msg_count));
		
		shift := "00" & x"00001C";
		
		for i in 0 to msg_count_int-1 loop
			wait for c_elbc_period;
			--read header
			ELBC_single_read(c_elbc_period,shift,cnt_h,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
			shift := std_logic_vector(unsigned(shift)+"10");
			ELBC_single_read(c_elbc_period,shift,cnt_l,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
			shift := std_logic_vector(unsigned(shift)+"10");
			cnt := cnt_h & cnt_l;
			
--			ELBC_single_read(c_elbc_period,shift,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
--			shift := std_logic_vector(unsigned(shift)+"10");
--			ELBC_single_read(c_elbc_period,shift,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
--			shift := std_logic_vector(unsigned(shift)+"10");
--			
--			ELBC_single_read(c_elbc_period,shift,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
--			shift := std_logic_vector(unsigned(shift)+"10");
--			ELBC_single_read(c_elbc_period,shift,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
--			shift := std_logic_vector(unsigned(shift)+"10");
			
			--read data
	--		d := 16x"0001";
			for i in 0 to to_integer(unsigned(cnt))/4-2 loop
	--			d := DataIn(i);
				ELBC_single_read(c_elbc_period,shift,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				shift := std_logic_vector(unsigned(shift)+"10");
				ELBC_single_read(c_elbc_period,shift,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				shift := std_logic_vector(unsigned(shift)+"10");
	--			d := d + 1;
			end loop;
		
		end loop;
		
	end ELBC_msg_read;
	----------------------------------------------------------------------------------------------
	procedure ELBC_msg_write(
		constant Period   : in    time;
		constant MSGLen   : in    integer;
		constant SendAddr : in    Std_logic_vector(15 downto 0);
		constant RecvAddr : in    Std_logic_vector(15 downto 0);
		constant DataIn   : in    std_matrix32(2**9-1 downto 0);
		constant NoWait   : in    boolean;
		constant Shift    : in    integer;
--		signal VarData    : in    Std_logic_vector(15 downto 0);
		signal LOE 	      : out   std_logic;
		signal LBCTL      : out   std_logic;
		signal LCS 	      : out   std_logic_vector(1 downto 0);
		signal LWE        : out   std_logic_vector(1 downto 0);
		signal ELBCAddr   : out   Std_logic_vector(25 downto 0);
		signal ELBCDInOut : inout Std_logic_vector(15 downto 0)
	) is
		variable a:Std_logic_vector(25 downto 0);
		variable tact:Std_logic_vector(63 downto 0);
		variable d,dp,t0,t1,t2,t3:Std_logic_vector(15 downto 0);
		variable b:bit:='0';
	begin
		wait for Period;
		
		if not NoWait then
			ELBC_single_read(c_elbc_period,"00" & x"000006",d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
			while b='0' loop
				dp := d;
				ELBC_single_read(c_elbc_period,"00" & x"000006",d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				if dp/=d then
					b := '1';
				end if;
			end loop;
		end if;
		
		ELBC_single_read(c_elbc_period,"00" & x"000000",t0,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_read(c_elbc_period,"00" & x"000002",t1,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_read(c_elbc_period,"00" & x"000004",t2,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_read(c_elbc_period,"00" & x"000006",t3,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		tact := t0&t1&t2&t3;
		--msg length
		ELBC_single_write(c_elbc_period,("00" & x"000014"+std_logic_vector(to_unsigned(Shift,26))),x"0000",LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_write(c_elbc_period,("00" & x"000016"+std_logic_vector(to_unsigned(Shift,26))),std_logic_vector(to_unsigned(MSGLen,16)),
			LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		--addr1
		ELBC_single_write(c_elbc_period,("00" & x"000018"+std_logic_vector(to_unsigned(Shift,26))),RecvAddr,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_write(c_elbc_period,("00" & x"00001A"+std_logic_vector(to_unsigned(Shift,26))),SendAddr,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		--addr2
		ELBC_single_write(c_elbc_period,("00" & x"00001C"+std_logic_vector(to_unsigned(Shift,26))),x"0000",LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_write(c_elbc_period,("00" & x"00001E"+std_logic_vector(to_unsigned(Shift,26))),x"0000",LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		--config addr
--		ELBC_single_write(c_elbc_period,26x"000001C",16x"0000",LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
--		ELBC_single_write(c_elbc_period,26x"000001E",2x"0"&c_base_addr_source,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		
		tact := std_logic_vector(unsigned(tact)+3);
		a := ("00" & x"00020"+std_logic_vector(to_unsigned(Shift,26)));
--		d := 16x"0001";
		for i in 0 to MSGLen/4-4 loop
			--write tact (H)
			if i=0 then
				d := tact(63 downto 48);
				ELBC_single_write(c_elbc_period,a,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				a := a + 2;
				d := tact(47 downto 32);
				ELBC_single_write(c_elbc_period,a,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				a := a + 2;
			--write tact (L)
			elsif i=1 then
				d := tact(31 downto 16);
				ELBC_single_write(c_elbc_period,a,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				a := a + 2;
				d := tact(15 downto 0);
				ELBC_single_write(c_elbc_period,a,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				a := a + 2;
			else
				d := DataIn(i)(31 downto 16);
				ELBC_single_write(c_elbc_period,a,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				a := a + 2;
				d := DataIn(i)(15 downto 0);
				ELBC_single_write(c_elbc_period,a,d,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
				a := a + 2;
			end if;
		end loop;
		
--		ELBC_single_read(c_elbc_period,26x"0000000",t0,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_write(c_elbc_period,"00" & x"000008",t0,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		
--		ELBC_single_read(c_elbc_period,26x"0000002",t1,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_write(c_elbc_period,"00" & x"00000A",t1,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		
--		ELBC_single_read(c_elbc_period,26x"0000004",t2,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_write(c_elbc_period,"00" & x"00000C",t2,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		
--		ELBC_single_read(c_elbc_period,26x"0000006",t3,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		ELBC_single_write(c_elbc_period,"00" & x"00000E",t3,LOE,LBCTL,LCS,LWE,ELBCAddr,ELBCDInOut);
		
	end ELBC_msg_write;
	----------------------------------------------------------------------------------------------
	procedure ELBC_msg_check(
		constant DataIn   : in    std_matrix32(2**16-1 downto 0);
		signal LOE 	      : in    std_logic;
		signal LBCTL      : in    std_logic;
		signal LCS 	      : in    std_logic_vector(1 downto 0);
		signal LWE        : in    std_logic_vector(1 downto 0);
		signal ELBCAddr   : in    Std_logic_vector(25 downto 0);
		signal ELBCDInOut : in    Std_logic_vector(15 downto 0);
		signal Error      : out   std_logic
	) is
		variable a:Std_logic_vector(25 downto 0);
		variable d,dp,cnt_h,cnt_l:Std_logic_vector(15 downto 0);
		variable cnt:Std_logic_vector(31 downto 0);
	begin
		Error <= '0';
		wait until falling_edge(LOE) and LCS="00" and LWE="11";
		cnt_h := ELBCDInOut;
		wait until falling_edge(LOE) and LCS="00" and LWE="11";
		cnt_l := ELBCDInOut;
		cnt := cnt_h & cnt_l;
		wait until falling_edge(LOE) and LCS="00" and LWE="11";
		wait until falling_edge(LOE) and LCS="00" and LWE="11";
		wait until falling_edge(LOE) and LCS="00" and LWE="11";
		wait until falling_edge(LOE) and LCS="00" and LWE="11";
		for i in 0 to to_integer(unsigned(cnt))/2-1 loop
			wait until falling_edge(LOE) and LCS="00" and LWE="11";
			if DataIn(i)/=ELBCDInOut then
				Error <= '1';
			else
				Error <= '0';
			end if;
		end loop;
	end ELBC_msg_check;
	
	procedure wait_one(
		signal C      : in    Std_logic;
		signal S      : in    Std_logic
	) is
		variable len:integer;
	begin
		while true loop
			wait until rising_edge(C);
			if S='1' then
				exit;
			end if;
		end loop;
	end procedure;
	
	procedure wait_one_before_clk(
		signal C      : in    Std_logic;
		signal S      : in    Std_logic
	) is
		variable len:integer;
	begin
		while true loop
			if S='1' then
				exit;
			end if;
			wait until rising_edge(C);
		end loop;
	end procedure;
	
	procedure uddcp_send(
		constant MSG  : in    uddcp_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	) is
		variable len:integer;
	begin
		len := to_integer(unsigned(MSG.Header.LD))-8;
		U.data_valid <= '1';
		U.message_start <= '1';
		U.data <= MSG.Header.LD & "00";
		wait_one(C,R);
		U.message_start <= '0';
		U.data <= MSG.Header.MPU;
		wait_one(C,R);
		U.data <= MSG.Header.LP;
		wait_one(C,R);
		U.data <= MSG.Header.Tact(63 downto 32);
		wait_one(C,R);
		U.data <= MSG.Header.Tact(31 downto 0);
		wait_one(C,R);
		U.data <= MSG.Header.Strobe;
		wait_one(C,R);
		U.data <= MSG.Header.PSID(63 downto 32);
		wait_one(C,R);
		U.data <= MSG.Header.PSID(31 downto 0);
		for i in 0 to len-1 loop
			wait_one(C,R);
			U.data <= MSG.data(i);
		end loop;
		wait_one(C,R);
	end procedure;
	
	procedure uddcp_send_pauses(
		constant Vec  : in    std_logic_vector;
		constant MSG  : in    uddcp_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	) is
		variable len,v:integer;
	begin
		len := to_integer(unsigned(MSG.Header.LD))-8;
		v := 0;
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.LD & "00";
				U.message_start <= '1';
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		U.message_start <= '0';
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.MPU;
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.LP;
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.Tact(63 downto 32);
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.Tact(31 downto 0);
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.Strobe;
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.PSID(63 downto 32);
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		while true loop
			if Vec(v)='0' then
				U.data_valid <= '0';
				wait until rising_edge(C);
				v := v + 1;
			else
				U.data <= MSG.Header.PSID(31 downto 0);
				U.data_valid <= '1';
				wait_one(C,R);
				v := v + 1;
				exit;
			end if;
		end loop;
		for i in 0 to len-1 loop
			while true loop
				if Vec(v)='0' then
					U.data_valid <= '0';
					wait until rising_edge(C);
					v := v + 1;
				else
					U.data <= MSG.data(i);
					U.data_valid <= '1';
					wait_one(C,R);
					v := v + 1;
					exit;
				end if;
			end loop;
		end loop;
		U.data_valid <= '0';
	end procedure;
	
	procedure uddcp_send_rand_pauses(
		variable s0   : inout integer;
		variable s1   : inout integer;
		constant MSG  : in    uddcp_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	) is
		variable Vec:std_logic_vector(to_integer(unsigned(MSG.header.LD))*4-1 downto 0);
	begin
		rand_vec(to_integer(unsigned(MSG.header.LD))*4,s0,s1,Vec);
		uddcp_send_pauses(Vec,MSG,C,R,U);
	end procedure;
	
	procedure uddcp_send_nohead(
		constant MSG  : in    uddcp_nohead_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	)is
	begin
		U.data_valid <= '1';
		U.message_start <= '1';
		U.data <= MSG.data(0);
		wait_one(C,R);
		U.message_start <= '0';
		U.data <= MSG.data(1);
		for i in 2 to MSG.len-1 loop
			wait_one(C,R);
			U.data <= MSG.data(i);
		end loop;
		wait_one(C,R);
	end procedure;
	
	procedure uddcp_send_nohead_pauses(
		constant Vec  : in    std_logic_vector;
		constant MSG  : in    uddcp_nohead_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	)is
		variable v:integer;
	begin
		v := 0;
		for i in 0 to MSG.Len-1 loop
			if i=0 then
				U.data_valid <= '1';
				U.message_start <= '1';
				U.data <= MSG.data(i);
				wait_one(C,R);
			else
				U.message_start <= '0';
				while true loop
					if Vec(v)='0' then
						U.data_valid <= '0';
						wait_one(C,R);
						v := v + 1;
					else
						U.data <= MSG.data(i);
						U.data_valid <= '1';
						wait_one(C,R);
						v := v + 1;
						exit;
					end if;
				end loop;
			end if;
		end loop;
	end procedure;
	
	procedure uddcp_send_nohead_rand_pauses(
		variable s0   : inout integer;
		variable s1   : inout integer;
		constant MSG  : in    uddcp_nohead_data93;
		signal C      : in    Std_logic;
		signal R      : in    Std_logic;
		signal U      : out   uddcp_lite
	)is
		variable Vec:std_logic_vector(2**16-1 downto 0);
	begin
		rand_vec(2**16,s0,s1,Vec);
		uddcp_send_nohead_pauses(Vec,MSG,C,R,U);
	end procedure;
	
	procedure uddcp_listener(
		constant MSG  : in  uddcp_data93;
		signal C      : in  std_logic;
		signal R      : in  std_logic;
		signal U      : in  uddcp_lite;
		signal Success: out boolean;
		constant noout: in  boolean:=false
	) is
		variable PSID:std_logic_vector(63 downto 0);
		variable l:line;
	begin
		-- wait_one(C,(U.message_start and U.data_valid and R));
		Success <= false;
		while true loop
			wait until rising_edge(C);
			if (U.message_start and U.data_valid and R)='1' then
				exit;
			end if;
		end loop;
		if MSG.Header.LD&"00"/=U.data and not noout then
			report "wrong length:";
			write(l,MSG.Header.LD);
			report "expected " & l.all;
			l := null;
			write(l,U.data);
			report "got " & l.all;
		else
			for i in 0 to to_integer(unsigned(MSG.Header.LD))-1-1 loop
				-- wait_one(C,(U.data_valid and R));
				while true loop
					wait until rising_edge(C);
					if (U.data_valid and R)='1' then
						exit;
					end if;
				end loop;
				if U.message_start='1' then
					if not noout then
						report "wrong start";
					end if;
					exit;
				else
					if i<7 then
						case i is
							when 0 =>
								if U.data/=MSG.Header.MPU then
									report "wrong MPU";
									exit;
								end if;
							when 1 =>
								if U.data/=MSG.Header.LP then
									if not noout then
										report "wrong LP";
									end if;
									exit;
								end if;
							when 2 =>
								if U.data/=MSG.Header.Tact(63 downto 32) then
									if not noout then
										report "wrong Tact(63 downto 32)";
									end if;
									exit;
								end if;
							when 3 =>
								if U.data/=MSG.Header.Tact(31 downto 0) then
									if not noout then
										report "wrong Tact(31 downto 0)";
									end if;
									exit;
								end if;
							when 4 =>
								if U.data/=MSG.Header.Strobe then
									if not noout then
										report "wrong Strobe";
									end if;
									exit;
								end if;
							when 5 =>
								if U.data/=MSG.Header.PSID(63 downto 32) then
									if not noout then
										report "wrong PSID(63 downto 32)";
									end if;
									exit;
								else
									PSID(63 downto 32) := MSG.Header.PSID(63 downto 32);
								end if;
							when 6 =>
								if U.data/=MSG.Header.PSID(31 downto 0) then
									if not noout then
										report "wrong PSID(31 downto 0)";
									end if;
									exit;
								else
									PSID(31 downto 0) := MSG.Header.PSID(31 downto 0);
								end if;
							when others =>
						end case;
					else
						if U.data/=MSG.data(i-7) then
							if not noout then
								report "wrong data at position " & integer'image(i-7);
								write(l,U.data);
								report "data " & l.all;
								l := null;
								write(l,PSID);
								report "(PSID " & l.all & ")";
							end if;
							exit;
						end if;
						if i=to_integer(unsigned(MSG.Header.LD))-1-1 then
							if not noout then
								report "message received successfully";
								write(l,PSID);
								report "(PSID " & l.all & ")";
								Success <= true;
								wait for 0 ns;
							end if;
						end if;
					end if;
				end if;
			end loop;
		end if;
	end procedure;
	
	procedure uddcp_arr_listener(
		constant messages: in  uddcp_data93_array;
		signal Success : out boolean;
		signal C : in  Std_logic;
		signal R : in  Std_logic;
		signal U : in  uddcp_lite
	) is
	begin
		for i in messages'reverse_range loop
			uddcp_listener(messages(i),C,R,U,Success);
		end loop;
	end procedure;
	
	procedure uddcp_nohead_listener(
		constant MSG  : in  uddcp_nohead_data93;
		signal C      : in  std_logic;
		signal R      : in  std_logic;
		signal U      : in  uddcp_lite
	) is
		variable l:line;
	begin
		-- wait_one(C,(U.message_start and U.data_valid and R));
		while true loop
			wait until rising_edge(C);
			if (U.message_start and U.data_valid and R)='1' then
				exit;
			end if;
		end loop;
		for i in 0 to MSG.len-1 loop
			-- wait_one(C,(U.data_valid and R));
			while true loop
				wait until rising_edge(C);
				if (U.data_valid and R)='1' then
					exit;
				end if;
			end loop;
			if U.message_start='1' then
				report "wrong start";
				exit;
			else
				if U.data/=MSG.data(i) then
					report "wrong data at position " & integer'image(i-1);
					write(l,U.data);
					report "data " & l.all;
					l := null;
					write(l,MSG.data(i));
					report "(expected " & l.all & ")";
					exit;
				end if;
				if i=MSG.len-1-1 then
					report "message received successfully";
					write(l,MSG.len);
					report "(MSG.len " & l.all & ")";
				end if;
			end if;
		end loop;
	end procedure;
	
	procedure uddcp_nohead_arr_listener(
		constant messages: in  uddcp_nohead_data93_array;
		signal C : in  Std_logic;
		signal R : in  Std_logic;
		signal U : in  uddcp_lite
	) is
	begin
		for i in messages'reverse_range loop
			uddcp_nohead_listener(messages(i),C,R,U);
		end loop;
	end procedure;
	
	impure function read_file_char_hex_to_matrix32(
		file_path :string
	)return std_matrix32 is
		file input_file:text;
		variable output:std_matrix32(2**16-1 downto 0):=(others=>(others=>'0'));
		variable v_line:line;
		variable i:integer;
		variable ok:boolean;
	begin
		file_open(input_file,file_path,read_mode);
		i := 0;
		while not endfile(input_file) loop
			readline(input_file,v_line);
			hread(v_line,output(i),ok);
			i := i+1;
		end loop;
		file_close(input_file);
		return output;
	end function;
	
end test_pack;







































