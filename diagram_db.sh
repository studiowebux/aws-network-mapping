#!/bin/bash

# Studio Webux @ 2022

echo "" > diagram.txt

accountId(){
    el=$1

    echo "Table account_$(echo $el | jq -r '.id') {" >> diagram.txt
    echo "  account_id \"$(echo $el | jq -r '.id')\"" >> diagram.txt
    echo "}" >> diagram.txt
}

region(){
    elr=$1

    echo "Table region_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g') {" >> diagram.txt
    echo "  region \"$(echo $el | jq -r '.id')\"" >> diagram.txt
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
        echo "Table vpc_$(echo $el | jq -r '.id')_$(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g') {" >> diagram.txt
        echo "  account_id \"$(echo $el | jq -r '.id')\"" >> diagram.txt
        echo "  region \"$(echo $elr | jq -r '.id' | sed 's/-/_/g')\"" >> diagram.txt
        echo "  cidr \"$(echo $el_vpc | jq -r '.CidrBlock')\"" >> diagram.txt
        echo "  vpc_id \"$(echo $el_vpc | jq -r '.VpcId')\"" >> diagram.txt
        echo "  state \"$(echo $el_vpc | jq -r '.State')\"" >> diagram.txt
        echo "  owner_id \"$(echo $el_vpc | jq -r '.OwnerId')\"" >> diagram.txt
        echo "  default \"$(echo $el_vpc | jq -r '.IsDefault')\"" >> diagram.txt
        echo "}" >> diagram.txt

        # Relations
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - vpc_$(echo $el | jq -r '.id')_$(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g').account_id" >> diagram.txt
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - vpc_$(echo $el | jq -r '.id')_$(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g').owner_id" >> diagram.txt
        echo "Ref: region_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - vpc_$(echo $el | jq -r '.id')_$(echo $el_vpc | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g').region" >> diagram.txt

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
        echo "Table subnet_$(echo $el | jq -r '.id')_$(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g' | sed 's/subnet_//g') {" >> diagram.txt
        echo "  account_id \"$(echo $el | jq -r '.id')\"" >> diagram.txt
        echo "  region \"$(echo $elr | jq -r '.id' | sed 's/-/_/g')\"" >> diagram.txt
        echo "  cidr \"$(echo $el_subnet | jq -r '.CidrBlock')\"" >> diagram.txt
        echo "  vpc_id \"$(echo $el_subnet | jq -r '.VpcId')\"" >> diagram.txt
        echo "  state \"$(echo $el_subnet | jq -r '.State')\"" >> diagram.txt
        echo "  owner_id \"$(echo $el_subnet | jq -r '.OwnerId')\"" >> diagram.txt
        echo "  availability_zone \"$(echo $el_subnet | jq -r '.AvailabilityZone')\"" >> diagram.txt
        echo "  subnet_id \"$(echo $el_subnet | jq -r '.SubnetId')\"" >> diagram.txt
        echo "}" >> diagram.txt

        # Relations
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - subnet_$(echo $el | jq -r '.id')_$(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g' | sed 's/subnet_//g').account_id" >> diagram.txt
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - subnet_$(echo $el | jq -r '.id')_$(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g' | sed 's/subnet_//g').owner_id" >> diagram.txt
        echo "Ref: region_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - subnet_$(echo $el | jq -r '.id')_$(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g' | sed 's/subnet_//g').region" >> diagram.txt
        echo "Ref: vpc_$(echo $el | jq -r '.id')_$(echo $el_subnet | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g').vpc_id - subnet_$(echo $el | jq -r '.id')_$(echo $el_subnet | jq -r '.SubnetId' | sed 's/-/_/g' | sed 's/subnet_//g').vpc_id" >> diagram.txt

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
        echo "Table igw_$(echo $el | jq -r '.id')_$(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g' | sed 's/igw_//g') {" >> diagram.txt
        echo "  account_id \"$(echo $el | jq -r '.id')\"" >> diagram.txt
        echo "  region \"$(echo $elr | jq -r '.id' | sed 's/-/_/g')\"" >> diagram.txt
        echo "  vpc_id \"$(echo $el_igw | jq -r '.Attachments[0].VpcId')\"" >> diagram.txt
        echo "  state \"$(echo $el_igw | jq -r '.Attachments[0].State')\"" >> diagram.txt
        echo "  owner_id \"$(echo $el_igw | jq -r '.OwnerId')\"" >> diagram.txt
        echo "  internet_gateway_id \"$(echo $el_igw | jq -r '.InternetGatewayId')\"" >> diagram.txt
        
        echo "}" >> diagram.txt

        # Relations
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - igw_$(echo $el | jq -r '.id')_$(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g' | sed 's/igw_//g').account_id" >> diagram.txt
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - igw_$(echo $el | jq -r '.id')_$(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g' | sed 's/igw_//g').owner_id" >> diagram.txt
        echo "Ref: region_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - igw_$(echo $el | jq -r '.id')_$(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g' | sed 's/igw_//g').region" >> diagram.txt
        echo "Ref: vpc_$(echo $el | jq -r '.id')_$(echo $el_igw | jq -r '.Attachments[0].VpcId' | sed 's/-/_/g' | sed 's/vpc_//g').vpc_id - igw_$(echo $el | jq -r '.id')_$(echo $el_igw | jq -r '.InternetGatewayId' | sed 's/-/_/g' | sed 's/igw_//g').vpc_id" >> diagram.txt

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
        echo "Table sg_$(echo $el | jq -r '.id')_$(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g' | sed 's/sg_//g') {" >> diagram.txt
        echo "  account_id \"$(echo $el | jq -r '.id')\"" >> diagram.txt
        echo "  region \"$(echo $elr | jq -r '.id' | sed 's/-/_/g')\"" >> diagram.txt
        echo "  vpc_id \"$(echo $el_sg | jq -r '.VpcId')\"" >> diagram.txt
        echo "  owner_id \"$(echo $el_sg | jq -r '.OwnerId')\"" >> diagram.txt
        echo "  group_id \"$(echo $el_sg | jq -r '.GroupId')\"" >> diagram.txt
        echo "  description \"$(echo $el_sg | jq -r '.Description')\"" >> diagram.txt
        echo "  group_name \"$(echo $el_sg | jq -r '.GroupName')\"" >> diagram.txt
        # TODO: Ingress
        # TODO: Egress
        echo "}" >> diagram.txt

        # Relations
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - sg_$(echo $el | jq -r '.id')_$(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g' | sed 's/sg_//g').account_id" >> diagram.txt
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - sg_$(echo $el | jq -r '.id')_$(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g' | sed 's/sg_//g').owner_id" >> diagram.txt
        echo "Ref: region_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - sg_$(echo $el | jq -r '.id')_$(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g' | sed 's/sg_//g').region" >> diagram.txt
        echo "Ref: vpc_$(echo $el | jq -r '.id')_$(echo $el_sg | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g').vpc_id - sg_$(echo $el | jq -r '.id')_$(echo $el_sg | jq -r '.GroupId' | sed 's/-/_/g' | sed 's/sg_//g').vpc_id" >> diagram.txt

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
        echo "Table rtb_$(echo $el | jq -r '.id')_$(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g' | sed 's/rtb_//g') {" >> diagram.txt
        echo "  account_id \"$(echo $el | jq -r '.id')\"" >> diagram.txt
        echo "  region \"$(echo $elr | jq -r '.id' | sed 's/-/_/g')\"" >> diagram.txt
        echo "  vpc_id \"$(echo $el_rtb | jq -r '.VpcId')\"" >> diagram.txt
        echo "  owner_id \"$(echo $el_rtb | jq -r '.OwnerId')\"" >> diagram.txt
        echo "  route_table_id \"$(echo $el_rtb | jq -r '.RouteTableId')\"" >> diagram.txt
        echo "  main \"$(echo $el_rtb | jq -r '.Associations[0].Main')\"" >> diagram.txt
        # TODO: Routes
        echo "}" >> diagram.txt

        # Relations
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - rtb_$(echo $el | jq -r '.id')_$(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g' | sed 's/rtb_//g').account_id" >> diagram.txt
        echo "Ref: account_$(echo $el | jq -r '.id').account_id - rtb_$(echo $el | jq -r '.id')_$(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g' | sed 's/rtb_//g').owner_id" >> diagram.txt
        echo "Ref: region_$(echo $el | jq -r '.id')_$(echo $elr | jq -r '.id' | sed 's/-/_/g').region - rtb_$(echo $el | jq -r '.id')_$(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g' | sed 's/rtb_//g').region" >> diagram.txt
        echo "Ref: vpc_$(echo $el | jq -r '.id')_$(echo $el_rtb | jq -r '.VpcId' | sed 's/-/_/g' | sed 's/vpc_//g').vpc_id - rtb_$(echo $el | jq -r '.id')_$(echo $el_rtb | jq -r '.RouteTableId' | sed 's/-/_/g' | sed 's/rtb_//g').vpc_id" >> diagram.txt
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
