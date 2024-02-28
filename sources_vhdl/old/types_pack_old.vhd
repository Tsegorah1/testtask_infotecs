library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;
use ieee.std_logic_misc.all;
library work;
use work.PCK_CRC32_D32.all;

package types_pack_old is
	
	type std_matrix128 is array(natural range<>) of std_logic_vector(127 downto 0);
	type std_matrix102 is array(natural range<>) of std_logic_vector(102 - 1 downto 0);
	type std_matrix67 is array(natural range<>) of std_logic_vector(66 downto 0);
	type std_matrix64 is array(natural range<>) of std_logic_vector(63 downto 0);
	type std_matrix56 is array(natural range<>) of std_logic_vector(55 downto 0);
	type std_matrix51 is array(natural range<>) of std_logic_vector(50 downto 0);
	type std_matrix48 is array(natural range<>) of std_logic_vector(47 downto 0);
	type std_matrix36 is array(natural range<>) of std_logic_vector(35 downto 0);
	type std_matrix33 is array(natural range<>) of std_logic_vector(32 downto 0);
	type std_matrix32 is array(natural range<>) of std_logic_vector(31 downto 0);
	type std_matrix25 is array(natural range<>) of std_logic_vector(24 downto 0);
	type std_matrix17 is array(natural range<>) of std_logic_vector(16 downto 0);
	type std_matrix16 is array(natural range<>) of std_logic_vector(15 downto 0);
	type std_matrix15 is array(natural range<>) of std_logic_vector(14 downto 0);
	type std_matrix14 is array(natural range<>) of std_logic_vector(13 downto 0);
	type std_matrix13 is array(natural range<>) of std_logic_vector(12 downto 0);
	type std_matrix10 is array(natural range<>) of std_logic_vector(9 downto 0);
	type std_matrix9 is array(natural range<>) of std_logic_vector(8 downto 0);
	type std_matrix8 is array(natural range<>) of std_logic_vector(7 downto 0);
	type std_matrix7 is array(natural range<>) of std_logic_vector(6 downto 0);
	type std_matrix6 is array(natural range<>) of std_logic_vector(5 downto 0);	
	type std_matrix5 is array(natural range<>) of std_logic_vector(4 downto 0);	
	type std_matrix4 is array(natural range<>) of std_logic_vector(3 downto 0);
	type std_matrix3 is array(natural range<>) of std_logic_vector(2 downto 0);
	type std_matrix2 is array(natural range<>) of std_logic_vector(1 downto 0);
	type std_matrix1 is array(natural range<>) of std_logic;	
	type std_tensor6_32 is array(natural range<>) of std_matrix32(5 downto 0);
	type std_tensor64_32 is array(natural range<>) of std_matrix32(63 downto 0);
	type std_tensor128_32 is array(natural range<>) of std_matrix32(127 downto 0);	
	type int_array is array(natural range<>) of integer;
	subtype int_arr is int_array;
	type natural_array is array(natural range<>) of natural;
	subtype natural_arr is natural_array;
	
	--Комплексное число и набор каналов с комплексными отсчетами
	type complex_type is record
		re	: std_logic_vector (15 downto 0);
		im	: std_logic_vector (15 downto 0);
	end record complex_type;
	subtype complex is complex_type;
	type arr_complex_type is array(natural range<>) of complex_type;
	subtype complex_arr is arr_complex_type;
	
	type complex32_type is record
		re	: std_logic_vector (31 downto 0);
		im	: std_logic_vector (31 downto 0);
	end record complex32_type;
	subtype complex32 is complex32_type;
	type arr_complex32_type is array(natural range<>) of complex32_type;
	subtype complex32_arr is arr_complex32_type;
	
	--Порт в одну сторону соединения устройств по УПСУЦ
	type uddcp is record
		message_start	: std_logic;
		data				: std_logic_vector(31 downto 0);
		data_valid		: std_logic;
		read_ready		: std_logic;
	end record uddcp;
	type uddcp_arr is array(natural range<>) of uddcp;
	type uddcp_full is record
		message_start	: std_logic;
		message_end		: std_logic;
		data				: std_logic_vector(31 downto 0);
		data_valid		: std_logic;
		read_ready		: std_logic;
	end record uddcp_full;
	type uddcp_full_arr is array(natural range<>) of uddcp_full;
	type uddcp_heads is record
		LD					: std_logic_vector(29 downto 0);
		MPU				: std_logic_vector(31 downto 0);
		LP					: std_logic_vector(31 downto 0);
		Tact				: std_logic_vector(63 downto 0);
		Strobe			: std_logic_vector(31 downto 0);
		PSID				: std_logic_vector(63 downto 0);
	end record uddcp_heads;
	type uddcp_heads_arr is array(natural range<>) of uddcp_heads;
	subtype heads_arr is uddcp_heads_arr;
	--uddcp_lite = без read_ready
	type uddcp_lite is record
		message_start	: std_logic;
		data				: std_logic_vector(31 downto 0);
		data_valid		: std_logic;
	end record uddcp_lite;
	subtype upcdd_lite is uddcp_lite;	
	type uddcp_lite_arr is array(natural range<>) of uddcp_lite;	
	type uddcp_lite_64 is record
		message_start	: std_logic;
		data				: std_logic_vector(63 downto 0);
		data_valid		: std_logic;
	end record uddcp_lite_64;	
	type uddcp_lite_64_arr is array(natural range<>) of uddcp_lite_64;	
	
	type uddcp_lite_complex is record
		message_start	: std_logic;
		data				: complex32_type;
		data_valid		: std_logic;
	end record uddcp_lite_complex;	
	type uddcp_lite_complex_arr is array(natural range<>) of uddcp_lite_complex;	
	
	type mem_port is record
		addres			: std_logic_vector(31 downto 0);
		data				: std_logic_vector(31 downto 0);
		data_valid		: std_logic;
		read_req			: std_logic;
	end record mem_port;
	
	function uddcp_lite_complex_to_64 (Inp : uddcp_lite_complex) return uddcp_lite_64;
	function uddcp_lite_complex_to_64_arr (Inp : uddcp_lite_complex_arr) return uddcp_lite_64_arr;	
	function uddcp_lite_to_complex (Inp : uddcp_lite) return uddcp_lite_complex;
	function to_complex32(Inp : complex) return complex32;
	function to_complex32_arr(Inp : complex_arr) return complex32_arr;
	
	function heads_to_vector(i:uddcp_heads) return std_logic_vector;
	function vector_to_heads(i:std_logic_vector) return uddcp_heads;
	function heads_to_matrix(i:uddcp_heads) return std_matrix32;
	function matrix_to_heads(i:std_matrix32(7 downto 0)) return uddcp_heads;
	
	function log2(Inp:integer) return integer;
	function log2(Inp:std_logic_vector) return integer;
	function arr_init_linear32(wid:integer)return std_matrix32;
	function reverse_std_logic_vector(v:std_logic_vector)return std_logic_vector;
	alias reverse is reverse_std_logic_vector[std_logic_vector return std_logic_vector];	
	function max(inp:int_arr) return integer;	
	function reverse_bytes(inp:std_logic_vector) return std_logic_vector;
	function crc32(
		inp:std_logic_vector(31 downto 0);
		crc:std_logic_vector(31 downto 0)
	) return std_logic_vector;
	function byte_swap(inp:std_logic_vector) return std_logic_vector;	
	function finding_first_one (Inp : std_logic_vector) return integer;
	function ones_count (Inp : std_logic_vector) return integer;	
	function get_index_ones (Inp : std_logic_vector) return int_arr;
	function sel(s:boolean; i0:integer; i1:integer) return integer;	
	function to_std_logic(i:integer) return std_logic;
	function get_rounding_bit(source:std_logic_vector; rounding_bit:std_logic; bits_to_round:positive) return std_logic;
	function round(source:std_logic_vector; control_bit:std_logic; bits_to_round:positive) return std_logic_vector;
	function round_sign(source:std_logic_vector; bits_to_round:positive) return std_logic_vector;
	function round_even(source:std_logic_vector; bits_to_round:positive) return std_logic_vector;
	function not1_to_0(source:std_logic_vector) return std_logic_vector;
	function invert_sign(source:std_logic_vector) return std_logic_vector;
	function bit_to_int(source:std_logic) return integer;
	function bits_tree_sum(source:std_logic_vector) return natural;

