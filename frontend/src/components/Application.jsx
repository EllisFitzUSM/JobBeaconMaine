import React from "react";
import "../styles/JobCard.css";

export default function Application({ job, onClick, onApply }) {
    const formatSalary = (min, max) => {
        if (!min && !max) return "Not specified";
        if (!max) return `\$${Number(min).toLocaleString()}+`;
        if (!min) return `Up to \$${Number(max).toLocaleString()}`;
        return `\$${Number(min).toLocaleString()} - \$${Number(max).toLocaleString()}`;
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

    const handleApplyClick = (e) => {
        e.stopPropagation();
        if (onApply) {
            onApply(job);
        }
    };

    return (
        <div onClick={() => onClick(job)} className="job-card">
            <div className="job-card-header">
                <h3 className="job-card-title">{job.job_title}</h3>
                {job.is_expired && (
                    <span className="job-card-expired">Expired</span>
                )}
            </div>

            <div className="job-card-badges">
                {job.city && (
                    <span className="job-card-badge location">{job.city}</span>
                )}
                {job.remote_pref && (
                    <span className="job-card-badge remote">{job.remote_pref}</span>
                )}
            </div>

            <p className="job-card-description">{job.job_description}</p>

            <div className="job-card-footer">
                <span className="job-card-salary">
                    {formatSalary(job.salary_min, job.salary_max)}
                </span>
                <span className="job-card-date">
                    Posted: {formatDate(job.posted_at)}
                </span>
            </div>

            <button onClick={handleApplyClick} className="job-card-apply-btn">
                Apply
            </button>
        </div>
    );
}