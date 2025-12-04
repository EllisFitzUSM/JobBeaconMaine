import { useState } from "react";
import { useNavigate } from "react-router-dom";

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
        placeholder="Search jobs..."
        value={keyword}
        onChange={(e) => setKeyword(e.target.value)}
      />
    </form>
  );
}
