module.exports = {
  generateIgw: ({
    title,
    subtitle,
    information,
    id,
    width,
    height,
    x,
    y,
  }) => {
    return `<mxCell
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
  },
};
