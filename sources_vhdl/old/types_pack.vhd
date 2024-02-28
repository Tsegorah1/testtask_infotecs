library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
library work;
use work.types_pack_old.all;

package types_pack is
	
	type std_matrix is array(natural range<>) of std_logic_vector;
	type uns_matrix is array(natural range<>) of unsigned;
	type std_tensor is array(natural range<>) of std_matrix;
	type std_tensor_4 is array(natural range<>) of std_tensor;
	type std_tensor32 is array(natural range<>) of std_matrix32;
	
	type int_matrix is array(natural range<>) of int_array;
	type int_tensor is array(natural range<>) of int_matrix;
	
	type complex_matrix is array(natural range<>) of complex_arr;
	type complex32_matrix is array(natural range<>) of complex32_arr;
	type uddcp_matrix is array(natural range<>) of uddcp_arr;
	type uddcp_lite_matrix is array(natural range<>) of uddcp_lite_arr;
	type uddcp_lite_64_matrix is array(natural range<>) of uddcp_lite_64_arr;
	type uddcp_lite_complex_matrix is array(natural range<>) of uddcp_lite_complex_arr;
	type heads_matrix is array(natural range<>) of heads_arr;
	
	function match(match_val: std_logic_vector; arr: std_matrix) return std_logic;
	
	function arr_init_linear(wid,dep:integer)return std_matrix;
	function matrix_tr(inp: std_matrix) return std_matrix;
	alias    transpose is matrix_tr[std_matrix return std_matrix];
	function matrix_tr(inp: uddcp_lite_64_matrix) return uddcp_lite_64_matrix;
	function matrix_tr(inp: uddcp_lite_complex_matrix) return uddcp_lite_complex_matrix;
	
	function to_std_matrix(inp:std_matrix32) return std_matrix;
	function matrix_to_matrix32(inp:std_matrix) return std_matrix32;
	function to_vector(Inp : std_matrix) return std_logic_vector;
	function to_matrix(Inp : std_logic_vector; width : integer) return std_matrix;
	
	function to_complex32_matrix(Inp : complex_matrix) return complex32_matrix;
	function to_uddcp_lite_matrix(Inp : uddcp_lite_64_arr; line_size : integer) return uddcp_lite_64_matrix;
	
	function matrix_to_vector(inp:std_matrix) return std_logic_vector;
	function vector_to_matrix(inp:std_logic_vector; row_length:natural) return std_matrix;
	function matrix_reshape(inp:std_matrix; row_length:natural) return std_matrix;
	function matrix_reverse_rows(inp:std_matrix) return std_matrix;
	function select_sub_vector(source:std_logic_vector; pos, len: natural) return std_logic_vector;
	function select_sub_matrix(source:std_matrix; pos, len: natural) return std_matrix;
	function reverse(source:std_matrix) return std_matrix;
	function matrix_tree_sum_u(source:std_matrix; adiitional_bits:positive) return std_logic_vector;

end package;

