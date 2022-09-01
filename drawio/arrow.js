module.exports = {
  link: (source, target) => {
    return `<mxCell 
        id="link_${source}_to_${target}" 
        style="edgeStyle=orthogonalEdgeStyle;rounded=0;orthogonalLoop=1;jettySize=auto;html=1;" 
        edge="1" 
        parent="1" 
        source="${source}"
        target="${target}">
        <mxGeometry relative="1" as="geometry" />
      </mxCell>`;
  },
};
