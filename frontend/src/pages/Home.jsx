import Title from "../components/Title.jsx";
import SearchBar from "../components/SearchBar.jsx";
import ProfileButton from "../components/ProfileButton.jsx";
import SignedInSearch from "../components/SignedInSearch.jsx";
import Resources from "../components/Resources.jsx";
import { useAuth } from "../AuthContext.jsx";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";

export default function Home() {
  const { isLoggedIn } = useAuth();
  const navigate = useNavigate();

  return (
    <div className="container" style={{ position: "relative" }}>
      {isLoggedIn && <ProfileButton />}

      {!isLoggedIn && (
        <button
          onClick={() => navigate("/signin")}
          style={{ marginBottom: "10px" }}
        >
          Sign In / Create Account
        </button>
      )}

      <Title />
      <SearchBar />

      {isLoggedIn && <SignedInSearch />}

      <Resources />
    </div>
  );
}
