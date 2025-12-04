import React, { useState } from "react";

export default function SignInPage() {
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
    skills: ""
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    console.log("Form submitted:", formData);
    // Later: send formData to Flask API
  };

  return (
    <div style={{ textAlign: "center", marginTop: "50px" }}>
      <h1>Enter Your Information</h1>

      <form onSubmit={handleSubmit} style={{ display: "inline-block", textAlign: "left" }}>

        <div>
          <label>First Name:</label><br />
          <input name="firstName" value={formData.firstName} onChange={handleChange} />
        </div>

        <div>
          <label>Last Name:</label><br />
          <input name="lastName" value={formData.lastName} onChange={handleChange} />
        </div>

        <div>
          <label>Middle Initial:</label><br />
          <input name="middleInitial" value={formData.middleInitial} onChange={handleChange} />
        </div>

        <div>
          <label>Email:</label><br />
          <input name="email" type="email" value={formData.email} onChange={handleChange} />
        </div>

        <div>
          <label>Phone Number:</label><br />
          <input name="phone" value={formData.phone} onChange={handleChange} />
        </div>

        <div>
          <label>City:</label><br />
          <input name="city" value={formData.city} onChange={handleChange} />
        </div>

        <div>
          <label>County:</label><br />
          <input name="county" value={formData.county} onChange={handleChange} />
        </div>

        <div>
          <label>Zip Code:</label><br />
          <input name="zip" value={formData.zip} onChange={handleChange} />
        </div>

        <div>
          <label>Max Commute Pref (miles):</label><br />
          <input name="maxCommute" type="number" value={formData.maxCommute} onChange={handleChange} />
        </div>

        <div>
          <label>Remote Pref (Remote, Hybrid, Office):</label><br />
          <input name="remotePref" value={formData.remotePref} onChange={handleChange} />
        </div>

        <div>
          <label>Salary Max Pref:</label><br />
          <input name="salaryMax" type="number" value={formData.salaryMax} onChange={handleChange} />
        </div>

        <div>
          <label>Salary Min Pref:</label><br />
          <input name="salaryMin" type="number" value={formData.salaryMin} onChange={handleChange} />
        </div>

        <div>
          <label>Skills:</label><br />
          <input name="skills" value={formData.skills} onChange={handleChange} />
        </div>

        <button type="submit" style={{ marginTop: "10px" }}>
          Submit
        </button>

      </form>
    </div>
  );
}
