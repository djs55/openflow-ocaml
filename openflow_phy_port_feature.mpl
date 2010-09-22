#define OFP_PORT_FEATURE(x) \
	x##_unused1: byte[2]; \
	x##_unused2: bit[4]; \
	x##pause_asym: bit[1]; \
	x##pause: bit[1]; \
	x##autoneg: bit[1]; \
	x##fiber: bit[1]; \
	x##copper: bit[1]; \
	x##_10GB_FD: bit[1]; \
	x##_1GB_FD: bit[1]; \
	x##_1GB_HD: bit[1]; \
	x##_100MB_FD: bit[1]; \
	x##_100MB_HD: bit[1]; \
	x##_10MB_FD: bit[1]; \
	x##_10MB_HD: bit[1]	

packet openflow_phy_port_feature{
	OFP_PORT_FEATURE(feature);
}
