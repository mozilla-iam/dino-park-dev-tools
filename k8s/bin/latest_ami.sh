#!/usr/bin/env bash
aws ec2 describe-images \
--owners amazon \
--filters \
'Name=name,Values=amzn2-ami-hvm-????.??.?.????????-x86_64-gp2' \
'Name=state,Values=available' \
'Name=architecture,Values=x86_64' \
'Name=virtualization-type,Values=hvm' \
'Name=root-device-type,Values=ebs' \
--query 'sort_by(Images, &CreationDate)[-1].ImageId'