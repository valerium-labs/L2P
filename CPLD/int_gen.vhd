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
   

-- ���� ����� ��������� �� 71680 ������
-- /nKS (�������� �������������) � ���������� �������� �� 68 ������ ������������ ������ ������ ����-������ 
-- ������� ����������� �� ����� ���, �� ���� �� ��������� ������ /nKS (� ����� ��� ����� 3584 �����),
-- ��� �� (68+3584) ����� ����� ������ ������ ����-������.
-- ���������� INT (������) � ������ ������ ����-������ ���������� �����, ��� ����� 71680 - (68 + 3584) = 68028 ������ ����� ����� ���
-- ������������ INT ����� 36 ������, ��� 71680 - (68 + 3584) + 36 = 68064 ����� ����� ���.
-- /nKS ����� � 6DD40, H0 ����� c 1DD13, INT (������) ������ �� 13DD1 (� �� 12DD1 ����������� /INT ��� ����������)

  process (CLK, nKS)
  begin
     if (rising_edge(CLK)) then  
  
        if (COUNTER < 71680) then  
             COUNTER <= COUNTER + 1;
        end if;

        if (COUNTER = 71680 - 68 - 3584 + 1) then  
            INT <= '1';
        end if;

        if (COUNTER = 71680 - 68 - 3584 + 36 + 1) then  
            INT <= '0';
        end if;

        if (nKS = '0') then
           COUNTER <= 0;
        end if;

     end if;
   end process;               

end architecture;