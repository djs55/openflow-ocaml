
packet openflow {
	version: byte;
	ty: byte;
	length: uint16 value(offset(end_of_packet));
	xid: uint32;
	ofp_header_end: label;

	classify(ty) {
		| 0:"HELLO" ->
			data: byte[length - offset(ofp_header_end)];
		| 1:"ERROR" ->
			error: uint32 variant {
				/* HELLO */
				| 0x00000000 -> HELLO_INCOMPATIBLE
				| 0x00000001 -> HELLO_EPERM
				/* REQUEST */
				| 0x00010000 -> REQUEST_BAD_VERSION
				| 0x00010001 -> REQUEST_BAD_TYPE
				| 0x00010002 -> REQUEST_BAD_STAT
				| 0x00010003 -> REQUEST_BAD_VENDOR
				| 0x00010004 -> REQUEST_BAD_SUBTYPE
				| 0x00010005 -> REQUEST_REQUEST_EPERM
				| 0x00010006 -> REQUEST_BAD_LEN
				| 0x00010007 -> REQUEST_BUFFER_EMPTY
				| 0x00010008 -> REQUEST_BUFFER_UNKNOWN
				/* ACTION */
				| 0x00020000 -> ACTION_BAD_TYPE
				| 0x00020001 -> ACTION_BAD_LEN
				| 0x00020002 -> ACTION_BAD_VENDOR
				| 0x00020003 -> ACTION_BAD_VENDOR_TYPE
				| 0x00020004 -> ACTION_BAD_OUT_PORT
				| 0x00020005 -> ACTION_BAD_ARGUMENT
				| 0x00020006 -> ACTION_EPERM
				| 0x00020007 -> ACTION_TOO_MANY
				| 0x00020008 -> ACTION_BAD_QUEUE
				/* FLOW_MOD */
				| 0x00030000 -> FLOW_MOD_ALL_TABLES_FULL
				| 0x00030001 -> FLOW_MOD_OVERLAP
				| 0x00030002 -> FLOW_MOD_EPERM
				| 0x00030003 -> FLOW_MOD_EMERG_TIMEOUT
				| 0x00030004 -> FLOW_MOD_BAD_COMMAND
				| 0x00030004 -> FLOW_MOD_UNSUPPORTED
				/* PORT_MOD */
				| 0x00040000 -> PORT_MOD_BAD_PORT
				| 0x00040001 -> PORT_MOD_BAD_HW_ADDR
				/* QUEUE_OP */
				| 0x00050000 -> QUEUE_OP_BAD_PORT
				| 0x00050001 -> QUEUE_OP_BAD_QUEUE
				| 0x00050002 -> QUEUE_OP_EPERM	
			};
			ofp_error_msg_end: label;

			data: byte[length - offset(ofp_error_msg_end)];
		| 2:"ECHO_REQUEST" ->
			data: byte[length - offset(ofp_header_end)];
		| 3:"ECHO_REPLY" ->
			data: byte[length - offset(ofp_header_end)];
		| 4:"VENDOR" ->
			vendor: uint32;
			ofp_vendor_header_end: label;

			data: byte[length - offset(ofp_vendor_header_end)];
		| 5:"FEATURES_REQUEST" ->
			ofp_features_request_header_end: label;

			data: byte[length - offset(ofp_features_request_header_end)];
		| 6:"FEATURES_REPLY" ->
			datapath_id: uint64;
			n_buffers: uint32;
			n_tables: byte;
			pad: byte[3];
			unused_capabilities: byte[3];
			arp_match_ip: bit[1];
			queue_stats: bit[1];
			ip_reasm: bit[1];
			reserved: bit[1];
			stp: bit[1];
			port_stats: bit[1];
			table_stats: bit[1];
			flow_stats: bit[1];
			actions: uint32;
			ofp_features_reply_header_end: label;

			data: byte[length - offset(ofp_features_reply_header_end)];
		| 7:"GET_CONFIG_REQUEST" ->
			();

		| 8:"GET_CONFIG_REPLY" ->
			_pad: bit[14] const(0);
			reasm: bit[1];
			drop: bit[1];
			miss_send_len: uint16;
		| 9:"SET_CONFIG" ->
			_pad: bit[14] const(0);
			reasm: bit[1];
			drop: bit[1];
			miss_send_len: uint16;
		| 10:"PACKET_IN" ->
			buffer_id: uint32;
			total_len: uint16;
			in_port: packet openflow_port();
			reason: byte variant {
				| 0 -> NO_MATCH
				| 1 -> ACTION
			};
			pad: byte;
			ofp_packet_in_header_end: label;

			data: byte[length - offset(ofp_packet_in_header_end)];
		| 11:"FLOW_REMOVED" ->
			ofp_match: packet openflow_match();
			cookie: uint64;
			priority: uint16;
			reason: byte variant {
				| 0 -> IDLE_TIMEOUT
				| 1 -> HARD_TIMEOUT
				| 2 -> DELETE
			};
			_pad: byte;
			duration_sec: uint32;
			duration_nsec: uint32;
			idle_timeout: uint16;
			_pad2: byte[2];
			packet_count: uint64;
			byte_count: uint64;
		| 12:"PORT_STATUS" ->
			reason: byte variant {
				| 0 -> ADD
				| 1 -> DELETE
				| 2 -> MODIFY
			};
			_pad: byte[7];
			ofp_port_status_header_end: label;
			phy_port: packet openflow_phy_port();
		| 13:"PACKET_OUT" ->
			buffer_id: uint32;
			in_port: packet openflow_port();
			actions_len: uint16 value(offset(actions_end)-offset(actions_start));
			actions_start: label;
			actions: byte[actions_len];
			actions_end: label;
			data: byte[length - offset(actions_end)];
		| 14:"FLOW_MOD" ->
			ofp_match: packet openflow_match();
			cookie: uint64;
			command: uint16 variant {
				| 0 -> ADD
				| 1 -> MODIFY
				| 2 -> MODIFY_STRICT
				| 3 -> DELETE
				| 4 -> DELETE_STRICT
			};
			idle_timeout: uint16;
			hard_timeout: uint16;
			priority: uint16;
			buffer_id: uint32 default (-1);
			out_port: packet openflow_port();
			_pad: bit[13] const(0);
			emerg: bit[1];
			overlap: bit[1];
			send_flow_rem: bit[1];
			ofp_flow_mod_header_end: label;

			data: byte[length - offset(ofp_flow_mod_header_end)];
 		| 15:"PORT_MOD" ->
			port_no: packet openflow_port();
			hw_addr: byte[6];
			config: packet openflow_port_config();
			mask: packet openflow_port_config();
			advertise: packet openflow_phy_port_feature();
			_pad: uint32;
		| 16:"STATS_REQUEST" ->
			request_ty: uint16;
			flags: uint16 const(0);
			classify (request_ty){
				| 0:"DESCR" -> ();
				| 1:"FLOW" ->
					ofp_match: packet openflow_match();
					table_id: byte variant {
						| 0xff -> ALL
					};
					pad: byte default(0);
					out_port: packet openflow_port(); 
				| 2:"AGGREGATE" ->
					ofp_match: packet openflow_match ();
					table_id: byte variant {
						| 0xfe -> EMERGENCY
						| 0xff -> ALL
					};
					pad: byte const(0);
					out_port: packet openflow_port();
				| 3:"TABLE" -> ();
				| 4:"PORT" ->
					port_no: packet openflow_port();
					pad: byte[6];
				| 5:"QUEUE" ->
					port_no: packet openflow_port();
					pad: byte[2];
					queue_id: uint32;
				| 0xffff:"VENDOR" -> ();

			};
		| 17:"STATS_REPLY" ->
			reply_ty: uint16;
			_pad: bit[15] const(0);
			more_to_follow: bit[1];
			classify (reply_ty) {
				| 0:"DESC" ->
					mfr_desc: byte[256];
					hw_desc: byte[256];
					sw_desc: byte[256];
					serial_num: byte[32];
					dp_desc: byte[256];
				| 1:"FLOW" ->
					entry_length: uint16; /* XXX */
					table_id: byte;
					pad: byte default(0);
					ofp_match: packet openflow_match();
					duration_sec: uint32;
					duration_nsec: uint32;
					priority: uint16;
					idle_timeout: uint16;
					hard_timeout: uint16;
					pad2: byte[6];
					cookie: uint64;
					packet_count: uint64;
					byte_count: uint64;
					action: packet openflow_action();
				| 2:"AGGREGATE" ->
					packet_count: uint64;
					byte_count: uint64;
					flow_count: uint32;
					pad: byte[4];
				| 3:"TABLE" ->
					table_id: byte;
					pad: byte[3];
					name: byte[32];
					wildcards: packet openflow_flow_wildcards();
					max_entries: uint32;
					active_count: uint32;
					lookup_count: uint64;
					matched_count: uint64;
				| 4:"PORT" ->
					port_no: uint16;
					pad: byte[6];
					rx_packets: uint64;
					tx_packets: uint64;
					rx_bytes: uint64;
					tx_bytes: uint64;
					rx_dropped: uint64;
					tx_dropped: uint64;
					rx_errors: uint64;
					tx_errors: uint64;
					rx_frame_err: uint64;
					rx_over_err: uint64;
					rx_crc_err: uint64;
					collisions: uint64;
				| 5:"QUEUE" ->
					port_no: uint16;
					pad: byte[2];
					queue_id: uint32;
					tx_bytes: uint64;
					tx_packets: uint64;
					tx_errors: uint64;
				| 6:"VENDOR" ->
					/* XXX vendor data */
					();
			};
			ofp_stats_reply_header_end: label;
		| 18:"BARRIER_REQUEST" ->
			();
		| 19:"BARRIER_REPLY" ->
			();
		| 20:"QUEUE_GET_CONFIG_REQUEST" ->
			port: packet openflow_port();
			_pad: uint16;
		| 21:"QUEUE_GET_CONFIG_REPLY" ->
			port: packet openflow_port();
			_pad: byte[6];
			ofp_queue_get_config_reply_header_end: label;
			data: byte[length - offset(ofp_queue_get_config_reply_header_end)];

	};
	end_of_packet: label;
}

