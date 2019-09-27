
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.ALL;


entity FP_MULT_tb is
end FP_MULT_tb;

architecture Behavioral of FP_MULT_tb is
component FP_MULT
    Port(x,y:in unsigned(31 downto 0);
    clk:buffer bit;
    z:out unsigned(31 downto 0)
    );
end component;
signal x,y,z:unsigned(31 downto 0);
signal clk:bit;
begin
    M:FP_MULT port map(x=>x,y=>y,clk=>clk,z=>z);
    process
    begin
        x<="01000011001011111000000000000000"; --  175.5
        y<="11000010100101111000000000000000"; --  -75.75
        wait for 200ns;
    end process;


end Behavioral;
