import React, { useState, useRef, useEffect } from "react";
import "../styles/SkillSelector.css";

export default function SkillSelector({ selectedSkills, onChange, maxSkills = 10 }) {
    const [allSkills, setAllSkills] = useState([]);
    const [inputValue, setInputValue] = useState("");
    const [filteredSkills, setFilteredSkills] = useState([]);
    const [showDropdown, setShowDropdown] = useState(false);
    const inputRef = useRef(null);
    const dropdownRef = useRef(null);

    // Fetch all skills on mount
    useEffect(() => {
        const fetchSkills = async () => {
            try {
                const res = await fetch("http://127.0.0.1:5000/api/skills/");
                const data = await res.json();
                if (data.success) {
                    // Assuming skills come back as array of objects with skill_name
                    const skillNames = data.skills.map(s => s.skill_name || s.Skill_Name || s);
                    setAllSkills(skillNames);
                }
            } catch (err) {
                console.error("Failed to fetch skills:", err);
            }
        };
        fetchSkills();
    }, []);

    // Handle click outside to close dropdown
    useEffect(() => {
        const handleClickOutside = (e) => {
            if (
                dropdownRef.current &&
                !dropdownRef.current.contains(e.target) &&
                inputRef.current &&
                !inputRef.current.contains(e.target)
            ) {
                setShowDropdown(false);
            }
        };
        document.addEventListener("mousedown", handleClickOutside);
        return () => document.removeEventListener("mousedown", handleClickOutside);
    }, []);

    // Filter skills as user types
    const handleInputChange = (e) => {
        const value = e.target.value;
        setInputValue(value);

        if (value.trim() === "") {
            setFilteredSkills([]);
            setShowDropdown(false);
        } else {
            const matches = allSkills.filter(
                (skill) =>
                    skill.toLowerCase().includes(value.toLowerCase()) &&
                    !selectedSkills.includes(skill)
            );
            setFilteredSkills(matches);
            setShowDropdown(matches.length > 0);
        }
    };

    // Add skill
    const handleSkillSelect = (skill) => {
        if (selectedSkills.length < maxSkills && !selectedSkills.includes(skill)) {
            onChange([...selectedSkills, skill]);
            setInputValue("");
            setShowDropdown(false);
            setFilteredSkills([]);
        }
    };

    // Remove skill
    const handleSkillRemove = (skillToRemove) => {
        onChange(selectedSkills.filter((s) => s !== skillToRemove));
    };

    const isMaxReached = selectedSkills.length >= maxSkills;

    return (
        <div className="skill-selector-container">
            {/* Selected Skills Tags */}
            {selectedSkills.length > 0 && (
                <div className="skill-tags">
                    {selectedSkills.map((skill, idx) => (
                        <div key={idx} className="skill-tag">
                            <span>{skill}</span>
                            <button
                                type="button"
                                onClick={() => handleSkillRemove(skill)}
                                className="skill-tag-remove"
                            >
                                ×
                            </button>
                        </div>
                    ))}
                </div>
            )}

            {/* Input */}
            <div className="skill-input-wrapper">
                <input
                    ref={inputRef}
                    type="text"
                    value={inputValue}
                    onChange={handleInputChange}
                    placeholder={
                        isMaxReached
                            ? `Maximum ${maxSkills} skills reached`
                            : "Search and add skills..."
                    }
                    className="skill-input"
                    disabled={isMaxReached}
                    autoComplete="off"
                />

                {/* Dropdown */}
                {showDropdown && !isMaxReached && (
                    <ul ref={dropdownRef} className="skill-dropdown">
                        {filteredSkills.map((skill, idx) => (
                            <li
                                key={idx}
                                onClick={() => handleSkillSelect(skill)}
                                className="skill-dropdown-item"
                            >
                                {skill}
                            </li>
                        ))}
                    </ul>
                )}
            </div>

            {/* Limit Notice */}
            <p className="skill-limit-notice">
                {selectedSkills.length} / {maxSkills} skills selected
            </p>
        </div>
    );
}