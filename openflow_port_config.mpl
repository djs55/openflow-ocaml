#define OFP_PORT_CONFIG(x) \
	x##_pad1: byte[3]; \
	x##_pad2: bit[1]; \
	x##_no_packet_in: bit[1]; \
	x##_no_fwd: bit[1]; \
	x##_no_flood: bit[1]; \
	x##_no_recv_stp: bit[1]; \
	x##_no_recv: bit[1]; \
	x##_no_stp: bit[1]; \
	x##_port_down: bit[1]
	
packet openflow_port_config{
	OFP_PORT_CONFIG(config);
}
