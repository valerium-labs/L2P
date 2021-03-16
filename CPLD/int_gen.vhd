library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity INT_GEN is
   port
   (
       CLK                    : in  std_logic;
       nKS                    : in  std_logic;
       INT                    : out  std_logic
   );
end INT_GEN;

architecture RTL of INT_GEN is
   signal COUNTER : integer range 0 to 71680;
begin
   
-- весь экран выводится за 71680 тактов
-- /nKS (кадровый синхроимпульс, его начало, т.е. СПАД) в ленинграде задержан на 67 тактов относительно начала первой скан-строки 
-- длина КСИ равна 3584 такта
-- счетчик же формирователя INT у нас запускается по концу КСИ, то есть по ПЕРЕДНЕМУ ФРОНТУ /nKS,
-- это на (67+3584) такте после начала первой скан-строки.
-- активируем INT (прямой) в начале первой скан-строки СЛЕДУЮЩЕГО кадра, это через 71680 - (68 + 3584) = 68028 тактов после конца КСИ
-- деактивируем INT через 36 тактов, это 71680 - (67 + 3584) + 36 = 68064 после конца КСИ.
-- /nKS берем с 6DD40, H0 берем c 1DD13, INT (прямой) подаем на 13DD1 (а на 12DD1 формируется /INT для процессора)
-- 1 такт H0 добавлен для корректиров	

  process (CLK, nKS)
  begin
     if (rising_edge(CLK)) then  
  
        if (COUNTER < 71680) then  
             COUNTER <= COUNTER + 1;
        end if;

        if (COUNTER = 71680 - 67 - 3584) then  
            INT <= '1';
        end if;

        if (COUNTER = 71680 - 67 - 3584 + 36) then  
            INT <= '0';
        end if;

        if (nKS = '0') then
           COUNTER <= 0;
        end if;

     end if;
   end process;               

end architecture;