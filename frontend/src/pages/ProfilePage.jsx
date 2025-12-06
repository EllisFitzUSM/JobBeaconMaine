import React, { useState, useEffect } from 'react';
import './ProfilePage.css';

const ProfilePage = () => {
  const [userData, setUserData] = useState({
    firstName: '',
    lastName: '',
    email: '',
    city: '',
    remotePref: '',
    salaryMin: '',
    salaryMax: ''
  });

  useEffect(() => {
    fetch('http://127.0.0.1:5001/user/1') // John Smith
      .then(res => res.json())
      .then(data => setUserData(data))  // ✅ fix here
      .catch(err => console.error(err));
  }, []);

  const handleChange = (e) => {
    setUserData({...userData, [e.target.name]: e.target.value});
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    fetch('http://127.0.0.1:5001/user/1', {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify(userData)
    })
    .then(res => res.json())
    .then(data => alert(data.message))
    .catch(err => console.error(err));
  };

  return (
    <div className="profile-page">
      <h2>Edit Your Profile</h2>
      <form onSubmit={handleSubmit}>
        <input name="firstName" value={userData.firstName} onChange={handleChange} placeholder="First Name" />
        <input name="lastName" value={userData.lastName} onChange={handleChange} placeholder="Last Name" />
        <input name="email" value={userData.email} onChange={handleChange} placeholder="Email" />
        <input name="city" value={userData.city} onChange={handleChange} placeholder="City" />
        <input name="remotePref" value={userData.remotePref} onChange={handleChange} placeholder="Remote Preference" />
        <input name="salaryMin" value={userData.salaryMin} onChange={handleChange} placeholder="Salary Min" />
        <input name="salaryMax" value={userData.salaryMax} onChange={handleChange} placeholder="Salary Max" />
        <button type="submit">Save</button>
      </form>
    </div>
  );
};

export default ProfilePage;