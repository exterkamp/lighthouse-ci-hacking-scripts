# lighthouse-ci-hacking-scripts

## Usage

### Using Dockerfile on Raspberry Pi

Raspberry Pi's run on ARM and cannot use the normal LHCI Dockerfile, so it has
to be modified a bit.

#### Pi's I support

* Raspberry Pi 1 B+

    ```shell
    docker image build -t lhci .
    docker volume create lhci-data
    docker container run --publish 9001:9001 --mount='source=lhci-data,target=/data' --detach lhci
    ```

### `run-and-upload.sh`

1. Make a `urls.txt` file:
    ```text
    https://exterkamp.codes/
    https://google.com/
    ...more urls...
    ```
2. Get a [PSI API key](https://developers.google.com/speed/docs/insights/v5/get-started#APIKey).
3. Find your LHCI server base url and get a LHCI API project token.
4. Run!
    ```shell
    sh run-and-upload.sh psi_api_key lhci_server_base_url lhci_api_token
    ```

## Hacking Hints

* Edit the curl command on l#28 to add more `categories`, change `strategy`, etc.
* Edit the committer info in l#35-36
* On Windows and reports are coming in blank? Maybe you need to swap line ends to just `LF`?
