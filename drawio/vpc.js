function generateItem({
  parentId,
  itemId,
  width,
  height,
  lineOne,
  lineTwo,
  lineThree,
  y,
}) {
  return `<mxCell id="${itemId}" value="${lineOne}&#xa;${lineTwo}&#xa;${lineThree}" style="text;align=left;verticalAlign=middle;spacingLeft=4;spacingRight=4;overflow=hidden;points=[[0,0.5],[1,0.5]];portConstraint=eastwest;rotatable=0;"
    vertex="1"
    parent="${parentId}">
    <mxGeometry y="${y}" width="${width}" height="${height}" as="geometry" />
  </mxCell>
`;
}

module.exports = {
  generateVpc: ({
    title,
    subtitle,
    information,
    items,
    id,
    width,
    height,
    x,
    y,
  }) => {
    console.log("y", y, "height", height);
    let content = `<mxCell
            id="${id}"
            value="${title}&#xa;${subtitle}&#xa;${information}"
            style="swimlane;fontStyle=0;childLayout=stackLayout;horizontal=1;startSize=60;horizontalStack=0;resizeParent=1;resizeParentMax=0;resizeLast=0;collapsible=1;marginBottom=0;"
            vertex="1"
            parent="1"
            collapsed="1">
        <mxGeometry x="${x}" y="${y}" width="${width}" height="60" as="geometry">
          <mxRectangle x="${x}" y="${y}" width="${width}" height="${height}" as="alternateBounds" />
        </mxGeometry>
      </mxCell>
      `;

    items.forEach((item, idx) => {
      content += generateItem({
        parentId: id,
        itemId: `${item.SubnetId}_${id}_${idx}`,
        width,
        height: 50,
        lineOne: item.SubnetId,
        lineTwo: item.AvailabilityZone,
        lineThree: item.CidrBlock,
        y: 60 + idx * 50,
      });
    });

    return content;
  },
};
