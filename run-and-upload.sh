#!/bin/bash
rm -rf .tmp

# I need somebody...
if [ $1 = "--help" ]; then
    echo "Usage: psi_api_key lhci_server_base_url lhci_token"
    exit 0
fi

# Read args
API_KEY=$1
LHCI_BASE_URL=$2
LHCI_TOKEN=$3

# Confirm urls config exists
input="urls.txt"
[ ! -f $input ] && echo "Create a urls.txt file with a list of urls to run." && exit 1

# Make a new, empty git repo
(mkdir .tmp && cd .tmp && git init)
RESULTS_PATH=".lighthouseci"
mkdir -p .tmp/$RESULTS_PATH

id=1
# Run PSI on the URLs in urls.txt
while read -r URL || [[ -n $URL ]]; do
    echo "Calling PSI (id: $id) on $URL"
    curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=$URL&key=$API_KEY&strategy=mobile&category=performance" | \
        python -c "import sys, json; print(json.dumps(json.load(sys.stdin)['lighthouseResult']))" > .tmp/$RESULTS_PATH/lhr-$id.json
    id=$((id + 1))
done < $input

cd .tmp
# Make an empty commit to get a new hash for this build
git config user.name "CI Build Bot"
git config user.email "robot@automati.on"
git commit --allow-empty -m "empty $(date +%Y-%m-%d_%H-%M-%S)" && git push
# Upload to LHCI
lhci upload --serverBaseUrl=$LHCI_BASE_URL --token=$LHCI_TOKEN

# Clean up
cd ..
rm -rf .tmp
exit 0