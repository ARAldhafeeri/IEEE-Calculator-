library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_bit.ALL;


entity FP_MULT is
    Port ( x,y : in unsigned(31 downto 0);
           clk:buffer bit;
           z : out unsigned(31 downto 0)
           );
end FP_MULT;

architecture Behavioral of FP_MULT is
begin
    clk<= not clk after 100ns;
    process(clk)
    variable sx:bit;--:=x(31);
    variable ex:unsigned(7 downto 0);--:=x(30 downto 23);
    variable fx:unsigned(23 downto 0);--:="001"&x(22 downto 0);
    variable sy:bit:=y(31);
    variable ey:unsigned(7 downto 0);--:=y(30 downto 23);
    variable fy:unsigned(23 downto 0);--:="001"&y(22 downto 0);
    variable sz:bit:='0';
    variable ez:unsigned(7 downto 0):=x"00";
    variable fz:unsigned(23 downto 0):= "100000000000000000000000";
    variable mult_reg: unsigned(47 downto 0);
    variable bit_count:integer:= 0;
    variable expx,expy: integer:= 0;
    variable mult_int: integer:= 0 ;
    begin
        
            if clk'event and clk = '1' then
                sx:=x(31);
                ex:=x(30 downto 23);
                fx:="1"&x(22 downto 0);
                sy:=y(31);
                ey:=y(30 downto 23);
                fy:="1"&y(22 downto 0);
                
--Exponent of the product is equal to the exponents of the x and y added together.
                expx:= to_integer(ex); --Change bit to integer
                expy:= to_integer(ey); 
                expx:= expx - 127; --Do the operation in integer type
                expy:= expy - 127;
                ez:=to_unsigned(expx + expy, 8);--Transform the resultant exponent back to unsigned.
                ez:=ez + "10000000";
--          

                sz:=sx xor sy;

                mult_reg:= fx * fy; --26 bit * by a 26 bit gives a 52 bit result.
               -- mult_int:=to_integer(mult_reg); --This doesn't work
               -- fz:=to_unsigned(mult_int,26); --This doesn't work
               -- mult_reg:= mult_reg srl 26; --This should work maybe.
                --while mult_reg(47) = '0' loop 
                                   --mult_reg:= mult_reg sll 1;
                                   --ez:= ez -1 ;
                               --end loop; 
                fz:=mult_reg(47 downto 24);
                
                
                while (fz(23) = '0' ) loop
                    fz:=fz sll 1;
                    ez:= ez -1 ;
                end loop;
                

--If the fraction of z is 0 then the exponent of z is also 0.
                if (fz = 0) then
                    ez:="00000000";
                end if;
                
               -- while (fz(25) = '1' or fz(24) = '1') loop
                 --   fz:=fz srl 1;
                  --  ez:=ez + 1;
               -- end loop;
                
                
         
            z<=sz & ez & fz(22 downto 0);
           end if;
    end process;
            

end Behavioral;
