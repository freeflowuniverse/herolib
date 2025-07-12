module models

import time

// Team represents a group of users working together
pub struct Team {
	BaseModel
pub mut:
	name            string @[required]
	description     string
	team_type       TeamType
	status          TeamStatus
	manager_id      int    // Team manager/lead
	members         []TeamMember
	projects        []int  // Project IDs this team works on
	skills          []TeamSkill // Skills available in this team
	capacity        TeamCapacity
	location        string
	time_zone       string
	working_hours   WorkingHours
	holidays        []Holiday
	rituals         []TeamRitual
	goals           []TeamGoal
	metrics         []TeamMetric
	budget          f64    // Team budget
	cost_per_hour   f64    // Average cost per hour
	utilization_target f32 // Target utilization percentage
	velocity_target int    // Target velocity (story points per sprint)
	slack_channel   string
	email_list      string
	wiki_url        string
	repository_urls []string
	tools           []TeamTool
	custom_fields   map[string]string
}

// TeamType for categorizing teams
pub enum TeamType {
	development
	qa
	design
	product
	marketing
	sales
	support
	operations
	security
	data
	research
	management
	cross_functional
}

// TeamStatus for team lifecycle
pub enum TeamStatus {
	forming
	storming
	norming
	performing
	adjourning
	disbanded
}

// TeamMember represents a user's membership in a team
pub struct TeamMember {
pub mut:
	user_id         int
	team_id         int
	role            string
	permissions     []string
	capacity_hours  f32    // Weekly capacity in hours
	allocation      f32    // Percentage allocation to this team (0.0 to 1.0)
	hourly_rate     f64    // Member's hourly rate
	start_date      time.Time
	end_date        time.Time // For temporary members
	status          MemberStatus
	skills          []int  // Skill IDs
	certifications  []string
	seniority_level SeniorityLevel
	performance_rating f32 // 1.0 to 5.0 scale
	last_review     time.Time
	notes           string
}

// MemberStatus for team member status
pub enum MemberStatus {
	active
	inactive
	on_leave
	temporary
	contractor
	intern
}

// SeniorityLevel for team member experience
pub enum SeniorityLevel {
	intern
	junior
	mid_level
	senior
	lead
	principal
	architect
}

// TeamSkill represents a skill available in the team
pub struct TeamSkill {
pub mut:
	skill_id        int
	team_id         int
	skill_name      string
	category        string
	proficiency_levels map[int]SkillLevel // user_id -> proficiency level
	demand          f32    // How much this skill is needed (0.0 to 1.0)
	supply          f32    // How much this skill is available (0.0 to 1.0)
	gap             f32    // Skill gap (demand - supply)
	training_plan   string
}

// TeamCapacity represents team capacity planning
pub struct TeamCapacity {
pub mut:
	total_hours_per_week f32
	available_hours_per_week f32
	committed_hours_per_week f32
	utilization_percentage f32
	velocity_last_sprint int
	velocity_average int
	velocity_trend f32 // Positive = improving, negative = declining
	capacity_by_skill map[string]f32 // skill -> available hours
	capacity_forecast []CapacityForecast
}

// CapacityForecast for future capacity planning
pub struct CapacityForecast {
pub mut:
	period_start    time.Time
	period_end      time.Time
	forecast_type   ForecastType
	total_capacity  f32
	available_capacity f32
	planned_allocation f32
	confidence_level f32 // 0.0 to 1.0
	assumptions     []string
	risks           []string
}

// ForecastType for capacity forecasting
pub enum ForecastType {
	weekly
	monthly
	quarterly
	yearly
}

// WorkingHours represents team working schedule
pub struct WorkingHours {
pub mut:
	monday_start    string // "09:00"
	monday_end      string // "17:00"
	tuesday_start   string
	tuesday_end     string
	wednesday_start string
	wednesday_end   string
	thursday_start  string
	thursday_end    string
	friday_start    string
	friday_end      string
	saturday_start  string
	saturday_end    string
	sunday_start    string
	sunday_end      string
	break_duration  int    // Minutes
	lunch_duration  int    // Minutes
	flexible_hours  bool
	core_hours_start string
	core_hours_end  string
}

