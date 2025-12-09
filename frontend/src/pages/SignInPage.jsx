import React, { useState, useRef, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";
import "../styles/SignIn.css";

export default function SignInPage() {
  const [mode, setMode] = useState("signin");
  const [error, setError] = useState("");
  const navigate = useNavigate();
  const { login } = useAuth();

  // City automplete
  const [cities, setCities] = useState([]);
  const [filteredCities, setFilteredCities] = useState([]);
  const [showCityDropdown, setShowCityDropdown] = useState(false);
  const cityInputRef = useRef(null);
  const dropdownRef = useRef(null);

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

  useEffect(() => {
    const fetchCities = async () => {
      try {
        const res = await fetch("http://127.0.0.1:5000/api/geo/cities");
        const data = await res.json();
        setCities(data.cities || []);
      } catch (err) {
        console.error("Failed to fetch cities:", err);
      }
    };
    fetchCities();
  }, []);

  useEffect(() => {
    const handleClickOutside = (e) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(e.target) &&
        cityInputRef.current &&
        !cityInputRef.current.contains(e.target)
      ) {
        setShowCityDropdown(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  const handleCityInput = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));

    // Filter cities as user types
    if (value.trim() === "") {
      setFilteredCities([]);
      setShowCityDropdown(false);
    } else {
      const matches = cities.filter((city) =>
        city.toLowerCase().startsWith(value.toLowerCase())
      );
      setFilteredCities(matches);
      setShowCityDropdown(matches.length > 0);
    }
  };

  const handleCitySelect = (city) => {
    setFormData((prev) => ({ ...prev, city }));
    setShowCityDropdown(false);
    setFilteredCities([]);
  };

  const handleChange = (e) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError("");

    try {
      // -------------------- SIGNUP --------------------
      if (mode === "signup") {
        const payload = {
          ...formData,
          // Float Values
          maxCommute: formData.maxCommute === "" ? null : parseFloat(formData.maxCommute),
          salaryMin: formData.salaryMin === "" ? null : parseFloat(formData.salaryMin),
          salaryMax: formData.salaryMax === "" ? null : parseFloat(formData.salaryMax),
          // String Values
          phone: formData.phone === "" ? null : formData.phone,
          middleInitial: formData.middleInitial === "" ? null : formData.middleInitial,
          county: formData.county === "" ? null : formData.county,
          zip: formData.zip === "" ? null : formData.zip,
          remotePref: formData.remotePref === "" ? null : formData.remotePref,
          skills: formData.skills === "" ? null : formData.skills,
        };
  
        const res = await fetch("http://127.0.0.1:5000/api/signup", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(payload),
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
          <label>
            Username <span style={{ color: "red" }}>*</span>
          </label>
          <input
            name="username"
            value={formData.username}
            onChange={handleChange}
            required
          />

          <label>
            Password <span style={{ color: "red" }}>*</span>
          </label>
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
                <label>
                  First Name <span style={{ color: "red" }}>*</span>
                </label>
                <input 
                  name="firstName" 
                  value={formData.firstName} 
                  onChange={handleChange}
                  required
                />
              </div>

              <div>
                <label>
                  Last Name <span style={{ color: "red" }}>*</span>
                </label>
                <input 
                  name="lastName" 
                  value={formData.lastName} 
                  onChange={handleChange}
                  required
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
                <label>
                  Email <span style={{ color: "red" }}>*</span>
                </label>
                <input 
                  type="email" 
                  name="email" 
                  value={formData.email} 
                  onChange={handleChange}
                  required 
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
                <label>
                  City <span style={{ color: "red" }}>*</span>
                </label>
                <div style={{ position: "relative" }}>
                  <input
                    ref={cityInputRef}
                    type="text"
                    name="city"
                    value={formData.city}
                    onChange={handleCityInput}
                    autoComplete="off"
                    required
                  />
                  {showCityDropdown && (
                    <ul
                      ref={dropdownRef}
                      style={{
                        position: "absolute",
                        top: "100%",
                        left: 0,
                        right: 0,
                        backgroundColor: "white",
                        border: "1px solid #ccc",
                        borderRadius: "4px",
                        maxHeight: "200px",
                        overflowY: "auto",
                        listStyle: "none",
                        margin: 0,
                        padding: 0,
                        zIndex: 1000,
                      }}
                    >
                      {filteredCities.map((city, idx) => (
                        <li
                          key={idx}
                          onClick={() => handleCitySelect(city)}
                          style={{
                            padding: "8px 12px",
                            cursor: "pointer",
                            borderBottom:
                              idx < filteredCities.length - 1
                                ? "1px solid #eee"
                                : "none",
                          }}
                          onMouseEnter={(e) =>
                            (e.target.style.backgroundColor = "#f0f0f0")
                          }
                          onMouseLeave={(e) =>
                            (e.target.style.backgroundColor = "white")
                          }
                        >
                          {city}
                        </li>
                      ))}
                    </ul>
                  )}
                </div>
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
                <label>Remote Preference</label>
                <select
                  name="remotePref"
                  value={formData.remotePref}
                  onChange={handleChange}
                  style={{ padding: "8px", fontSize: "14px", borderRadius: "4px", border: "1px solid #ccc" }}
                >
                  <option value="">Select preference</option>
                  <option value="remote">Remote</option>
                  <option value="hybrid">Hybrid</option>
                  <option value="onsite">On-site</option>
                </select>
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
