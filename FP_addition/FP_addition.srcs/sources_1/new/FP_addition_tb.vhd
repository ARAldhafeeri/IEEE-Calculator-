library IEEE;
use IEEE.numeric_bit.ALL;


entity additiontb is
end additiontb;


architecture Behavioral of additiontb is
component FP_addition  
Port ( x,y : in unsigned(31 downto 0); 
      ovf,unf: out bit;
      clk: buffer bit;
      Fv: out bit; -- fraction over fllow
      z : out unsigned(31 downto 0) );
end component;
signal z,x,y:  unsigned(31 downto 0);
signal ovf,unf,fv: bit;
signal clk: bit;  
begin 
    W: FP_addition port map ( x=>x, y=>y, z=>z, ovf=>ovf, unf=>unf, clk=>clk, fv=>fv);
    process
    begin
        x <="11000000010111000000000000000000"; -- 14.875  01000000110111000000000000000000
        y <="01000000011011100000000000000000"; --   -6.875
        wait for 200ns;
    end process;
end Behavioral;