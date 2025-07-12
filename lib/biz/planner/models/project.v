module models

import time

// Project represents a project in the system
pub struct Project {
	BaseModel
pub mut:
	name            string @[required]
	description     string
	customer_id     int    // Links to Customer
	status          ProjectStatus
	priority        Priority
	start_date      time.Time
	end_date        time.Time
	actual_start_date time.Time
	actual_end_date   time.Time
	budget          f64
	actual_cost     f64
	estimated_hours f32
	actual_hours    f32
	progress        f32    // 0.0 to 1.0
	milestones      []int  // Milestone IDs
	sprints         []int  // Sprint IDs
	tasks           []int  // Task IDs
	issues          []int  // Issue IDs
	team_members    []ProjectRole // Users and their roles in this project
	project_manager_id int    // User ID of project manager
	client_contact_id  int    // Contact ID from customer
	billing_type    ProjectBillingType
	hourly_rate     f64    // Default hourly rate for this project
	currency        string = 'USD'
	risk_level      RiskLevel
	methodology     ProjectMethodology
	repository_url  string
	documentation_url string
	slack_channel   string
	custom_fields   map[string]string
	labels          []int  // Label IDs
}

// ProjectBillingType for different billing models
pub enum ProjectBillingType {
	fixed_price
	time_and_materials
	retainer
	milestone_based
}

// RiskLevel for project risk assessment
pub enum RiskLevel {
	low
	medium
	high
	critical
}

// ProjectMethodology for project management approach
pub enum ProjectMethodology {
	agile
	scrum
	kanban
	waterfall
	hybrid
}

// get_duration returns the planned duration in days
pub fn (p Project) get_duration() int {
	if p.start_date.unix == 0 || p.end_date.unix == 0 {
		return 0
	}
	return int((p.end_date.unix - p.start_date.unix) / 86400) // 86400 seconds in a day
}

// get_actual_duration returns the actual duration in days
pub fn (p Project) get_actual_duration() int {
	if p.actual_start_date.unix == 0 || p.actual_end_date.unix == 0 {
		return 0
	}
	return int((p.actual_end_date.unix - p.actual_start_date.unix) / 86400)
}

// is_overdue checks if the project is past its end date
pub fn (p Project) is_overdue() bool {
	if p.end_date.unix == 0 || p.status in [.completed, .cancelled] {
		return false
	}
	return time.now() > p.end_date
}

// is_over_budget checks if the project is over budget
pub fn (p Project) is_over_budget() bool {
	return p.budget > 0 && p.actual_cost > p.budget
}

// get_budget_variance returns the budget variance (positive = under budget, negative = over budget)
pub fn (p Project) get_budget_variance() f64 {
	return p.budget - p.actual_cost
}

// get_budget_variance_percentage returns the budget variance as a percentage
pub fn (p Project) get_budget_variance_percentage() f64 {
	if p.budget == 0 {
		return 0
	}
	return (p.get_budget_variance() / p.budget) * 100
}

// get_schedule_variance returns schedule variance in days
pub fn (p Project) get_schedule_variance() int {
	planned_duration := p.get_duration()
	if planned_duration == 0 {
		return 0
	}
	
	if p.status == .completed {
		actual_duration := p.get_actual_duration()
		return planned_duration - actual_duration
	}
	
	// For ongoing projects, calculate based on current date
	if p.start_date.unix == 0 {
		return 0
	}
	
	days_elapsed := int((time.now().unix - p.start_date.unix) / 86400)
	expected_progress := f32(days_elapsed) / f32(planned_duration)
	
	if expected_progress == 0 {
		return 0
	}
	
	schedule_performance := p.progress / expected_progress
	return int(f32(planned_duration) * (schedule_performance - 1))
}

// add_team_member adds a user to the project with a specific role
pub fn (mut p Project) add_team_member(user_id int, role string, permissions []string) {
	// Check if user is already in the project
	for i, member in p.team_members {
		if member.user_id == user_id {
			// Update existing member
			p.team_members[i].role = role
			p.team_members[i].permissions = permissions
			return
		}
	}
	
	// Add new member
	p.team_members << ProjectRole{
		user_id: user_id
		project_id: p.id
		role: role
		permissions: permissions
		assigned_at: time.now()
	}
}

// remove_team_member removes a user from the project
pub fn (mut p Project) remove_team_member(user_id int) bool {
	for i, member in p.team_members {
		if member.user_id == user_id {
			p.team_members.delete(i)
			return true
		}
	}
	return false
}

// has_team_member checks if a user is a team member
pub fn (p Project) has_team_member(user_id int) bool {
	for member in p.team_members {
		if member.user_id == user_id {
			return true
		}
	}
	return false
}

