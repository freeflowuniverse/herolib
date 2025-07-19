module models

import time

// Chat represents a communication channel or conversation
pub struct Chat {
	BaseModel
pub mut:
	name            string @[required]
	description     string
	chat_type       ChatType
	status          ChatStatus
	visibility      ChatVisibility
	owner_id        int // User who owns/created the chat
	members         []ChatMember
	messages        []Message
	project_id      int // Links to Project (optional)
	team_id         int // Links to Team (optional)
	customer_id     int // Links to Customer (optional)
	task_id         int // Links to Task (optional)
	issue_id        int // Links to Issue (optional)
	milestone_id    int // Links to Milestone (optional)
	sprint_id       int // Links to Sprint (optional)
	agenda_id       int // Links to Agenda (optional)
	settings        ChatSettings
	integrations    []ChatIntegration
	pinned_messages []int // Message IDs that are pinned
	archived_at     time.Time
	last_activity   time.Time
	message_count   int
	file_count      int
	custom_fields   map[string]string
}

// ChatType for categorizing chats
pub enum ChatType {
	direct_message
	group_chat
	channel
	announcement
	support
	project_chat
	team_chat
	customer_chat
	incident_chat
	meeting_chat
	thread
}

// ChatStatus for chat lifecycle
pub enum ChatStatus {
	active
	archived
	locked
	deleted
	suspended
}

// ChatVisibility for access control
pub enum ChatVisibility {
	public
	private
	restricted
	invite_only
}

// ChatMember represents a member of a chat
pub struct ChatMember {
pub mut:
	user_id               int
	chat_id               int
	role                  ChatRole
	permissions           []ChatPermission
	joined_at             time.Time
	last_read_at          time.Time
	last_read_message_id  int
	notification_settings NotificationSettings
	status                MemberStatus
	invited_by            int
	muted                 bool
	muted_until           time.Time
	custom_title          string
}

// ChatRole for member roles in chat
pub enum ChatRole {
	member
	moderator
	admin
	owner
	guest
	bot
}

// ChatPermission for granular permissions
pub enum ChatPermission {
	read_messages
	send_messages
	send_files
	send_links
	mention_all
	delete_messages
	edit_messages
	pin_messages
	invite_members
	remove_members
	manage_settings
	manage_integrations
}

// Message represents a chat message
pub struct Message {
	BaseModel
pub mut:
	chat_id         int
	sender_id       int
	content         string
	message_type    MessageType
	thread_id       int   // For threaded conversations
	reply_to_id     int   // Message this is replying to
	mentions        []int // User IDs mentioned in message
	attachments     []Attachment
	reactions       []Reaction
	edited_at       time.Time
	edited_by       int
	deleted_at      time.Time
	deleted_by      int
	pinned          bool
	pinned_at       time.Time
	pinned_by       int
	forwarded_from  int       // Original message ID if forwarded
	scheduled_at    time.Time // For scheduled messages
	delivery_status MessageDeliveryStatus
	read_by         []MessageRead
	priority        MessagePriority
	expires_at      time.Time // For ephemeral messages
	rich_content    RichContent
	system_message  bool   // Is this a system-generated message?
	bot_message     bool   // Is this from a bot?
	external_id     string // ID from external system (Slack, Teams, etc.)
}

// MessageType for categorizing messages
pub enum MessageType {
	text
	file
	image
	video
	audio
	link
	code
	quote
	poll
	announcement
	system
	bot_response
	task_update
	issue_update
	project_update
	meeting_summary
	reminder
}

// MessageDeliveryStatus for tracking message delivery
pub enum MessageDeliveryStatus {
	sending
	sent
	delivered
	read
	failed
}

// MessagePriority for message importance
pub enum MessagePriority {
	low
	normal
	high
	urgent
}

// MessageRead tracks who has read a message
pub struct MessageRead {
pub mut:
	user_id    int
	message_id int
	read_at    time.Time
	device     string
}

// Reaction represents an emoji reaction to a message
pub struct Reaction {
pub mut:
	id         int
	message_id int
	user_id    int
	emoji      string
	created_at time.Time
}

