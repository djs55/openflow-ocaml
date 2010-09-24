
packet openflow_action{
	ty: uint16;
	len: uint16 value(offset(end_of_packet));
	pad: byte[4];	
	classify(ty) {
		| 0:"OUTPUT" ->
			_type: uint16 const(0);
			_len: uint16 const(8);
			port: packet openflow_port ();
			max_len: uint16;	
		| 1:"SET_VLAN_VID" ->
			_type: uint16 const(1);
			_len: uint16 const(8);
			vlan_vid: uint16 variant {
				| 0xffff -> None
			};
			pad2: byte[2];
		| 2:"SET_VLAN_PCP" ->
			_type: uint16 const(2);
			_len: uint16 const(8);
			_pad1: bit[5] const(0);
			vlan_pcp: bit[3];
			pad2: byte[3];
		| 3:"STRIP_VLAN" -> ();
		| 4:"SET_DL_SRC" ->
			_type: uint16 const(4);
			_len: uint16 const(16);
			dl_addr: byte[6];
			pad2: byte[6];
		| 5:"SET_DL_DST" ->
			_type: uint16 const(5);
			_len: uint16 const(16);
			dl_addr: byte[6];
			pad2: byte[6];
		| 6:"SET_NW_SRC" ->
			_type: uint16 const(6);
			_len: uint16 const(8);
			nw_addr: uint32;
		| 7:"SET_NW_DST" ->
			_type: uint16 const(7);
			_len: uint16 const(8);
			nw_addr: uint32;
		| 8:"SET_NW_TOS" ->
			_type: uint16 const(8);
			_len: uint16 const(8);
			nw_tos: byte;
			pad2: byte[3];
		| 9:"SET_TP_SRC" ->
			_type: uint16 const(9);
			_len: uint16 const(8);
			tp_port: uint16;
			pad2: byte[2];
		| 10:"SET_TP_DST" ->
			_type: uint16 const(10);
			_len: uint16 const(8);
			ty_port: uint16;
			pad2: byte[2];
		| 11:"ENQUEUE" ->
			_type: uint16 const(11);
			_len: uint16 const(16);
			port: packet openflow_port();
			pad2: byte[6];
			queue_id: uint32;
		| 0xffff:"VENDOR" ->
			vendor_start: label;
			_type: uint16 const(0xffff);
			_len: uint16 value(offset(end_of_packet)-offset(vendor_start));
			data_start: label;
			data: byte[_len - offset(data_start) + offset(vendor_start)];

	};

	end_of_packet: label;
}
