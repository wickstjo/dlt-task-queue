module.exports = {
    plugins: ["truffle-security"],
    networks: {
        development: {
            host: '127.0.0.1',
            port: 8545,
            network_id: '*',
            gas: 5000000
        }
    },
    compilers: {
        solc: {
            version: '0.7.0',
            settings: {
                optimizer: {
                    enabled: true,
                    runs: 200
                }
            }
        }
    }
}