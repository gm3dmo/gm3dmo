## Avoid getting rate limited by GitHub by coding defensively

GitHub's API layer serves astounding numbers of requests per day. To do this and keep a free offering for everybody using GitHub we rely on the [rate-limit](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28). Github's API has a generous free offering of 5k requests per hour for authenticated users and even unauthenticated users can interact with the API at a rate of 60 requests per hour.

### Make your code aware of the the rate limit headers
To help customers [work within our rate limits](https://docs.github.com/en/rest/using-the-rest-api/rate-limits-for-the-rest-api?apiVersion=2022-11-28#checking-the-status-of-your-rate-limit) we provide 5 response headers in requests to the API.

To demonstrate these we can use a snippet of python.

### Respond the 

### Taking things further
The samples here are for demonstration purposes here isn't code for production. You may want to investigate things like the design patterns for *circuit-breakers* or throttling and discuss with your team the best way of working within GitHub's rate limits for your organization.