package body types_pack is
	
	function match(match_val: std_logic_vector; arr: std_matrix) return std_logic is
		variable tmp	: std_logic := '0';
	begin
		for i in 0 to arr'length-1 loop
			if arr(i)=match_val then
				tmp := '1';
			end if;
		end loop;
		return tmp;
	end function;
	
	function arr_init_linear(wid,dep:integer)return std_matrix is
		variable v:std_matrix(wid-1 downto 0)(dep-1 downto 0);
	begin
		for i in 0 to wid-1 loop
			v(i)(dep-1 downto dep/2) := std_logic_vector(to_unsigned(i,dep/2));
			v(i)(dep/2-1 downto 0) := std_logic_vector(to_unsigned(i,dep/2));
		end loop;
		return v;
	end function;
	
	function matrix_tr(inp: std_matrix) return std_matrix is
		variable v : std_matrix(inp(0)'range)(inp'range);
	begin
		for j in inp'range loop
			for i in inp(0)'range loop
				v(i)(j) := inp(j)(i);
			end loop;
		end loop;
		return v;
	end function;
	
	function matrix_tr(inp: uddcp_lite_64_matrix) return uddcp_lite_64_matrix is
		variable v : uddcp_lite_64_matrix(inp(inp'high)'range)(inp'range);
	begin
		for j in inp'range loop
			for i in inp(inp'high)'range loop
				v(i)(j) := inp(j)(i);
			end loop;
		end loop;
		return v;
	end function;

	function matrix_tr(inp: uddcp_lite_complex_matrix) return uddcp_lite_complex_matrix is
		variable v : uddcp_lite_complex_matrix(inp(inp'high)'range)(inp'range);
	begin
		for j in inp'range loop
			for i in inp(inp'high)'range loop
				v(i)(j) := inp(j)(i);
			end loop;
		end loop;
		return v;
	end function;

	function to_std_matrix(inp:std_matrix32) return std_matrix is
		variable v:std_matrix(inp'range)(31 downto 0);
	begin
		for i in inp'range loop
			v(i) := inp(i);
		end loop;
		return v;
	end function;
	
	function matrix_to_matrix32(inp:std_matrix) return std_matrix32 is
		variable v:std_matrix32(inp'range);
	begin
		for i in inp'range loop
			v(i) := inp(i);
		end loop;
		return v;
	end function;
	
	function to_vector(inp:std_matrix) return std_logic_vector is
		variable v : std_logic_vector(inp'length * inp(0)'length - 1 downto 0);
	begin
		for i in inp'range loop
			v((inp(0)'length*(i+1)) - 1 downto inp(0)'length * i) := inp(i);
		end loop;
		return v;
	end function;

	function to_matrix(Inp : std_logic_vector; width : integer) return std_matrix is
		variable v : std_matrix(Inp'length/width - 1 downto 0)(width - 1 downto 0);
	begin
		for i in v'range loop
			v(i) := Inp((width*(i+1)) - 1 downto width * i);
		end loop;
		return v;
	end function;
	
	function to_complex32_matrix(Inp : complex_matrix) return complex32_matrix is
		variable tmp : complex32_matrix(Inp'range)(Inp(inp'low)'range); 
	begin
		for i in Inp'range loop
			tmp(i) := to_complex32_arr(Inp(i));
		end loop;
		return tmp;
	end to_complex32_matrix;
	
	function to_uddcp_lite_matrix(Inp : uddcp_lite_64_arr; line_size : integer) return uddcp_lite_64_matrix is
		constant line_num	: integer := Inp'length/line_size;
		variable tmp : uddcp_lite_64_matrix(line_num - 1 downto 0)(line_size - 1 downto 0);
	begin
		for i in line_num - 1 downto 0 loop
			tmp(i) := Inp(line_size*(i+1) - 1 downto line_size*i);
		end loop;
		return tmp;
	end function;
	
	function matrix_to_vector(inp:std_matrix) return std_logic_vector is
		variable ret:std_logic_vector(inp'length * inp(inp'low)'length - 1 downto 0);
	begin
		for i in 0 to inp'length-1 loop
			ret((i+1)*inp(inp'low)'length-1 downto i*inp(inp'low)'length) := inp(inp'low+i);
		end loop;
		return ret;
	end function;

	function vector_to_matrix(inp:std_logic_vector; row_length:natural) return std_matrix is
		variable ret:std_matrix(inp'length/row_length - 1 downto 0)(row_length-1 downto 0);
	begin
		for i in ret'range loop
			ret(i) := inp((i+1)*row_length-1 downto i*row_length);
		end loop;
		return ret;
	end function;

	function matrix_reshape(inp:std_matrix; row_length:natural) return std_matrix is
	begin
		return vector_to_matrix(matrix_to_vector(inp), row_length);
	end function;

	function matrix_reverse_rows(inp:std_matrix) return std_matrix is
		variable ret:std_matrix(inp'range)(inp(inp'low)'range);
	begin
		for i in inp'range loop
			ret(i) := inp(inp'high-i);
		end loop;
		return ret;
	end function;

	function select_sub_vector(source:std_logic_vector; pos, len: natural) return std_logic_vector is
		variable ret : std_logic_vector(len-1 downto 0);
	begin
		for i in ret'range loop
			ret(i) := source(i+pos);
		end loop;
		return ret;
	end function;

	function select_sub_matrix(source:std_matrix; pos, len: natural) return std_matrix is
		variable ret : std_matrix(len-1 downto 0)(source(source'low)'range);
	begin
		for i in ret'range loop
			ret(i) := source(source'low+i+pos);
		end loop;
		return ret;
	end function;

	function reverse(source:std_matrix) return std_matrix is
		variable ret : std_matrix(source'range)(source(source'low)'range);
	begin
		for i in source'range loop
			ret(i) := source(source'high-i);
		end loop;
		return ret;
	end function;

	function matrix_tree_sum_u(source:std_matrix; adiitional_bits:positive) return std_logic_vector is
		variable ret:std_logic_vector(adiitional_bits+source(source'low)'length-1 downto 0);
	begin
		if source'length = 1 then
			ret := std_logic_vector(resize(unsigned(source(source'low)), ret'length));
		else
			ret := std_logic_vector(
				unsigned(matrix_tree_sum_u(source(source'high downto source'high-source'length/2+1), adiitional_bits))
				+ unsigned(matrix_tree_sum_u(source(source'high-source'length/2 downto source'low), adiitional_bits))
			);
		end if;
		return ret;
	end function;
	
end types_pack;




























