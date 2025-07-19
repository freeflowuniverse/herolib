module models

import time

// Milestone represents a significant project goal or deliverable
pub struct Milestone {
	BaseModel
pub mut:
	name                string @[required]
	description         string
	project_id          int // Links to Project
	status              MilestoneStatus
	priority            Priority
	milestone_type      MilestoneType
	due_date            time.Time
	completed_date      time.Time
	progress            f32         // 0.0 to 1.0
	owner_id            int         // User responsible for this milestone
	stakeholders        []int       // User IDs of stakeholders
	conditions          []Condition // Conditions that must be met
	deliverables        []Deliverable
	dependencies        []MilestoneDependency
	tasks               []int // Task IDs associated with this milestone
	budget              f64   // Budget allocated to this milestone
	actual_cost         f64   // Actual cost incurred
	estimated_hours     f32   // Estimated effort in hours
	actual_hours        f32   // Actual effort spent
	acceptance_criteria []string
	success_metrics     []SuccessMetric
	risks               []Risk
	approvals           []Approval
	communications      []Communication
	review_notes        string
	lessons_learned     string
	custom_fields       map[string]string
}

// MilestoneStatus for milestone lifecycle
pub enum MilestoneStatus {
	planning
	in_progress
	review
	completed
	cancelled
	on_hold
}

// MilestoneType for categorizing milestones
pub enum MilestoneType {
	deliverable
	decision_point
	review
	release
	contract
	regulatory
	internal
	external
}

// Condition represents a condition that must be met for milestone completion
pub struct Condition {
pub mut:
	id                  int
	milestone_id        int
	title               string
	description         string
	condition_type      ConditionType
	status              ConditionStatus
	required            bool // Is this condition mandatory?
	weight              f32  // Weight in milestone completion (0.0 to 1.0)
	assigned_to         int  // User responsible for this condition
	due_date            time.Time
	completed_date      time.Time
	verification_method string
	evidence            []string // URLs, file paths, or descriptions of evidence
	notes               string
	created_at          time.Time
	created_by          int
}

// ConditionType for categorizing conditions
pub enum ConditionType {
	deliverable
	approval
	test_passed
	documentation
	training
	compliance
	quality_gate
	performance
	security
	legal
}

// ConditionStatus for condition tracking
pub enum ConditionStatus {
	not_started
	in_progress
	pending_review
	completed
	failed
	waived
}

// Deliverable represents a specific deliverable for a milestone
pub struct Deliverable {
pub mut:
	id                  int
	milestone_id        int
	name                string
	description         string
	deliverable_type    DeliverableType
	status              DeliverableStatus
	assigned_to         int
	due_date            time.Time
	completed_date      time.Time
	file_path           string
	url                 string
	size_estimate       string
	quality_criteria    []string
	acceptance_criteria []string
	review_status       ReviewStatus
	reviewer_id         int
	review_notes        string
	version             string
	created_at          time.Time
	created_by          int
}

// DeliverableType for categorizing deliverables
pub enum DeliverableType {
	document
	software
	design
	report
	presentation
	training_material
	process
	template
	specification
	test_plan
}

// DeliverableStatus for deliverable tracking
pub enum DeliverableStatus {
	not_started
	in_progress
	draft
	review
	approved
	delivered
	rejected
}

// ReviewStatus for deliverable reviews
pub enum ReviewStatus {
	not_reviewed
	under_review
	approved
	rejected
	needs_revision
}

// MilestoneDependency represents dependencies between milestones
pub struct MilestoneDependency {
pub mut:
	milestone_id            int
	depends_on_milestone_id int
	dependency_type         DependencyType
	created_at              time.Time
	created_by              int
}

// SuccessMetric for measuring milestone success
pub struct SuccessMetric {
pub mut:
	id                 int
	milestone_id       int
	name               string
	description        string
	metric_type        MetricType
	target_value       f64
	actual_value       f64
	unit               string
	measurement_method string
	status             MetricStatus
	measured_at        time.Time
	measured_by        int
}

// MetricType for categorizing success metrics
pub enum MetricType {
	performance
	quality
	cost
	time
	satisfaction
	adoption
	revenue
	efficiency
}

// MetricStatus for metric tracking
pub enum MetricStatus {
	not_measured
	measuring
	target_met
	target_exceeded
	target_missed
}

// Risk represents a risk associated with a milestone
pub struct Risk {
pub mut:
	id               int
	milestone_id     int
	title            string
	description      string
	risk_type        RiskType
	probability      f32 // 0.0 to 1.0
	impact           f32 // 0.0 to 1.0
	risk_score       f32 // probability * impact
	status           RiskStatus
	owner_id         int
	mitigation_plan  string
	contingency_plan string
	identified_at    time.Time
	identified_by    int
	reviewed_at      time.Time
	reviewed_by      int
}

