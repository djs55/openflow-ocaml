
packet openflow_flow_wildcards {
	_pad: bit[10] const(0);
	nw_tos: bit[1];
	dl_vlan_pcp: bit[1];
	nw_dst: bit[6];
	nw_src: bit[6];
	tp_dst: bit[1];
	tp_src: bit[1];
	nw_proto: bit[1];
	dl_type: bit[1];
	dl_dst: bit[1];
	dl_src: bit[1];
	dl_vlan: bit[1];
	in_port: bit[1];
}

