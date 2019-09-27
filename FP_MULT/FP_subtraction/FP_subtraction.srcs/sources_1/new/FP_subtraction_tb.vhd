

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.ALL;

entity FP_subtraction_tb is
end FP_subtraction_tb;

architecture Behavioral of FP_subtraction_tb is
component FP_subtraction
    Port(x,y:in unsigned(31 downto 0);
    ovf,unf:out bit; 
    FV:out bit;
    clk:buffer bit;
    z:out unsigned(31 downto 0)
    );
end component;
signal x,y,z:unsigned(31 downto 0);
signal ovf,unf,FV,clk:bit;
begin
    M:FP_subtraction port map(x=>x,y=>y,clk=>clk,z=>z,ovf=>ovf,unf=>unf,FV=>FV);
    process
    begin
        x<="11000001101101000000000000000000"; --22.5
        y<="11000001010001100000000000000000"; --12.375
        wait for 200ns;
    end process;


end Behavioral;
