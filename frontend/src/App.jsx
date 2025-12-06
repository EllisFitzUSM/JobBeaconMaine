import { BrowserRouter as Router, Routes, Route } from "react-router-dom";
import Home from "./pages/Home.jsx";
import JobResults from "./pages/JobResults.jsx";
import JobMaximized from "./pages/JobMaximized.jsx";
import SignInPage from "./pages/SignInPage.jsx";
import PersonalizedSearchPage from "./pages/PersonalizedSearchPage.jsx";
import ProfilePage from './pages/ProfilePage';
import "./styles/App.css";

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/jobs" element={<JobResults />} />
        <Route path="/job" element={<JobMaximized />} />
        <Route path="/personalized-search" element={<PersonalizedSearchPage />} />
        <Route path="/signin" element={<SignInPage />} />
        <Route path="/profile" element={<ProfilePage />} />
      </Routes>
    </Router>
  );
}