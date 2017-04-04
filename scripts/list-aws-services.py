import skew # pip install skew


# EC2 Instances
'''
print '# EC2 Instances'
for instance in skew.scan('arn:aws:ec2:*:*:instance/*'):
    name = 'Unnamed'
    for tag in instance.data['Tags']:
        if (tag['Key'] == 'Name'):
            name = tag['Value']

    print instance.id, name
    print (' - %s (%s)' % (instance.data['PublicDnsName'], instance.data['PublicIpAddress']))
    print (' - Launched %s by %s' % (instance.data['LaunchTime'], instance.data['KeyName']))
    print(' - %s' % (instance.data['InstanceType']))
'''

# EBS Volumes
#for volume in skew.scan('arn:aws:ec2:*:*:volume/*')

# S3 Buckets
for bucket in skew.scan("arn:aws:s3:*:*:*/*"):
    print(bucket, bucket.data)

