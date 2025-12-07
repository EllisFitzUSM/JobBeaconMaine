import { useState, useEffect } from 'react';
import { useLocation, useNavigate } from 'react-router-dom';
import JobCard from '../components/JobCard';
import JobMaximized from './JobMaximized';

export default function JobResults() {
  const location = useLocation();
  const navigate = useNavigate();
  
  const [jobs, setJobs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  const [selectedJob, setSelectedJob] = useState(null);
  
  // Available filter options
  const [cities, setCities] = useState([]);
  
  // Get current filters from URL
  const params = new URLSearchParams(location.search);
  const keyword = params.get('keyword') || '';
  const city = params.get('city') || '';
  const remote = params.get('remote') || '';
  const minSalary = params.get('min_salary') || '';
  const maxSalary = params.get('max_salary') || '';

  // Local state for search form
  const [searchFilters, setSearchFilters] = useState({
    keyword: keyword,
    city: city,
    remote: remote,
    min_salary: minSalary,
    max_salary: maxSalary
  });

  // Fetch cities for filter dropdown
  useEffect(() => {
    fetchCities();
  }, []);

  // Fetch jobs when URL parameters change
  useEffect(() => {
    fetchJobs();
  }, [location.search]);

  // Sync local state with URL params when they change
  useEffect(() => {
    setSearchFilters({
      keyword: keyword,
      city: city,
      remote: remote,
      min_salary: minSalary,
      max_salary: maxSalary
    });
  }, [keyword, city, remote, minSalary, maxSalary]);

  const fetchCities = async () => {
    try {
      const response = await fetch('http://localhost:5000/api/jobs/filters/cities');
      const data = await response.json();
      
      if (data.success) {
        setCities(data.cities);
      }
    } catch (err) {
      console.error('Error fetching cities:', err);
    }
  };

  const fetchJobs = async () => {
    try {
      setLoading(true);
      setError(null);
      
      // Build query parameters from URL
      const queryParams = new URLSearchParams();
      if (city) queryParams.append('city', city);
      if (remote) queryParams.append('remote_pref', remote);
      if (minSalary) queryParams.append('min_salary', minSalary);
      
      const url = `http://localhost:5000/api/jobs${queryParams.toString() ? '?' + queryParams.toString() : ''}`;
      
      const response = await fetch(url);
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      
      if (data.success) {
        setJobs(data.jobs);
      } else {
        throw new Error(data.error || 'Failed to fetch jobs');
      }
    } catch (err) {
      setError(err.message);
      console.error('Error fetching jobs:', err);
    } finally {
      setLoading(false);
    }
  };

  // Handle search form submission
  const handleSearch = (e) => {
    e.preventDefault();
    
    // Build URL with all search parameters
    const params = new URLSearchParams();
    
    if (searchFilters.keyword) params.set('keyword', searchFilters.keyword);
    if (searchFilters.city) params.set('city', searchFilters.city);
    if (searchFilters.remote) params.set('remote', searchFilters.remote);
    if (searchFilters.min_salary) params.set('min_salary', searchFilters.min_salary);
    if (searchFilters.max_salary) params.set('max_salary', searchFilters.max_salary);
    
    navigate(`${location.pathname}?${params.toString()}`);
  };

  const clearFilters = () => {
    setSearchFilters({
      keyword: '',
      city: '',
      remote: '',
      min_salary: '',
      max_salary: ''
    });
    navigate(location.pathname);
  };

  const updateSearchFilter = (field, value) => {
    setSearchFilters(prev => ({
      ...prev,
      [field]: value
    }));
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center min-h-screen">
        <div className="text-xl text-gray-600">Loading jobs...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex justify-center items-center min-h-screen">
        <div className="bg-red-50 border border-red-200 rounded-lg p-6 max-w-md">
          <h2 className="text-xl font-bold text-red-800 mb-2">Error Loading Jobs</h2>
          <p className="text-red-600">{error}</p>
          <button
            onClick={fetchJobs}
            className="mt-4 bg-red-600 hover:bg-red-700 text-white px-4 py-2 rounded transition-colors"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  // Build active filters display
  const activeFilters = [];
  if (keyword) activeFilters.push(`Keyword: "${keyword}"`);
  if (city) activeFilters.push(`City: ${city}`);
  if (remote) activeFilters.push(`Work Type: ${remote}`);
  if (minSalary) activeFilters.push(`Min Salary: $${minSalary}`);
  if (maxSalary) activeFilters.push(`Max Salary: $${maxSalary}`);

  return (
    <div className="max-w-6xl mx-auto p-5">
      <div className="text-center mb-8">
        <h1 className="text-4xl font-bold text-gray-900 mb-2">Job Search</h1>
        <p className="text-gray-600">Find your perfect job in Maine</p>
      </div>

      {/* Search Form */}
      <form onSubmit={handleSearch} className="bg-white rounded-lg shadow-md p-6 mb-6">
        <h2 className="text-lg font-semibold text-gray-900 mb-4">Search Criteria</h2>
        
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 mb-4">
          {/* Keyword Search */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Keywords
            </label>
            <input
              type="text"
              value={searchFilters.keyword}
              onChange={(e) => updateSearchFilter('keyword', e.target.value)}
              placeholder="Job title, description, company..."
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* City Filter */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Location
            </label>
            <select
              value={searchFilters.city}
              onChange={(e) => updateSearchFilter('city', e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">All Cities</option>
              {cities.map((c) => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
          </div>

          {/* Remote Preference */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Work Type
            </label>
            <select
              value={searchFilters.remote}
              onChange={(e) => updateSearchFilter('remote', e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            >
              <option value="">All Types</option>
              <option value="Remote">Remote</option>
              <option value="Hybrid">Hybrid</option>
              <option value="On-site">On-site</option>
              <option value="Office">Office</option>
            </select>
          </div>

          {/* Min Salary */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Min Salary ($)
            </label>
            <input
              type="number"
              value={searchFilters.min_salary}
              onChange={(e) => updateSearchFilter('min_salary', e.target.value)}
              placeholder="e.g., 50000"
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>

          {/* Max Salary */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-1">
              Max Salary ($)
            </label>
            <input
              type="number"
              value={searchFilters.max_salary}
              onChange={(e) => updateSearchFilter('max_salary', e.target.value)}
              placeholder="e.g., 100000"
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
            />
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex gap-3">
          <button
            type="submit"
            className="bg-blue-600 hover:bg-blue-700 text-white font-semibold px-6 py-2 rounded-lg transition-colors"
          >
            Search Jobs
          </button>
          <button
            type="button"
            onClick={clearFilters}
            className="bg-gray-200 hover:bg-gray-300 text-gray-700 px-6 py-2 rounded-lg transition-colors"
          >
            Clear All
          </button>
        </div>
      </form>

      {/* Active Filters Display */}
      {activeFilters.length > 0 && (
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4 mb-4">
          <div className="flex items-center justify-between">
            <div className="flex flex-wrap gap-2 items-center">
              <span className="font-medium text-gray-700">Active Filters:</span>
              {activeFilters.map((filter, idx) => (
                <span key={idx} className="px-3 py-1 bg-blue-100 text-blue-800 text-sm rounded-full">
                  {filter}
                </span>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* Results Count */}
      <div className="mb-4 text-gray-600 font-medium">
        Found {jobs.length} job{jobs.length !== 1 ? 's' : ''}
      </div>

      {/* Jobs List */}
      <div className="flex flex-col gap-5">
        {jobs.length > 0 ? (
          jobs.map((job) => (
            <JobCard 
              key={job.job_id} 
              job={job} 
              onClick={setSelectedJob}
            />
          ))
        ) : (
          <div className="text-center py-12 bg-gray-50 rounded-lg">
            <p className="text-xl text-gray-500 mb-2">No jobs found matching your criteria</p>
            <p className="text-gray-400 mb-4">Try adjusting your search filters</p>
            <button
              onClick={clearFilters}
              className="text-blue-600 hover:text-blue-700 font-medium"
            >
              Clear all filters
            </button>
          </div>
        )}
      </div>

      {/* Job Detail Modal */}
      {selectedJob && (
        <JobMaximized job={selectedJob} onClose={() => setSelectedJob(null)} />
      )}
    </div>
  );
}