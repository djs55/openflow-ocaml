
packet openflow_phy_port_feature{
	feature_unused1: byte[2];
	feature_unused2: bit[4];
	feature_pause_asym: bit[1];
	feature_pause: bit[1];
	feature_autoneg: bit[1];
	feature_fiber: bit[1];
	feature_copper: bit[1];
	feature_10GB_FD: bit[1];
	feature_1GB_FD: bit[1];
	feature_1GB_HD: bit[1];
	feature_100MB_FD: bit[1];
	feature_100MB_HD: bit[1];
	feature_10MB_FD: bit[1];
	feature_10MB_HD: bit[1];	
}
