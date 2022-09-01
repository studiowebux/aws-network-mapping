#!/bin/bash

# Studio Webux @ 2022

# tryeraser implementation tryeraser.com

echo "" > diagram.txt

accountId(){
    el=$1

    echo "account_$(echo $el | jq -r '.id') {" >> diagram.txt
    echo "  account_id number $(echo $el | jq -r '.id')" >> diagram.txt
    echo "}" >> diagram.txt
}

region(){
    elr=$1

    echo "region_$(echo $elr | jq -r '.id' | sed 's/-/_/g') {" >> diagram.txt
    echo "  region number $(echo $el | jq -r '.id')" >> diagram.txt
    echo "}" >> diagram.txt
}

vpcs(){
    elr=$1
    el=$2
    for vpc in $(echo "$elr" | jq -r '.vpc' | jq -r '.[] | @base64'); do
        _jq() {
            echo ${vpc} | base64 --decode | jq -r ${1}
        }

        el_vpc=$(echo "$(_jq '.')")
        # echo "account_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g')_$(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g') {" >> diagram.txt
        echo "$(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g') {" >> diagram.txt
        echo "  account_id number $(echo $el | jq -r '.id')" >> diagram.txt
        echo "  region string $(echo $elr | jq -r '.id' | sed 's/-/_/g')" >> diagram.txt
        echo "  cidr string $(echo $el_vpc | jq -r '.CidrBlock')" >> diagram.txt
        echo "  vpc_id string $(echo $el_vpc | jq -r '.VpcId')" >> diagram.txt
        echo "  state string $(echo $el_vpc | jq -r '.State')" >> diagram.txt
        echo "  owner_id number $(echo $el_vpc | jq -r '.OwnerId')" >> diagram.txt
        echo "  default boolean $(echo $el_vpc | jq -r '.IsDefault')" >> diagram.txt
        echo "}" >> diagram.txt

        # Relations
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g').account_id" >> diagram.txt
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g').owner_id" >> diagram.txt
        echo "region_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - $(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g').region" >> diagram.txt

    done
}


subnets(){
    elr=$1
    el=$2
    for subnet in $(echo "$elr" | jq -r '.subnet' | jq -r '.[] | @base64'); do
        _jq() {
            echo ${subnet} | base64 --decode | jq -r ${1}
        }

        el_subnet=$(echo "$(_jq '.')")
        # echo "account_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g')_$(echo $el_subnet | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g') {" >> diagram.txt
        echo "$(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g') {" >> diagram.txt
        echo "  account_id number $(echo $el | jq -r '.id')" >> diagram.txt
        echo "  region string $(echo $elr | jq -r '.id' | sed 's/-/_/g')" >> diagram.txt
        echo "  cidr string $(echo $el_subnet | jq -r '.CidrBlock')" >> diagram.txt
        echo "  vpc_id string $(echo $el_subnet | jq -r '.VpcId')" >> diagram.txt
        echo "  state string $(echo $el_subnet | jq -r '.State')" >> diagram.txt
        echo "  owner_id number $(echo $el_subnet | jq -r '.OwnerId')" >> diagram.txt
        echo "  availability_zone string $(echo $el_subnet | jq -r '.AvailabilityZone')" >> diagram.txt
        echo "  subnet_id string $(echo $el_subnet | jq -r '.SubnetId')" >> diagram.txt
        echo "}" >> diagram.txt

        # Relations
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g').account_id" >> diagram.txt
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g').owner_id" >> diagram.txt
        echo "region_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - $(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g').region" >> diagram.txt
        echo "vpc_$(echo $el_subnet | jq -r '.VpcId' | sed 's/-/_/g').vpc_id - $(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g').vpc_id" >> diagram.txt

    done
}

internetGateways(){
    elr=$1
    el=$2
    for igw in $(echo "$elr" | jq -r '.internet_gateway' | jq -r '.[] | @base64'); do
        _jq() {
            echo ${igw} | base64 --decode | jq -r ${1}
        }

        el_igw=$(echo "$(_jq '.')")
        # echo "account_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g')_$(echo $el_subnet | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g') {" >> diagram.txt
        echo "$(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g') {" >> diagram.txt
        echo "  account_id number $(echo $el | jq -r '.id')" >> diagram.txt
        echo "  region string $(echo $elr | jq -r '.id' | sed 's/-/_/g')" >> diagram.txt
        echo "  vpc_id string $(echo $el_igw | jq -r '.Attachments[0].VpcId')" >> diagram.txt
        echo "  state string $(echo $el_igw | jq -r '.Attachments[0].State')" >> diagram.txt
        echo "  owner_id number $(echo $el_igw | jq -r '.OwnerId')" >> diagram.txt
        echo "  internet_gateway_id number $(echo $el_igw | jq -r '.InternetGatewayId')" >> diagram.txt
        
        echo "}" >> diagram.txt

        # Relations
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g').account_id" >> diagram.txt
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g').owner_id" >> diagram.txt
        echo "region_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - $(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g').region" >> diagram.txt
        echo "vpc_$(echo $el_igw | jq -r '.Attachments[0].VpcId' | sed 's/-/_/g').vpc_id - $(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g').vpc_id" >> diagram.txt

    done
}


