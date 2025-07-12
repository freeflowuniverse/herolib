module models

// Task/Project Management System with Integrated CRM
// 
// This module provides a comprehensive task and project management system
// with integrated CRM capabilities, built using V language best practices.
//
// Architecture:
// - Root objects stored as JSON in database tables with matching names
// - Each root object has incremental IDs for efficient querying
// - Additional indexing for searchable properties
// - V structs with public fields and base class inheritance
// - Support for SQLite and PostgreSQL via V's relational ORM
//
// Key Features:
// - Scrum methodology support with sprints, story points, velocity tracking
// - Milestone management with conditions and deliverables
// - Comprehensive task management with dependencies and time tracking
// - Issue tracking with severity levels and resolution workflow
// - Team management with capacity planning and skill tracking
// - Customer relationship management (CRM) integration
// - Calendar/agenda management with recurrence and reminders
// - Real-time chat and communication system
// - Rich metadata support with tags, custom fields, and comments
// - Audit trail with created/updated timestamps and user tracking
// - Health scoring and analytics for projects, sprints, and teams

// Re-export all model types for easy importing
pub use base { BaseModel }
pub use enums { 
	Priority, ProjectStatus, TaskStatus, TaskType, IssueStatus, 
	IssueType, SprintStatus, MilestoneStatus, TeamStatus, 
	AgendaStatus, ChatStatus, UserRole, CustomerStatus,
	SkillLevel, NotificationChannel, ReminderType
}
pub use subobjects { 
	Contact, Address, TimeEntry, Comment, Attachment, 
	Condition, Notification, Reaction, Reminder, 
	UserPreferences, ProjectRole, Label
}
pub use user { User }
pub use customer { Customer }
pub use project { Project, ProjectBillingType, RiskLevel, ProjectMethodology }
pub use task { Task, TaskDependency, DependencyType, Severity }
pub use sprint { 
	Sprint, SprintMember, SprintRetrospective, ActionItem, 
	BurndownPoint, DailyStandup, Impediment
}
pub use milestone { 
	Milestone, Condition as MilestoneCondition, Deliverable, 
	MilestoneDependency, SuccessMetric, Risk, Approval, Communication
}
pub use issue { 
	Issue, IssueLink, Workaround, TestCase, LogEntry,
	IssueFrequency, WorkaroundComplexity, TestType, LogLevel
}
pub use team { 
	Team, TeamMember, TeamSkill, TeamCapacity, WorkingHours,
	Holiday, TeamRitual, TeamGoal, TeamMetric, TeamTool
}
pub use agenda { 
	Agenda, Attendee, Resource, Recurrence, AgendaItem, Decision,
	AttendanceType, ResponseStatus, ResourceType, RecurrencePattern
}
pub use chat { 
	Chat, ChatMember, Message, Reaction, RichContent, Poll,
	ChatSettings, NotificationSettings, ChatIntegration
}

// System Overview:
//
// ROOT OBJECTS (stored as JSON with incremental IDs):
// 1. User - System users with roles, skills, and preferences
// 2. Customer - CRM entities with contacts and project relationships  
// 3. Project - Main project containers with budgets and timelines
// 4. Task - Work items with dependencies and time tracking
// 5. Sprint - Scrum sprints with velocity and burndown tracking
// 6. Milestone - Project goals with conditions and deliverables
// 7. Issue - Problem tracking with severity and resolution workflow
// 8. Team - Groups with capacity planning and skill management
// 9. Agenda - Calendar events with recurrence and attendee management
// 10. Chat - Communication channels with threading and integrations
//
// RELATIONSHIPS:
// - Projects belong to Customers and contain Tasks, Sprints, Milestones, Issues
// - Tasks can be assigned to Sprints and Milestones, have dependencies
// - Users are members of Teams and can be assigned to Projects/Tasks
// - Sprints contain Tasks and track team velocity
// - Milestones have Conditions that must be met for completion
// - Issues can be linked to Projects, Tasks, or other Issues
// - Agenda items can be linked to any entity for meeting context
// - Chats can be associated with Projects, Teams, or specific entities
//
// DATA STORAGE:
// - Each root object stored as JSON in database table matching struct name
// - Incremental integer IDs for efficient querying and relationships
// - Additional indexes on searchable fields (status, assignee, dates, etc.)
// - Soft delete support via BaseModel.deleted_at field
// - Full audit trail with created_at, updated_at, created_by, updated_by
//
// EXTENSIBILITY:
// - Custom fields support via map[string]string on all root objects
// - Tag system for flexible categorization
// - Metadata field for additional structured data
// - Plugin architecture via integrations (webhooks, external APIs)
//
// PERFORMANCE CONSIDERATIONS:
// - JSON storage allows flexible schema evolution
// - Targeted indexing on frequently queried fields
// - Pagination support for large datasets
// - Caching layer for frequently accessed data
// - Async processing for heavy operations (notifications, reports)

// Database table names (matching struct names in lowercase)
pub const table_names = [
	'user',
	'customer', 
	'project',
	'task',
	'sprint',
	'milestone',
	'issue',
	'team',
	'agenda',
	'chat'
]

