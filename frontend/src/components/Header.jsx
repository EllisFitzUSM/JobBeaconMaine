import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";
import ProfileButton from "./ProfileButton.jsx";
import "../styles/Header.css";

export default function Header() {
    const { isLoggedIn, logout } = useAuth();
    const navigate = useNavigate();

    const handleLogout = () => {
        logout();
        navigate("/");
    };

    {/* ===== HEADER ===== */ }
    return (
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

                        <button
                            onClick={navigate("/applications")}
                            className="btn btn-solid-red"
                        >
                            Applications
                        </button>

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
    )
}