import { useLocation } from "react-router-dom";

export default function JobResults() {
  const location = useLocation();
  const params = new URLSearchParams(location.search);
  const keyword = params.get("keyword") || "";

  return (
    <div style={{ textAlign: "center", marginTop: "50px" }}>
      <h1>Job Results Page</h1>
      {keyword && <p>Showing results for: <strong>{keyword}</strong></p>}
      {/* TODO: Later render job cards based on the keyword */}
    </div>
  );
}
