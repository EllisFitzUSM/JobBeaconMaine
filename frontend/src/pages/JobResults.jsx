import { useState, useEffect } from "react";
import { useLocation, useNavigate } from "react-router-dom";
import JobCard from "../components/JobCard";
import JobMaximized from "./JobMaximized.jsx";
import { useAuth } from "../AuthContext.jsx";

export default function JobResults() {
  const location = useLocation();
  const navigate = useNavigate();
  const { user } = useAuth();

  // URL params
  const params = new URLSearchParams(location.search);
  const recommended = params.get("recommended") === "true";

  const keyword = params.get("keyword") || "";
  const city = params.get("city") || "";
  const remote = params.get("remote") || "";
  const minSalary = params.get("min_salary") || "";
  const maxSalary = params.get("max_salary") || "";

  // State
  const [jobs, setJobs] = useState([]);
  const [cities, setCities] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedJob, setSelectedJob] = useState(null);

  const [searchFilters, setSearchFilters] = useState({
    keyword,
    city,
    remote,
    min_salary: minSalary,
    max_salary: maxSalary,
  });

  // Load cities once
  useEffect(() => {
    fetchCities();
  }, []);

  const fetchCities = async () => {
    try {
      const res = await fetch("http://localhost:5000/api/jobs/filters/cities");
      const data = await res.json();
      if (data.success) setCities(data.cities);
    } catch (err) {
      console.error("Error fetching cities:", err);
    }
  };

  // Fetch jobs when URL changes
  useEffect(() => {
    fetchJobs();
  }, [location.search]);

  const fetchJobs = async () => {
    try {
      setLoading(true);
      setError(null);

      let url = "";

      // MODE 1: Recommended jobs
      if (recommended && user?.User_ID) {
        url = `http://localhost:5000/api/jobs/recommend/${user.User_ID}`;
      }
      // MODE 2: Keyword only
      else if (keyword && !city && !remote && !minSalary && !maxSalary) {
        url = `http://localhost:5000/api/jobs/search?keyword=${encodeURIComponent(
          keyword
        )}`;
      }
      // MODE 3: Filtered search
      else {
        const qp = new URLSearchParams();
        if (keyword) qp.set("keyword", keyword);
        if (city) qp.set("city", city);
        if (remote) qp.set("remote_pref", remote);
        if (minSalary) qp.set("min_salary", minSalary);
        if (maxSalary) qp.set("max_salary", maxSalary);

        url = `http://localhost:5000/api/jobs/filter?${qp.toString()}`;
      }

      console.log("FETCHING:", url);

      const res = await fetch(url);
      const data = await res.json();

      if (!data.success) throw new Error(data.error);

      setJobs(data.jobs);
    } catch (err) {
      setError(err.message);
    } finally {
      setLoading(false);
    }
  };

  // Update individual form fields
  const updateSearchFilter = (field, value) => {
    setSearchFilters((prev) => ({ ...prev, [field]: value }));
  };

  // Submit search form
  const handleSearch = (e) => {
    e.preventDefault();

    const qp = new URLSearchParams();

    if (searchFilters.keyword) qp.set("keyword", searchFilters.keyword);
    if (searchFilters.city) qp.set("city", searchFilters.city);
    if (searchFilters.remote) qp.set("remote", searchFilters.remote);
    if (searchFilters.min_salary) qp.set("min_salary", searchFilters.min_salary);
    if (searchFilters.max_salary) qp.set("max_salary", searchFilters.max_salary);

    navigate(`${location.pathname}?${qp.toString()}`);
  };

  const clearFilters = () => {
    setSearchFilters({
      keyword: "",
      city: "",
      remote: "",
      min_salary: "",
      max_salary: "",
    });
    navigate(location.pathname);
  };

  // Handle loading / error UI
  if (loading)
    return (
      <div className="flex justify-center items-center min-h-screen text-xl text-gray-600">
        Loading jobs...
      </div>
    );

  if (error)
    return (
      <div className="flex justify-center items-center min-h-screen">
        <div className="bg-red-50 border p-6 rounded-lg">
          <h2 className="text-xl font-bold text-red-800 mb-2">Error Loading Jobs</h2>
          <p className="text-red-600">{error}</p>
          <button
            onClick={fetchJobs}
            className="mt-4 bg-red-600 text-white px-4 py-2 rounded"
          >
            Retry
          </button>
        </div>
      </div>
    );

  const activeFilters = [];
  if (keyword) activeFilters.push(`Keyword: "${keyword}"`);
  if (city) activeFilters.push(`City: ${city}`);
  if (remote) activeFilters.push(`Work Type: ${remote}`);
  if (minSalary) activeFilters.push(`Min Salary: $${minSalary}`);
  if (maxSalary) activeFilters.push(`Max Salary: $${maxSalary}`);

  return (
    <div className="max-w-6xl mx-auto p-5">
      <h1 className="text-4xl font-bold text-center mb-2">
        {recommended ? "Recommended Jobs" : "Job Search"}
      </h1>

      {/* Search Form */}
      <form onSubmit={handleSearch} className="bg-white p-6 shadow rounded mb-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">

          <input
            type="text"
            value={searchFilters.keyword}
            onChange={(e) => updateSearchFilter("keyword", e.target.value)}
            placeholder="Keywords..."
            className="border px-3 py-2 rounded"
          />

          <select
            value={searchFilters.city}
            onChange={(e) => updateSearchFilter("city", e.target.value)}
            className="border px-3 py-2 rounded"
          >
            <option value="">All Cities</option>
            {cities.map((c) => (
              <option key={c}>{c}</option>
            ))}
          </select>

          <select
            value={searchFilters.remote}
            onChange={(e) => updateSearchFilter("remote", e.target.value)}
            className="border px-3 py-2 rounded"
          >
            <option value="">All Types</option>
            <option value="Remote">Remote</option>
            <option value="Hybrid">Hybrid</option>
            <option value="On-site">On-site</option>
          </select>

          <input
            type="number"
            value={searchFilters.min_salary}
            onChange={(e) => updateSearchFilter("min_salary", e.target.value)}
            placeholder="Min Salary"
            className="border px-3 py-2 rounded"
          />

          <input
            type="number"
            value={searchFilters.max_salary}
            onChange={(e) => updateSearchFilter("max_salary", e.target.value)}
            placeholder="Max Salary"
            className="border px-3 py-2 rounded"
          />
        </div>

        <div className="flex gap-3 mt-4">
          <button className="bg-blue-600 text-white px-6 py-2 rounded">
            Search
          </button>
          <button
            type="button"
            onClick={clearFilters}
            className="bg-gray-200 px-6 py-2 rounded"
          >
            Clear
          </button>
        </div>
      </form>

      {/* Results */}
      <p className="text-gray-600 mb-4">
        Found {jobs.length} job{jobs.length !== 1 && "s"}
      </p>

      <div className="flex flex-col gap-5">
        {jobs.map((job) => (
          <JobCard key={job.job_id} job={job} onClick={setSelectedJob} />
        ))}
      </div>

      {selectedJob && (
        <JobMaximized job={selectedJob} onClose={() => setSelectedJob(null)} />
      )}
    </div>
  );
}
