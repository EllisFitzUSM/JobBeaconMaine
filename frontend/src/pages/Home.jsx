import Title from "../components/Title.jsx";
import SearchBar from "../components/SearchBar.jsx";
import SignedInSearch from "../components/SignedInSearch.jsx";
import { useAuth } from "../AuthContext.jsx";
import Header from "../components/Header.jsx";
import "../styles/App.css";

export default function Home() {
  const { isLoggedIn } = useAuth();

  return (
    <div className="home">

      {/* ===== HEADER ===== */}
      <Header/>

      {/* ===== MAIN CONTENT ===== */}
      <main className="home-main">

        {/* Search hero section */}
        <section className="hero-section">
          <Title />

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
        {/* <section className="resources-band">
          <img src="/assets/T_CircleTransparent.png"
            alt="decor"
            className="band-circle band-circle-left" />

          <img src="/assets/T_CircleTransparent.png"
            alt="decor"
            className="band-circle band-circle-right" />

          <div className="resources-inner">
            <Resources />
          </div>
        </section> */}

      </main>

    </div>
  );
}
