library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity ctrl_state is
  port (
    clk   		: in    std_logic;                    
    rst   		: in    std_logic;
    BTNU_d		: in    std_logic;
    BTNC_d		: in    std_logic;
    BTND_d		: in    std_logic;
    BTNL_d		: in    std_logic;
    BTNR_d		: in    std_logic;
    set_SW 		: in    std_logic;
    train_SW 	: in    std_logic;
    break_SW 	: in    std_logic;
    reps_SW 	: in    std_logic;
    
    digit_0		: out    std_logic_vector(4-1 downto 0);
    digit_1	 	: out    std_logic_vector(3-1 downto 0);
    digit_2 	: out    std_logic_vector(4-1 downto 0);
    digit_4 	: out    std_logic_vector(7-1 downto 0);
  );
end entity ctrl_state;


architecture behavioral of ctrl_state is

  type t_state is (
    SET,
    GO,
    PAUSE,
    TRAIN,
    RELAX
  );

  signal sig_state		: t_state;
  signal sig_en 		: std_logic;
  signal sig_cnt 		: unsigned(4 downto 0);
  
  signal sig_num_reps		: unsigned(4 downto 0);
  signal sig_reps_set 		: unsigned(4 downto 0);
  signal sig_train_set		: unsigned(4 downto 0);
  signal sig_break_set 		: unsigned(4 downto 0);
  signal sig_stopwatch_cnt 	: unsigned(4 downto 0);
  signal sig_last_state 	: t_state;

  constant c_SET   		: std_logic_vector(2 downto 0) := b"0010010"; 
  constant c_GO     	: std_logic_vector(2 downto 0) := b"0000000"; 
  constant c_PAUSE  	: std_logic_vector(2 downto 0) := b"0011000";
  constant c_TRAIN  	: std_logic_vector(2 downto 0) := b"1110000";
  constant c_BREAK  	: std_logic_vector(2 downto 0) := b"1100000";

begin
  clk_en0 : entity work.clock_enable
    generic map (
      -- 250 ms
      g_MAX => 25000000
    )
    port map (
      clk => clk,
      rst => rst,
      ce  => sig_en
    );


  p_ctrl : process (clk) is
  begin

    if (rising_edge(clk)) then
      if (rst = '1') then                   -- Synchronous reset
        sig_state <= GO;              		-- Init state
        sig_cnt   <= (others => '0');       -- Clear delay counter
      elsif (sig_en = '1') then
        -- Every 250 ms, CASE checks the value of sig_state
        -- local signal and changes to the next state 
        -- according to the delay value.
        case sig_state is

          when GO =>
            if (set_SW = '1') then
            	sig_state <= SET;
            elsif (BTNU_d = '1') then
            	sig_state <= TRAIN;
            else 
            	sig_state <= GO;
            end if;

		  when SET =>
            if (train_SW = '1' and break_SW = '0' and reps_SW = '0') then
                if (BTNR_d = '1') then
                    sig_train_set <= sig_train_set + 1;
                elsif (BTNL_d = '1' and sig_train_set != 0) then
                	sig_train_set <= sig_train_set - 1;
                else
                	sig_state <= SET;
				end if;
                
            elsif (train_SW = '0' and break_SW = '1' and reps_SW = '0') then
            	if (BTNR_d = '1') then
                    sig_break_set <= sig_break_set + 1;
                elsif (BTNL_d = '1' and sig_break_set != 0) then
                	sig_break_set <= sig_break_set - 1;
                else
                	sig_state <= SET;
				end if;
                
            elsif (train_SW = '0' and break_SW = '0' and reps_SW = '1') then
            	if (BTNR_d = '1') then
                    sig_reps_set <= sig_reps_set + 1;
                elsif (BTNL_d = '1' and sig_reps_set != 0) then
                	sig_reps_set <= sig_reps_set - 1;
                else
                	sig_state <= SET;
				end if;
                
            elsif (set_SW = '0') then
            	sig_state <= GO;
            else 
            	sig_state <= SET;
            end if;

















          when WEST_GO =>
            if (sig_cnt < c_DELAY_4SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= WEST_WAIT;
              -- Reset delay counter value
              sig_cnt   <= (others => '0');
            end if;
            
          when WEST_WAIT =>
            if (sig_cnt < c_DELAY_1SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= SOUTH_STOP;
              -- Reset delay counter value
              sig_cnt   <= (others => '0');
            end if;

          when SOUTH_STOP =>
            if (sig_cnt < c_DELAY_2SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= SOUTH_GO;
              -- Reset delay counter value
              sig_cnt   <= (others => '0');
            end if;
          
          when SOUTH_GO =>
            if (sig_cnt < c_DELAY_4SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= SOUTH_WAIT;
              -- Reset delay counter value
              sig_cnt   <= (others => '0');
            end if;
          
           when SOUTH_WAIT =>
            if (sig_cnt < c_DELAY_1SEC) then
              sig_cnt <= sig_cnt + 1;
            else
              -- Move to the next state
              sig_state <= WEST_STOP;
              -- Reset delay counter value
              sig_cnt   <= (others => '0');
            end if;
          
          when others =>
            -- It is a good programming practice to use the
            -- OTHERS clause, even if all CASE choices have
            -- been made.
            sig_state <= WEST_STOP;
            sig_cnt   <= (others => '0');

        end case;

      end if; -- Synchronous reset
    end if; -- Rising edge
  end process p_ctrl;

























  --------------------------------------------------------
  -- p_output_fsm:
  -- A combinatorial process is sensitive to state
  -- changes and sets the output signals accordingly.
  -- This is an example of a Moore state machine and
  -- therefore the output is set based on the active
  -- state only.
  --------------------------------------------------------
  p_output_fsm : process (sig_state) is
  begin

    case sig_state is
      when WEST_STOP =>
        south <= c_RED;
        west  <= c_RED;

      when WEST_GO =>
        south <= c_RED;
        west  <= c_GREEN;
        
      when WEST_WAIT =>
        south <= c_RED;
        west  <= c_YELLOW;

      when SOUTH_STOP =>
        south <= c_RED;
        west  <= c_RED;
      
      when SOUTH_GO =>
        south <= c_GREEN;
        west  <= c_RED;
      
      when SOUTH_WAIT =>
        south <= c_YELLOW;
        west  <= c_RED;
      
      when others =>
        south <= c_RED;
        west  <= c_RED;
    end case;

  end process p_output_fsm;

end architecture behavioral;
