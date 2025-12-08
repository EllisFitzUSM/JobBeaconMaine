import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";

export default function ProfileButton() {
  const { isLoggedIn } = useAuth();
  const navigate = useNavigate();

  if (!isLoggedIn) return null;

  return (
    <button
      onClick={() => navigate("/profile")}
      className="btn-solid-black"
    >
      Profile
    </button>
  );
}
