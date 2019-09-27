library IEEE;
use IEEE.numeric_bit.ALL;


entity FP_addition is
    Port ( x,y : in unsigned(31 downto 0); 
    ovf,unf: out bit;
    Fv: out bit; -- fraction over fllow 
    clk: buffer bit;
    z : out unsigned(31 downto 0)
      );
end FP_addition;

      
architecture Behavioral of FP_addition is
begin


    clk <= not clk after 100ns;
    process(clk)
    variable Fx,Fy,Fz: unsigned (25 downto 0);  --break down the input/ output into variables sgin / exponent/ fraction register
    variable Ex,Ey,Ez: unsigned (7 downto 0);
    variable Sx,Sy,Sz,Fovf,Eovf,Eunf,Normliazitioncheck, done: bit; -- variables for the sgins and the over fllow and underflllow and checks
    variable count:integer:=0;
    begin
        if clk'event and clk = '1' then   -- triger the process on the rising edage of the clk
        fx := "001" & x(22 downto 0);
        Ex := x(30 downto 23);
        sx := x(31);
        fy :=  "001" & y(22 downto 0);
        Ey :=  y(30 downto 23);
        sy := y(31);
        
        
  --first step is to compare the exponent. while they are not equal then. 
        while (Ex /= Ey) loop
            if (Ex < Ey )  then -- loop if Ex is the smaller exp then
                Fx := fx srl 1;                               --shift fraction right one bit
                Ex := Ex + 1;       --add one to the exponent 
            elsif (Ex > Ey) then  -- if Ey the smaller exp then
                Fy := fy srl 1;       --shift y fraction right one bit add 1 to the exp
                Ey := Ey + 1;  
            end if;
        end loop; 
               

                
  -- add fractions
       if (sx = sy) then
            fz:=fx + fy;
            sz:= sx and sy;
            ez:=ex;
       elsif (sx /= sy) then
            if (sx = '0' and sy = '1') then
                if (fy>fx) then
                    sz:=sy;
                    fy:=(not fy) + 1;
                    fz:=(fx + fy);
                    if sz = '1' then
                        fz:=(not fz) + 1;
                    end if;
                    ez:=ex;
                else --fx>fy
                    sz:=sx;
                    fy:=(not fy) + 1;
                    fz:=(fx + fy);
                    if sz = '1' then
                        fz:= (not fz) + 1;
                    end if;
                    ez:=ex;
                 end if;
            else
                if (fx>fy) then
                    sz:=sx;
                    fx:=(not fx) + 1;
                    fz:=(fx + fy);
                    if sz='1' then
                        fz:=(not fz) + 1;
                    end if;
                    ez:=ex; 
                else
                    sz:=sy;
                    fx:=(not fx) + 1;
                    fz:=(fy + fx);
                    if sz = '1' then
                        fz:=(not fz )+1;
                    end if;
                    ez:=ex;
                end if;
            end if;
       end if;
--    
 

 --if the sum is zero set exponent to zero
            if  ( Fz  = 0) then                   
                Ez := "00000000";
            end if;
            
            
--Dealing with fractional overflow            
            while ( fz(25)= '1' or fz(24)= '1' ) loop    --overflow inducator of the 2 MSB are 1 then shift frac to right and increment the exp by 1       
                fz := fz srl 1;
                Ez := Ez + 1;
            end loop;   
--

 --Normalizing the fraction           
            loop
            exit when (fz(23) = '1' );
               fz:=fz sll 1;
               ez:= ez - 1;
            end loop;
--Normalizing the fraction. 
 
 
 -- Checking for overflow and underflow.
        if ( to_integer( ( unsigned (Ez))) = (0) ) 
            then unf <= '1'; -- exponent under flow
            report "NAN";
        elsif (to_integer( ( unsigned (Ez))) =    (255)  ) then 
            ovf <='1' ;  --exponent overflow
            report "NAN";
        else 
            unf<='0'; 
            ovf<='0'; 
        end if;
        

--

    end if;
    z <= sz & ez(7 downto 0) & fz(22 downto 0);
    end process;
end Behavioral;