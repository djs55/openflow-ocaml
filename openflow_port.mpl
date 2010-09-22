
packet openflow_port {
	port : uint16 variant {
		| 0xff00 -> MAX
		| 0xfff8 -> IN_PORT
		| 0xfff9 -> TABLE
		| 0xfffa -> NORMAL
		| 0xfffb -> FLOOD
		| 0xfffc -> ALL
		| 0xfffd -> CONTROLLER
		| 0xfffe -> LOCAL
		| 0xffff -> NONE
	};
}
