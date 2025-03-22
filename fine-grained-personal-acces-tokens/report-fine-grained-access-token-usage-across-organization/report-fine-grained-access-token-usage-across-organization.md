# Report fine grained access token usage across an organization

Use the [List fine-grained personal access tokens with access to organization resources](https://docs.github.com/en/rest/orgs/personal-access-tokens?apiVersion=2022-11-28#list-fine-grained-personal-access-tokens-with-access-to-organization-resources) REST API endpoint to list approved fine-grained personal access tokens owned by organization members that can access organization resources.

The [`tiny-fine-grained-tokens-with-permission-on-organization-report-csv.sh`](https://github.com/gm3dmo/the-power/blob/main/tiny-fine-grained-tokens-with-permission-on-organization-report-csv.sh)
demonstrates this:

```
./tiny-fine-grained-tokens-with-permission-on-organization-report-csv.sh
```

Output:

```csv
"id","owner_login","token_last_used_at","token_expires_at"
522067,"pipcrispy","2025-02-28T15:09:16Z","2025-03-30T14:09:02Z"
461741,"robin-of-loxley","2024-12-28T08:42:58Z","2025-12-29T08:40:21Z"
435783,"roger-de-courcey","2024-11-22T17:33:17Z",
435724,"roger-de-courcey","2024-11-22T16:23:49Z",
318509,"robin-of-loxley","2025-03-18T14:05:49Z","2025-12-28T15:06:33Z"
```

Here we use csvlook to smarten up the output:

```
./tiny-fine-grained-tokens-with-permission-on-organization-report-csv.sh | csvlook

```
|      id | owner_login      |        token_last_used_at |          token_expires_at |
| ------- | ---------------- | ------------------------- | ------------------------- |
| 522,067 | pipcrispy        | 2025-02-28 15:09:16+00:00 | 2025-03-30 14:09:02+00:00 |
| 461,741 | robin-of-loxley  | 2024-12-28 08:42:58+00:00 | 2025-12-29 08:40:21+00:00 |
| 435,783 | roger-de-courcey | 2024-11-22 17:33:17+00:00 |                           |
| 435,724 | roger-de-courcey | 2024-11-22 16:23:49+00:00 |                           |
| 318,509 | robin-of-loxley  | 2025-03-18 14:05:49+00:00 | 2025-12-28 15:06:33+00:00 |
```
