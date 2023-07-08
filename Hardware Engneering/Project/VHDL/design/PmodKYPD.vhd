----------------------------------------------------------------------------------
-- Company: Digilent Inc 2011
-- Engineer: Michelle Yu  
-- Create Date:    17:05:39 08/23/2011 
--
-- Module Name:    PmodKYPD - Behavioral 
-- Project Name:  PmodKYPD
-- Target Devices: Nexys3
-- Tool versions: Xilinx ISE 13.2 
-- Description: 
--	This file defines a project that outputs the key pressed on the PmodKYPD to the seven segment display
--
-- Revision: 
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PmodKYPD is
    Port ( 
    reset: in std_logic;
	clk : in  STD_LOGIC;
	LED1, LED2: out std_logic;
    LED3, LED4: out std_logic;
	JAcol : out  STD_LOGIC_VECTOR (3 downto 0); -- PmodKYPD is designed to be connected to JA
JArow : in  STD_LOGIC_VECTOR (3 downto 0); -- PmodKYPD is designed to be connected to JA
    an : out  STD_LOGIC_VECTOR (3 downto 0);   -- Controls which position of the seven segment display to display
    seg : out  STD_LOGIC_VECTOR (6 downto 0)); -- digit to display on the seven segment display 
end PmodKYPD;

architecture Behavioral of PmodKYPD is

component decoderFSM is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        DecodeOut : in STD_LOGIC_VECTOR (3 downto 0);
        Key1Assigned : out STD_LOGIC;
        Key2Assigned : out STD_LOGIC;
        Key3Assigned : out STD_LOGIC;
        Key1Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key2Value : out STD_LOGIC_VECTOR (3 downto 0);
        Key3Value : out STD_LOGIC_VECTOR (1 downto 0)
    );
end component;

component Decoder is
	Port (
	clk : in  STD_LOGIC;
          Row : in  STD_LOGIC_VECTOR (3 downto 0);
	  Col : out  STD_LOGIC_VECTOR (3 downto 0);
          DecodeOut : out  STD_LOGIC_VECTOR (3 downto 0));
	end component;

component DisplayController is
	Port (
	   DispVal : in  STD_LOGIC_VECTOR (3 downto 0);
           anode: out std_logic_vector(3 downto 0);
           segOut : out  STD_LOGIC_VECTOR (6 downto 0));
	end component;

component Calculator is 
	Port (
	a, b: in std_logic_vector(3 downto 0);
        op: in std_logic_vector(1 downto 0);  -- 00: addition, 01: subtraction, 10: multiplication, 11: division
        resultOut: out std_logic_vector(3 downto 0);
        errorOut: out std_logic);
end component;

signal Decode: STD_LOGIC_VECTOR (3 downto 0);
signal result: STD_LOGIC_VECTOR (3 downto 0);
signal key1, key2: STD_LOGIC_VECTOR (3 downto 0);
signal key3: STD_LOGIC_VECTOR (1 downto 0);
begin

	C0: Decoder port map (clk=>clk, Row =>JArow, Col=>JAcol, DecodeOut=> Decode);
--	C1: DisplayController port map (DispVal=>Decode, anode=>an, segOut=>seg );
	C2: decoderFSM port map (clk=>clk, reset=>reset, DecodeOut => Decode, Key1Assigned =>LED1, Key2Assigned =>LED2, Key3Assigned =>LED3, Key1Value => Key1, Key2Value => Key2, Key3Value => Key3 );
	C3: Calculator port map (a=>key1, b=>key2, op=>key3, resultOut=>result, errorOut=>LED4);
    	C4: DisplayController port map (DispVal=>result, anode=>an, segOut=>seg );
end Behavioral;


