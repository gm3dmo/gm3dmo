Use more than 1 destination/header in a --write-out flag:

```
curl --silent --write-out "%output{a.txt}%{json}%output{b.txt}{json_header}"  https://example.com -o /dev/null
```
