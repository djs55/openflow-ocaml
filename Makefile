OCAMLC = ocamlfind ocamlc -package "unix,str,stdext,mpl" -g
OCAMLOPT = ocamlfind ocamlopt -package "unix,str,stdext,mpl"
MPLC = mplc

PROGRAMS = test
OBJS = openflow_phy_port openflow_packet
INTF = $(foreach obj, $(OBJS),$(obj).cmi)

all: $(INTF) $(LIBS) $(PROGRAMS)

bins: $(PROGRAMS)

libs: $(LIBS)

test: openflow_phy_port.cmx openflow_packet.cmx openflow_desc_stats.cmx openflow_match.cmx test.cmx
	$(OCAMLOPT) -linkpkg -o test openflow_phy_port.cmx openflow_packet.cmx openflow_desc_stats.cmx openflow_match.cmx test.cmx

test.cmx: openflow_phy_port.cmi openflow_packet.cmi openflow_desc_stats.cmi openflow_match.cmi test.ml

%.ml: %.mpl
	cpp $< $<.2
	cat $<.2 | grep -v '^#' > $<.3
	$(MPLC) $<.3 > $@
	rm -f $<.2 $<.3

%.mli: %.ml
	$(OCAMLC) -i $< > $@ 

%.cmo: %.ml
	$(OCAMLC) $(OCAMLFLAGS) -c -o $@ $<

%.cmi: %.mli
	$(OCAMLC) $(OCAMLFLAGS) -c -o $@ $<

%.cmx: %.ml
	$(OCAMLOPT) $(OCAMLOPTFLAGS) $(OCAMLFLAGS) -c -o $@ $<

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $<

META: META.in
	sed 's/@VERSION@/$(VERSION)/g' < $< > $@

clean:
	rm -f *.o *.so *.a *.cmo *.cmi *.cma *.cmx *.cmxa *.annot $(LIBS) $(PROGRAMS) *.2 *.3
