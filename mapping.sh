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
        --query "RouteTables[].{Associations: Associations[].{Main: Main, RouteTableId: RouteTableId}, RouteTableId: RouteTableId, Routes: Routes[].{DestinationCidrBlock: DestinationCidrBlock, GatewayId: GatewayId, State: State}, VpcId: VpcId, OwnerId: OwnerId}" \
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


for profile in "${profiles[@]}"; do
    echo "$profile"
    export AWS_PROFILE="$profile"
    accountId=$(aws sts get-caller-identity --query "Account" --output text)
    echo "#$accountId"
    json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" '.accounts += [{"id": $ACCOUNTID, "regions": []}]')
    for region in "${regions[@]}"; do
        echo ">$region"
        export AWS_REGION="$region"
        json=$(echo $json | jq -r --arg ACCOUNTID "$accountId" --arg REGION "$region" '.accounts[.accounts|map(.id == $ACCOUNTID) | index(true)].regions += [{"id": $REGION, "route_tables": [], "vpc": [], "subnet": [], "internet_gateway": [], "security_group": []}]')
        json="$(fetchVpcs "$json" "$accountId" "$region")"
        json="$(fetchSubnets "$json" "$accountId" "$region")"
        json="$(fetchInternetGateways "$json" "$accountId" "$region")"
        json="$(fetchRouteTables "$json" "$accountId" "$region")"
        json="$(fetchSecurityGroups "$json" "$accountId" "$region")"
    done
done

echo $json | jq '.' > network.json

# I'm too poor to have these on my personal account :/
# aws ec2 describe-nat-gateways
# aws ec2 describe-transit-gateway-attachments
# aws ec2 describe-transit-gateway-peering-attachments
# aws ec2 describe-transit-gateway-route-tables
# aws ec2 describe-transit-gateway-vpc-attachments
# aws ec2 describe-transit-gateways
# aws ec2 describe-network-interfaces
# aws ec2 describe-client-vpn-routes