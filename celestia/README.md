# celestia
The included bash script provides a simple way to reproduce
the submitted issue: https://github.com/celestiaorg/celestia-node/issues/3185

## Usage
Checkout the repository and grant the bash scripts executable permissions with:
```bash
chmod +x <file_name>.sh
```

Make sure to export `$CELESTIA_NODE_AUTH_TOKEN`.

### Blobs
Execute the file with the following parameters:
```bash
./load_test_blob.sh <port of celestia-node> 781000
```

#### What is the script doing?
It executes the `blob.GetAll` query five times for each height for a predefined namespace.
Thereby, it logs the requested height (key), response and the duration of the query.

#### Expected behaviour
Over time, the duration of requests increases and command execution is temporarily halted, 
resulting in noticeable delays for certain requests. As the script runs for a few minutes, 
these delays become more significant and eventually cause the logging of responses to halt 
completely at a certain point.

### Shares
Execute the file with the following parameters:
```bash
./load_test_eds.sh <port of celestia-node> 800000
```

#### What is the script doing?
It executes the `header.GetByHeight` query in order to execute the `share.GetEDS` query with the
received header. Thereby, it logs the requested height (key), response and the duration of the query.

#### Expected behaviour
Other than for `load_test_blob.sh`, there is no noticeable increase in the request duration. 
The script should be executed with different start_heights (recommended: in 50,000 steps). 
If successful, the responses of the `share.GetEDS` query are logged. From a certain height 
the `header.GetByHeight` can be performed, but the `share.GetEDS` can no longer be performed.
