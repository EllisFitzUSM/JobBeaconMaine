import { useState } from "react";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";

export default function SearchBar() {
  const [keyword, setKeyword] = useState("");
  const navigate = useNavigate();

  const handleSubmit = (e) => {
    e.preventDefault();
    if (keyword.trim() === "") return;
    // Navigate to /jobs with query parameter
    navigate(`/jobs?keyword=${encodeURIComponent(keyword)}`);
  };

  return (
    <form onSubmit={handleSubmit}>
      <input
        className="search-bar"
        // style={{ minWidth: "800px", display: "block", margin: "0 auto"}}   // <— add this
        style={{
          minWidth: "800px",
          minHeight: "50px",
          padding: "10px 14px",
          border: "1px solid #ccc",
          borderRadius: "8px",
          fontSize: "1rem",
          color: "#000",
          background: "white",
          width: "100%"
        }}
        placeholder="Search jobs..."
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
      />
    </form>
  );
}
