library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.math_real.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.float_pkg.all;
library work;
use work.types_pack_old.all;
use work.types_pack.all;
use work.test_pack.all;

package test_pack_2008 is
	
	impure function read_file_char_real_to_matrix32(
		file_path :string
	)return std_matrix32;
	
	procedure rand_matrix(
		constant len : in    integer;
		constant dep : in    integer;
		variable s0  : inout integer;
		variable s1  : inout integer;
		variable vec : out   std_matrix
	);
	
end package;

package body test_pack_2008 is
	
	impure function read_file_char_real_to_matrix32(
		file_path :string
	)return std_matrix32 is
		file input_file:text;
		variable output:std_matrix32(2**16-1 downto 0):=(others=>(others=>'0'));
		variable v_line:line;
		variable i:integer;
		variable ok:boolean;
		variable v_real:real;
	begin
		file_open(input_file,file_path,read_mode);
		i := 0;
		while not endfile(input_file) loop
			readline(input_file,v_line);
			read(v_line,v_real,ok);
			output(i) := std_logic_vector(to_float(v_real));
			i := i+1;
		end loop;
		file_close(input_file);
		return output;
	end function;
	
	procedure rand_matrix(
		constant len : in    integer;
		constant dep : in    integer;
		variable s0  : inout integer;
		variable s1  : inout integer;
		variable vec : out   std_matrix
	)is
	begin
		for i in 0 to len-1 loop
			rand_vec(dep,s0,s1,vec(i));
		end loop;
	end procedure;
	
end test_pack_2008;







































