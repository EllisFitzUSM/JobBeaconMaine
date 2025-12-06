import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";

export default function ProfileButton() {
  const { isLoggedIn } = useAuth();
  const navigate = useNavigate();

  if (!isLoggedIn) return null; // hide if not logged in

  const goToProfile = () => {
    navigate("/profile");
  };

  return (
    <button
      onClick={goToProfile}
      style={{
        position: "absolute",
        top: "10px",
        left: "10px",
        padding: "8px 14px",
        fontSize: "14px",
        borderRadius: "6px",
        cursor: "pointer"
      }}
    >
      Profile
    </button>
  );
}
