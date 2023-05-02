------------------------------------------------------------------------
--
-- One-minute stopwatch.
-- Nexys A7-50T, Vivado v2020.1.1, EDA Playground
--
-- Copyright (c) 2020 Tomas Fryza
-- Dept. of Radio Electronics, Brno University of Technology, Czechia
-- This work is licensed under the terms of the MIT license.
--
------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

------------------------------------------------------------------------
-- Entity declaration for stopwatch counter
------------------------------------------------------------------------
entity stopwatch_new is
    port(
        clk            : in  std_logic;
        rst            : in  std_logic;
        start_i        : in  std_logic;
        pause_i        : in  std_logic;
        min_set        : in  std_logic_vector(4 - 1 downto 0);
        seconds_h_o    : out std_logic_vector(4 - 1 downto 0);
        seconds_l_o    : out std_logic_vector(4 - 1 downto 0);
        minutes_l_o    : out std_logic_vector(4 - 1 downto 0);
        set_enable     : in  std_logic;
        cnt_end        : out  std_logic
    );
end entity stopwatch_new;

------------------------------------------------------------------------
-- Architecture declaration for stopwatch counter
------------------------------------------------------------------------
architecture Behavioral of stopwatch_new is

    -- Internal clock enable
    signal s_en    : std_logic;
    -- Internal start button flag
    signal s_start : std_logic;
    
    signal s_pause : std_logic;
    -- Local counters
	signal s_cnt2  : unsigned(4 - 1 downto 0);  -- minutes
    signal s_cnt1  : unsigned(4 - 1 downto 0);  -- tens of Seconds
    signal s_cnt0  : unsigned(4 - 1 downto 0);  -- seconds
    
    signal s_min_set : unsigned(4 - 1 downto 0);
    
    
    signal s_wait : std_logic;
    signal s_end : std_logic;
    
    --signal min     : unsigned(4 - 1 downto 0);

begin
    --------------------------------------------------------------------
    -- Instance (copy) of clock_enable entity generates an enable pulse
    -- every 10 ms (100 Hz).

    -- JUST FOR SHORTER/FASTER SIMULATION
    --s_en <= '1';
   clk_en0 : entity work.clock_enable
       generic map(
            g_MAX => 4 --100000000        -- 10 ms / (1/100 MHz) = g_MAX
       )
        port map(
            clk => clk,
            rst => rst,  --! High-active synchronous reset
            ce  => s_en  --! Clock enable pulse signal
        );

    --------------------------------------------------------------------
    -- p_stopwatch_cnt:
    -- Sequential process with synchronous reset and clock enable,
    -- which implements four decimal counters. The lowest of the 
    -- counters is incremented every 10 ms, and each higher-order 
    -- counter is incremented if all lower-order counters are equal 
    -- to the maximum value.
    --------------------------------------------------------------------
    p_stopwatch_cnt : process(clk)
    begin
        if rising_edge(clk) then
        
            --s_min_set <= unsigned(min_set);
            
            if (rst = '1') then           
                s_cnt2 <= (others => '0');
                s_cnt1 <= (others => '0');
                s_cnt0 <= (others => '0');
                s_start <= '0';   
                s_pause <= '0';
                s_wait <= '0';
                cnt_end <= '0';

            elsif (start_i = '1' and s_start = '0' and s_pause /= '1' and s_cnt2 = 0 and s_cnt1 = 0 and s_cnt0 = 0) then
                s_cnt2 <= unsigned(min_set);
                s_wait <= '1';
                cnt_end <= '0';
                
            --elsif (start_i = '1' and s_start = '0' and s_pause /= '1' and s_wait = "01") then
                --s_wait <= '1';
            
            elsif (start_i = '1' and s_start = '0' and s_pause /= '1' and s_wait = '1') then
                s_start <= '1';
                s_pause <= '0';
                s_wait <= '0';
            
            elsif (s_en = '1' and s_start = '1' and s_pause /= '1') then
                
                if (s_cnt0 = 0 ) then
                    --if (s_cnt2 = 0 ) and (s_cnt1 = 0 ) and (s_cnt0 = 0 ) then
                        --s_start <= '0';
                        --s_pause <= '1'; --+++
                        --cnt_end <= '1';
                    if (s_cnt1 = 0) then
                        s_cnt2 <= s_cnt2 - 1;  
                        s_cnt1 <= "0101";
                        s_cnt0 <= "1001";
                    else
                        s_cnt1 <= s_cnt1 - 1;
                        s_cnt0 <= "1001";
                    end if;
                --elsif (s_cnt2 = 0 ) and (s_cnt1 = 0 ) and (s_cnt0 = 0 ) then
                    --s_start <= '0';
                    --s_pause <= '1'; --+++
                    --cnt_end <= '1';
                else
                    s_cnt0 <= s_cnt0 - 1; 
                end if;
                                
            end if;
            
            if (s_cnt2 = 0 and s_cnt1 = 0 and s_cnt0 = 0 and s_start = '1') then
                        s_pause <= '1';
                        cnt_end <= '1';
                        s_start <= '0';
            end if;
            
            if pause_i = '1' then
                s_pause <= '1';
                s_end <= '0';
            
            elsif pause_i = '0' then
                s_pause <= '0';
                s_end <= '0';
                
            end if;
            
         end if;
    end process p_stopwatch_cnt;

    -- Outputs must be retyped from "unsigned" to "std_logic_vector"
    
    minutes_l_o <= std_logic_vector(s_cnt2);
    seconds_h_o <= std_logic_vector(s_cnt1);
    seconds_l_o <= std_logic_vector(s_cnt0);
    --cnt_end <= s_end;

end architecture Behavioral;