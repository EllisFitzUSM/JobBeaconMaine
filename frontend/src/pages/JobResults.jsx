import { useLocation } from "react-router-dom";
import JobCard from "../components/JobCard";

export default function JobResults() {
  const location = useLocation();
  const params = new URLSearchParams(location.search);
  const keyword = params.get("keyword") || "";

  // Example/default job cards
  const exampleJobs = [
    {
      job_id: 1,
      application_url: 'https://example.com/apply/1',
      job_description: 'We are seeking a talented Full Stack Developer to join our dynamic team. You will be responsible for developing and maintaining web applications, working with both front-end and back-end technologies. The ideal candidate has experience with React, Node.js, and modern web development practices. You will collaborate with cross-functional teams to deliver high-quality software solutions that meet our clients\' needs. This is an excellent opportunity to work on exciting projects and grow your skills.',
      job_title: 'Full Stack Developer',
      salary_min: '80000',
      salary_max: '120000',
      remote_pref: 'Hybrid',
      city: 'Portland',
      posted_at: '2024-12-01T10:00:00',
      is_expired: false
    },
    {
      job_id: 2,
      application_url: 'https://example.com/apply/2',
      job_description: 'Join our team as a Marketing Manager! Lead marketing campaigns and strategies to drive brand awareness and customer engagement. Work with creative teams to develop compelling content and analyze campaign performance.',
      job_title: 'Marketing Manager',
      salary_min: '60000',
      salary_max: '90000',
      remote_pref: 'Remote',
      city: 'Bangor',
      posted_at: '2024-11-15T14:30:00',
      is_expired: false
    },
    {
      job_id: 3,
      application_url: 'https://example.com/apply/3',
      job_description: 'Experienced Data Analyst needed to help derive insights from complex datasets. You will work with stakeholders across the organization to identify trends, create visualizations, and support data-driven decision making.',
      job_title: 'Data Analyst',
      salary_min: '65000',
      salary_max: '95000',
      remote_pref: 'On-site',
      city: 'Augusta',
      posted_at: '2024-11-28T09:15:00',
      is_expired: false
    }
  ];

  return (
    <div style={{ maxWidth: '1200px', margin: '0 auto', padding: '20px' }}>
      <div style={{ textAlign: 'center', marginBottom: '30px' }}>
        <h1>Job Results</h1>
        {keyword && <p>Showing results for: <strong>{keyword}</strong></p>}
      </div>
      
      <div style={{ display: 'flex', flexDirection: 'column', gap: '20px' }}>
        {exampleJobs.map(job => (
          <JobCard key={job.job_id} job={job} />
        ))}
      </div>
      
      {/* TODO: Later fetch and render job cards based on the keyword from API */}
    </div>
  );
}