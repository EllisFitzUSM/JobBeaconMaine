import { useNavigate } from "react-router-dom";

export default function SignedInSearch() {
  const navigate = useNavigate();

  const handleClick = () => {
    navigate("/personalized-search");
  };

  return (
    <button 
      onClick={handleClick} 
      style={{
        marginTop: "10px",
        padding: "10px 20px",
        fontSize: "16px",
        cursor: "pointer"
      }}
    >
      Signed - In Search
    </button>
  );
}
