
packet openflow_phy_port {
	port_no: uint16;
	hw_addr: byte[6];
	name: byte[16];
	
	unused_config1: byte[3];
	unused_config2: bit[1];
	no_packet_in: bit[1];
	no_fwd: bit[1];
	no_flood: bit[1];
	no_recv_stp: bit[1];
	no_recv: bit[1];
	no_stp: bit[1];
	port_down: bit[1];

	unused_state3: byte[2];
	unused_state2: bit[6];	
	stp_forward: bit[1];
	stp_learn: bit[1];
	unused_state1: bit[7];
	link_down: bit[1];

	curr: byte[4];       /* phy_port_feature */
	advertised: byte[4]; /* phy_port_feature */
	supported: byte[4];  /* phy_port_feature */
	peer: byte[4];       /* phy_port_feature */
}
