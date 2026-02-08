----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Dylann Kinfack
-- 

-- Design Name: thermostat Controller
-- Module Name: thermostat - Behavioral
-- Project Name: thermostat Controller
-- Target Devices: Spartan-7
-- Tool Versions: Vivado 2020.2
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
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity thermostat is
    Port (  CLK : in std_logic;
            RESET : in std_logic;
            CURRENT_TEMP : in STD_LOGIC_VECTOR (6 downto 0);
            DESIRED_TEMP : in STD_LOGIC_VECTOR (6 downto 0);
            DISPLAY_SELECT : in STD_LOGIC;
            COOL : in STD_LOGIC;
            HEAT: in STD_LOGIC;
            FURNACE_HOT: in STD_LOGIC;
            AC_READY : in STD_LOGIC;
            AC_ON : out STD_LOGIC;
            FURNACE_ON : out STD_LOGIC;
            FAN_ON : out STD_LOGIC;
            TEMP_DISPLAY : out STD_LOGIC_VECTOR (6 downto 0));
end thermostat;

architecture Behavioral of thermostat is

signal current_temp_reg, desired_temp_reg: std_logic_vector ( 6 downto 0);
signal display_sel_reg, cool_reg, heat_reg : std_logic;

type t_state is (IDLE, HEATON, FURNACENOWHOT, FURNACECOOL, COOLON, ACNOWREADY, ACDONE);
signal current_state, next_state : t_state;

signal counter : std_logic_vector (4 downto 0);
begin
    
    process (CLK, RESET) 
    begin
        if RESET = '0' then
            current_temp_reg <= (others => '0');
            desired_temp_reg <= (others => '0');
            display_sel_reg <= '0';
            cool_reg <= '0';
            heat_reg <= '0';
        
         elsif  CLK'event and CLK = '1' then
            current_temp_reg <=  CURRENT_TEMP;
            desired_temp_reg <=  DESIRED_TEMP;
            display_sel_reg <= DISPLAY_SELECT;
            cool_reg <= COOL;
            heat_reg <= HEAT;
         end if;
         
    end process;
    
    
    thermostat_pro: process (CLK, RESET)
    begin
        if RESET = '0' then
            TEMP_DISPLAY <= ( others => '0');
            
        elsif CLK'event and CLK = '1' then
  
            if DISPLAY_SELECT = '1' then
                TEMP_DISPLAY <=  current_temp_reg;
            else
                TEMP_DISPLAY <= desired_temp_reg;
            end if; 
         end if; 
        
    end process;
    
    
    -- FSM to control FURNACE AC and FAN --
    
    -- Current state Logic reg FF
       cur_state:  process (CLK, RESET) 
        begin
             if RESET = '0' then
                current_state <= IDLE;
            
            elsif rising_edge(CLK) then
                current_state <= next_state;    
        end if;      
 end process;
 
     -- Next state Logic combinatorisch
     next_state_lo: process(current_state, COOL, HEAT, CURRENT_TEMP, DESIRED_TEMP, FURNACE_HOT, AC_READY)
        begin
            next_state <= current_state; -- default state
            
            case current_state is
                when IDLE =>
                    if ( HEAT = '1') and ( CURRENT_TEMP < DESIRED_TEMP) then
                        next_state <=  HEATON;
                    elsif (COOL = '1') and (CURRENT_TEMP > DESIRED_TEMP) then
                         next_state <= COOLON;
                    else
                        next_state <= IDLE;
                    end if;
                 
                 when  HEATON =>
                      if FURNACE_HOT ='1' then
                        next_state <= FURNACENOWHOT;
                      else 
                         next_state <= HEATON;
                      end if;
                 
                 when FURNACENOWHOT =>
                      if HEAT='0' or (CURRENT_TEMP >= DESIRED_TEMP) then
                           next_state <= FURNACECOOL;
                      else 
                           next_state <= FURNACENOWHOT;
                      end if;
                      
                 when FURNACECOOL =>
                       if FURNACE_HOT = '0' and counter = "00000" then
                            next_state <= IDLE;
                       else
                            next_state <= FURNACECOOL ;
                       end if;
                 
                 when COOLON =>
                       if AC_READY = '1' then
                           next_state <= ACNOWREADY;
                       else
                           next_state <= COOLON;
                      end if;
                 
                 when  ACNOWREADY =>
                       if COOL ='0' or(CURRENT_TEMP <= DESIRED_TEMP) then
                            next_state <= ACDONE;
                       else
                            next_state <= ACNOWREADY;
                       end if;
                 
                 when  ACDONE => 
                        if AC_READY = '0' and counter = "00000" then
                            next_state <= IDLE;
                        else
                            next_state <=  ACDONE;
                        end if;
                        
                 when others =>
                        next_state <= IDLE;
              end case;        
        end process;
     
 
        -- Data for the FSM
         data_path: process (CLK, RESET)
                begin
                     if RESET = '0' then
                        FURNACE_ON <= '0';
                        AC_ON <= '0';
                        FAN_ON <= '0';
                        counter <= ( others => '0');
                      
                      elsif rising_edge(CLK) then
                         case current_state is
                            
                            when IDLE =>
                                FURNACE_ON <= '0';
                                AC_ON <= '0';
                                FAN_ON <= '0';
                             
                            when  HEATON =>
                                FURNACE_ON <= '1';
                                AC_ON <= '0';
                                FAN_ON <= '0';
                            
                            when FURNACENOWHOT =>
                                FURNACE_ON <= '0';
                                AC_ON <= '0';
                                FAN_ON <= '1';
                                counter <= "01010";
                            
                            when FURNACECOOL =>
                                FURNACE_ON <= '0';
                                AC_ON <= '0';
                                FAN_ON <= '1';
                                if counter = "00000" then
                                    counter <= counter;
                                else 
                                    counter <= counter -1;
                                end if;
                            
                            when COOLON =>
                                FURNACE_ON <= '0';
                                AC_ON <= '1';
                                FAN_ON <= '0';
                            
                            when ACNOWREADY =>
                                FURNACE_ON <= '0';
                                AC_ON <= '1';
                                FAN_ON <= '1';
                                counter <= "10100";
                            
                            when ACDONE =>
                                FURNACE_ON <= '0';
                                AC_ON <= '0';
                                FAN_ON <= '1';
                                
                                if counter = "00000" then
                                    counter <= counter;
                                else 
                                    counter <= counter -1;
                                end if;
                                
                            when others =>
                                FURNACE_ON <= '0';
                                AC_ON <= '0';
                                FAN_ON <= '0';
                       end case;
                       
                   end if;               
                end process;
    
    
    
    
    
    
    
    
    
   end Behavioral;
    

    
    

