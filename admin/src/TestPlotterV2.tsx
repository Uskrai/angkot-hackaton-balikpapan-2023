import DraggableLines from "leaflet-draggable-lines";
import "leaflet-geometryutil";
import {
  HighlightablePolygon,
  HighlightablePolyline,
} from "leaflet-highlightable-layers";
import L, { LatLng, LatLngExpression } from "leaflet";
import { MapContainer, useMap, TileLayer } from "react-leaflet";
import { useEffect, useState } from "react";

export function MyComponent(props: Props) {
  const map = useMap();

  useEffect(() => {
    const lines = [
      [53.09897, 12.02728],
      [52.01701, 14.18884],
    ];

    const routeLayer = new HighlightablePolyline([props.lines], {
      color: "#0000ff",
      weight: 10,
      //   draggableLinesRoutePoints: [props.lines],
    }).addTo(map);

    const draggable = new DraggableLines(map);
    draggable.enable();

    draggable.on("dragend remove insert", (e) => {
      props.setLines(e.layer.getLatLngs()[0]);
    });

    return () => {
      draggable.disable();
      routeLayer.remove();
    };
  }, [map]);

  return null;
}

interface Props {
  lines: LatLngExpression[];
  setLines: (lines: LatLng[]) => void;
}

export default function MyMapComponent(props: Props) {
  return (
    <MapContainer center={[52.483, 13.3414]} zoom={13} id="map">
      <TileLayer
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        url="https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png"
      ></TileLayer>
      <MyComponent lines={props.lines} setLines={props.setLines} />
    </MapContainer>
  );
}