// Searchable fields that should be indexed
pub const indexed_fields = {
	'user': ['email', 'username', 'status', 'role']
	'customer': ['name', 'email', 'status', 'type']
	'project': ['name', 'status', 'priority', 'customer_id', 'project_manager_id']
	'task': ['title', 'status', 'priority', 'assignee_id', 'project_id', 'sprint_id']
	'sprint': ['name', 'status', 'project_id', 'start_date', 'end_date']
	'milestone': ['name', 'status', 'priority', 'project_id', 'due_date']
	'issue': ['title', 'status', 'priority', 'severity', 'assignee_id', 'project_id']
	'team': ['name', 'status', 'team_type', 'manager_id']
	'agenda': ['title', 'status', 'start_time', 'organizer_id', 'project_id']
	'chat': ['name', 'chat_type', 'status', 'owner_id', 'project_id', 'team_id']
}

// Common query patterns for efficient database access
pub const common_queries = {
	'active_projects': 'status IN ("planning", "active")'
	'overdue_tasks': 'due_date < NOW() AND status NOT IN ("done", "cancelled")'
	'current_sprints': 'status = "active" AND start_date <= NOW() AND end_date >= NOW()'
	'pending_milestones': 'status IN ("planning", "in_progress") AND due_date IS NOT NULL'
	'open_issues': 'status NOT IN ("resolved", "closed", "cancelled")'
	'active_teams': 'status = "performing"'
	'upcoming_meetings': 'start_time > NOW() AND status = "scheduled"'
	'active_chats': 'status = "active" AND last_activity > DATE_SUB(NOW(), INTERVAL 30 DAY)'
}

// System-wide constants
pub const (
	max_file_size = 100 * 1024 * 1024 // 100MB
	max_message_length = 10000
	max_comment_length = 5000
	max_description_length = 10000
	default_page_size = 50
	max_page_size = 1000
	session_timeout_hours = 24
	password_min_length = 8
	username_min_length = 3
	team_max_members = 100
	project_max_tasks = 10000
	sprint_max_duration_days = 30
	chat_max_members = 1000
)

// Validation helpers
pub fn validate_email(email string) bool {
	// Simple email validation - in production use proper regex
	return email.contains('@') && email.contains('.')
}

pub fn validate_username(username string) bool {
	return username.len >= username_min_length && username.is_alnum()
}

pub fn validate_password(password string) bool {
	return password.len >= password_min_length
}

// Utility functions for common operations
pub fn generate_slug(text string) string {
	return text.to_lower().replace(' ', '-').replace_each(['/', '\\', '?', '#'], '-')
}

pub fn truncate_text(text string, max_length int) string {
	if text.len <= max_length {
		return text
	}
	return text[..max_length-3] + '...'
}

pub fn format_duration(minutes int) string {
	if minutes < 60 {
		return '${minutes}m'
	}
	hours := minutes / 60
	remaining_minutes := minutes % 60
	if remaining_minutes == 0 {
		return '${hours}h'
	}
	return '${hours}h ${remaining_minutes}m'
}

pub fn calculate_business_days(start_date time.Time, end_date time.Time) int {
	mut days := 0
	mut current := start_date
	
	for current.unix <= end_date.unix {
		weekday := current.weekday()
		if weekday != 0 && weekday != 6 { // Not Sunday (0) or Saturday (6)
			days++
		}
		current = time.Time{unix: current.unix + 86400} // Add one day
	}
	
	return days
}

// Health scoring weights for different metrics
pub const health_weights = {
	'project': {
		'budget': 0.25
		'schedule': 0.25  
		'progress': 0.25
		'risk': 0.25
	}
	'sprint': {
		'completion': 0.4
		'utilization': 0.3
		'impediments': 0.2
		'schedule': 0.1
	}
	'team': {
		'utilization': 0.25
		'velocity': 0.25
		'goals': 0.25
		'stability': 0.25
	}
	'milestone': {
		'progress': 0.3
		'schedule': 0.25
		'budget': 0.2
		'conditions': 0.15
		'approvals': 0.1
	}
}

// Default notification settings
pub const default_notifications = {
	'task_assigned': true
	'task_due_soon': true
	'task_overdue': true
	'project_milestone': true
	'sprint_started': true
	'sprint_ended': true
	'meeting_reminder': true
	'chat_mention': true
	'issue_assigned': true
	'approval_requested': true
}

// System roles and their default permissions
pub const role_permissions = {
	'admin': ['*'] // All permissions
	'manager': [
		'create_project', 'edit_project', 'delete_project',
		'create_team', 'edit_team', 'manage_team_members',
		'create_milestone', 'edit_milestone',
		'view_reports', 'export_data'
	]
	'lead': [
		'create_task', 'edit_task', 'assign_task',
		'create_sprint', 'edit_sprint',
		'create_issue', 'edit_issue',
		'schedule_meeting', 'create_chat'
	]
	'member': [
		'view_project', 'create_task', 'edit_own_task',
		'create_issue', 'comment', 'upload_file',
		'join_meeting', 'send_message'
	]
	'viewer': [
		'view_project', 'view_task', 'view_issue',
		'view_meeting', 'read_message'
	]
}