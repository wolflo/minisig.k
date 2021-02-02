see the minisig [repo](https://github.com/wolflo/minisig)

## Setup
* `docker pull wolflo0/kevm:latest`
* `docker run -it -v ${PWD}:/home/user/specs wolflo0/kevm:6955e13`

## Proving a spec
* `make prove spec=msig-spec-nonce` to prove the spec in `specs/msig-spec-nonce.k`
* `make prove-all` to prove all of the specs
