// JobCard component
export default function JobCard({ job, onClick }) {
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
            onClick={() => onClick(job)}
            className="bg-white border border-gray-200 rounded-lg p-6 hover:shadow-lg transition-shadow cursor-pointer"
        >
            <div className="flex justify-between items-start mb-3">
                <h3 className="text-xl font-bold text-gray-900">{job.job_title}</h3>
                {job.is_expired && (
                    <span className="px-2 py-1 bg-red-100 text-red-700 text-xs rounded">Expired</span>
                )}
            </div>

            <div className="flex flex-wrap gap-2 mb-3">
                {job.city && (
                    <span className="px-2 py-1 bg-blue-100 text-blue-700 text-sm rounded">
                        {job.city}
                    </span>
                )}
                {job.remote_pref && (
                    <span className="px-2 py-1 bg-green-100 text-green-700 text-sm rounded">
                        {job.remote_pref}
                    </span>
                )}
            </div>

            <p className="text-gray-700 mb-4 line-clamp-2">{job.job_description}</p>

            <div className="flex justify-between items-center">
                <span className="font-semibold text-gray-800">
                    {formatSalary(job.salary_min, job.salary_max)}
                </span>
                <span className="text-sm text-gray-500">
                    Posted: {formatDate(job.posted_at)}
                </span>
            </div>
        </div>
    );
}