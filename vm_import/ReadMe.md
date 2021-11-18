procedure main page: https://docs.aws.amazon.com/vm-import/latest/userguide/vmimport-image-import.html

compatible OS list: https://docs.aws.amazon.com/vm-import/latest/userguide/vmie_prereqs.html#vmimport-operating-systems

# role creation for vmimport (done once)

```
aws iam create-role --role-name vmimport --assume-role-policy-document "file://$(pwd)/trust-policy.json"

aws iam put-role-policy --role-name vmimport --policy-name vmimport --policy-document "file://$(pwd)/role-policy.json"
```

# s3 image presign

```
aws s3 presign s3://mikesac-import/aws.ova
```


# import VM

Importing image from s3 bucket

```
aws ec2 import-image --description "Fl Import test" --disk-containers "file://$(pwd)/containers.json"
```

Checking progress (ami ID taken from previous response)

```
aws ec2 describe-import-image-tasks --import-task-ids import-ami-1234567890abcdef0
```

