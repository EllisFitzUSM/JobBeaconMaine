import React, { useState } from "react";
import { useNavigate } from "react-router-dom";

export default function PersonalizedSearchPage() {
  const navigate = useNavigate();

  // Temporary state for filter inputs
  const [filters, setFilters] = useState({
    keyword: "",
    counties: [],
    jobTypes: { fullTime: false, partTime: false, contract: false },
    remotePrefs: { remote: false, hybrid: false, office: false },
    salaryMin: "",
    salaryMax: "",
    maxCommute: "",
    skills: ""
  });

  // Handle text/number inputs
  const handleChange = (e) => {
    const { name, value } = e.target;
    setFilters((prev) => ({ ...prev, [name]: value }));
  };

  // Handle checkbox groups
  const handleCheckboxGroup = (groupName, key) => (e) => {
    const checked = e.target.checked;
    setFilters((prev) => ({
      ...prev,
      [groupName]: { ...prev[groupName], [key]: checked }
    }));
  };

  // Handle comma-separated multi-values like counties
  const handleMultiValueInput = (e) => {
    const { name, value } = e.target;
    const values = value
      .split(",")
      .map((v) => v.trim())
      .filter(Boolean);
    setFilters((prev) => ({ ...prev, [name]: values }));
  };

  // Submit filters temporarily to match scoring
  const handleSubmit = (e) => {
    e.preventDefault();

    // Prepare query params for backend or navigation
    const query = new URLSearchParams();

    if (filters.keyword) query.set("keyword", filters.keyword);
    if (filters.counties.length > 0) query.set("counties", filters.counties.join(","));

    const jobTypesSelected = Object.entries(filters.jobTypes)
      .filter(([, val]) => val)
      .map(([key]) => key)
      .join(",");
    if (jobTypesSelected) query.set("jobTypes", jobTypesSelected);

    const remoteSelected = Object.entries(filters.remotePrefs)
      .filter(([, val]) => val)
      .map(([key]) => key)
      .join(",");
    if (remoteSelected) query.set("remotePrefs", remoteSelected);

    if (filters.salaryMin) query.set("salaryMin", filters.salaryMin);
    if (filters.salaryMax) query.set("salaryMax", filters.salaryMax);
    if (filters.maxCommute) query.set("maxCommute", filters.maxCommute);
    if (filters.skills) query.set("skills", filters.skills.split(",").map(s => s.trim()).join(","));

    // Navigate to JobResults page with query parameters
    navigate(`/jobs?${query.toString()}`);
  };

  // Clear all temporary filters
  const handleClear = () => {
    setFilters({
      keyword: "",
      counties: [],
      jobTypes: { fullTime: false, partTime: false, contract: false },
      remotePrefs: { remote: false, hybrid: false, office: false },
      salaryMin: "",
      salaryMax: "",
      maxCommute: "",
      skills: ""
    });
  };

  return (
    <div style={{ maxWidth: 900, margin: "40px auto", padding: 20 }}>
      <h1>Personalized Filter Search</h1>
      <form onSubmit={handleSubmit} style={{ display: "grid", gap: 12 }}>
        
        {/* Keyword */}
        <div>
          <label>Keyword</label><br />
          <input
            name="keyword"
            value={filters.keyword}
            onChange={handleChange}
            placeholder="e.g., 'Developer', 'Nurse'"
            style={{ width: "100%", padding: 8 }}
          />
        </div>

        {/* Counties */}
        <div>
          <label>Counties (comma separated)</label><br />
          <input
            name="counties"
            value={filters.counties.join(", ")}
            onChange={handleMultiValueInput}
            placeholder="Cumberland, York"
            style={{ width: "100%", padding: 8 }}
          />
        </div>

        {/* Job Type */}
        <fieldset style={{ padding: 12 }}>
          <legend>Job Type</legend>
          <label>
            <input
              type="checkbox"
              checked={filters.jobTypes.fullTime}
              onChange={handleCheckboxGroup("jobTypes", "fullTime")}
            /> Full-time
          </label>
          <label style={{ marginLeft: 12 }}>
            <input
              type="checkbox"
              checked={filters.jobTypes.partTime}
              onChange={handleCheckboxGroup("jobTypes", "partTime")}
            /> Part-time
          </label>
          <label style={{ marginLeft: 12 }}>
            <input
              type="checkbox"
              checked={filters.jobTypes.contract}
              onChange={handleCheckboxGroup("jobTypes", "contract")}
            /> Contract
          </label>
        </fieldset>

        {/* Remote Preference */}
        <fieldset style={{ padding: 12 }}>
          <legend>Remote Preference</legend>
          <label>
            <input
              type="checkbox"
              checked={filters.remotePrefs.remote}
              onChange={handleCheckboxGroup("remotePrefs", "remote")}
            /> Remote
          </label>
          <label style={{ marginLeft: 12 }}>
            <input
              type="checkbox"
              checked={filters.remotePrefs.hybrid}
              onChange={handleCheckboxGroup("remotePrefs", "hybrid")}
            /> Hybrid
          </label>
          <label style={{ marginLeft: 12 }}>
            <input
              type="checkbox"
              checked={filters.remotePrefs.office}
              onChange={handleCheckboxGroup("remotePrefs", "office")}
            /> Office
          </label>
        </fieldset>

        {/* Salary */}
        <div style={{ display: "flex", gap: 12 }}>
          <div style={{ flex: 1 }}>
            <label>Salary Min</label><br />
            <input
              name="salaryMin"
              type="number"
              min="0"
              value={filters.salaryMin}
              onChange={handleChange}
              style={{ width: "100%", padding: 8 }}
            />
          </div>
          <div style={{ flex: 1 }}>
            <label>Salary Max</label><br />
            <input
              name="salaryMax"
              type="number"
              min="0"
              value={filters.salaryMax}
              onChange={handleChange}
              style={{ width: "100%", padding: 8 }}
            />
          </div>
        </div>

        {/* Max Commute */}
        <div>
          <label>Max Commute (miles)</label><br />
          <input
            name="maxCommute"
            type="number"
            min="0"
            value={filters.maxCommute}
            onChange={handleChange}
            style={{ width: "100%", padding: 8 }}
          />
        </div>

        {/* Skills */}
        <div>
          <label>Skills (comma separated)</label><br />
          <input
            name="skills"
            value={filters.skills}
            onChange={handleChange}
            placeholder="React, SQL, Nursing"
            style={{ width: "100%", padding: 8 }}
          />
        </div>

        {/* Buttons */}
        <div style={{ display: "flex", gap: 12 }}>
          <button type="submit" style={{ padding: "10px 18px", cursor: "pointer" }}>
            Search
          </button>
          <button type="button" onClick={handleClear} style={{ padding: "10px 18px", cursor: "pointer" }}>
            Clear
          </button>
        </div>
      </form>
    </div>
  );
}



// Prompts for ChatGPT 5.1:
// on my personalized search page I want there to 
// be the option to search by the users own filters, 
// and also a button that returns personalised searched as well