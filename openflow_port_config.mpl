packet openflow_port_config{
	config_pad1: byte[3];
	config_pad2: bit[1];
	config_no_packet_in: bit[1];
	config_no_fwd: bit[1];
	config_no_flood: bit[1];
	config_no_recv_stp: bit[1];
	config_no_recv: bit[1];
	config_no_stp: bit[1];
	config_port_down: bit[1];
}
