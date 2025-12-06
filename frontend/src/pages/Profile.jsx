import { useAuth } from "../AuthContext.jsx";
import { useNavigate } from "react-router-dom";
import { useState } from "react";

export default function Profile() {
  const { user, updateUser } = useAuth();
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
    salaryMin: user?.salaryMin || "",
    salaryMax: user?.salaryMax || "",
    skills: user?.skills || "",
  });

  const handleChange = (e) => {
    setFormData((prev) => ({ ...prev, [e.target.name]: e.target.value }));
  };

  const handleSave = () => {
    updateUser(formData);
    navigate("/");
  };

  return (
    <div style={{ padding: 20 }}>
      <h1>Edit Profile</h1>

      {Object.keys(formData).map((key) => (
        <div key={key} style={{ marginBottom: "10px" }}>
          <label>{key}:</label><br />
          <input name={key} value={formData[key]} onChange={handleChange} />
        </div>
      ))}

      <button onClick={handleSave}>Save</button>
      <button onClick={() => navigate("/")}>Back to Home</button>
    </div>
  );
}
