entity test is
end entity;

architecture bench of test is

component HA is
   port (a: in bit;
         b: in bit;
         s: out bit;
	 co: out bit);
end component;

signal a_t, b_t, s_t, co_t: bit;

begin

uut: HA port map (a_t, b_t, s_t, co_t);

a_t <= '0', '1' after 20 ns, '0' after 40 ns, '1' after 60 ns;
b_t <= '0', '0' after 20 ns, '1' after 40 ns, '1' after 60 ns;

end architecture;