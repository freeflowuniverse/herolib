module models

import time

// Sprint represents a Scrum sprint
pub struct Sprint {
	BaseModel
pub mut:
	name           string @[required]
	description    string
	project_id     int // Links to Project
	sprint_number  int // Sequential number within project
	status         SprintStatus
	start_date     time.Time
	end_date       time.Time
	goal           string         // Sprint goal
	capacity       f32            // Team capacity in hours
	commitment     int            // Story points committed
	completed      int            // Story points completed
	velocity       f32            // Actual velocity (story points / sprint duration)
	tasks          []int          // Task IDs in this sprint
	team_members   []SprintMember // Team members and their capacity
	retrospective  SprintRetrospective
	review_notes   string
	demo_url       string
	burndown_data  []BurndownPoint
	daily_standups []DailyStandup
	impediments    []Impediment
	custom_fields  map[string]string
}

// SprintStatus for sprint lifecycle
pub enum SprintStatus {
	planning
	active
	completed
	cancelled
}

// SprintMember represents a team member's participation in a sprint
pub struct SprintMember {
pub mut:
	user_id         int
	sprint_id       int
	capacity_hours  f32 // Available hours for this sprint
	allocated_hours f32 // Hours allocated to tasks
	actual_hours    f32 // Hours actually worked
	availability    f32 // Percentage availability (0.0 to 1.0)
	role            string
	joined_at       time.Time
}

// SprintRetrospective for sprint retrospective data
pub struct SprintRetrospective {
pub mut:
	conducted_at    time.Time
	facilitator_id  int
	participants    []int // User IDs
	what_went_well  []string
	what_went_wrong []string
	action_items    []ActionItem
	team_mood       f32 // 1.0 to 5.0 scale
	notes           string
}

// ActionItem for retrospective action items
pub struct ActionItem {
pub mut:
	description string
	assignee_id int
	due_date    time.Time
	status      ActionItemStatus
	created_at  time.Time
}

// ActionItemStatus for action item tracking
pub enum ActionItemStatus {
	open
	in_progress
	completed
	cancelled
}

// BurndownPoint for burndown chart data
pub struct BurndownPoint {
pub mut:
	date             time.Time
	remaining_points int
	remaining_hours  f32
	completed_points int
	added_points     int // Points added during sprint
	removed_points   int // Points removed during sprint
}

// DailyStandup for daily standup meeting data
pub struct DailyStandup {
pub mut:
	date             time.Time
	facilitator_id   int
	participants     []int // User IDs
	updates          []StandupUpdate
	impediments      []int // Impediment IDs discussed
	duration_minutes int
	notes            string
}

// StandupUpdate for individual team member updates
pub struct StandupUpdate {
pub mut:
	user_id   int
	yesterday string // What did you do yesterday?
	today     string // What will you do today?
	blockers  string // Any blockers or impediments?
	mood      f32    // 1.0 to 5.0 scale
}

// Impediment for tracking sprint impediments
pub struct Impediment {
pub mut:
	id          int
	sprint_id   int
	title       string
	description string
	reported_by int
	assigned_to int
	status      ImpedimentStatus
	severity    Priority
	reported_at time.Time
	resolved_at time.Time
	resolution  string
}

// ImpedimentStatus for impediment tracking
pub enum ImpedimentStatus {
	open
	in_progress
	resolved
	cancelled
}

// get_duration returns the sprint duration in days
pub fn (s Sprint) get_duration() int {
	if s.start_date.unix == 0 || s.end_date.unix == 0 {
		return 0
	}
	return int((s.end_date.unix - s.start_date.unix) / 86400)
}

// get_days_remaining returns the number of days remaining in the sprint
pub fn (s Sprint) get_days_remaining() int {
	if s.end_date.unix == 0 || s.status != .active {
		return 0
	}

	now := time.now()
	if now > s.end_date {
		return 0
	}

	return int((s.end_date.unix - now.unix) / 86400)
}

// get_days_elapsed returns the number of days elapsed in the sprint
pub fn (s Sprint) get_days_elapsed() int {
	if s.start_date.unix == 0 {
		return 0
	}

	now := time.now()
	if now < s.start_date {
		return 0
	}

	end_time := if s.status == .completed && s.end_date.unix > 0 { s.end_date } else { now }
	return int((end_time.unix - s.start_date.unix) / 86400)
}

// is_active checks if the sprint is currently active
pub fn (s Sprint) is_active() bool {
	return s.status == .active
}

// is_overdue checks if the sprint has passed its end date
pub fn (s Sprint) is_overdue() bool {
	return s.status == .active && time.now() > s.end_date
}

// get_completion_percentage returns the completion percentage based on story points
pub fn (s Sprint) get_completion_percentage() f32 {
	if s.commitment == 0 {
		return 0
	}
	return f32(s.completed) / f32(s.commitment) * 100
}

// get_velocity calculates the actual velocity for the sprint
pub fn (s Sprint) get_velocity() f32 {
	duration := s.get_duration()
	if duration == 0 {
		return 0
	}
	return f32(s.completed) / f32(duration)
}

// get_team_capacity returns the total team capacity in hours
pub fn (s Sprint) get_team_capacity() f32 {
	mut total := f32(0)
	for member in s.team_members {
		total += member.capacity_hours
	}
	return total
}

// get_team_utilization returns the team utilization percentage
pub fn (s Sprint) get_team_utilization() f32 {
	capacity := s.get_team_capacity()
	if capacity == 0 {
		return 0
	}

	mut actual := f32(0)
	for member in s.team_members {
		actual += member.actual_hours
	}

	return (actual / capacity) * 100
}

// add_task adds a task to the sprint
pub fn (mut s Sprint) add_task(task_id int, by_user_id int) {
	if task_id !in s.tasks {
		s.tasks << task_id
		s.update_timestamp(by_user_id)
	}
}

