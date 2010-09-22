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

packet openflow_port {
	OFP_PORT(port);
}
