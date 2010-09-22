#include "openflow_port_config.mpl"

packet openflow_phy_port {
	port_no: uint16;
	hw_addr: byte[6];
	name: byte[16];

	OFP_PORT_CONFIG(config);

	unused_state3: byte[2];
	unused_state2: bit[6];	
	stp_forward: bit[1];
	stp_learn: bit[1];
	unused_state1: bit[7];
	link_down: bit[1];

	curr: packet openflow_phy_port_feature();
	advertised: packet openflow_phy_port_feature();
	supported: packet openflow_phy_port_feature();
	peer: packet openflow_phy_port_feature();
}
