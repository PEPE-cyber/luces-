library ieee;
use ieee.std_logic_1164.all;

ENTITY FSM IS
   PORT( clk, rst, dir_der , dir_izq, int    : IN STD_LOGIC;
         LedsDer, LedsIzq : OUT std_logic_vector(3 downto 0));
END FSM;

ARCHITECTURE A1 OF FSM is
  type State is (LedIzq1, LedIzq2, LedIzq3, LedDer1, LedDer2, LedDer3, LedOn, LedOff);
  signal currentState, nextState: State;
  signal count: integer:= 1;
  begin
    Registers: process (clk, rst)
    begin
      if rst = '0' then
        currentState <= LedOff;
      elsif Rising_edge(clk) then
		  count <= count + 1;
		  if (count = 25000000) then
          count <= 1;
			 currentState <= nextState;
		  end if;
      end if;
    end process Registers;

    combProcess: process(CurrentState, dir_der, dir_izq, int)
    begin
       LedsDer <= "1000";
       LedsIzq <= "0001";
       nextState <= LedOff;
       case currentState is
         when LedIzq1 =>
           LedsDer <= "1000";
           LedsIzq <= "0011";
			  if (dir_izq = '1' and int = '0') then
				nextState <= LedIzq2;
			  else
				nextState <= LedOff;
			  end if;
         when LedIzq2 =>
           LedsDer <= "1000";
           LedsIzq <= "0111";
           if (dir_izq = '1' and int = '0') then
				nextState <= LedIzq3;
			  else
				nextState <= LedOff;
			  end if;
         when LedIzq3 =>
           LedsDer <= "1000";
           LedsIzq <= "1111";
           nextState <= LedOff;
         when LedDer1 =>
           LedsDer <= "1100";
           LedsIzq <= "0001";
			  if (dir_der = '1' and int = '0') then
             nextState <= LedDer2;
			  else
			    nextState <= LedOff;
			  end if;
         when LedDer2 =>
           LedsDer <= "1110";
           LedsIzq <= "0001";
           if (dir_der = '1' and int = '0') then
             nextState <= LedDer3;
			  else
			    nextState <= LedOff;
			  end if;
         when LedDer3 =>
           LedsDer <= "1111";
           LedsIzq <= "0001";
           nextState <= LedOff;
         when LedOn =>
           LedsDer <= "1111";
           LedsIzq <= "1111";
           nextState <= LedOff;
         when others =>
           LedsDer <= "1000";
			  LedsIzq <= "0001";																																								
           if (int = '1') then
             nextState <= LedOn;
           elsif (dir_izq = '1') then
             nextState <= LedIzq1;
           elsif (dir_der = '1') then
             nextState <= LedDer1;
           end if;
       end case;
    end process combProcess;
end architecture A1;