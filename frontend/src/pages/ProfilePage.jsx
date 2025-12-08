import React, { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../AuthContext.jsx";
import "../styles/ProfilePage.css";

const ProfilePage = () => {
  const { user, updateUser } = useAuth(); // logged-in user
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    firstName: user?.firstName || "",
    lastName: user?.lastName || "",
    email: user?.email || "",
    city: user?.city || "",
    county: user?.county || "",
    zip: user?.zip || "",
    maxCommute: user?.maxCommute || "",
    remotePref: user?.remotePref || "",
    culturePref: user?.culturePref || "",
    salaryMin: user?.salaryMin || "",
    salaryMax: user?.salaryMax || "",
    skills: user?.skills || "",
  });

  useEffect(() => {
    if (user?.userId) {
      fetch(`/user/${user.userId}`) // your Flask backend route
        .then((res) => res.json())
        .then((data) => setFormData((prev) => ({ ...prev, ...data })))
        .catch((err) => console.error(err));
    }
  }, [user]);

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!user?.userId) return;

    try {
      const res = await fetch(`/user/${user.userId}`, {
        method: "PUT",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(formData),
      });
      const data = await res.json();

      if (res.ok) {
        alert("Profile updated successfully");
        updateUser(formData); // update AuthContext with latest info
      } else {
        alert(data.error || "Error updating profile");
      }
    } catch (err) {
      console.error(err);
      alert("Network error");
    }
  };

  return (
    <div className="profile-page">
      <h2>Edit Your Profile</h2>
      <form onSubmit={handleSubmit}>
        <input
          name="firstName"
          value={formData.firstName}
          onChange={handleChange}
          placeholder="First Name"
        />
        <input
          name="lastName"
          value={formData.lastName}
          onChange={handleChange}
          placeholder="Last Name"
        />
        <input
          name="email"
          value={formData.email}
          onChange={handleChange}
          placeholder="Email"
        />
        <input
          name="city"
          value={formData.city}
          onChange={handleChange}
          placeholder="City"
        />
        <input
          name="county"
          value={formData.county}
          onChange={handleChange}
          placeholder="County"
        />
        <input
          name="zip"
          value={formData.zip}
          onChange={handleChange}
          placeholder="ZIP"
        />
        <input
          name="maxCommute"
          value={formData.maxCommute}
          onChange={handleChange}
          placeholder="Max Commute Distance"
        />
        <input
          name="remotePref"
          value={formData.remotePref}
          onChange={handleChange}
          placeholder="Remote Preference"
        />
        <input
          name="culturePref"
          value={formData.culturePref}
          onChange={handleChange}
          placeholder="Culture Preference"
        />
        <input
          name="salaryMin"
          value={formData.salaryMin}
          onChange={handleChange}
          placeholder="Salary Min"
        />
        <input
          name="salaryMax"
          value={formData.salaryMax}
          onChange={handleChange}
          placeholder="Salary Max"
        />
        <input
          name="skills"
          value={formData.skills}
          onChange={handleChange}
          placeholder="Skills"
        />
        <button type="submit">Save</button>
        <button
          type="button"
          onClick={() => navigate("/")}
          style={{ marginLeft: "10px" }}
        >
          Back to Home
        </button>
      </form>
    </div>
  );
};

export default ProfilePage;