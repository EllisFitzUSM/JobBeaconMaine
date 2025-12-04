import Title from "../components/Title.jsx";
import SearchBar from "../components/SearchBar.jsx";
import SignIn from "../components/SignIn.jsx";
import Resources from "../components/Resources.jsx";
import SignedInSearch from "../components/SignedInSearch.jsx";
import "../App.css";

export default function Home() {
  return (
    <div className="container">
      <SignIn />
      <Title />
      <SearchBar />
      <SignedInSearch/>
      <Resources />
    </div>
  );
}
