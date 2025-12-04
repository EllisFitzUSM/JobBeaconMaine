import Title from "../components/Title.jsx";
import SearchBar from "../components/SearchBar.jsx";
import SignIn from "../components/SignIn.jsx";
import Resources from "../components/Resources.jsx";
import SignedInSearch from "../components/SignedInSearch.jsx";
import { useAuth } from "../AuthContext.jsx"; // <-- import the hook
import { useNavigate } from "react-router-dom"; // if you want to navigate
import "../styles/App.css";

export default function Home() {
  const { isLoggedIn } = useAuth(); // get login status
  const navigate = useNavigate(); // for navigation

  const handleRecommendClick = () => {
    navigate("/recommend"); // navigate to recommend jobs page
  };

  return (
    <div className="container">
      <SignIn />
      <Title />
      <SearchBar />
      <SignedInSearch />

      {/* Recommend Jobs button only shows when user is logged in */}
      {isLoggedIn && (
        <button onClick={handleRecommendClick} className="recommend-btn">
          Recommend Jobs
        </button>
      )}

      <Resources />
    </div>
  );
}
