## Understand the rate limit headers returned by GitHub

GitHub's API layer serves astounding numbers of requests per day. To do this and keep a free offering for everybody using GitHub a [rate-limit](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28) is enforced. Github's API has a generous free offering of 5k requests per hour for authenticated users and even unauthenticated users can interact with the API at a rate of 60 requests per hour.

To keep this explanation simple we use the [Zen of Github](https://docs.github.com/en/rest/meta/meta?apiVersion=2022-11-28#get-the-zen-of-github) api endpoint to get a random sentence from the [Zen of GitHub](https://ben.balter.com/2015/08/12/the-zen-of-github/)

```
curl --silent https://api.github.com/zen
```

and the response (responses may differ):

```
Approachable is better than simple.
```

Add `-i` to the `curl` command to include response headers:

```
curl  --silent -i  https://api.github.com/zen
```

```
HTTP/2 200 
date: Sat, 13 Jul 2024 10:56:58 GMT
content-type: text/plain;charset=utf-8
x-github-api-version-selected: 2022-11-28
access-control-expose-headers: ETag, Link, Location, Retry-After, X-GitHub-OTP, X-RateLimit-Limit, X-RateLimit-Remaining, X-RateLimit-Used, X-RateLimit-Resource, X-RateLimit-Reset, X-OAuth-Scopes, X-Accepted-OAuth-Scopes, X-Poll-Interval, X-GitHub-Media-Type, X-GitHub-SSO, X-GitHub-Request-Id, Deprecation, Sunset
access-control-allow-origin: *
strict-transport-security: max-age=31536000; includeSubdomains; preload
x-frame-options: deny
x-content-type-options: nosniff
x-xss-protection: 0
referrer-policy: origin-when-cross-origin, strict-origin-when-cross-origin
content-security-policy: default-src 'none'
vary: Accept-Encoding, Accept, X-Requested-With
server: github.com
x-ratelimit-limit: 60
x-ratelimit-remaining: 29
x-ratelimit-reset: 1720869958
x-ratelimit-resource: core
x-ratelimit-used: 31
accept-ranges: bytes
content-length: 35
x-github-request-id: D6F0:1DEC14:20E524:2355FB:66925D7A

Approachable is better than simple.   
```

These limits are defined in [checking the status of your rate limit](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28#checking-the-status-of-your-rate-limit). 

```
x-ratelimit-limit: 60
x-ratelimit-remaining: 29
x-ratelimit-reset: 1720869958
x-ratelimit-resource: core
x-ratelimit-used: 31
```

`x-ratelimit-reset` is a unix timestamp at which GitHub will reset the limit. On Linux/Mac you can convert this to a readable date using the `date` command (there are also websites like [Unixtimestamp](https://www.unixtimestamp.com/) that can show you a conversion:

On Linux
```
date -d @1720869958
Sat Jul 13 11:25:58 AM UTC 2024
```


On Mac
```
date -j -f %s 1720869958
Sat 13 Jul 2024 12:25:58 BST
```

Our rate limit will reset back to zero on Saturday July 13th 11:58:58 2024.

Make another request and inspect the headers:

```
curl  --silent -i  https://api.github.com/zen
```

```
x-ratelimit-limit: 60
x-ratelimit-remaining: 28
x-ratelimit-reset: 1720869958
x-ratelimit-resource: core
x-ratelimit-used: 32
```

The `x-ratelimit-remaining` is now 28, `x-ratelimit-used` has increased by 1 to 32. 

## Avoid getting rate limited by GitHub by coding defensively

### Make your code aware of the the rate limit headers
To help you [work within GitHub's rate limits](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28#checking-the-status-of-your-rate-limit) we provide 5 response headers in requests to the API.

```
curl  --silent -w %output{headers1.json}%{header_json}  https://api.github.com/users/1 -o 1.json
```
 
### Respond to the values in the header

### Taking things further
The samples here are for demonstration purposes here isn't code for production. You may want to investigate things like the design patterns for *circuit-breakers* or throttling and discuss with your team the best way of working within GitHub's rate limits for your organization.

[Easier header picking with curl](https://daniel.haxx.se/blog/2022/03/24/easier-header-picking-with-curl/)
