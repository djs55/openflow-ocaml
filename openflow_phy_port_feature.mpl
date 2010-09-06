
packet openflow_phy_port_feature {
	_unused1: byte[2];
	_unused2: bit[4];
	pause_asym: bit[1];
	pause: bit[1];
	autoneg: bit[1];
	fiber: bit[1];
	copper: bit[1];
	_10GB_FD: bit[1];
	_1GB_FD: bit[1];
	_1GB_HD: bit[1];
	_100MB_FD: bit[1];
	_100MB_HD: bit[1];
	_10MB_FD: bit[1];
	_10MB_HD: bit[1];	
}
