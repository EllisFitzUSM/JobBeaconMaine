import React from "react";
import "../styles/JobMaximized.css";

export default function JobMaximized({ job, onClose, onBack }) {
    const formatSalary = (min, max) => {
        if (!min && !max) return "Not specified";

        if (!max) return `$${Number(min).toLocaleString()}+`;
        if (!min) return `Up to $${Number(max).toLocaleString()}`;
        return `$${Number(min).toLocaleString()} - $${Number(max).toLocaleString()}`;
    };

    const formatDate = (dateString) => {
        if (!dateString) return "N/A";
        const date = new Date(dateString);
        return date.toLocaleDateString("en-US", {
            month: "short",
            day: "numeric",
            year: "numeric",
        });
    };

    return (
        <div className="job-max-overlay" onClick={onClose}>
            <div className="job-max-container" onClick={(e) => e.stopPropagation()}>

                {/* Back Button */}
                <button onClick={onBack} className="job-max-back-btn">
                    <span className="job-max-back-arrow">←</span>
                    Back to Results
                </button>

                {/* Close Button */}
                <button onClick={onClose} className="job-max-close-btn">
                    ×
                </button>

                <div className="job-max-content">
                    <h1 className="job-max-title">{job.job_title}</h1>

                    <div className="job-max-meta">
                        {job.city && <span>📍 {job.city}</span>}
                        {job.remote_pref && <span>💼 {job.remote_pref}</span>}
                        <span>📅 Posted: {formatDate(job.posted_at)}</span>
                    </div>

                    <div className="job-max-salary">
                        {formatSalary(job.salary_min, job.salary_max)}
                    </div>

                    <h2 className="job-max-section-title">Job Description</h2>
                    <div className="job-max-description">{job.job_description}</div>

                    {(job.estimated_start_date || job.expires_at) && (
                        <div className="job-max-info-box">
                            <h3>Additional Information</h3>
                            {job.estimated_start_date && (
                                <div className="job-max-info-item">
                                    <strong>Estimated Start Date:</strong>{" "}
                                    {formatDate(job.estimated_start_date)}
                                </div>
                            )}
                            {job.expires_at && (
                                <div className="job-max-info-item">
                                    <strong>Application Deadline:</strong>{" "}
                                    {formatDate(job.expires_at)}
                                </div>
                            )}
                        </div>
                    )}

                    {job.is_expired && (
                        <div className="job-max-expired-notice">
                            <strong>Note:</strong> This job posting has expired
                        </div>
                    )}

                    {job.application_url && (
                        <div className="job-max-apply-section">
                            <a
                                href={job.application_url}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="job-max-apply-btn"
                            >
                                Apply for this Position
                            </a>
                        </div>
                    )}
                </div>
            </div>
        </div>
    );
}