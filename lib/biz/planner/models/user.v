module models

import time

// User represents a system user (employees, clients, etc.)
pub struct User {
	BaseModel
pub mut:
	username      string @[required; unique]
	email         string @[required; unique]
	first_name    string @[required]
	last_name     string @[required]
	display_name  string
	avatar_url    string
	role          UserRole
	status        UserStatus
	timezone      string = 'UTC'
	preferences   UserPreferences
	teams         []int // Team IDs this user belongs to
	skills        []string
	hourly_rate   f64
	hire_date     time.Time
	last_login    time.Time
	password_hash string // For authentication
	phone         string
	mobile        string
	department    string
	job_title     string
	manager_id    int   // User ID of manager
	reports       []int // User IDs of direct reports
}

// get_full_name returns the user's full name
pub fn (u User) get_full_name() string {
	return '${u.first_name} ${u.last_name}'
}

// get_display_name returns the display name or full name if display name is empty
pub fn (u User) get_display_name() string {
	if u.display_name.len > 0 {
		return u.display_name
	}
	return u.get_full_name()
}

// is_admin checks if the user has admin role
pub fn (u User) is_admin() bool {
	return u.role == .admin
}

// is_project_manager checks if the user can manage projects
pub fn (u User) is_project_manager() bool {
	return u.role in [.admin, .project_manager]
}

// can_manage_users checks if the user can manage other users
pub fn (u User) can_manage_users() bool {
	return u.role == .admin
}

// add_skill adds a skill if it doesn't already exist
pub fn (mut u User) add_skill(skill string) {
	if skill !in u.skills {
		u.skills << skill
	}
}

// remove_skill removes a skill if it exists
pub fn (mut u User) remove_skill(skill string) {
	u.skills = u.skills.filter(it != skill)
}

// has_skill checks if the user has a specific skill
pub fn (u User) has_skill(skill string) bool {
	return skill in u.skills
}

// add_to_team adds the user to a team
pub fn (mut u User) add_to_team(team_id int) {
	if team_id !in u.teams {
		u.teams << team_id
	}
}

// remove_from_team removes the user from a team
pub fn (mut u User) remove_from_team(team_id int) {
	u.teams = u.teams.filter(it != team_id)
}

// is_in_team checks if the user is in a specific team
pub fn (u User) is_in_team(team_id int) bool {
	return team_id in u.teams
}

// update_last_login updates the last login timestamp
pub fn (mut u User) update_last_login() {
	u.last_login = time.now()
}

// is_active checks if the user is active and not suspended
pub fn (u User) is_active() bool {
	return u.status == .active && u.is_active
}

// suspend suspends the user account
pub fn (mut u User) suspend(by_user_id int) {
	u.status = .suspended
	u.update_timestamp(by_user_id)
}

// activate activates the user account
pub fn (mut u User) activate(by_user_id int) {
	u.status = .active
	u.update_timestamp(by_user_id)
}

// set_manager sets the user's manager
pub fn (mut u User) set_manager(manager_id int, by_user_id int) {
	u.manager_id = manager_id
	u.update_timestamp(by_user_id)
}

// add_report adds a direct report
pub fn (mut u User) add_report(report_id int) {
	if report_id !in u.reports {
		u.reports << report_id
	}
}

// remove_report removes a direct report
pub fn (mut u User) remove_report(report_id int) {
	u.reports = u.reports.filter(it != report_id)
}

// get_initials returns the user's initials
pub fn (u User) get_initials() string {
	mut initials := ''
	if u.first_name.len > 0 {
		initials += u.first_name[0].ascii_str()
	}
	if u.last_name.len > 0 {
		initials += u.last_name[0].ascii_str()
	}
	return initials.to_upper()
}

// calculate_total_hours calculates total hours worked in a time period
pub fn (u User) calculate_total_hours(start_date time.Time, end_date time.Time, time_entries []TimeEntry) f32 {
	mut total := f32(0)
	for entry in time_entries {
		if entry.user_id == u.id && entry.start_time >= start_date && entry.end_time <= end_date {
			total += entry.duration
		}
	}
	return total
}

// calculate_billable_hours calculates billable hours in a time period
pub fn (u User) calculate_billable_hours(start_date time.Time, end_date time.Time, time_entries []TimeEntry) f32 {
	mut total := f32(0)
	for entry in time_entries {
		if entry.user_id == u.id && entry.billable && entry.start_time >= start_date
			&& entry.end_time <= end_date {
			total += entry.duration
		}
	}
	return total
}