// Holiday represents team holidays and time off
pub struct Holiday {
pub mut:
	name            string
	date            time.Time
	end_date        time.Time // For multi-day holidays
	holiday_type    HolidayType
	affects_members []int  // User IDs affected (empty = all)
	description     string
}

// HolidayType for categorizing holidays
pub enum HolidayType {
	public
	company
	team
	personal
	sick_leave
	vacation
	training
	conference
}

// TeamRitual represents recurring team activities
pub struct TeamRitual {
pub mut:
	id              int
	team_id         int
	name            string
	description     string
	ritual_type     RitualType
	frequency       RitualFrequency
	duration_minutes int
	participants    []int  // User IDs
	facilitator_id  int
	location        string
	virtual_link    string
	agenda          string
	outcomes        []string
	next_occurrence time.Time
	last_occurrence time.Time
	active          bool
}

// RitualType for categorizing team rituals
pub enum RitualType {
	standup
	retrospective
	planning
	review
	one_on_one
	team_meeting
	training
	social
	demo
	sync
}

// RitualFrequency for ritual scheduling
pub enum RitualFrequency {
	daily
	weekly
	biweekly
	monthly
	quarterly
	ad_hoc
}

// TeamGoal represents team objectives
pub struct TeamGoal {
pub mut:
	id              int
	team_id         int
	title           string
	description     string
	goal_type       GoalType
	target_value    f64
	current_value   f64
	unit            string
	start_date      time.Time
	target_date     time.Time
	status          GoalStatus
	owner_id        int
	progress        f32    // 0.0 to 1.0
	milestones      []GoalMilestone
	success_criteria []string
}

// GoalType for categorizing team goals
pub enum GoalType {
	performance
	quality
	delivery
	learning
	process
	culture
	business
	technical
}

// GoalStatus for goal tracking
pub enum GoalStatus {
	draft
	active
	achieved
	missed
	cancelled
	deferred
}

// GoalMilestone represents milestones within team goals
pub struct GoalMilestone {
pub mut:
	title           string
	target_date     time.Time
	target_value    f64
	achieved        bool
	achieved_date   time.Time
	achieved_value  f64
}

// TeamMetric represents team performance metrics
pub struct TeamMetric {
pub mut:
	id              int
	team_id         int
	name            string
	description     string
	metric_type     MetricType
	current_value   f64
	target_value    f64
	unit            string
	trend           f32    // Positive = improving
	last_updated    time.Time
	history         []MetricDataPoint
	benchmark       f64    // Industry/company benchmark
}

// MetricDataPoint for metric history
pub struct MetricDataPoint {
pub mut:
	timestamp       time.Time
	value           f64
	period          string // "2024-Q1", "2024-01", etc.
}

// TeamTool represents tools used by the team
pub struct TeamTool {
pub mut:
	name            string
	category        ToolCategory
	url             string
	description     string
	cost_per_month  f64
	licenses        int
	admin_contact   string
	renewal_date    time.Time
	satisfaction_rating f32 // 1.0 to 5.0
}

// ToolCategory for categorizing team tools
pub enum ToolCategory {
	development
	testing
	design
	communication
	project_management
	documentation
	monitoring
	deployment
	security
	analytics
}

// get_total_capacity returns total team capacity in hours per week
pub fn (t Team) get_total_capacity() f32 {
	mut total := f32(0)
	for member in t.members {
		if member.status == .active {
			total += member.capacity_hours * member.allocation
		}
	}
	return total
}

// get_available_capacity returns available capacity considering current commitments
pub fn (t Team) get_available_capacity() f32 {
	total := t.get_total_capacity()
	return total - t.capacity.committed_hours_per_week
}

