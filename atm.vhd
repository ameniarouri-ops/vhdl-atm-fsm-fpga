library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity atm is
    port(
        clk         : in  std_logic;
        reset       : in  std_logic;
        pin_in      : in  std_logic_vector(3 downto 0);
        enter       : in  std_logic;
        withdraw_in : in  std_logic_vector(3 downto 0);  -- changed to 4 bits
        ok          : out std_logic;
        error       : out std_logic;
        balance_o   : out std_logic_vector(7 downto 0)
    );
end atm;

architecture beh of atm is

    type state_type is (
        IDLE,
        CHECK_PIN,
        MENU,
        SHOW_BALANCE,
        WITHDRAW,
        ERROR_ST,
        BLOCKED
    );

    signal state       : state_type := IDLE;
    signal balance_reg : unsigned(7 downto 0) := to_unsigned(15, 8);  -- max 15 fits 4 switches
    signal attempts    : integer range 0 to 3 := 0;
    signal enter_prev  : std_logic := '0';

    constant CORRECT_PIN  : std_logic_vector(3 downto 0) := "1010";
    constant MAX_ATTEMPTS : integer := 3;

begin

    process(clk, reset)
    begin
        if reset = '1' then
            state       <= IDLE;
            balance_reg <= to_unsigned(15, 8);
            attempts    <= 0;
            enter_prev  <= '0';

        elsif rising_edge(clk) then
            enter_prev <= enter;

            if enter = '1' and enter_prev = '0' then
                case state is

                    when IDLE =>
                        state <= CHECK_PIN;

                    when CHECK_PIN =>
                        if pin_in = CORRECT_PIN then
                            attempts <= 0;
                            state    <= MENU;
                        else
                            if attempts + 1 >= MAX_ATTEMPTS then
                                attempts <= MAX_ATTEMPTS;
                                state    <= BLOCKED;
                            else
                                attempts <= attempts + 1;
                                state    <= ERROR_ST;
                            end if;
                        end if;

                    when ERROR_ST =>
                        state <= CHECK_PIN;

                    when MENU =>
                        if unsigned(withdraw_in) = 0 then
                            state <= SHOW_BALANCE;
                        else
                            state <= WITHDRAW;
                        end if;

                    when SHOW_BALANCE =>
                        state <= MENU;

                    when WITHDRAW =>
                        if unsigned(withdraw_in) <= balance_reg then
                            balance_reg <= balance_reg - unsigned(withdraw_in);
                            state       <= MENU;
                        else
                            state <= ERROR_ST;
                        end if;

                    when BLOCKED =>
                        state <= BLOCKED;

                end case;
            end if;
        end if;
    end process;

    ok        <= '1' when state = MENU else '0';
    error     <= '1' when (state = ERROR_ST or state = BLOCKED) else '0';
    balance_o <= std_logic_vector(balance_reg) when state = SHOW_BALANCE
                 else (others => '0');

end beh;