#!/bin/bash

# Studio Webux @ 2022

source config.sh

json=$(echo '{"accounts": []}' | jq '.')

fetchVpcs(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-vpcs \
        --query "Vpcs[].{CidrBlock: CidrBlock, State: State, VpcId: VpcId, OwnerId: OwnerId, IsDefault: IsDefault, CidrBlockAssociationSet: CidrBlockAssociationSet[].{CidrBlock: CidrBlock} }" \
        | jq -r '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .vpc += [$RESPONSE]')
    done
    echo $json
}

fetchSubnets(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-subnets \
        --query "Subnets[].{AvailabilityZone: AvailabilityZone, CidrBlock: CidrBlock, State: State, SubnetId: SubnetId, VpcId: VpcId, OwnerId: OwnerId, SubnetArn: SubnetArn}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .subnet += [$RESPONSE]')
    done
    echo $json
}

fetchInternetGateways(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-internet-gateways \
        --query "InternetGateways[].{Attachments: Attachments, InternetGatewayId: InternetGatewayId, OwnerId: OwnerId}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .internet_gateway += [$RESPONSE]')
    done
    echo $json
}

fetchRouteTables(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-route-tables \
        --query "RouteTables[].{Associations: Associations[].{Main: Main, RouteTableId: RouteTableId, SubnetId: SubnetId}, RouteTableId: RouteTableId, Routes: Routes[].{DestinationCidrBlock: DestinationCidrBlock, GatewayId: GatewayId, State: State}, VpcId: VpcId, OwnerId: OwnerId}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .route_table += [$RESPONSE]')
    done
    echo $json
}

fetchSecurityGroups(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-security-groups \
        --query "SecurityGroups[]" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .security_group += [$RESPONSE]')
    done
    echo $json
}


fetchNatGateways(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-nat-gateways \
        --query "NatGateways[].{NatGatewayAddresses: NatGatewayAddresses[0].{NetworkInterfaceId: NetworkInterfaceId, PrivateIp: PrivateIp, PublicIp: PublicIp}, NatGatewayId: NatGatewayId, State: State, SubnetId: SubnetId, VpcId: VpcId}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .nat_gateway += [$RESPONSE]')
    done
    echo $json
}

fetchTransitGateways(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-transit-gateways \
        --query "TransitGateways[].{TransitGatewayId: TransitGatewayId, TransitGatewayArn: TransitGatewayArn, State: State, OwnerId: OwnerId, Description: Description, AmazonSideAsn: Options.AmazonSideAsn, AssociationDefaultRouteTableId: Options.AssociationDefaultRouteTableId, PropagationDefaultRouteTableId: Options.PropagationDefaultRouteTableId, DnsSupport: Options.DnsSupport}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .transit_gateway += [$RESPONSE]')
    done
    echo $json
}


fetchTransitGatewayRouteTables(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-transit-gateway-route-tables \
        --query "TransitGatewayRouteTables[].{TransitGatewayId: TransitGatewayId, TransitGatewayRouteTableId: TransitGatewayRouteTableId, State: State}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .transit_gateway_route_table += [$RESPONSE]')
    done
    echo $json
}


fetchTransitGatewayAttachments(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-transit-gateway-attachments \
        --query "TransitGatewayAttachments[].{TransitGatewayAttachmentId: TransitGatewayAttachmentId, TransitGatewayId: TransitGatewayId, ResourceType: ResourceType, ResourceId: ResourceId, State: State, Association: Association.{TransitGatewayRouteTableId: TransitGatewayRouteTableId}}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .transit_gateway_attachments += [$RESPONSE]')
    done
    echo $json
}


fetchTransitGatewayPeeringAttachments(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-transit-gateway-peering-attachments \
        --query "TransitGatewayPeeringAttachments[].{TransitGatewayAttachmentId: TransitGatewayAttachmentId, RequesterTgwInfo: RequesterTgwInfo, AccepterTgwInfo: AccepterTgwInfo, State: State}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .transit_gateway_peering_attachments += [$RESPONSE]')
    done
    echo $json
}


fetchTransitGatewayVpcAttachments(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-transit-gateway-vpc-attachments \
        --query "TransitGatewayVpcAttachments[].{TransitGatewayAttachmentId: TransitGatewayAttachmentId, TransitGatewayId: TransitGatewayId, VpcId: VpcId, VpcOwnerId: VpcOwnerId, State: State, SubnetIds: SubnetIds}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .transit_gateway_vpc_attachments += [$RESPONSE]')
    done
    echo $json
}


fetchNetworkInterfaces(){
    json=$1
    accountId=$2
    region=$3

    response=$(aws ec2 describe-network-interfaces \
        --query "NetworkInterfaces[].{Association: Association, Attachment: Attachment, AvailabilityZone: AvailabilityZone, Description: Description, Groups: Groups, NetworkInterfaceId: NetworkInterfaceId, OwnerId: OwnerId, PrivateIpAddress: PrivateIpAddress, PrivateIpAddresses: PrivateIpAddresses, SubnetId: SubnetId, Status: Status, VpcId: VpcId}" \
        | jq '.')

    for item in $(echo $response | jq -r '.[] | @base64'); do
        _jq() {
            echo ${item} | base64 --decode | jq -r ${1}
        }
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" --argjson RESPONSE "$(echo $(_jq '.'))" \
            '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)]
            .regions[.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions|map(.id == $REGION) | index(true)]
            .network_interfaces += [$RESPONSE]')
    done
    echo $json
}




for profile in "${profiles[@]}"; do
    echo "$profile"
    export AWS_PROFILE="$profile"
    accountId=$(aws sts get-caller-identity --query "Account" --output text)
    echo "#$accountId"
    json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" '.accounts += [{"id": $ACCOUNTID, "regions": []}]')
    for region in "${regions[@]}"; do
        echo ">$region"
        export AWS_REGION="$region"
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions += [{"id": $REGION, "route_tables": [], "vpc": [], "subnet": [], "internet_gateway": [], "security_group": [], "nat_gateway": []}]')
        
        echo "Fetch Vpcs"
        json="$(fetchVpcs "$json" "$accountId" "$region")"
        
        echo "Fetch Subnets"
        json="$(fetchSubnets "$json" "$accountId" "$region")"
        
        echo "Fetch Internet Gateways"
        json="$(fetchInternetGateways "$json" "$accountId" "$region")"
        
        echo "Fetch Route Tables"
        json="$(fetchRouteTables "$json" "$accountId" "$region")"
        
        echo "Fetch Security Groups"
        json="$(fetchSecurityGroups "$json" "$accountId" "$region")"
        
        echo "Fetch Nat Gateways"
        json="$(fetchNatGateways "$json" "$accountId" "$region")"
        
        echo "Fetch Transit Gateways"
        json="$(fetchTransitGateways "$json" "$accountId" "$region")"
        
        echo "Fetch Transit Gateway Route Tables"
        json="$(fetchTransitGatewayRouteTables "$json" "$accountId" "$region")"
        
        echo "Fetch Transit Gateway Route Tables Attachments"
        json="$(fetchTransitGatewayAttachments "$json" "$accountId" "$region")"
        
        echo "Fetch Transit Gateway Peering Attachments"
        json="$(fetchTransitGatewayPeeringAttachments "$json" "$accountId" "$region")"
        
        echo "Fetch Transit Gateway VPC Attachments"
        json="$(fetchTransitGatewayVpcAttachments "$json" "$accountId" "$region")"

        echo "Fetch Network Interfaces"
        json="$(fetchNetworkInterfaces "$json" "$accountId" "$region")"

        
    done
done

echo $json | jq '.' > network.json