// RichContent for rich message formatting
pub struct RichContent {
pub mut:
	formatted_text string // HTML or markdown
	embeds         []Embed
	buttons        []ActionButton
	cards          []Card
	polls          []Poll
}

// Embed for rich content embeds
pub struct Embed {
pub mut:
	title         string
	description   string
	url           string
	thumbnail_url string
	image_url     string
	video_url     string
	author_name   string
	author_url    string
	color         string
	fields        []EmbedField
	footer_text   string
	timestamp     time.Time
}

// EmbedField for structured embed data
pub struct EmbedField {
pub mut:
	name   string
	value  string
	inline bool
}

// ActionButton for interactive messages
pub struct ActionButton {
pub mut:
	id           string
	label        string
	style        ButtonStyle
	action       string
	url          string
	confirmation string
}

// ButtonStyle for button appearance
pub enum ButtonStyle {
	default
	primary
	success
	warning
	danger
	link
}

// Card for rich card content
pub struct Card {
pub mut:
	title     string
	subtitle  string
	text      string
	image_url string
	actions   []ActionButton
	facts     []CardFact
}

// CardFact for key-value pairs in cards
pub struct CardFact {
pub mut:
	name  string
	value string
}

// Poll for interactive polls
pub struct Poll {
pub mut:
	id              int
	question        string
	options         []PollOption
	multiple_choice bool
	anonymous       bool
	expires_at      time.Time
	created_by      int
	created_at      time.Time
}

// PollOption for poll choices
pub struct PollOption {
pub mut:
	id         int
	text       string
	votes      []PollVote
	vote_count int
}

// PollVote for tracking poll votes
pub struct PollVote {
pub mut:
	user_id   int
	option_id int
	voted_at  time.Time
}

// ChatSettings for chat configuration
pub struct ChatSettings {
pub mut:
	allow_guests           bool
	require_approval       bool
	message_retention_days int
	file_retention_days    int
	max_members            int
	slow_mode_seconds      int
	profanity_filter       bool
	link_preview           bool
	emoji_reactions        bool
	threading              bool
	message_editing        bool
	message_deletion       bool
	file_uploads           bool
	external_sharing       bool
	read_receipts          bool
	typing_indicators      bool
	welcome_message        string
	rules                  []string
	auto_moderation        AutoModerationSettings
}

// AutoModerationSettings for automated moderation
pub struct AutoModerationSettings {
pub mut:
	enabled               bool
	spam_detection        bool
	profanity_filter      bool
	link_filtering        bool
	caps_limit            int
	rate_limit_messages   int
	rate_limit_seconds    int
	auto_timeout_duration int
	escalation_threshold  int
}

// NotificationSettings for member notification preferences
pub struct NotificationSettings {
pub mut:
	all_messages          bool
	mentions_only         bool
	direct_messages       bool
	keywords              []string
	mute_until            time.Time
	email_notifications   bool
	push_notifications    bool
	desktop_notifications bool
	sound_enabled         bool
	vibration_enabled     bool
}

// ChatIntegration for external service integrations
pub struct ChatIntegration {
pub mut:
	id               int
	chat_id          int
	integration_type IntegrationType
	name             string
	description      string
	webhook_url      string
	api_key          string
	settings         map[string]string
	enabled          bool
	created_by       int
	created_at       time.Time
	last_used        time.Time
	error_count      int
	last_error       string
}

// IntegrationType for different integrations
pub enum IntegrationType {
	webhook
	slack
	teams
	discord
	telegram
	email
	sms
	jira
	github
	gitlab
	jenkins
	monitoring
	custom
}

// get_unread_count returns unread message count for a user
pub fn (c Chat) get_unread_count(user_id int) int {
	// Find member's last read message
	mut last_read_id := 0
	for member in c.members {
		if member.user_id == user_id {
			last_read_id = member.last_read_message_id
			break
		}
	}

	// Count messages after last read
	return c.messages.filter(it.id > last_read_id && !it.system_message).len
}

