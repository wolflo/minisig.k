.PHONY: prove prove-all

BACKEND := java
SPEC_DIR := specs

specs := $(wildcard $(SPEC_DIR)/*.k)

$(SPEC_DIR)/%.k.prove: $(SPEC_DIR)/%.k
	kevm prove --backend $(BACKEND) $< VERIFICATION --smt-prelude specs/lemmas/evm.smt2 --z3-impl-timeout 100 --concrete-rules $(shell cat specs/lemmas/concrete-rules.txt | tr '\n' ',')
# --log-rules

prove: $(spec).prove; $<
prove-all: $(specs:=.prove)
