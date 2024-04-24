-- influenced from repositories by https://github.com/DHMarinov
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity fir is
    Generic (
        FILTER_TAPS  : integer := 17;
        INPUT_WIDTH  : integer := 16; 
        COEFF_WIDTH  : integer := 16;
        OUTPUT_WIDTH : integer := 16
    );
    Port ( 
           clk    : in STD_LOGIC;
           data_i : in STD_LOGIC_VECTOR (INPUT_WIDTH-1 downto 0);
           data_o : out STD_LOGIC_VECTOR (OUTPUT_WIDTH-1 downto 0)
           );
end fir;

architecture Behavioral of fir is

constant MAC_WIDTH : integer := COEFF_WIDTH+INPUT_WIDTH;

-- array data type
type inputs is array(0 to FILTER_TAPS-1) of signed(INPUT_WIDTH-1 downto 0);
signal x : inputs := (others=>(others=>'0')); -- initialize to 0

type coeffs is array(0 to FILTER_TAPS-1) of signed(COEFF_WIDTH-1 downto 0);
signal b : coeffs :=(x"05bd", x"065e", x"06f0", x"0772", x"07df", x"0837", x"0878", x"089f", x"08ac", x"089f", x"0878", x"0837", x"07df", x"0772", x"06f0", x"065e", x"05bd");

type results is array(0 to FILTER_TAPS-1) of signed(MAC_WIDTH-1 downto 0);
signal y : results := (others=>(others=>'0'));

begin  

data_o <= std_logic_vector(y(0)(MAC_WIDTH-2 downto MAC_WIDTH-OUTPUT_WIDTH-1));         
      
process(clk)
begin
    if rising_edge(clk) then
        for i in 0 to FILTER_TAPS-1 loop
            x(i) <= signed(data_i);         
            if (i < FILTER_TAPS-1) then
                y(i) <= x(i)*b(i) + y(i+1);
            elsif (i = FILTER_TAPS-1) then
                y(i)<= x(i)*b(i);
            end if;
        end loop;
    end if;
end process;

end Behavioral;