// is_member checks if a user is a member of the chat
pub fn (c Chat) is_member(user_id int) bool {
	for member in c.members {
		if member.user_id == user_id && member.status == .active {
			return true
		}
	}
	return false
}

// has_permission checks if a user has a specific permission
pub fn (c Chat) has_permission(user_id int, permission ChatPermission) bool {
	for member in c.members {
		if member.user_id == user_id && member.status == .active {
			return permission in member.permissions
		}
	}
	return false
}

// get_member_role returns a user's role in the chat
pub fn (c Chat) get_member_role(user_id int) ?ChatRole {
	for member in c.members {
		if member.user_id == user_id {
			return member.role
		}
	}
	return none
}

// add_member adds a member to the chat
pub fn (mut c Chat) add_member(user_id int, role ChatRole, permissions []ChatPermission, invited_by int, by_user_id int) {
	// Check if member already exists
	for i, member in c.members {
		if member.user_id == user_id {
			// Update existing member
			c.members[i].role = role
			c.members[i].permissions = permissions
			c.members[i].status = .active
			c.update_timestamp(by_user_id)
			return
		}
	}

	// Add new member
	c.members << ChatMember{
		user_id:               user_id
		chat_id:               c.id
		role:                  role
		permissions:           permissions
		joined_at:             time.now()
		invited_by:            invited_by
		status:                .active
		notification_settings: NotificationSettings{
			all_messages:        true
			mentions_only:       false
			direct_messages:     true
			email_notifications: true
			push_notifications:  true
		}
	}
	c.update_timestamp(by_user_id)
}

// remove_member removes a member from the chat
pub fn (mut c Chat) remove_member(user_id int, by_user_id int) {
	for i, member in c.members {
		if member.user_id == user_id {
			c.members[i].status = .inactive
			c.update_timestamp(by_user_id)
			return
		}
	}
}

// send_message sends a message to the chat
pub fn (mut c Chat) send_message(sender_id int, content string, message_type MessageType, thread_id int, reply_to_id int, mentions []int, attachments []Attachment, by_user_id int) int {
	message := Message{
		id:              c.messages.len + 1
		chat_id:         c.id
		sender_id:       sender_id
		content:         content
		message_type:    message_type
		thread_id:       thread_id
		reply_to_id:     reply_to_id
		mentions:        mentions
		attachments:     attachments
		delivery_status: .sent
		priority:        .normal
		created_at:      time.now()
		created_by:      by_user_id
	}

	c.messages << message
	c.message_count++
	c.last_activity = time.now()
	c.update_timestamp(by_user_id)

	return message.id
}

// edit_message edits an existing message
pub fn (mut c Chat) edit_message(message_id int, new_content string, by_user_id int) bool {
	for i, mut message in c.messages {
		if message.id == message_id {
			c.messages[i].content = new_content
			c.messages[i].edited_at = time.now()
			c.messages[i].edited_by = by_user_id
			c.update_timestamp(by_user_id)
			return true
		}
	}
	return false
}

// delete_message deletes a message
pub fn (mut c Chat) delete_message(message_id int, by_user_id int) bool {
	for i, mut message in c.messages {
		if message.id == message_id {
			c.messages[i].deleted_at = time.now()
			c.messages[i].deleted_by = by_user_id
			c.update_timestamp(by_user_id)
			return true
		}
	}
	return false
}

// pin_message pins a message
pub fn (mut c Chat) pin_message(message_id int, by_user_id int) bool {
	for i, mut message in c.messages {
		if message.id == message_id {
			c.messages[i].pinned = true
			c.messages[i].pinned_at = time.now()
			c.messages[i].pinned_by = by_user_id
			if message_id !in c.pinned_messages {
				c.pinned_messages << message_id
			}
			c.update_timestamp(by_user_id)
			return true
		}
	}
	return false
}

