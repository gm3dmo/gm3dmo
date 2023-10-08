### Legacy Migrations

- Dry run. Write out on paper the steps you think you'll need to perform.
- Minimizde disruption on the legacy machine:
  - Don't try to install software on the legacy machine, it's likely to end up breaking something unexpected and crucial to the operation of the system.
  - Does legacy have enough diskspace for the data dumps you are planning. Don't find out by filling the disk and wrecking things.
- Identify when the best times are to run jobs like data extracts.
- SSL/TLS. Older apps can't do modern versions of TLS. Bear that in mind when you need to connect to them via the network you may need some older ISO's to boot up and connect.

#### Databases

##### Microsoft Access

#### Languages
What is likely to be available on the legacy system? It's likely to have Python or Java which can make life easier for extracting data.

On Python 2.5 we can use the `with` statetement by importing it from `future`:

```
from __future__ import with_statement

import csv
import MySQLdb
```

The `csv` module didn't get `DictWriter` until 2.6 so we can't use that:


```
    with open('countries.csv', 'w') as csvfile:
        fieldnames = ['id', 'country_name']
        writer = csv.writer(csvfile)
        countries = get_all_countries(conn, 'cmpm_country')
        print(type(countries))
        writer.writerows(countries)
```


#### Operating systems
`readdir` on solaris sorts it's responses and `readdir` on Linux does not.
