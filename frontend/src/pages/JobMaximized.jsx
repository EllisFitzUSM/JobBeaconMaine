export default function JobMaximized({ job, onClose }) {
    const formatSalary = (min, max) => {
        if (!min && !max) return 'Not specified';
        if (!max) return `$${min}+`;
        if (!min) return `Up to $${max}`;
        return `$${min} - $${max}`;
    };

    const formatDate = (dateString) => {
        if (!dateString) return 'N/A';
        const date = new Date(dateString);
        return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' });
    };

    return (
        <div
            className="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50 p-5"
            onClick={onClose}
        >
            <div
                className="bg-white rounded-lg shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-auto relative"
                onClick={(e) => e.stopPropagation()}
            >
                <button
                    onClick={onClose}
                    className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 text-2xl font-bold"
                >
                    ×
                </button>

                <div className="p-10">
                    <h1 className="text-3xl font-bold text-gray-900 mb-4">{job.job_title}</h1>

                    <div className="flex flex-wrap gap-4 text-gray-600 mb-6">
                        {job.city && <span>📍 {job.city}</span>}
                        {job.remote_pref && <span>💼 {job.remote_pref}</span>}
                        <span>📅 Posted: {formatDate(job.posted_at)}</span>
                    </div>

                    <div className="text-2xl font-semibold text-gray-800 mb-6">
                        {formatSalary(job.salary_min, job.salary_max)}
                    </div>

                    <h2 className="text-xl font-bold text-gray-900 mb-3">Job Description</h2>
                    <div className="text-gray-700 leading-relaxed whitespace-pre-wrap mb-6">
                        {job.job_description}
                    </div>

                    {(job.estimated_start_date || job.expires_at) && (
                        <div className="bg-gray-50 rounded-lg p-5 mb-6">
                            <h3 className="font-semibold text-gray-900 mb-2">Additional Information</h3>
                            {job.estimated_start_date && (
                                <div className="text-gray-700 mb-1">
                                    <strong>Estimated Start Date:</strong> {formatDate(job.estimated_start_date)}
                                </div>
                            )}
                            {job.expires_at && (
                                <div className="text-gray-700">
                                    <strong>Application Deadline:</strong> {formatDate(job.expires_at)}
                                </div>
                            )}
                        </div>
                    )}

                    {job.is_expired && (
                        <div className="bg-red-50 border border-red-200 rounded-lg p-4 mb-6 text-red-700">
                            <strong>Note:</strong> This job posting has expired
                        </div>
                    )}

                    {job.application_url && (
                        <div className="text-center">
                            <a
                                href={job.application_url}
                                target="_blank"
                                rel="noopener noreferrer"
                                className="inline-block bg-blue-600 hover:bg-blue-700 text-white font-semibold rounded-lg px-10 py-3 text-lg transition-colors"
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