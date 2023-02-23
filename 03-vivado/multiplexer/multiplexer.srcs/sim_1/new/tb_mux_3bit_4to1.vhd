----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.02.2023 14:13:14
-- Design Name: 
-- Module Name: tb_mux_3bit_4to1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_mux_3bit_4to1 is 

end tb_mux_3bit_4to1;

architecture testbench of tb_mux_3bit_4to1 is

    signal sig_a           : std_logic_vector(2 downto 0);
    signal sig_b           : std_logic_vector(2 downto 0);
    signal sig_c           : std_logic_vector(2 downto 0);
    signal sig_d           : std_logic_vector(2 downto 0);
    signal sig_sel         : std_logic_vector(1 downto 0);
    signal sig_f           : std_logic_vector(2 downto 0);

begin
    uut_mux_3bit_4to1 : entity work.mux_3bit_4to1
    port map (
      a_i           => sig_a,
      b_i           => sig_b,
      c_i           => sig_c,
      d_i           => sig_d,
      sel_i         => sig_sel,
      f_o           => sig_f
    );
    
    p_stimulus : process is
    begin
    
        report "Stimulus process started";
        
        -- First test case ...
        sig_a <= "000";
        sig_b <= "001";
        sig_c <= "010";
        sig_d <= "011";
        sig_sel <= "00";
        wait for 100 ns;
    
        assert (
            (sig_f = "000")
        )
        report "Selection of a (sel = 00) failed"
        severity error;
    
        -- Second test case ...
        sig_a <= "000";
        sig_b <= "001";
        sig_c <= "010";
        sig_d <= "011";
        sig_sel <= "01";
        wait for 100 ns;
    
        assert (
            (sig_f = "001")
        )
        report "Selection of b (sel = 01) failed"
        severity error;
        
         -- Third test case ...
        sig_a <= "000";
        sig_b <= "001";
        sig_c <= "010";
        sig_d <= "011";
        sig_sel <= "10";
        wait for 100 ns;
    
        assert (
            (sig_f = "010")
        )
        report "Selection of c (sel = 10) failed"
        severity error;
        
        -- Fourth test case ...
        sig_a <= "000";
        sig_b <= "001";
        sig_c <= "010";
        sig_d <= "011";
        sig_sel <= "11";
        wait for 100 ns;
    
        assert (
            (sig_f = "011")
        )
        report "Selection of d (sel = 11) failed"
        severity error;
      
        report "Stimulus process finished";
        wait;
    end process p_stimulus;

end testbench;