// get_utilization returns current team utilization percentage
pub fn (t Team) get_utilization() f32 {
	total := t.get_total_capacity()
	if total == 0 {
		return 0
	}
	return (t.capacity.committed_hours_per_week / total) * 100
}

// get_member_count returns the number of active team members
pub fn (t Team) get_member_count() int {
	return t.members.filter(it.status == .active).len
}

// get_average_seniority returns the average seniority level
pub fn (t Team) get_average_seniority() f32 {
	active_members := t.members.filter(it.status == .active)
	if active_members.len == 0 {
		return 0
	}
	
	mut total := f32(0)
	for member in active_members {
		match member.seniority_level {
			.intern { total += 1 }
			.junior { total += 2 }
			.mid_level { total += 3 }
			.senior { total += 4 }
			.lead { total += 5 }
			.principal { total += 6 }
			.architect { total += 7 }
		}
	}
	
	return total / f32(active_members.len)
}

// add_member adds a member to the team
pub fn (mut t Team) add_member(user_id int, role string, capacity_hours f32, allocation f32, hourly_rate f64, seniority_level SeniorityLevel, by_user_id int) {
	// Check if member already exists
	for i, member in t.members {
		if member.user_id == user_id {
			// Update existing member
			t.members[i].role = role
			t.members[i].capacity_hours = capacity_hours
			t.members[i].allocation = allocation
			t.members[i].hourly_rate = hourly_rate
			t.members[i].seniority_level = seniority_level
			t.members[i].status = .active
			t.update_timestamp(by_user_id)
			return
		}
	}
	
	// Add new member
	t.members << TeamMember{
		user_id: user_id
		team_id: t.id
		role: role
		capacity_hours: capacity_hours
		allocation: allocation
		hourly_rate: hourly_rate
		start_date: time.now()
		status: .active
		seniority_level: seniority_level
	}
	t.update_timestamp(by_user_id)
}

// remove_member removes a member from the team
pub fn (mut t Team) remove_member(user_id int, by_user_id int) {
	for i, member in t.members {
		if member.user_id == user_id {
			t.members[i].status = .inactive
			t.members[i].end_date = time.now()
			t.update_timestamp(by_user_id)
			return
		}
	}
}

// update_member_capacity updates a member's capacity
pub fn (mut t Team) update_member_capacity(user_id int, capacity_hours f32, allocation f32, by_user_id int) {
	for i, member in t.members {
		if member.user_id == user_id {
			t.members[i].capacity_hours = capacity_hours
			t.members[i].allocation = allocation
			t.update_timestamp(by_user_id)
			return
		}
	}
}

// add_skill adds a skill to the team
pub fn (mut t Team) add_skill(skill_id int, skill_name string, category string, demand f32, by_user_id int) {
	// Check if skill already exists
	for i, skill in t.skills {
		if skill.skill_id == skill_id {
			t.skills[i].demand = demand
			t.update_timestamp(by_user_id)
			return
		}
	}
	
	t.skills << TeamSkill{
		skill_id: skill_id
		team_id: t.id
		skill_name: skill_name
		category: category
		demand: demand
		proficiency_levels: map[int]SkillLevel{}
	}
	t.update_timestamp(by_user_id)
}

// update_skill_proficiency updates a member's proficiency in a skill
pub fn (mut t Team) update_skill_proficiency(skill_id int, user_id int, level SkillLevel, by_user_id int) {
	for i, mut skill in t.skills {
		if skill.skill_id == skill_id {
			t.skills[i].proficiency_levels[user_id] = level
			t.update_timestamp(by_user_id)
			return
		}
	}
}

