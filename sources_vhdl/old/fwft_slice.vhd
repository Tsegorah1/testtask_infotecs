library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.math_real.all;
library work;
--use work.const_pack.all;
use work.types_pack_old.all;

entity fwft_slice is
	generic(
		G_WIDTH:positive:=32
	);
	port(
		Clk   : in  std_logic;
		Rst   : in  std_logic;
		
		DIn  : in  std_logic_vector(G_WIDTH-1 downto 0);
		VIn  : in  std_logic;
		ReOut: out std_logic;
		DOut : out std_logic_vector(G_WIDTH-1 downto 0);
		VOut : out std_logic;
		ReIn : in  std_logic
	);
end fwft_slice;

architecture arc of fwft_slice is
	
	signal
		v_out
	:std_logic:='0';
	
	signal
		buf_empty,
		re_in_d,
		re_out,
		same_sample
	:std_logic:='1';
	
	signal
		d_out,
		buf
	:std_logic_vector(G_WIDTH-1 downto 0):=(others=>'0');
	
begin
	
	ReOut <= re_out;
	DOut <= d_out;
	VOut <= v_out;
	
	p_proc:process(Clk, Rst)
	begin
		if Rst='1' then
			d_out <= (others=>'0');
			v_out <= '0';
			re_out <= '1';
			buf_empty <= '1';
		elsif rising_edge(Clk) then
			re_in_d <= ReIn;
			if VIn='1' then
				if ReIn='1' then
					if buf_empty='0' then
						d_out <= buf;
						v_out <= '1';
						buf_empty <= '1';
						re_out <= '1';
					else
						if v_out='1' then
							if re_out='1' then
								d_out <= din;
								v_out <= '1';
								buf_empty <= '1';
								re_out <= '1';
								same_sample <= '0';
							else
								d_out <= din;
								v_out <= '0';
								buf_empty <= '1';
								re_out <= '1';
								same_sample <= '1';
							end if;
						else
							if re_out='1' then
								d_out <= din;
								v_out <= '1';
								buf_empty <= '1';
								re_out <= '1';
								same_sample <= '0';
							else
								d_out <= din;
								v_out <= '1';
								buf_empty <= '1';
								re_out <= '1';
							end if;
						end if;
					end if;
				else
					if buf_empty='0' then
						if v_out='1' then
							d_out <= d_out;
							v_out <= '1';
							buf_empty <= '0';
							re_out <= '0';
						else
							d_out <= buf;
							v_out <= '1';
							buf_empty <= '1';
							re_out <= '0';
						end if;
					else
						if v_out='1' then
							d_out <= d_out;
							v_out <= '1';
							re_out <= '0';
							if re_out='1' then
								same_sample <= '0';
								if same_sample='0' then
									buf_empty <= '0';
									buf <= DIn;
								end if;
							else
								buf_empty <= '1';
								buf <= DIn;
							end if;
						else
							d_out <= DIn;
							v_out <= '1';
							buf_empty <= '1';
							re_out <= '1';
							same_sample <= '0';
						end if;
					end if;
				end if;
			else
				if ReIn='1' then
					if buf_empty='0' then
						d_out <= buf;
						v_out <= '1';
						buf_empty <= '1';
						re_out <= '0';
					else
						d_out <= DIn;
						v_out <= '0';
						buf_empty <= '1';
						re_out <= '1';
					end if;
				else
					if buf_empty='0' then
						if v_out='1' then
							d_out <= d_out;
							v_out <= '1';
							buf_empty <= '0';
							re_out <= '0';
						else
							d_out <= buf;
							v_out <= '1';
							buf_empty <= '1';
							re_out <= '0';
						end if;
					else
						d_out <= d_out;
						v_out <= v_out;
						buf_empty <= '1';
						re_out <= '1';
					end if;
				end if;
			end if;
		end if;
	end process;
	
end arc;

























