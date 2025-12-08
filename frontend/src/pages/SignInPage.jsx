import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";
import "../styles/SignIn.css";

export default function SignInPage() {
  const [mode, setMode] = useState("signin");
  const [error, setError] = useState("");
  const navigate = useNavigate();
  const { login } = useAuth();

  const [formData, setFormData] = useState({
    username: "",
    password: "",
    firstName: "",
    lastName: "",
    middleInitial: "",
    email: "",
    phone: "",
    city: "",
    county: "",
    zip: "",
    maxCommute: "",
    remotePref: "",
    salaryMin: "",
    salaryMax: "",
    skills: "",
  });

  const handleChange = (e) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      // -------------------- SIGNUP --------------------
      if (mode === "signup") {
        const res = await fetch("http://127.0.0.1:5000/api/signup", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(formData),
        });

        const data = await res.json();

        if (!res.ok) {
          setError(data.error || "Signup failed.");
          return;
        }

        alert("Account created! Please sign in.");
        setMode("signin");
        return;
      }

      // -------------------- SIGNIN --------------------
      if (mode === "signin") {
        const result = await login(formData.username, formData.password);

        if (!result.success) {
          setError(result.message || "Invalid username or password.");
          return;
        }

        navigate("/");
      }
    } catch (err) {
      setError("Server error: " + err.message);
    }
  };

  return (
    <div className="auth-bg">
      <div className="auth-card">
        <h2 className="auth-title">
          {mode === "signin" ? "Sign In" : "Create an Account"}
        </h2>

        {error && <p className="auth-error">{error}</p>}

        <form onSubmit={handleSubmit} className="auth-form">

          {/* Username + Password (always shown) */}
          <label>Username</label>
          <input
            name="username"
            value={formData.username}
            onChange={handleChange}
            required
          />

          <label>Password</label>
          <input
            type="password"
            name="password"
            value={formData.password}
            onChange={handleChange}
            required
          />

          {/* --------------------- SIGNUP FIELDS --------------------- */}
          {mode === "signup" && (
            <div className="signup-grid">

              <div>
                <label>First Name</label>
                <input 
                  name="firstName" 
                  value={formData.firstName} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Last Name</label>
                <input 
                  name="lastName" 
                  value={formData.lastName} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Middle Initial</label>
                <input 
                  name="middleInitial" 
                  value={formData.middleInitial} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Email</label>
                <input 
                  type="email" 
                  name="email" 
                  value={formData.email} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Phone</label>
                <input 
                  name="phone" 
                  value={formData.phone} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>City</label>
                <input 
                  name="city" 
                  value={formData.city} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>County</label>
                <input 
                  name="county" 
                  value={formData.county} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Zip</label>
                <input 
                  name="zip" 
                  value={formData.zip} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Max Commute (mi)</label>
                <input 
                  name="maxCommute" 
                  value={formData.maxCommute} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Remote Pref</label>
                <input 
                  name="remotePref" 
                  value={formData.remotePref} 
                  onChange={handleChange} 
                  placeholder="Remote / Hybrid / On-site"
                />
              </div>

              <div>
                <label>Min Salary</label>
                <input 
                  name="salaryMin" 
                  value={formData.salaryMin} 
                  onChange={handleChange} 
                />
              </div>

              <div>
                <label>Max Salary</label>
                <input 
                  name="salaryMax" 
                  value={formData.salaryMax} 
                  onChange={handleChange} 
                />
              </div>

              <div className="grid-full">
                <label>Skills (comma-separated)</label>
                <input 
                  name="skills" 
                  value={formData.skills} 
                  onChange={handleChange} 
                />
              </div>

            </div>
          )}

          <button type="submit" className="auth-btn">
            {mode === "signin" ? "Sign In" : "Create Account"}
          </button>
        </form>

        <p className="auth-switch">
          {mode === "signin" ? (
            <>
              New user?{" "}
              <span onClick={() => setMode("signup")}>Create an Account</span>
            </>
          ) : (
            <>
              Already have an account?{" "}
              <span onClick={() => setMode("signin")}>Sign In</span>
            </>
          )}
        </p>
      </div>
    </div>
  );
}