end package;

package body types_pack_old is
	
	function log2(Inp:integer) return integer is
		variable v,tmp:integer:=0;
	begin
		tmp := 1;
		while tmp<Inp loop
			v := v+1;
			tmp := tmp*2;
		end loop;
		return v;
	end log2;
	
	function log2(Inp:std_logic_vector) return integer is
		variable tmp:integer:=0;
	begin
		tmp := to_integer(unsigned(Inp));
		return log2(tmp);
	end log2;
	
	function arr_init_linear32(wid:integer)return std_matrix32 is
		variable v:std_matrix32(wid-1 downto 0);
	begin
		for i in 0 to wid-1 loop
			v(i)(32-1 downto 32/2) := std_logic_vector(to_unsigned(i,32/2));
			v(i)(32/2-1 downto 0) := std_logic_vector(to_unsigned(i,32/2));
		end loop;
		return v;
	end function;

	function uddcp_lite_complex_to_64 (Inp : uddcp_lite_complex) return uddcp_lite_64 is
		variable tmp : uddcp_lite_64;
	begin
		tmp.message_start := Inp.message_start;
		tmp.data := Inp.data.re & Inp.data.im;
		tmp.data_valid := Inp.data_valid;
		return tmp;
	end uddcp_lite_complex_to_64;
	function uddcp_lite_complex_to_64_arr (Inp : uddcp_lite_complex_arr) return uddcp_lite_64_arr is
		variable tmp : uddcp_lite_64_arr(Inp'range);
	begin
		for i in Inp'range loop
			tmp(i) := uddcp_lite_complex_to_64(Inp(i));
		end loop;
		return tmp;
	end uddcp_lite_complex_to_64_arr;
	
	function uddcp_lite_to_complex (Inp : uddcp_lite) return uddcp_lite_complex is
		variable tmp : uddcp_lite_complex;
	begin
		tmp.message_start := Inp.message_start;
		tmp.data.re := Inp.data;
		tmp.data.im := (others => '0');
		tmp.data_valid := Inp.data_valid;
		return tmp;
	end uddcp_lite_to_complex;
	
	function to_complex32_arr(Inp : complex_arr) return complex32_arr is
		variable tmp : complex32_arr(Inp'range); 
	begin
		for i in Inp'range loop
			tmp(i) := to_complex32(Inp(i));
		end loop;
		return tmp;
	end to_complex32_arr;
	
	function to_complex32(Inp : complex) return complex32 is
		variable tmp : complex32; 
	begin
		tmp.re := std_logic_vector(resize(unsigned(Inp.re), 32));
		tmp.im := std_logic_vector(resize(unsigned(Inp.im), 32));
		return tmp;
	end to_complex32;
	
	function heads_to_vector(i:uddcp_heads) return std_logic_vector is
	begin
		return i.PSID & i.Strobe & i.Tact & i.LP & i.MPU & i.LD;
	end function;
	function vector_to_heads(i:std_logic_vector) return uddcp_heads is
		variable res : uddcp_heads;
	begin
		res := (i(29 downto 0), i(61 downto 30), i(93 downto 62), i(157 downto 94), i(189 downto 158), i(253 downto 190));
		return res;
	end function;
	
	function heads_to_matrix(i:uddcp_heads) return std_matrix32 is
		variable tmp : std_matrix32(7 downto 0);
	begin
		tmp(7) := i.PSID(31 downto 0); tmp(6) := i.PSID(63 downto 32);	tmp(5) := i.Strobe;
		tmp(4) := i.Tact(31 downto 0); tmp(3) := i.Tact(63 downto 32);
		tmp(2) := i.LP; tmp(1) := i.MPU;	tmp(0) := "00" & i.LD;
		return tmp;
	end function;
	function matrix_to_heads(i:std_matrix32(7 downto 0)) return uddcp_heads is
		variable res : uddcp_heads;
	begin
		res := (i(0)(29 downto 0), i(1), i(2), i(3)&i(4), i(5), i(6)&i(7));
		return res;
	end function;
		
	function reverse_std_logic_vector(v:std_logic_vector)return std_logic_vector is
		variable rez:std_logic_vector(v'range);
		alias a:std_logic_vector(v'reverse_range) is v;
	begin
		for i in a'range loop
			rez(i) := a(i);
		end loop;
		return rez;
	end function;	
	
	function max(inp:int_arr) return integer is
		variable v:integer;
	begin
		v := integer'low;
		for i in inp'range loop
			if v < inp(i) then
				v := inp(i);
			end if;
		end loop;
		return v;
	end function;
	
	function reverse_bytes(inp:std_logic_vector) return std_logic_vector is
		variable v:std_logic_vector(inp'range);
	begin
		for i in 0 to 7 loop
			for j in 0 to inp'length/8-1 loop
				v(j*8+i) := inp((j+1)*8-1-i);
			end loop;
		end loop;
		return v;
	end function;
	
	function crc32(
		inp:std_logic_vector(31 downto 0);
		crc:std_logic_vector(31 downto 0)
	) return std_logic_vector is
		variable v:std_logic_vector(31 downto 0);
		variable lin:line;
	begin
		v := reverse_bytes(inp);
		v := nextCRC32_D32(v, crc);
		-- v := reverse(v);
		-- v := not v;
		return v;
	end function;
	
	function byte_swap(inp:std_logic_vector) return std_logic_vector is
		variable v:std_logic_vector(inp'range);
		constant bcount:integer:=inp'length/8;
	begin
		for j in 0 to bcount-1 loop
			v((j+1)*8-1 downto j*8) := inp((bcount-j)*8-1 downto (bcount-j-1)*8);
		end loop;
		return v;
	end function;
	
	function finding_first_one (Inp : std_logic_vector) return integer is
	begin   
		for i in Inp'low to Inp'high loop
			if Inp(i) = '1' then
				return i;
			end if;
		end loop;    
		-- all zero
		return 0;
	end function;
	function ones_count (Inp : std_logic_vector) return integer is
		variable result : integer := 0;
	begin
		for i in 0 to Inp'high loop
			if (Inp(i) = '1') then
				result := result + 1;
			end if;
		end loop;
		return result;
	end function;

	function get_index_ones (Inp : std_logic_vector) return int_arr is
		variable result : int_arr(ones_count(Inp) - 1 downto 0) := (others => 0);
		variable start_find : integer := 0;
	begin
		for i in 0 to ones_count(Inp) - 1 loop
			result(i) := finding_first_one(Inp(Inp'high downto start_find));
			start_find := result(i) + 1;
		end loop;
		return result;
	end function;

	function sel(s:boolean; i0:integer; i1:integer)
		return integer is
	begin
		if s = true then
			return i0;
		else
			return i1;
		end if;
	end function;
	
	function to_std_logic(i:integer) return std_logic is
	begin
		if i=0 then return '0';
		else return '1';
		end if;
	end function;
	
	function get_rounding_bit(source:std_logic_vector; rounding_bit:std_logic; bits_to_round:positive) return std_logic is
		variable source_v : std_logic_vector(source'length-1 downto 0);
	begin
		source_v := source;
		if bits_to_round=1 then
			return rounding_bit and source_v(0);
		else
			if source_v(bits_to_round-1)='1' and unsigned(source_v(bits_to_round-2 downto 0))=0 then -- if 0,5
				return rounding_bit;
			else
				return source_v(bits_to_round-1);
			end if;
		end if;
	end function;

	function round(source:std_logic_vector; control_bit:std_logic; bits_to_round:positive) return std_logic_vector is
		variable r_bit:unsigned(0 downto 0);
		variable source_v : std_logic_vector(source'length-1 downto 0);
		variable result	: std_logic_vector(source'length-bits_to_round - 1 downto 0);
	begin
		source_v := source;
		if source_v(source_v'high)='0' and signed(source_v(source_v'high-1 downto bits_to_round)) = -1 then-- if max
			result := source_v(source_v'high downto bits_to_round);--overflow, do nothing
		else
			r_bit(0) := get_rounding_bit(source_v, control_bit, bits_to_round);
			result := std_logic_vector(unsigned(source_v(source_v'high downto bits_to_round)) + r_bit);
		end if;
		return result;
	end function;

	function round_sign(source:std_logic_vector; bits_to_round:positive) return std_logic_vector is
	begin
		return round(source, not source(source'high), bits_to_round);
	end function;

	function round_even(source:std_logic_vector; bits_to_round:positive) return std_logic_vector is
	begin
		return round(source, source(bits_to_round), bits_to_round);
	end function;

	function not1_to_0(source:std_logic_vector) return std_logic_vector is
		variable ret:std_logic_vector(source'range);
	begin
		for i in source'range loop
			if source(i)/='1' then
				ret(i) := '0';
			else
				ret(i) := '1';
			end if;
		end loop;
			return ret;
	end function;

	function invert_sign(source:std_logic_vector) return std_logic_vector is
	begin
		if source(source'high) = '0' and unsigned(not(source(source'high-1 downto 0))) = 0 then --if overflow
			return source;
		else
			return std_logic_vector(signed(not source) + 1);
		end if;
	end function;

	function bit_to_int(source:std_logic) return integer is
	begin
		if source = '1'then
			return 1;
		else
			return 0;
		end if;
	end function;

    function bits_tree_sum(source:std_logic_vector) return natural is
    begin
        if source'length > 0 then
            if source'length = 1 then
                return bit_to_int(source(0));
            else
                return bits_tree_sum(source(source'high downto source'length/2)) + bits_tree_sum(source(source'length/2-1 downto 0));
            end if;
        end if;
        return 0;
    end function;

end types_pack_old;
