Use more than 1 destination/header in a --write-out flag:

```
curl --silent --write-out "%output{a.txt}%{json}%output{b.txt}%{header_json}"  https://example.com -o /dev/null
```

Force a version of TLS:

```
curl --tlsv1.2 --tls-max 1.2
