import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";

export default function SignInPage() {
  const [mode, setMode] = useState("signup"); // "signup" or "signin"
  const navigate = useNavigate();
  const { login } = useAuth();

  const [error, setError] = useState("");

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

  // --------------------------------------------------------------
  // Handle Signup + Signin
  // --------------------------------------------------------------
  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      // =====================================================================
      // SIGN UP MODE
      // =====================================================================
      if (mode === "signup") {
        const res = await fetch("http://127.0.0.1:5000/api/signup", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(formData),
        });

        const data = await res.json();

        if (!res.ok) {
          setError(data.error || data.message || "Signup failed.");
          return;
        }

        alert("Account created! Please sign in.");
        setMode("signin");
        return;
      }

      // =====================================================================
      // SIGN IN MODE (temporary behavior)
      // =====================================================================
      if (mode === "signin") {
        // For now just simulate login
        login(formData);
        navigate("/");
      }

    } catch (err) {
      setError("Server error: " + err.message);
    }
  };

  // --------------------------------------------------------------
  // UI
  // --------------------------------------------------------------
  return (
    <div style={{ textAlign: "center", marginTop: "40px" }}>
      <h1>{mode === "signup" ? "Create an Account" : "Sign In"}</h1>

      {/* Toggle button */}
      <button
        style={{ marginBottom: "20px" }}
        onClick={() => setMode(mode === "signup" ? "signin" : "signup")}
      >
        {mode === "signup"
          ? "Already have an account? Sign In"
          : "New user? Create an Account"}
      </button>

      {error && <p style={{ color: "red" }}>{error}</p>}

      <form onSubmit={handleSubmit} style={{ display: "inline-block", textAlign: "left" }}>
        
        {/* Username */}
        <div>
          <label>Username:</label><br />
          <input
            name="username"
            value={formData.username}
            onChange={handleChange}
            required
          />
        </div>

        {/* Password */}
        <div>
          <label>Password:</label><br />
          <input
            type="password"
            name="password"
            value={formData.password}
            onChange={handleChange}
            required
          />
        </div>

        {/* ==========================================================
            SIGNUP-ONLY FIELDS
           ========================================================== */}
        {mode === "signup" && (
          <>
            <div>
              <label>First Name:</label><br />
              <input
                name="firstName"
                value={formData.firstName}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Last Name:</label><br />
              <input
                name="lastName"
                value={formData.lastName}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Middle Initial:</label><br />
              <input
                name="middleInitial"
                value={formData.middleInitial}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Email:</label><br />
              <input
                name="email"
                type="email"
                value={formData.email}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Phone:</label><br />
              <input
                name="phone"
                value={formData.phone}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>City:</label><br />
              <input
                name="city"
                value={formData.city}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>County:</label><br />
              <input
                name="county"
                value={formData.county}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Zip Code:</label><br />
              <input
                name="zip"
                value={formData.zip}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Max Commute (miles):</label><br />
              <input
                name="maxCommute"
                value={formData.maxCommute}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Remote Preference:</label><br />
              <input
                name="remotePref"
                value={formData.remotePref}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Salary Minimum:</label><br />
              <input
                name="salaryMin"
                value={formData.salaryMin}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Salary Maximum:</label><br />
              <input
                name="salaryMax"
                value={formData.salaryMax}
                onChange={handleChange}
              />
            </div>

            <div>
              <label>Skills:</label><br />
              <input
                name="skills"
                value={formData.skills}
                onChange={handleChange}
              />
            </div>
          </>
        )}

        <button type="submit" style={{ marginTop: "20px", width: "100%" }}>
          {mode === "signup" ? "Create Account" : "Sign In"}
        </button>
      </form>
    </div>
  );
}
