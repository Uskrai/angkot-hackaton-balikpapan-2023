import { createBrowserRouter, RouterProvider } from "react-router-dom";
import FormComponent from "./Form";
import "./index.css";
import RouteIndex from "./RouteIndex";
import LoginForm from "./Login";
import RouteEdit from "./RouteEdit";

export default function App() {
  const router = createBrowserRouter([
    {
      path: "/route/create",
      element: <FormComponent />,
    },
    {
      path: "/route",
      element: <RouteIndex />,
    },
    {
      path: "/route/:id/edit",
      element: <RouteEdit />,
    },
    {
      path: "/login",
      element: <LoginForm />,
    },
  ]);

  return <RouterProvider router={router}></RouterProvider>;
}