// RiskType for categorizing risks
pub enum RiskType {
	technical
	schedule
	budget
	resource
	quality
	external
	regulatory
	market
}

// RiskStatus for risk tracking
pub enum RiskStatus {
	identified
	analyzing
	mitigating
	monitoring
	closed
	realized
}

// Approval represents an approval required for milestone completion
pub struct Approval {
pub mut:
	id            int
	milestone_id  int
	title         string
	description   string
	approver_id   int
	approval_type ApprovalType
	status        ApprovalStatus
	requested_at  time.Time
	requested_by  int
	responded_at  time.Time
	comments      string
	conditions    string
	expires_at    time.Time
}

// ApprovalType for categorizing approvals
pub enum ApprovalType {
	technical
	business
	legal
	financial
	quality
	security
	regulatory
}

// ApprovalStatus for approval tracking
pub enum ApprovalStatus {
	pending
	approved
	rejected
	conditional
	expired
}

// Communication represents communication about the milestone
pub struct Communication {
pub mut:
	id                 int
	milestone_id       int
	title              string
	message            string
	communication_type CommunicationType
	sender_id          int
	recipients         []int
	sent_at            time.Time
	channel            string
	priority           Priority
	read_by            []int // User IDs who have read this communication
}

// CommunicationType for categorizing communications
pub enum CommunicationType {
	update
	alert
	reminder
	announcement
	request
	escalation
}

// is_overdue checks if the milestone is past its due date
pub fn (m Milestone) is_overdue() bool {
	if m.due_date.unix == 0 || m.status in [.completed, .cancelled] {
		return false
	}
	return time.now() > m.due_date
}

// get_completion_percentage calculates completion based on conditions
pub fn (m Milestone) get_completion_percentage() f32 {
	if m.conditions.len == 0 {
		return m.progress * 100
	}

	mut total_weight := f32(0)
	mut completed_weight := f32(0)

	for condition in m.conditions {
		weight := if condition.weight > 0 { condition.weight } else { 1.0 }
		total_weight += weight

		if condition.status == .completed {
			completed_weight += weight
		} else if condition.status == .waived {
			completed_weight += weight * 0.5 // Waived conditions count as half
		}
	}

	if total_weight == 0 {
		return 0
	}

	return (completed_weight / total_weight) * 100
}

// get_days_until_due returns days until due date
pub fn (m Milestone) get_days_until_due() int {
	if m.due_date.unix == 0 {
		return 0
	}

	now := time.now()
	if now > m.due_date {
		return 0
	}

	return int((m.due_date.unix - now.unix) / 86400)
}

// get_budget_variance returns budget variance
pub fn (m Milestone) get_budget_variance() f64 {
	return m.budget - m.actual_cost
}

// is_over_budget checks if milestone is over budget
pub fn (m Milestone) is_over_budget() bool {
	return m.budget > 0 && m.actual_cost > m.budget
}

// add_condition adds a condition to the milestone
pub fn (mut m Milestone) add_condition(title string, description string, condition_type ConditionType, required bool, weight f32, assigned_to int, due_date time.Time, by_user_id int) {
	m.conditions << Condition{
		id:             m.conditions.len + 1
		milestone_id:   m.id
		title:          title
		description:    description
		condition_type: condition_type
		status:         .not_started
		required:       required
		weight:         weight
		assigned_to:    assigned_to
		due_date:       due_date
		created_at:     time.now()
		created_by:     by_user_id
	}
	m.update_timestamp(by_user_id)
}

// complete_condition marks a condition as completed
pub fn (mut m Milestone) complete_condition(condition_id int, evidence []string, notes string, by_user_id int) bool {
	for i, mut condition in m.conditions {
		if condition.id == condition_id {
			m.conditions[i].status = .completed
			m.conditions[i].completed_date = time.now()
			m.conditions[i].evidence = evidence
			m.conditions[i].notes = notes
			m.update_timestamp(by_user_id)

			// Update milestone progress
			m.progress = m.get_completion_percentage() / 100
			return true
		}
	}
	return false
}

// add_deliverable adds a deliverable to the milestone
pub fn (mut m Milestone) add_deliverable(name string, description string, deliverable_type DeliverableType, assigned_to int, due_date time.Time, by_user_id int) {
	m.deliverables << Deliverable{
		id:               m.deliverables.len + 1
		milestone_id:     m.id
		name:             name
		description:      description
		deliverable_type: deliverable_type
		status:           .not_started
		assigned_to:      assigned_to
		due_date:         due_date
		created_at:       time.now()
		created_by:       by_user_id
	}
	m.update_timestamp(by_user_id)
}