// add_goal adds a goal to the team
pub fn (mut t Team) add_goal(title string, description string, goal_type GoalType, target_value f64, unit string, target_date time.Time, owner_id int, by_user_id int) {
	t.goals << TeamGoal{
		id: t.goals.len + 1
		team_id: t.id
		title: title
		description: description
		goal_type: goal_type
		target_value: target_value
		unit: unit
		start_date: time.now()
		target_date: target_date
		status: .active
		owner_id: owner_id
	}
	t.update_timestamp(by_user_id)
}

// update_goal_progress updates progress on a team goal
pub fn (mut t Team) update_goal_progress(goal_id int, current_value f64, by_user_id int) {
	for i, mut goal in t.goals {
		if goal.id == goal_id {
			t.goals[i].current_value = current_value
			if goal.target_value > 0 {
				t.goals[i].progress = f32(current_value / goal.target_value)
				if t.goals[i].progress >= 1.0 {
					t.goals[i].status = .achieved
				}
			}
			t.update_timestamp(by_user_id)
			return
		}
	}
}

// add_ritual adds a recurring ritual to the team
pub fn (mut t Team) add_ritual(name string, description string, ritual_type RitualType, frequency RitualFrequency, duration_minutes int, facilitator_id int, by_user_id int) {
	t.rituals << TeamRitual{
		id: t.rituals.len + 1
		team_id: t.id
		name: name
		description: description
		ritual_type: ritual_type
		frequency: frequency
		duration_minutes: duration_minutes
		facilitator_id: facilitator_id
		active: true
	}
	t.update_timestamp(by_user_id)
}

// calculate_team_health returns a team health score
pub fn (t Team) calculate_team_health() f32 {
	mut score := f32(1.0)
	
	// Utilization health (25% weight)
	utilization := t.get_utilization()
	if utilization < 70 || utilization > 90 {
		if utilization < 70 {
			score -= 0.25 * (70 - utilization) / 70
		} else {
			score -= 0.25 * (utilization - 90) / 90
		}
	}
	
	// Velocity trend (25% weight)
	if t.capacity.velocity_trend < -0.1 {
		score -= 0.25 * (-t.capacity.velocity_trend)
	}
	
	// Goal achievement (25% weight)
	active_goals := t.goals.filter(it.status == .active)
	if active_goals.len > 0 {
		mut avg_progress := f32(0)
		for goal in active_goals {
			avg_progress += goal.progress
		}
		avg_progress /= f32(active_goals.len)
		if avg_progress < 0.7 {
			score -= 0.25 * (0.7 - avg_progress)
		}
	}
	
	// Team stability (25% weight)
	active_members := t.members.filter(it.status == .active)
	if active_members.len < 3 {
		score -= 0.25 * (3 - f32(active_members.len)) / 3
	}
	
	if score < 0 {
		score = 0
	}
	
	return score
}

// get_health_status returns a human-readable health status
pub fn (t Team) get_health_status() string {
	health := t.calculate_team_health()
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

// get_cost_per_week returns the team's cost per week
pub fn (t Team) get_cost_per_week() f64 {
	mut total_cost := f64(0)
	for member in t.members {
		if member.status == .active {
			weekly_hours := member.capacity_hours * member.allocation
			total_cost += f64(weekly_hours) * member.hourly_rate
		}
	}
	return total_cost
}

// forecast_capacity forecasts team capacity for a future period
pub fn (t Team) forecast_capacity(start_date time.Time, end_date time.Time, forecast_type ForecastType) CapacityForecast {
	current_capacity := t.get_total_capacity()
	
	// Simple forecast based on current capacity
	// In a real implementation, this would consider planned hires, departures, etc.
	return CapacityForecast{
		period_start: start_date
		period_end: end_date
		forecast_type: forecast_type
		total_capacity: current_capacity
		available_capacity: t.get_available_capacity()
		planned_allocation: t.capacity.committed_hours_per_week
		confidence_level: 0.8
		assumptions: ['Current team composition remains stable', 'No major holidays or time off']
		risks: ['Team member departures', 'Increased project demands']
	}
}