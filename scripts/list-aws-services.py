import skew # pip install skew

show_ec2 = False
show_s3 = False
show_ebs = True

if show_ec2:
    print '# --- EC2 Instances --- '
    for instance in skew.scan('arn:aws:ec2:*:*:instance/*'):
        name = 'Unnamed'
        for tag in instance.data['Tags']:
            if (tag['Key'] == 'Name'):
                name = tag['Value']
        try:
            if (instance.data['State']['Name'] == 'running'):
                print '- ', instance.id, name, 'running'
                print ('   - %s (%s)' % (instance.data['PublicDnsName'], instance.data['PublicIpAddress']))
                print ('   - Launched %s by %s' % (instance.data['LaunchTime'], instance.data['KeyName']))
                print('   - %s' % (instance.data['InstanceType']))
            else:
                print '- ', instance.id, name, instance.data['State']['Name']
        except KeyError:
            print instance.data

# EBS Volumes
if show_ebs:
    print '# --- EBS Volumes ---'
    for volume in skew.scan('arn:aws:ec2:*:*:volume/*'):
        print '- ', volume.id, volume.data['AvailabilityZone'], volume.data['Size'], 'gb'


if show_s3:
    print '# --- S3 Buckets ---'
    for bucket in skew.scan("arn:aws:s3:*:*:*/*"):
        print '- ', bucket.id
        print('   - %s' % (bucket.data['CreationDate']))

