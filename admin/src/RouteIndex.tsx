import useSWR from "swr";

interface RouteModel {
  id: string;
  name: string;
  type: "Bus" | "SharedTaxi";
  lines: {
    latitude: number;
    longitude: number;
  }[];
}
export default function RouteIndex() {
  const { data, isLoading } = useSWR(
    "http://localhost:3000/api/v1/route",
    (url) => fetch(url).then((it) => it.json())
  );

  const { data: dataLogin, isLoading: isLoadingLogin } = useSWR(
    "http://localhost:3000/api/v1/route",
    (url) => fetch(url).then((it) => it.json())
  );

  if (isLoading) {
    return <div>Loading...</div>;
  } else {
    return (
      <div>
        {data.routes.map((it: RouteModel) => (
          <div key={it.id}>
            {it.name}
            <a href={`/route/${it.id}/edit`}>Edit</a>
          </div>
        ))}
      </div>
    );
  }

  return null;
}