securityGroups(){
    elr=$1
    el=$2
    for sg in $(echo "$elr" | jq -r '.security_group' | jq -r '.[] | @base64'); do
        _jq() {
            echo ${sg} | base64 --decode | jq -r ${1}
        }

        el_sg=$(echo "$(_jq '.')")
        # echo "account_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g')_$(echo $el_subnet | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g') {" >> diagram.txt
        echo "$(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g') {" >> diagram.txt
        echo "  account_id number $(echo $el | jq -r '.id')" >> diagram.txt
        echo "  region string $(echo $elr | jq -r '.id' | sed 's/-/_/g')" >> diagram.txt
        echo "  vpc_id string $(echo $el_sg | jq -r '.VpcId')" >> diagram.txt
        echo "  owner_id number $(echo $el_sg | jq -r '.OwnerId')" >> diagram.txt
        echo "  group_id number $(echo $el_sg | jq -r '.GroupId')" >> diagram.txt
        echo "  description string $(echo $el_sg | jq -r '.Description')" >> diagram.txt
        echo "  group_name string $(echo $el_sg | jq -r '.GroupName')" >> diagram.txt
        # TODO: Ingress
        # TODO: Egress
        echo "}" >> diagram.txt

        # Relations
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g').account_id" >> diagram.txt
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g').owner_id" >> diagram.txt
        echo "region_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - $(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g').region" >> diagram.txt
        echo "vpc_$(echo $el_sg | jq -r '.VpcId' | sed 's/-/_/g').vpc_id - $(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g').vpc_id" >> diagram.txt

    done
}

routeTables(){
    elr=$1
    el=$2
    for rtb in $(echo "$elr" | jq -r '.route_table' | jq -r '.[] | @base64'); do
        _jq() {
            echo ${rtb} | base64 --decode | jq -r ${1}
        }

        el_rtb=$(echo "$(_jq '.')")
        # echo "account_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g')_$(echo $el_subnet | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g') {" >> diagram.txt
        echo "$(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g') {" >> diagram.txt
        echo "  account_id number $(echo $el | jq -r '.id')" >> diagram.txt
        echo "  region string $(echo $elr | jq -r '.id' | sed 's/-/_/g')" >> diagram.txt
        echo "  vpc_id string $(echo $el_rtb | jq -r '.VpcId')" >> diagram.txt
        echo "  owner_id number $(echo $el_rtb | jq -r '.OwnerId')" >> diagram.txt
        echo "  route_table_id string $(echo $el_rtb | jq -r '.RouteTableId')" >> diagram.txt
        echo "  main boolean $(echo $el_rtb | jq -r '.Associations[0].Main')" >> diagram.txt
        # TODO: Routes
        echo "}" >> diagram.txt

        # Relations
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g').account_id" >> diagram.txt
        echo "account_$(echo $el | jq -r '.id').account_id - $(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g').owner_id" >> diagram.txt
        echo "region_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - $(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g').region" >> diagram.txt
        echo "vpc_$(echo $el_rtb | jq -r '.VpcId' | sed 's/-/_/g').vpc_id - $(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g').vpc_id" >> diagram.txt
        # TODO: Routes Associations
    done
}

for item in $(cat network.json | jq '.accounts' | jq -r '.[] | @base64'); do
    _jq() {
        echo ${item} | base64 --decode | jq -r ${1}
    }

    el=$(echo "$(_jq '.')")
    accountId "$el"

    for region in $(echo "$el" | jq -r '.regions' | jq -r '.[] | @base64'); do
        _jq() {
            echo ${region} | base64 --decode | jq -r ${1}
        }

        elr=$(echo "$(_jq '.')")

        region "$elr"
        vpcs "$elr" "$el"
        subnets "$elr" "$el"
        internetGateways "$elr" "$el"
        securityGroups "$elr" "$el"
        routeTables "$elr" "$el"

    done

done

# cat diagram.txt
