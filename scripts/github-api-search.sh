#!/bin/bash
#
.  ./.gh-api-examples.conf

# https://docs.github.com/en/rest/reference/search#search-code
# GET /search/code

org=${1:-apache}
search_string=${2:-america}
search_query="org%3A${org}%20${search_string}&type=code"

# Uses the PAT from the config file and fgtoken1 from the config file
# where fgtoken1 is a fine grained token to submit a search
# For use with [The Power](https://github.com/gm3dmo/the-power)


echo "----------------------------------------------------"
for pat_type in "pat" "fgt"
do
    case $pat_type in
      "pat")
        printf "PAT type ${pat_type}: ${GITHUB_TOKEN:0:10}\n"
        ;;
      "fgt")
        GITHUB_TOKEN=${fgtoken1}
        printf "PAT type ${pat_type}: ${GITHUB_TOKEN:0:10}\n"
        ;;
      *)
        echo "Unknown pat type."
        ;;
    esac


    out_file=${pat_type}-token-${org}search-result.json
    headers_file=headers-${pat_type}.txt

    curl --silent -D ${headers_file} \
         -H "Accept: application/vnd.github.v3+json" \
         -H "Authorization: Bearer ${GITHUB_TOKEN}" \
            "${GITHUB_API_BASE_URL}/search/code?q=${search_query}" > ${out_file}

    printf "results: "
    cat ${out_file} | jq -r '.total_count'
    cat ${out_file} | jq -r '.items[] | [.repository.full_name, .repository.id, .name, .path] | @csv'
    echo
    printf "x-github-request-id: "
    grep x-github-request-id ${headers_file} | awk '{print $2}'
    echo
    echo "----------------------------------------------------"
 done