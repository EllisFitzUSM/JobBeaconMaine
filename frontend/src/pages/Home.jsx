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
    navigate("/");
  };

  return (
    <div className="home">
      
      {/* ===== HEADER ===== */}
      <div className="home-header">

        {/* Logo (top-left) */}
        <img
          src="/assets/T_Circle.png"
          className="header-logo"
          alt="Logo"
          onClick={() => navigate("/")}
          style={{ cursor: "pointer" }}
        />

        {/* Right side */}
        <div className="header-right">

          {isLoggedIn ? (
            <>
              {/* Profile button should appear here */}
              <div className="header-profile-wrapper">
                <ProfileButton />
              </div>

              {/* Sign Out */}
              <button
                onClick={handleLogout}
                className="btn btn-solid-red"
              >
                Sign Out
              </button>
            </>
          ) : (
            <button
              onClick={() => navigate("/signin")}
              className="btn btn-outline-red"
            >
              Sign In / Create Account
            </button>
          )}

        </div>
      </div>

      {/* ===== MAIN CONTENT ===== */}
      <main className="home-main">

        {/* Search hero section */}
        <section className="hero-section">
          <Title />
          <p className="hero-subtitle">
            One search for jobs across Maine. Filter, match, and discover roles
            tailored for students & alumni.
          </p>

          <div className="hero-search">
            <SearchBar />

            {isLoggedIn && (
              <div className="hero-recommend">
                <SignedInSearch />
              </div>
            )}
          </div>
        </section>

        {/* Resources band */}
        <section className="resources-band">
          <img src="/assets/T_CircleTransparent.png"
               alt="decor"
               className="band-circle band-circle-left" />

          <img src="/assets/T_CircleTransparent.png"
               alt="decor"
               className="band-circle band-circle-right" />

          <div className="resources-inner">
            <Resources />
          </div>
        </section>

      </main>

    </div>
  );
}
