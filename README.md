See the minisig [repo](https://github.com/wolflo/minisig).

## Setup
* `docker pull wolflo0/kevm:3efa855`
* `docker run -it -v ${PWD}:/home/user/specs wolflo0/kevm:3efa855`

Alternatively, you can build K and Kevm locally or install from a [release](https://github.com/kframework/evm-semantics/releases/tag/v1.0.0-3efa855) build.

## Proving a spec
* `make prove spec=msig-spec-nonce` to prove the spec in `specs/msig-spec-nonce.k`
* `make prove-all` to prove all of the specs
