import Title from "../components/Title.jsx";
import SearchBar from "../components/SearchBar.jsx";
import ProfileButton from "../components/ProfileButton.jsx";
import SignedInSearch from "../components/SignedInSearch.jsx";
import Resources from "../components/Resources.jsx";
import { useAuth } from "../AuthContext.jsx";
import { useNavigate } from "react-router-dom";
import "../styles/App.css";

export default function Home() {
  const { isLoggedIn, logout } = useAuth();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate("/"); // refresh home after signout
  };

  return (
    <div className="container" style={{ position: "relative" }}>
      
      {/* Show Profile Button when logged in */}
      {isLoggedIn && <ProfileButton />}

      {/* Show Sign Out button when logged in */}
      {isLoggedIn && (
        <button
          onClick={handleLogout}
          style={{
            position: "absolute",
            top: "20px",
            right: "20px",
            padding: "8px 14px",
            background: "red",
            color: "white",
            border: "none",
            borderRadius: "6px",
            cursor: "pointer",
          }}
        >
          Sign Out
        </button>
      )}

      {/* Show Sign In button only when logged out */}
      {!isLoggedIn && (
        <button
          onClick={() => navigate("/signin")}
          style={{ marginBottom: "10px" }}
        >
          Sign In / Create Account
        </button>
      )}

      {/* Your page content */}
      <Title />
      <SearchBar />
      {isLoggedIn && <SignedInSearch />}
      <Resources />
    </div>
  );
}
