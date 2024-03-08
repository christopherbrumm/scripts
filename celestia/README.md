## celestia
The included bash script provides a simple way to reproduce
the submitted issue: https://github.com/celestiaorg/celestia-node/issues/3185

### Usage
Please copy the file to your desired location and grant it executable permissions using the following command: 
```bash
chmod +x load_test_celestia-node.sh
```

Make sure to export `$CELESTIA_NODE_AUTH_TOKEN`.

Execute the file with the following parameters:
```bash
./request_script.sh <port of celestia-node> 781000
```

### What is the script doing?
It executes the `blob.GetAll` query five times for each height for a predefined namespace.
Thereby, it logs the requested height (key), response and the duration of the query.

### Expected behaviour
Over time, the duration of requests increases and command execution is temporarily halted, 
resulting in noticeable delays for certain requests. As the script runs for a few minutes, 
these delays become more significant and eventually cause the logging of responses to halt 
completely at a certain point.