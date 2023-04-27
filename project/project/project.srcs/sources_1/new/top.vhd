----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2023 01:54:49 PM
-- Design Name: 
-- Module Name: top - Behavioral
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
use ieee.numeric_std.all;



entity top is
    Port ( CLK100MHZ : in STD_LOGIC;
           SW : in STD_LOGIC_VECTOR (15 downto 0);
           CA : out STD_LOGIC;
           CB : out STD_LOGIC;
           CC : out STD_LOGIC;
           CD : out STD_LOGIC;
           CE : out STD_LOGIC;
           CF : out STD_LOGIC;
           CG : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR (3 downto 0);
           BTNC : in STD_LOGIC;  --reset
           BTNU : in STD_LOGIC;
           BTND : in STD_LOGIC;
           BTNL : in STD_LOGIC;
           BTNR : in STD_LOGIC;
           digit_0   : buffer    std_logic_vector(4-1 downto 0);
           digit_1   : buffer    std_logic_vector(3-1 downto 0);
           digit_2   : buffer    std_logic_vector(4-1 downto 0));
end top;

----------------------------------------------------------
-- Architecture body for top level
----------------------------------------------------------

architecture behavioral of top is

    signal s_seconds_l  : std_logic_vector(4 - 1 downto 0);  -- minutes
    signal s_seconds_h  : std_logic_vector(3 - 1 downto 0);  -- tens of Seconds
    signal s_minutes_l  : std_logic_vector(4 - 1 downto 0);

begin
  --------------------------------------------------------
  -- Instance (copy) of tlc entity
  --------------------------------------------------------
  driver_7seg_4digits : entity work.driver_7seg_4digits_alt
    port map ( clk     => CLK100MHZ,
               rst     => BTNC,
               data0   => digit_0,
               data1   => digit_1,
               data2   => digit_2,
                                 
               seg(6) => CA,
               seg(5) => CB,
               seg(4) => CC,
               seg(3) => CD,
               seg(2) => CE,
               seg(1) => CF,
               seg(0) => CG,    
                  
      
      
              dp_vect => "1011",
              dp      => DP,

          -- DIGITS
              dig(3 downto 0) => AN(3 downto 0)
    );
    
   stopwatch_seconds : entity work.stopwatch_seconds
    
    port map (
        clk  => CLK100MHZ,
        rst  => BTNC,
        start_i  => BTNU,
        pause_i => BTND,
        -- Tens of seconds
        seconds_h_o  => s_seconds_h,
        -- Seconds
        seconds_l_o  => s_seconds_l,
        -- Tenths of seconds
        minutes_l_o => s_minutes_l
       -- secstart : out std_logic_vector(3 downto 0)
    );

p_top : process(CLK100MHZ)
    begin
        if rising_edge(CLK100MHZ) then
           digit_0 <= s_seconds_l;
           digit_1 <= s_seconds_h;
           digit_2 <= s_minutes_l;
                
        end if;
    end process p_top;


end architecture behavioral;