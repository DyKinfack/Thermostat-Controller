----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Dylann Kinfack
-- 

-- Design Name: thermostat Controller
-- Module Name: thermostat_tb - Behavioral
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

entity thermostat_tb is
--  Port ( );
end thermostat_tb;

architecture Behavioral of thermostat_tb is

component thermostat
    Port ( 
           CLK : in std_logic;
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
end component;


signal CLK : std_logic :='0';
signal RESET : std_logic := '0';

signal current_temp, desired_temp, temp_display : std_logic_vector (6 downto 0); 
signal display_select, COOL, HEAT,  AC_ON, FURNACE_ON, AC_READY, FAN_ON, FURNACE_HOT: std_logic;



begin

 THERMO_TEMP: thermostat port map ( 
                                    CLK => CLK,
                                    RESET => RESET,
                                    CURRENT_TEMP => current_temp, 
                                    DESIRED_TEMP => desired_temp , 
                                    DISPLAY_SELECT => display_select,
                                    COOL => COOL,
                                    HEAT => HEAT,
                                    FURNACE_HOT => FURNACE_HOT,
                                    AC_READY => AC_READY,
                                    AC_ON => AC_ON,
                                    FURNACE_ON => FURNACE_ON,
                                    FAN_ON => FAN_ON, 
                                    TEMP_DISPLAY => temp_display
                                    );
                                    
                                    
  CLK <= not CLK after 5ns;  
  RESET <= '1' after 20ns;
                     
  process 
     begin
     
     report "starting the therm simulation";
     
     current_temp <= "0000000";
     desired_temp <= "1111111";
     display_select <= '0';
     FURNACE_HOT <='0';
     AC_READY<= '0';
     COOL <= '0';
     HEAT <= '0';
    
     wait for 50 ns;
     assert temp_display /= desired_temp report "temp_display error, should have been desired, but wasnt" severity warning;
     
     display_select <= '1';
     
     wait for 50 ns;
     assert temp_display /= current_temp report "error, display was not current_temp" severity warning;
     
     HEAT <= '1';
     
     wait until FURNACE_ON  = '1';
     FURNACE_HOT <= '1';
     
     wait until FAN_ON = '1';
     HEAT <= '0';
     
   --  wait until FURNACE_ON ='0'; 
     while FURNACE_ON /= '0' loop
        wait until rising_edge(CLK);
     end loop;
     
     FURNACE_HOT <= '0';
     
     wait for 50ns;
     HEAT <='0';
     
     wait for 150 ns;
     current_temp <= "1000000";
     desired_temp <= "0100000";
     
     wait for 50ns;
     COOL <= '1';
     
     while  AC_ON /= '1' loop
        wait until rising_edge(CLK);
     end loop;
     AC_READY <= '1';
     
     while FAN_ON /='1' loop
        wait until rising_edge(CLK);
     end loop;
     
     COOL <= '0';
     AC_READY <='0';
     
     wait for 200 ns;
     
     end process;                     

end Behavioral;
