import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";

export default function SignInPage() {
  const [mode, setMode] = useState("signup"); 
  const navigate = useNavigate();
  const { login } = useAuth();

  const [formData, setFormData] = useState({
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
    salaryMax: "",
    salaryMin: "",
    skills: "",
    username: "",
    password: "",
  });

  const handleChange = (e) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    // 🚨 TEMPORARY — until backend is added
    // Later this is where you will call Flask API
    console.log(`${mode} submitted:`, formData);

    // For now, simulate a successful login
    login(formData);

    // Go back home
    navigate("/");
  };

  return (
    <div style={{ textAlign: "center", marginTop: "40px" }}>
      <h1>{mode === "signup" ? "Create an Account" : "Sign In"}</h1>

      {/* Toggle between modes */}
      <button
        style={{ marginBottom: "20px" }}
        onClick={() => setMode(mode === "signup" ? "signin" : "signup")}
      >
        {mode === "signup"
          ? "Already have an account? Sign In"
          : "New user? Create an Account"}
      </button>

      <form onSubmit={handleSubmit} style={{ display: "inline-block", textAlign: "left" }}>
        
        {/* Shared fields */}
        <div>
          <label>Username:</label><br />
          <input name="username" value={formData.username} onChange={handleChange} required />
        </div>

        <div>
          <label>Password:</label><br />
          <input type="password" name="password" value={formData.password} onChange={handleChange} required />
        </div>

        {/* Only show user info fields on SIGN UP */}
        {mode === "signup" && (
          <>
            <div><label>First Name:</label><br />
              <input name="firstName" value={formData.firstName} onChange={handleChange} />
            </div>

            <div><label>Last Name:</label><br />
              <input name="lastName" value={formData.lastName} onChange={handleChange} />
            </div>

            <div><label>Middle Initial:</label><br />
              <input name="middleInitial" value={formData.middleInitial} onChange={handleChange} />
            </div>

            <div><label>Email:</label><br />
              <input type="email" name="email" value={formData.email} onChange={handleChange} />
            </div>

            <div><label>Phone:</label><br />
              <input name="phone" value={formData.phone} onChange={handleChange} />
            </div>

            <div><label>City:</label><br />
              <input name="city" value={formData.city} onChange={handleChange} />
            </div>

            <div><label>County:</label><br />
              <input name="county" value={formData.county} onChange={handleChange} />
            </div>

            <div><label>Zip Code:</label><br />
              <input name="zip" value={formData.zip} onChange={handleChange} />
            </div>

            <div><label>Max Commute (miles):</label><br />
              <input type="number" name="maxCommute" value={formData.maxCommute} onChange={handleChange} />
            </div>

            <div><label>Remote Preference:</label><br />
              <input name="remotePref" value={formData.remotePref} onChange={handleChange} />
            </div>

            <div><label>Salary Min:</label><br />
              <input type="number" name="salaryMin" value={formData.salaryMin} onChange={handleChange} />
            </div>

            <div><label>Salary Max:</label><br />
              <input type="number" name="salaryMax" value={formData.salaryMax} onChange={handleChange} />
            </div>

            <div><label>Skills (comma separated):</label><br />
              <input name="skills" value={formData.skills} onChange={handleChange} />
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