// remove_task removes a task from the sprint
pub fn (mut s Sprint) remove_task(task_id int, by_user_id int) {
	s.tasks = s.tasks.filter(it != task_id)
	s.update_timestamp(by_user_id)
}

// add_team_member adds a team member to the sprint
pub fn (mut s Sprint) add_team_member(user_id int, capacity_hours f32, availability f32, role string, by_user_id int) {
	// Check if member already exists
	for i, member in s.team_members {
		if member.user_id == user_id {
			// Update existing member
			s.team_members[i].capacity_hours = capacity_hours
			s.team_members[i].availability = availability
			s.team_members[i].role = role
			s.update_timestamp(by_user_id)
			return
		}
	}

	// Add new member
	s.team_members << SprintMember{
		user_id:        user_id
		sprint_id:      s.id
		capacity_hours: capacity_hours
		availability:   availability
		role:           role
		joined_at:      time.now()
	}
	s.update_timestamp(by_user_id)
}

// remove_team_member removes a team member from the sprint
pub fn (mut s Sprint) remove_team_member(user_id int, by_user_id int) {
	for i, member in s.team_members {
		if member.user_id == user_id {
			s.team_members.delete(i)
			s.update_timestamp(by_user_id)
			return
		}
	}
}

// start_sprint starts the sprint
pub fn (mut s Sprint) start_sprint(by_user_id int) {
	s.status = .active
	if s.start_date.unix == 0 {
		s.start_date = time.now()
	}
	s.update_timestamp(by_user_id)
}

// complete_sprint completes the sprint
pub fn (mut s Sprint) complete_sprint(by_user_id int) {
	s.status = .completed
	s.velocity = s.get_velocity()
	s.update_timestamp(by_user_id)
}

// cancel_sprint cancels the sprint
pub fn (mut s Sprint) cancel_sprint(by_user_id int) {
	s.status = .cancelled
	s.update_timestamp(by_user_id)
}

// update_commitment updates the story points commitment
pub fn (mut s Sprint) update_commitment(points int, by_user_id int) {
	s.commitment = points
	s.update_timestamp(by_user_id)
}

// update_completed updates the completed story points
pub fn (mut s Sprint) update_completed(points int, by_user_id int) {
	s.completed = points
	s.update_timestamp(by_user_id)
}

// add_burndown_point adds a burndown chart data point
pub fn (mut s Sprint) add_burndown_point(remaining_points int, remaining_hours f32, completed_points int, by_user_id int) {
	s.burndown_data << BurndownPoint{
		date:             time.now()
		remaining_points: remaining_points
		remaining_hours:  remaining_hours
		completed_points: completed_points
	}
	s.update_timestamp(by_user_id)
}

// add_daily_standup adds a daily standup record
pub fn (mut s Sprint) add_daily_standup(facilitator_id int, participants []int, updates []StandupUpdate, duration_minutes int, notes string, by_user_id int) {
	s.daily_standups << DailyStandup{
		date:             time.now()
		facilitator_id:   facilitator_id
		participants:     participants
		updates:          updates
		duration_minutes: duration_minutes
		notes:            notes
	}
	s.update_timestamp(by_user_id)
}

// add_impediment adds an impediment to the sprint
pub fn (mut s Sprint) add_impediment(title string, description string, reported_by int, severity Priority, by_user_id int) {
	s.impediments << Impediment{
		id:          s.impediments.len + 1
		sprint_id:   s.id
		title:       title
		description: description
		reported_by: reported_by
		status:      .open
		severity:    severity
		reported_at: time.now()
	}
	s.update_timestamp(by_user_id)
}

// resolve_impediment resolves an impediment
pub fn (mut s Sprint) resolve_impediment(impediment_id int, resolution string, by_user_id int) {
	for i, mut impediment in s.impediments {
		if impediment.id == impediment_id {
			s.impediments[i].status = .resolved
			s.impediments[i].resolved_at = time.now()
			s.impediments[i].resolution = resolution
			s.update_timestamp(by_user_id)
			return
		}
	}
}

// conduct_retrospective conducts a sprint retrospective
pub fn (mut s Sprint) conduct_retrospective(facilitator_id int, participants []int, went_well []string, went_wrong []string, action_items []ActionItem, team_mood f32, notes string, by_user_id int) {
	s.retrospective = SprintRetrospective{
		conducted_at:    time.now()
		facilitator_id:  facilitator_id
		participants:    participants
		what_went_well:  went_well
		what_went_wrong: went_wrong
		action_items:    action_items
		team_mood:       team_mood
		notes:           notes
	}
	s.update_timestamp(by_user_id)
}

// get_health_score calculates a health score for the sprint
pub fn (s Sprint) get_health_score() f32 {
	mut score := f32(1.0)

	// Completion rate (40% weight)
	completion := s.get_completion_percentage()
	if completion < 70 {
		score -= 0.4 * (70 - completion) / 70
	}

	// Team utilization (30% weight)
	utilization := s.get_team_utilization()
	if utilization < 80 || utilization > 120 {
		if utilization < 80 {
			score -= 0.3 * (80 - utilization) / 80
		} else {
			score -= 0.3 * (utilization - 120) / 120
		}
	}

	// Impediments (20% weight)
	open_impediments := s.impediments.filter(it.status == .open).len
	if open_impediments > 0 {
		score -= 0.2 * f32(open_impediments) / 5 // Assume 5+ impediments is very bad
	}

	// Schedule adherence (10% weight)
	if s.is_overdue() {
		score -= 0.1
	}

	if score < 0 {
		score = 0
	}

	return score
}

// get_health_status returns a human-readable health status
pub fn (s Sprint) get_health_status() string {
	health := s.get_health_score()
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
