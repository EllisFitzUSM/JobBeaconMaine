import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";

export default function SignedInSearch() {
  const { isLoggedIn } = useAuth();
  const navigate = useNavigate();

  if (!isLoggedIn) return null;

  return (
    <button
      onClick={() => navigate("/jobs?recommended=true")}
      style={{
        marginTop: "10px",
        padding: "10px 20px",
        fontSize: "16px",
        cursor: "pointer"
      }}
    >
      Recommended Jobs
    </button>
  );
}