// add_reaction adds a reaction to a message
pub fn (mut c Chat) add_reaction(message_id int, user_id int, emoji string, by_user_id int) {
	for i, mut message in c.messages {
		if message.id == message_id {
			// Check if user already reacted with this emoji
			for reaction in message.reactions {
				if reaction.user_id == user_id && reaction.emoji == emoji {
					return
				}
			}

			c.messages[i].reactions << Reaction{
				id:         message.reactions.len + 1
				message_id: message_id
				user_id:    user_id
				emoji:      emoji
				created_at: time.now()
			}
			c.update_timestamp(by_user_id)
			return
		}
	}
}

// mark_as_read marks messages as read for a user
pub fn (mut c Chat) mark_as_read(user_id int, message_id int, by_user_id int) {
	// Update member's last read message
	for i, mut member in c.members {
		if member.user_id == user_id {
			c.members[i].last_read_at = time.now()
			c.members[i].last_read_message_id = message_id
			break
		}
	}

	// Add read receipt to message
	for i, mut message in c.messages {
		if message.id == message_id {
			// Check if already marked as read
			for read in message.read_by {
				if read.user_id == user_id {
					return
				}
			}

			c.messages[i].read_by << MessageRead{
				user_id:    user_id
				message_id: message_id
				read_at:    time.now()
			}
			break
		}
	}

	c.update_timestamp(by_user_id)
}

// mute_chat mutes the chat for a user
pub fn (mut c Chat) mute_chat(user_id int, until time.Time, by_user_id int) {
	for i, mut member in c.members {
		if member.user_id == user_id {
			c.members[i].muted = true
			c.members[i].muted_until = until
			c.update_timestamp(by_user_id)
			return
		}
	}
}

// archive_chat archives the chat
pub fn (mut c Chat) archive_chat(by_user_id int) {
	c.status = .archived
	c.archived_at = time.now()
	c.update_timestamp(by_user_id)
}

// add_integration adds an external integration
pub fn (mut c Chat) add_integration(integration_type IntegrationType, name string, webhook_url string, settings map[string]string, by_user_id int) {
	c.integrations << ChatIntegration{
		id:               c.integrations.len + 1
		chat_id:          c.id
		integration_type: integration_type
		name:             name
		webhook_url:      webhook_url
		settings:         settings
		enabled:          true
		created_by:       by_user_id
		created_at:       time.now()
	}
	c.update_timestamp(by_user_id)
}

// get_activity_level returns chat activity level
pub fn (c Chat) get_activity_level() string {
	if c.messages.len == 0 {
		return 'Inactive'
	}

	// Messages in last 24 hours
	day_ago := time.now().unix - 86400
	recent_messages := c.messages.filter(it.created_at.unix > day_ago).len

	if recent_messages > 50 {
		return 'Very Active'
	} else if recent_messages > 20 {
		return 'Active'
	} else if recent_messages > 5 {
		return 'Moderate'
	} else if recent_messages > 0 {
		return 'Low'
	} else {
		return 'Inactive'
	}
}

// get_engagement_score calculates engagement score
pub fn (c Chat) get_engagement_score() f32 {
	if c.members.len == 0 || c.messages.len == 0 {
		return 0
	}

	// Calculate unique participants in last 7 days
	week_ago := time.now().unix - (86400 * 7)
	recent_messages := c.messages.filter(it.created_at.unix > week_ago)

	mut unique_senders := map[int]bool{}
	for message in recent_messages {
		unique_senders[message.sender_id] = true
	}

	participation_rate := f32(unique_senders.len) / f32(c.members.len)

	// Calculate message frequency
	messages_per_day := f32(recent_messages.len) / 7.0
	frequency_score := if messages_per_day > 10 { 1.0 } else { messages_per_day / 10.0 }

	// Calculate reaction engagement
	mut total_reactions := 0
	for message in recent_messages {
		total_reactions += message.reactions.len
	}
	reaction_rate := if recent_messages.len > 0 {
		f32(total_reactions) / f32(recent_messages.len)
	} else {
		0
	}
	reaction_score := if reaction_rate > 2 { 1.0 } else { reaction_rate / 2.0 }

	// Weighted average
	return (participation_rate * 0.5) + (frequency_score * 0.3) + (reaction_score * 0.2)
}
