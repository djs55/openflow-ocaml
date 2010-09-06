
/* 40 bytes long */
packet openflow_match {
	wildcards: uint32;
	in_port: uint16;
	dl_src: byte[6];
	dl_dst: byte[6];
	dl_vlan: uint16;
	dl_vlan_pcp: byte;
	_pad1: byte;
	dl_type: uint16;
	nw_tos: byte;
	nw_proto: byte;
	_pad2: byte[2];
	nw_src: uint32;
	nw_dst: uint32;
	tp_src: uint16;
	tp_dst: uint16;

}