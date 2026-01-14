# readRDS operator

##### Description
`readRDS` operator imports rdsdata files

##### Usage

Input projection|.
---|---
`documentId`        | Document ID of the RDS file

Output relations|.
---|---
a tercen table   | tableid, for every tablid there is a documentid relation 

##### Details

The operator takes the documentIds (i.e. the RDS data file) and converts them to a tercen table.

#### References

see the `readRDS()` function in base R.

##### See Also

[readxls_operator](https://github.com/tercen/readxls_operator)
#### Examples
