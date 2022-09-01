// Studio webux @ 2022
// draw.io integration

const { link } = require("./drawio/arrow");
const { header, footer } = require("./drawio/header");
const { generateIgw } = require("./drawio/igw");
const { generateRouteTable } = require("./drawio/rtb");
const { generateVpc } = require("./drawio/vpc");
const data = require("./network.json");

let contentV2 = ``;

let accountY = 0;
let regionY = 0;
// Accounts
data.accounts.forEach((account) => {
  // Regions
  account.regions.forEach((region) => {
    // VPC
    let subnetHeight = 0;
    region.vpc.forEach((vpc, idx) => {
      const subnets = region.subnet.filter(
        (subnet) => subnet.VpcId === vpc.VpcId
      );

      subnetHeight = subnets.length * 50 + 60;

      contentV2 += generateVpc({
        title: vpc.VpcId,
        subtitle: vpc.CidrBlock,
        information: vpc.OwnerId,
        items: subnets,
        width: 300,
        height: subnetHeight,
        id: `account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${vpc.VpcId.replace(/-/g, "_")}`,
        x: 0,
        y: regionY + accountY + subnetHeight,
      });
    });

    // Route tables
    let routeTableHeight = 0;
    region.route_table.forEach((rtb, idx) => {
      routeTableHeight = rtb.Routes.length * 50 + 60;

      contentV2 += generateRouteTable({
        title: rtb.RouteTableId,
        subtitle: rtb.VpcId,
        information: rtb.OwnerId,
        items: rtb.Routes,
        width: 300,
        height: routeTableHeight,
        id: `account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${rtb.RouteTableId.replace(/-/g, "_")}`,
        x: 600,
        y: regionY + accountY + routeTableHeight,
      });

      // References
      contentV2 += link(
        `account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${rtb.VpcId.replace(/-/g, "_")}`,
        `account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${rtb.RouteTableId.replace(/-/g, "_")}`
      );
    });

    // IGW
    let internetGatewayHeight = 0;
    region.internet_gateway.forEach((igw) => {
      internetGatewayHeight = 110;

      contentV2 += generateIgw({
        title: igw.InternetGatewayId,
        subtitle: igw.Attachments[0].VpcId,
        information: igw.OwnerId,
        width: 300,
        height: internetGatewayHeight,
        id: `account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${igw.InternetGatewayId.replace(/-/g, "_")}`,
        x: 1200,
        y: regionY + accountY + internetGatewayHeight,
      });

      // References
      contentV2 += link(
        `account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${region.route_table
          .find((rtb) =>
            rtb.Routes.find((rt) => rt.GatewayId === igw.InternetGatewayId)
          )
          .RouteTableId.replace(/-/g, "_")}`,
        `account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${igw.InternetGatewayId.replace(/-/g, "_")}`
      );
    });

    // TODO: NAT

    // TODO: TGW
    // TODO: TGW Attachment
    // TODO: TGW Route Table
    // TODO: TGW Peering

    regionY += region.vpc.length * subnetHeight + 60;
  });

  accountY += regionY + 60 * 2;
  regionY = 0; // reset region to 0
});

console.log(header());
console.log(contentV2);
console.log(footer());

// ---
