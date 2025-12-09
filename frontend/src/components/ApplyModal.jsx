import React from "react";
import "../styles/ApplyModal.css";

export default function ApplyModal({ job, onConfirm, onCancel }) {
    const handleOverlayClick = (e) => {
        if (e.target === e.currentTarget) {
            onCancel();
        }
    };

    return (
        <div className="modal-overlay" onClick={handleOverlayClick}>
            <div className="modal-card">
                <h3 className="modal-title">Did you apply to this job?</h3>
                <p className="modal-message">
                    You're about to be redirected to apply for <strong>{job.job_title}</strong>.
                    After applying, please confirm so we can track your application.
                </p>
                <div className="modal-buttons">
                    <button onClick={() => onConfirm(true)} className="modal-btn yes">
                        Yes, I Applied
                    </button>
                    <button onClick={() => onConfirm(false)} className="modal-btn no">
                        No, I Didn't
                    </button>
                </div>
            </div>
        </div>
    );
}