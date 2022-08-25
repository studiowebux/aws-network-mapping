const data = require("./network.json");

const PAGE_PADDING = 100;
const PADDING = 50;
const SMALL_PADDING = 20;
const REGION_WIDTH = 600;
const REGION_HEIGHT = 800;

const VPC_WIDTH = 500;
const VPC_HEIGHT = 700;

const SUBNET_WIDTH = 220;
const SUBNET_HEIGHT = 250;

const accountCount = data.accounts.length;
const regionCount = Math.max(
  ...data.accounts.map((account) => account.regions.length)
);
const vpcCount = Math.max(
  ...data.accounts.flatMap((account) =>
    account.regions.map((region) => region.vpc.length)
  )
);

const vpcHeight =
  //   VPC_HEIGHT +
  Math.ceil(
    Math.max(
      ...data.accounts.flatMap((account) =>
        account.regions.map((region) => region.subnet.length)
      )
    ) / 2
  ) *
    SUBNET_HEIGHT +
  Math.ceil(
    Math.max(
      ...data.accounts.flatMap((account) =>
        account.regions.map((region) => region.subnet.length)
      )
    )
  ) *
    SMALL_PADDING;

const accountWidth = regionCount * REGION_WIDTH + regionCount * PADDING;
const accountHeight = 3 * PADDING + vpcHeight * vpcCount;

const regionWidth = REGION_WIDTH;
const regionHeight = vpcCount * vpcHeight + 3 * PADDING;

const pageWidth = accountWidth * accountCount + PAGE_PADDING;
const pageHeight = accountHeight;

console.log(
  `accountWidth = ${accountWidth} / accountHeight = ${accountHeight}`
);
console.log(`pageWidth = ${pageWidth} / pageHeight = ${pageHeight}`);

const header = `<mxGraphModel dx="${pageWidth * 3}" dy="${
  pageHeight * 3
}" grid="0" gridSize="10" guides="0" tooltips="1" connect="0" arrows="0" fold="0" page="0" pageScale="0.2" pageWidth="${pageWidth}" pageHeight="${pageHeight}" math="0" shadow="0">
<root>
  <mxCell id="0" />
  <mxCell id="1" 
          parent="0" />`;
const footer = `</root>
</mxGraphModel>`;

let content = ``;

let x = 0;
data.accounts.forEach((account) => {
  content += `<mxCell id="account_${account.id}" 
    value="AWS Account ${account.id}" 
    style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=16;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_account;strokeColor=#CD2264;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#CD2264;dashed=0;strokeWidth=3;shadow=0;" 
    vertex="1" 
    parent="1">
  <mxGeometry x="${x}" y="0"  width="${accountWidth + 2 * PADDING}" height="${
    accountHeight + 2 * PADDING
  }" as="geometry" />
</mxCell>`;

  let xr = PADDING;
  account.regions.forEach((region) => {
    content += `<mxCell id="account_${account.id}_${region.id.replace(
      /-/g,
      "_"
    )}" 
                value="Region ${region.id}" 
                style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=16;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_region;strokeColor=#147EBA;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#147EBA;dashed=1;shadow=0;strokeWidth=3;" 
                vertex="1" 
                parent="account_${account.id}">
            <mxGeometry x="${xr}" y="${PADDING}"  width="${regionWidth}" height="${regionHeight}" as="geometry" />
            </mxCell>`;

    xr += REGION_WIDTH + 2 * PADDING;

    let xv = PADDING,
      yv = PADDING;
    region.vpc.forEach((vpc) => {
      content += `
        <mxCell id="account_${account.id}_${region.id.replace(
        /-/g,
        "_"
      )}_${vpc.VpcId.replace(/-/g, "_")}" value="VPC ${
        vpc.VpcId
      }" style="points=[[0,0],[0.25,0],[0.5,0],[0.75,0],[1,0],[1,0.25],[1,0.5],[1,0.75],[1,1],[0.75,1],[0.5,1],[0.25,1],[0,1],[0,0.75],[0,0.5],[0,0.25]];outlineConnect=0;gradientColor=none;html=1;whiteSpace=wrap;fontSize=16;fontStyle=0;container=1;pointerEvents=0;collapsible=0;recursiveResize=0;shape=mxgraph.aws4.group;grIcon=mxgraph.aws4.group_vpc;strokeColor=#248814;fillColor=none;verticalAlign=top;align=left;spacingLeft=30;fontColor=#AAB7B8;dashed=0;shadow=0;strokeWidth=3;"
        vertex="1" 
        parent="account_${account.id}_${region.id.replace(/-/g, "_")}">
          <mxGeometry x="${xv}" y="${yv}" width="${VPC_WIDTH}" height="${vpcHeight}" as="geometry" />
        </mxCell>`;

      yv += vpcHeight + PADDING;

      //   Internet Gateway
      const igw = region.internet_gateway.filter(
        (igw) => igw.Attachments[0].VpcId === vpc.VpcId
      );
      if (igw && igw.length > 0) {
        content += `<UserObject label="" tooltip="${
          igw[0].InternetGatewayId
        }" id="account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${vpc.VpcId.replace(/-/g, "_")}_${igw[0].InternetGatewayId.replace(
          /-/g,
          "_"
        )}">
          <mxCell 
    style="sketch=0;outlineConnect=0;fontColor=#232F3E;gradientColor=none;fillColor=#4D27AA;strokeColor=none;dashed=0;verticalLabelPosition=bottom;verticalAlign=top;align=center;html=1;fontSize=12;fontStyle=0;aspect=fixed;pointerEvents=1;shape=mxgraph.aws4.internet_gateway;shadow=0;" 
    vertex="1" 
    parent="account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${vpc.VpcId.replace(/-/g, "_")}">
    <mxGeometry x="${
      VPC_WIDTH - 50
    }" y="5" width="45" height="45" as="geometry" />
  </mxCell>
    </UserObject>`;
      }

      let xs = SMALL_PADDING,
        ys = PADDING;
      region.subnet.forEach((subnet, idx) => {
        if (idx !== 0 && idx % 2 === 0) {
          ys += SUBNET_HEIGHT + SMALL_PADDING;
          xs = SMALL_PADDING;
        }
        content += `<mxCell id="account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${vpc.VpcId.replace(/-/g, "_")}_${subnet.SubnetId.replace(
          /-/g,
          "_"
        )}" value="Subnet ${subnet.SubnetId}"
        style="fillColor=none;strokeColor=#5A6C86;dashed=1;verticalAlign=top;fontStyle=0;fontColor=#5A6C86;shadow=0;strokeWidth=3;fontSize=10;" 
        vertex="1" 
        parent="account_${account.id}_${region.id.replace(
          /-/g,
          "_"
        )}_${vpc.VpcId.replace(/-/g, "_")}">
        <mxGeometry x="${xs}" y="${ys}" width="${SUBNET_WIDTH}" height="${SUBNET_HEIGHT}" as="geometry" />
      </mxCell>`;

        xs += SUBNET_WIDTH + SMALL_PADDING;
      });
    });
  });

  x += accountWidth + 4 * PADDING;
});

console.log(header);
console.log(content);
console.log(footer);