// complete_deliverable marks a deliverable as completed
pub fn (mut m Milestone) complete_deliverable(deliverable_id int, file_path string, url string, version string, by_user_id int) bool {
	for i, mut deliverable in m.deliverables {
		if deliverable.id == deliverable_id {
			m.deliverables[i].status = .delivered
			m.deliverables[i].completed_date = time.now()
			m.deliverables[i].file_path = file_path
			m.deliverables[i].url = url
			m.deliverables[i].version = version
			m.update_timestamp(by_user_id)
			return true
		}
	}
	return false
}

// add_dependency adds a dependency to this milestone
pub fn (mut m Milestone) add_dependency(depends_on_milestone_id int, dep_type DependencyType, by_user_id int) {
	// Check if dependency already exists
	for dep in m.dependencies {
		if dep.depends_on_milestone_id == depends_on_milestone_id {
			return
		}
	}

	m.dependencies << MilestoneDependency{
		milestone_id:            m.id
		depends_on_milestone_id: depends_on_milestone_id
		dependency_type:         dep_type
		created_at:              time.now()
		created_by:              by_user_id
	}
	m.update_timestamp(by_user_id)
}

// add_stakeholder adds a stakeholder to the milestone
pub fn (mut m Milestone) add_stakeholder(user_id int, by_user_id int) {
	if user_id !in m.stakeholders {
		m.stakeholders << user_id
		m.update_timestamp(by_user_id)
	}
}

// request_approval requests an approval for the milestone
pub fn (mut m Milestone) request_approval(title string, description string, approver_id int, approval_type ApprovalType, expires_at time.Time, by_user_id int) {
	m.approvals << Approval{
		id:            m.approvals.len + 1
		milestone_id:  m.id
		title:         title
		description:   description
		approver_id:   approver_id
		approval_type: approval_type
		status:        .pending
		requested_at:  time.now()
		requested_by:  by_user_id
		expires_at:    expires_at
	}
	m.update_timestamp(by_user_id)
}

// approve grants an approval
pub fn (mut m Milestone) approve(approval_id int, comments string, conditions string, by_user_id int) bool {
	for i, mut approval in m.approvals {
		if approval.id == approval_id && approval.approver_id == by_user_id {
			m.approvals[i].status = if conditions.len > 0 { .conditional } else { .approved }
			m.approvals[i].responded_at = time.now()
			m.approvals[i].comments = comments
			m.approvals[i].conditions = conditions
			m.update_timestamp(by_user_id)
			return true
		}
	}
	return false
}

// start_milestone starts work on the milestone
pub fn (mut m Milestone) start_milestone(by_user_id int) {
	m.status = .in_progress
	m.update_timestamp(by_user_id)
}

// complete_milestone marks the milestone as completed
pub fn (mut m Milestone) complete_milestone(by_user_id int) {
	m.status = .completed
	m.completed_date = time.now()
	m.progress = 1.0
	m.update_timestamp(by_user_id)
}

// calculate_health returns a health score for the milestone
pub fn (m Milestone) calculate_health() f32 {
	mut score := f32(1.0)

	// Progress health (30% weight)
	if m.progress < 0.8 && m.status == .in_progress {
		score -= 0.3 * (0.8 - m.progress)
	}

	// Schedule health (25% weight)
	if m.is_overdue() {
		score -= 0.25
	} else {
		days_until_due := m.get_days_until_due()
		if days_until_due < 7 && m.progress < 0.9 {
			score -= 0.125
		}
	}

	// Budget health (20% weight)
	if m.is_over_budget() {
		variance_pct := (m.actual_cost - m.budget) / m.budget
		score -= 0.2 * variance_pct
	}

	// Conditions health (15% weight)
	overdue_conditions := m.conditions.filter(it.due_date.unix > 0 && time.now() > it.due_date
		&& it.status !in [.completed, .waived]).len
	if overdue_conditions > 0 {
		score -= 0.15 * f32(overdue_conditions) / f32(m.conditions.len)
	}

	// Approvals health (10% weight)
	pending_approvals := m.approvals.filter(it.status == .pending).len
	if pending_approvals > 0 {
		score -= 0.1 * f32(pending_approvals) / f32(m.approvals.len)
	}

	if score < 0 {
		score = 0
	}

	return score
}

// get_health_status returns a human-readable health status
pub fn (m Milestone) get_health_status() string {
	health := m.calculate_health()
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
