### Initial Discussion

The three of us initially started our discussion by debating a few different areas of interest. We spoke about possible geological, biological, sociological data sets. Considering the fact that we have to tell a story with the exploration of our data, we felt that sociological data was the way to go.

### Honing in on a Dataset

We decided on a California Schools data set which included three different tables.

These three tables are named schools, satscores, and frpm where fprm stands for free reduced price meals.

We felt that this would a good way of investigating how students who recieve free or reduced lunches perform on standardized tests. This could be an interesting story to see the disparities in poverty and educational achievement.


### Creating our tables

Based on what we learned in class in conjunction with what information the website provided, we decided on the columns data types. Most were varchar, a few numeric fields and a few date fields.


### Dataset issues

Initially we were a bit confused because the California Education website indicated that a column by the name of CDS existed within the fprm table. Once we downloaded the data, we saw that no such code existed in this table, which was a problem. This code was the only common link between the other two, and without it, we would need to find a composite key.

With some deeper checking we actually found that CDS stood for County District School code. In our fprm table we had three columns, for county code, district code, and school code. This meant we could combine the three columns to form the single CDS code we needed.

### Choosing Keys

We concatinated the three columns in fprm above as a varchar and renamed the column so that it matched the cds code column in the schools and satscores table. We set the primary key for each of the three tables to this value, since it satisfied the cardinality tests we ran against it.

We checked for the distinct count of the cds column for each table and it matched the total count of the rows. This meant for the three tables we were able to set cds column as the primary key.


### Exploring the data set




