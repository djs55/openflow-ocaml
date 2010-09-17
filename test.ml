module M = Mpl_stdlib
open Openflow_packet

let path_of_switch name = Printf.sprintf "/var/run/openvswitch/%s.mgmt" name

let with_switch name f =
    let fd = Unix.socket Unix.PF_UNIX Unix.SOCK_STREAM 0 in
    Pervasiveext.finally 
	(fun () ->
	     let sa = Unix.ADDR_UNIX (path_of_switch "xenbr0") in
	     Unix.connect fd sa;
	     f fd
	)
    	(fun () -> Unix.close fd)

(* enum ofp_port, p18 *)
module Port = struct
	type t = 
	| Physical of int32
	| In_port (* Send the packet out the input port *)
	| Table (* Perform actions in flow table (packet-out messages only) *)
	| Normal (* normal L2/L3 switching *)
	| Flood (* All physical ports except input and any STP-disabled *)
	| All (* All physical ports except input *)
	| Controller (* Send to controller *)
	| Local (* Local openflow "port" *)
	| NoPort (* Not associated with a physical port *)

	let enum = [ 0xfff8l, In_port; 0xfff9l, Table; 0xfffal, Normal;
	             0xfffbl, Flood; 0xfffcl, All; 0xfffdl, Controller;
	             0xfffel, Local; 0xffffl, NoPort ]
	let enum' = List.map (fun (x, y) -> y, x) enum
	let keys = List.map fst enum
	let of_int32 x = if List.mem x keys then List.assoc x enum else (Physical x)
	let to_int32 = function
	| Physical x -> assert (not (List.mem x keys)); x
	| x -> List.assoc x enum'
end



let hello env = 
	let (_: HELLO.o) = HELLO.t ~version:1 ~xid:0l ~data:(`Str "") env in ()

let vendor env = 
	let (_: VENDOR.o) = VENDOR.t ~version:1 ~xid:0l ~vendor:0l ~data:(`Str "") env in ()

let features_request env = 
	let (_: FEATURES_REQUEST.o) = FEATURES_REQUEST.t ~version:1 ~xid:0l ~data:(`Str "") env in ()

let get_config_request env = 
	let (_: GET_CONFIG_REQUEST.o) = GET_CONFIG_REQUEST.t ~version:1 ~xid:0l env in ()

let set_config env = 
	let (_: SET_CONFIG.o) = SET_CONFIG.t ~version:1 ~xid:0l ~flags:`NORMAL ~miss_send_len:0 env in ()

let stats_request env = 
	let (_: STATS_REQUEST.o) = STATS_REQUEST.t ~version:1 ~xid:0l ~req_ty:`DESCR env in ()

let features_reply x = match x with 
|`FEATURES_REPLY o ->
	FEATURES_REPLY.prettyprint o;
	M.fold_env o#data_env
		(fun env () ->
			let o = Openflow_phy_port.unmarshal env in
			Openflow_phy_port.prettyprint o;
			List.iter
				(fun (name, features_env) ->
				let o' = Openflow_phy_port_feature.unmarshal features_env in
				Printf.printf "%s features:\n" name; flush stdout;
				Openflow_phy_port_feature.prettyprint o'
			) [ 
			"curr", o#curr_env;
		    	"advertised", o#advertised_env;
		    	"supported", o#supported_env;
		    	"peer", o#peer_env ]) ()

| _ -> failwith "Not a FEATURES_REPLY"

let stats_reply x = match x with 
|`STATS_REPLY o ->
	STATS_REPLY.prettyprint o;
	let data_env = o#data_env in
	while M.remaining data_env > 0 do
		(* XXX: bad pattern: unmarshal respects base but ignores pos? *)
		let env = M.env_at data_env (M.curpos data_env) (M.size data_env) in
		let o = Openflow_desc_stats.unmarshal env in
		M.skip data_env (M.curpos env);
		Openflow_desc_stats.prettyprint o;
	done
| _ -> failwith "Not a STATS_REPLY"

let send f env fd = 
      M.reset env;
      f env;
      M.flush env fd

let recv env fd handler = 
      M.reset env;
      M.fill env fd;
      let o = unmarshal env in
      handler o;
      o

let _ =
    let env = M.new_env (String.make 16384 '\000') in
    let senv = M.new_env (String.make 1000 '\000') in

    with_switch "xenbr0"
    (fun fd ->
      send hello senv fd;
      ignore(recv env fd prettyprint);
      send vendor senv fd;
      ignore(recv env fd prettyprint);
      send features_request senv fd;
      ignore(recv env fd features_reply);
      send get_config_request senv fd;
      ignore(recv env fd prettyprint);
      send stats_request senv fd;
      ignore(recv env fd stats_reply);
      send set_config senv fd;
      ignore(recv env fd prettyprint);
    )
