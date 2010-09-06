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
			error_type: uint16 variant {
				| 0 -> HELLO_FAILED
				| 1 -> BAD_REQUEST
				| 2 -> BAD_ACTION
				| 3 -> FLOW_MOD_FAILED
				| 4 -> PORT_MOD_FAILED
				| 5 -> QUEUE_OP_FAILED
			};
			error_code: uint16;
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
			ofp_get_config_request_header_end: label;

		| 8:"GET_CONFIG_REPLY" ->
			flags: uint16 variant {
				| 0 -> NORMAL
				| 1 -> DROP
				| 2 -> REASM
			};
			miss_send_len: uint16;
		| 9:"SET_CONFIG" ->
			flags: uint16 variant {
				| 0 -> NORMAL
				| 1 -> DROP
				| 2 -> REASM
			};
			miss_send_len: uint16;
		| 10:"PACKET_IN" ->
			buffer_id: uint32;
			total_len: uint16;
			in_port: uint16;
			reason: byte variant {
				| 0 -> NO_MATCH
				| 1 -> ACTION
			};
			pad: byte;
			ofp_packet_in_header_end: label;

			data: byte[length - offset(ofp_packet_in_header_end)];
		| 11:"FLOW_REMOVED" ->
			ofp_match: byte[40]; /* openflow_match */
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
			phy_port: byte[length - offset(ofp_port_status_header_end)];
		| 13:"PACKET_OUT" ->
			buffer_id: uint32;
			in_port: uint16;
			actions_len: uint16 value(offset(actions_end)-offset(actions_start));
			actions_start: label;
			actions: byte[actions_len];
			actions_end: label;
			/* XXX */
		| 14:"FLOW_MOD" ->
			ofp_match: byte[40]; /* openflow_match */
			cookie: uint64;
			command: uint16;
			idle_timeout: uint16;
			hard_timeout: uint16;
			priority: uint16;
			buffer_id: uint32;
			out_port: uint16;
			flags: uint16;
			ofp_flow_mod_header_end: label;

			data: byte[length - offset(ofp_flow_mod_header_end)];
/* 		| 15:"PORT_MOD" -> */
		| 16:"STATS_REQUEST" ->
			req_ty: uint16 variant {
				| 0 -> DESCR
				| 1 -> FLOW
				| 2 -> AGGREGATE
				| 3 -> TABLE
				| 4 -> PORT
				| 5 -> QUEUE
				| 0xffff -> VENDOR
			};
			flags: uint16 const(0);
		| 17:"STATS_REPLY" ->
			reply_ty: uint16 variant {
				| 0 -> DESCR
				| 1 -> FLOW
				| 2 -> AGGREGATE
				| 3 -> TABLE
				| 4 -> PORT
				| 5 -> QUEUE
				| 0xffff -> VENDOR
			};
			_unused: bit[15];
			more_to_follow: bit[1];
			ofp_stats_reply_header_end: label;
			data: byte[length - offset(ofp_stats_reply_header_end)];
	};
	end_of_packet: label;
}

