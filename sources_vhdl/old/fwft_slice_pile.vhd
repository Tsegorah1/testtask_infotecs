library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_misc.all;
use ieee.math_real.all;
library work;
--use work.const_pack.all;
use work.types_pack_old.all;

entity fwft_slice_pile is
	generic(
		G_WIDTH:positive:=33;
		G_DEPTH:positive:=2
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
end fwft_slice_pile;

architecture arc of fwft_slice_pile is
	
	signal
		v_out
	:std_logic:='0';
	
	signal
		valids,
		readys
	:std_logic_vector(G_DEPTH downto 0):=(others=>'0');
	
	type fwft_slice_data is array(natural range<>) of std_logic_vector(G_WIDTH-1 downto 0);
	signal
		datas
	:fwft_slice_data(G_DEPTH downto 0);--(G_WIDTH-1 downto 0);
	
begin
	
	datas(0) <= DIn;
	valids(0) <= VIn;
	readys(readys'high) <= ReIn;
	DOut <= datas(datas'high);
	VOut <= valids(valids'high);
	ReOut <= readys(0);
	
	genbufchain:for i in 0 to G_DEPTH-1 generate
		inst_buf:entity work.fwft_slice
			generic map(
				G_WIDTH => G_WIDTH
			)
			port map(
				Clk   => Clk,
				Rst   => Rst,
				
				DIn   => datas(i),
				VIn   => valids(i),
				ReOut => readys(i),
				DOut  => datas(i+1),
				VOut  => valids(i+1),
				ReIn  => readys(i+1)
			);
	end generate;
	
end arc;

























