#!/usr/bin/env -S v -n -w -gc none -no-retry-compilation -cc tcc -d use_openssl -enable-globals run

import log

// Mock implementation for testing
struct MockDeployer {
mut:
    logger &log.Log
}

fn (mut d MockDeployer) cancel_contract(contract_id u64) ! {
    d.logger.info('Mock: Canceling contract ${contract_id}')
}

fn test_cancel_contract(contract_id u64) ! {
    mut logger := &log.Log{}
    logger.set_level(.debug)
    mut deployer := MockDeployer{
        logger: logger
    }
    deployer.cancel_contract(contract_id)!
}

fn main() {
    test_cancel_contract(u64(119497)) or { println('error happened: ${err}') }
}
