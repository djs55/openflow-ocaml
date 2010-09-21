#include "openflow_port_config.mpl"
#include "openflow_phy_port_feature.mpl"

/* OFP_PORT is a common 'type'. Note that Unknown values represent real
   ports */
#define OFP_PORT(x) x : uint16 variant { \
	| 0xff00 -> MAX \
	| 0xfff8 -> IN_PORT \
	| 0xfff9 -> TABLE \
	| 0xfffa -> NORMAL \
	| 0xfffb -> FLOOD \
	| 0xfffc -> ALL \
	| 0xfffd -> CONTROLLER \
	| 0xfffe -> LOCAL \
	| 0xffff -> NONE \
}


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
			OFP_PORT(in_port);
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
			OFP_PORT(in_port);
			actions_len: uint16 value(offset(actions_end)-offset(actions_start));
			actions_start: label;
			actions: byte[actions_len];
			actions_end: label;
			data: byte[length - offset(actions_end)];
		| 14:"FLOW_MOD" ->
			ofp_match: byte[40]; /* openflow_match */
			cookie: uint64;
			command: uint16;
			idle_timeout: uint16;
			hard_timeout: uint16;
			priority: uint16;
			buffer_id: uint32;
			OFP_PORT(out_port);
			flags: uint16;
			ofp_flow_mod_header_end: label;

			data: byte[length - offset(ofp_flow_mod_header_end)];
 		| 15:"PORT_MOD" ->
			OFP_PORT(port_no);
			hw_addr: byte[6];
			OFP_PORT_CONFIG(config);
			OFP_PORT_CONFIG(mask);
			OFP_PORT_FEATURE(advertise);
			_pad: uint32;
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
		| 18:"BARRIER_REQUEST" ->
			();
		| 19:"BARRIER_REPLY" ->
			();
		| 20:"QUEUE_GET_CONFIG_REQUEST" ->
			OFP_PORT(port);
			_pad: uint16;
		| 21:"QUEUE_GET_CONFIG_REPLY" ->
			OFP_PORT(port);
			_pad: byte[6];
			ofp_queue_get_config_reply_header_end: label;
			data: byte[length - offset(ofp_queue_get_config_reply_header_end)];

	};
	end_of_packet: label;
}