// get_team_member_role returns the role of a team member
pub fn (p Project) get_team_member_role(user_id int) ?string {
	for member in p.team_members {
		if member.user_id == user_id {
			return member.role
		}
	}
	return none
}

// add_milestone adds a milestone to the project
pub fn (mut p Project) add_milestone(milestone_id int) {
	if milestone_id !in p.milestones {
		p.milestones << milestone_id
	}
}

// remove_milestone removes a milestone from the project
pub fn (mut p Project) remove_milestone(milestone_id int) {
	p.milestones = p.milestones.filter(it != milestone_id)
}

// add_sprint adds a sprint to the project
pub fn (mut p Project) add_sprint(sprint_id int) {
	if sprint_id !in p.sprints {
		p.sprints << sprint_id
	}
}

// remove_sprint removes a sprint from the project
pub fn (mut p Project) remove_sprint(sprint_id int) {
	p.sprints = p.sprints.filter(it != sprint_id)
}

// add_task adds a task to the project
pub fn (mut p Project) add_task(task_id int) {
	if task_id !in p.tasks {
		p.tasks << task_id
	}
}

// remove_task removes a task from the project
pub fn (mut p Project) remove_task(task_id int) {
	p.tasks = p.tasks.filter(it != task_id)
}

// add_issue adds an issue to the project
pub fn (mut p Project) add_issue(issue_id int) {
	if issue_id !in p.issues {
		p.issues << issue_id
	}
}

// remove_issue removes an issue from the project
pub fn (mut p Project) remove_issue(issue_id int) {
	p.issues = p.issues.filter(it != issue_id)
}

// start_project marks the project as started
pub fn (mut p Project) start_project(by_user_id int) {
	p.status = .active
	p.actual_start_date = time.now()
	p.update_timestamp(by_user_id)
}

// complete_project marks the project as completed
pub fn (mut p Project) complete_project(by_user_id int) {
	p.status = .completed
	p.actual_end_date = time.now()
	p.progress = 1.0
	p.update_timestamp(by_user_id)
}

// cancel_project marks the project as cancelled
pub fn (mut p Project) cancel_project(by_user_id int) {
	p.status = .cancelled
	p.update_timestamp(by_user_id)
}

// put_on_hold puts the project on hold
pub fn (mut p Project) put_on_hold(by_user_id int) {
	p.status = .on_hold
	p.update_timestamp(by_user_id)
}

// update_progress updates the project progress
pub fn (mut p Project) update_progress(progress f32, by_user_id int) {
	if progress < 0 {
		p.progress = 0
	} else if progress > 1 {
		p.progress = 1
	} else {
		p.progress = progress
	}
	p.update_timestamp(by_user_id)
}

// add_cost adds to the actual cost
pub fn (mut p Project) add_cost(amount f64, by_user_id int) {
	p.actual_cost += amount
	p.update_timestamp(by_user_id)
}

// add_hours adds to the actual hours
pub fn (mut p Project) add_hours(hours f32, by_user_id int) {
	p.actual_hours += hours
	p.update_timestamp(by_user_id)
}

// calculate_health returns a project health score based on various factors
pub fn (p Project) calculate_health() f32 {
	mut score := f32(1.0)
	
	// Budget health (25% weight)
	if p.budget > 0 {
		budget_ratio := p.actual_cost / p.budget
		if budget_ratio > 1.2 {
			score -= 0.25
		} else if budget_ratio > 1.0 {
			score -= 0.125
		}
	}
	
	// Schedule health (25% weight)
	schedule_var := p.get_schedule_variance()
	if schedule_var < -7 { // More than a week behind
		score -= 0.25
	} else if schedule_var < 0 {
		score -= 0.125
	}
	
	// Progress health (25% weight)
	if p.progress < 0.5 && p.status == .active {
		days_elapsed := int((time.now().unix - p.start_date.unix) / 86400)
		total_days := p.get_duration()
		if total_days > 0 {
			expected_progress := f32(days_elapsed) / f32(total_days)
			if p.progress < expected_progress * 0.8 {
				score -= 0.25
			}
		}
	}
	
	// Risk level (25% weight)
	match p.risk_level {
		.critical { score -= 0.25 }
		.high { score -= 0.125 }
		else {}
	}
	
	if score < 0 {
		score = 0
	}
	
	return score
}

// get_health_status returns a human-readable health status
pub fn (p Project) get_health_status() string {
	health := p.calculate_health()
	if health >= 0.8 {
		return 'Excellent'
	} else if health >= 0.6 {
		return 'Good'
	} else if health >= 0.4 {
		return 'At Risk'
	} else {
		return 'Critical'
	}
}