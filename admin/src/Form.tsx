import { LatLng, LatLngExpression } from "leaflet";
import React, { useState } from "react";
import TestPlotterV2 from "./TestPlotterV2";

export default function FormComponent() {
  const [name, setName] = useState("");
  const [type, setType] = useState("");
  const [lines, setLines] = useState<LatLng[]>([]);
  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    console.log(
      lines.map((it) => ({ latitude: it.lat, longitude: it.lng })),
      lines.map((it) => it)
    );
    let body = {
      name,
      lines: lines.map((it) => {
        console.log(it);
        return {
          latitude: it.lat,
          longitude: it.lng,
        };
      }),
      type,
    };
    console.log(JSON.stringify(body));
    const response = await fetch("http://localhost:3000/api/v1/route", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(body),
    });
    const data = await response.json();
    // Update component state based on response data
  };

  return (
    <div className="">
      <form onSubmit={handleSubmit} className="p-10 ">
        <label className="">
          Name:
          <input
            type="text"
            value={name}
            onChange={(event) => setName(event.target.value)}
          />
        </label>
        <div className="" onChange={(e) => setType((e.target as any).value)}>
          <input type="radio" id="bus" name="type" value="Bus" />
          <label>Bus</label>
          <input type="radio" id="angkot" name="type" value="SharedTaxi" />
          <label>Angkot</label>
        </div>

        <button type="submit">Submit</button>
      </form>

      <TestPlotterV2
        lines={[
          [53.09897, 12.02728],
          [52.01701, 14.18884],
        ]}
        setLines={(e) => {
          setLines(e);
        }}
      />
    </div>
  );
}
