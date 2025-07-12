#!/usr/bin/env -S v -n -w -cg -gc none  -cc tcc -d use_openssl -enable-globals run


import db.sqlite
import db.pg
import time
// import lib.biz.planner.models

// Enums for better type safety
pub enum ChatType {
	direct_message
	group_chat
	project_chat
	team_chat
	customer_chat
	support_chat
	announcement
}

pub enum ChatStatus {
	active
	inactive
	archived
	deleted
}

pub enum ChatVisibility {
	private
	public
	restricted
}

pub enum MessageType {
	text
	image
	file
	audio
	video
	system
	notification
}

pub enum MessagePriority {
	low
	normal
	high
	urgent
}

pub enum MessageDeliveryStatus {
	pending
	sent
	delivered
	read
	failed
}

pub enum MemberRole {
	owner
	admin
	moderator
	member
	guest
}

pub enum MemberStatus {
	active
	inactive
	banned
	left
}

// Parameter structs using @[params]
@[params]
pub struct ChatNewArgs {
pub mut:
	name        string
	description ?string
	chat_type   ChatType
	visibility  ChatVisibility = .private
	owner_id    int
	project_id  ?int
	team_id     ?int
	customer_id ?int
	task_id     ?int
	issue_id    ?int
	milestone_id ?int
	sprint_id   ?int
	agenda_id   ?int
	created_by  int
}

@[params]
pub struct MessageNewArgs {
pub mut:
	chat_id      int
	sender_id    int
	content      string
	message_type MessageType = .text
	thread_id    ?int
	reply_to_id  ?int
	priority     MessagePriority = .normal
	scheduled_at ?u32
	expires_at   ?u32
	created_by   int
}

@[params]
pub struct ChatMemberNewArgs {
pub mut:
	chat_id    int
	user_id    int
	role       MemberRole = .member
	invited_by ?int
}

@[params]
pub struct ChatListArgs {
pub mut:
	chat_type ChatType = ChatType.direct_message // default value, will be ignored if not set
	status    ChatStatus = ChatStatus.active     // default value, will be ignored if not set
	owner_id  int
	limit     int = 50
	offset    int
}

@[params]
pub struct ChatSearchArgs {
pub mut:
	search_term string
	limit       int = 20
}

// Chat model for ORM - simplified version with ORM attributes
@[table: 'chat']
pub struct ChatORM {
pub mut:
	id              int           @[primary; sql: serial]
	name            string
	description     ?string
	chat_type       ChatType
	status          ChatStatus
	visibility      ChatVisibility
	owner_id        int
	project_id      ?int
	team_id         ?int
	customer_id     ?int
	task_id         ?int
	issue_id        ?int
	milestone_id    ?int
	sprint_id       ?int
	agenda_id       ?int
	last_activity   u32
	message_count   int
	file_count      int
	archived_at     u32
	created_at      u32
	updated_at      u32
	created_by      int
	updated_by      int
	version         int
	deleted_at      u32
}

// Message model for ORM
@[table: 'message']
pub struct MessageORM {
pub mut:
	id              int                   @[primary; sql: serial]
	chat_id         int
	sender_id       int
	content         string
	message_type    MessageType
	thread_id       ?int
	reply_to_id     ?int
	edited_at       u32
	edited_by       ?int
	deleted_at      u32
	deleted_by      ?int
	pinned          bool
	pinned_at       u32
	pinned_by       ?int
	forwarded_from  ?int
	scheduled_at    u32
	delivery_status MessageDeliveryStatus
	priority        MessagePriority
	expires_at      u32
	system_message  bool
	bot_message     bool
	external_id     ?string
	created_at      u32
	updated_at      u32
	created_by      int
	updated_by      int
	version         int
}

// ChatMember model for ORM
@[table: 'chat_member']
pub struct ChatMemberORM {
pub mut:
	id              int          @[primary; sql: serial]
	user_id         int
	chat_id         int
	role            MemberRole
	joined_at       u32
	last_read_at    u32
	last_read_message_id ?int
	status          MemberStatus
	invited_by      ?int
	muted           bool
	muted_until     u32
	custom_title    ?string
	created_at      u32
	updated_at      u32
}

// ChatRepository using V ORM
pub struct ChatRepository {
mut:
	db sqlite.DB
}

// PostgreSQL version
pub struct ChatRepositoryPG {
mut:
	db pg.DB
}

// Initialize SQLite database with ORM
pub fn new_chat_repository(db_path string) !ChatRepository {
	mut db := sqlite.connect(db_path)!
	
	// Create tables using ORM
	sql db {
		create table ChatORM
		create table MessageORM
		create table ChatMemberORM
	}!
	
	return ChatRepository{db: db}
}

// Initialize PostgreSQL database with ORM
pub fn new_chat_repository_pg(host string, port int, user string, password string, dbname string) !ChatRepositoryPG {
	mut db := pg.connect(host: host, port: port, user: user, password: password, dbname: dbname)!
	
	// Create tables using ORM
	sql db {
		create table ChatORM
		create table MessageORM
		create table ChatMemberORM
	}!
	
	return ChatRepositoryPG{db: db}
}

// Create a new chat using ORM
pub fn (mut repo ChatRepository) create_chat(args_ ChatNewArgs) !ChatORM {
	mut args := args_
	now := u32(time.now().unix())
	mut chat := ChatORM{
		name: args.name
		description: args.description
		chat_type: args.chat_type
		status: .active
		visibility: args.visibility
		owner_id: args.owner_id
		project_id: args.project_id
		team_id: args.team_id
		customer_id: args.customer_id
		task_id: args.task_id
		issue_id: args.issue_id
		milestone_id: args.milestone_id
		sprint_id: args.sprint_id
		agenda_id: args.agenda_id
		created_by: args.created_by
		updated_by: args.created_by
		created_at: now
		updated_at: now
		deleted_at: 0
		last_activity: 0
		message_count: 0
		file_count: 0
		archived_at: 0
		version: 1
	}
	
	// Insert using ORM
	sql repo.db {
		insert chat into ChatORM
	}!
	
	// Get the last inserted ID
	chat.id = repo.db.last_id()
	
	return chat
}

// Get chat by ID using ORM
pub fn (repo ChatRepository) get_chat(id int) !ChatORM {
	chat := sql repo.db {
		select from ChatORM where id == id && deleted_at == 0
	}!
	
	if chat.len == 0 {
		return error('Chat not found')
	}
	
	return chat[0]
}

// Update chat using ORM
pub fn (mut repo ChatRepository) update_chat(mut chat ChatORM, updated_by int) ! {
	chat.updated_at = u32(time.now().unix())
	chat.updated_by = updated_by
	chat.version++
	
	sql repo.db {
		update ChatORM set name = chat.name, description = chat.description,
		status = chat.status, updated_at = chat.updated_at,
		updated_by = chat.updated_by, version = chat.version
		where id == chat.id
	}!
}

// Delete chat (soft delete) using ORM
pub fn (mut repo ChatRepository) delete_chat(id int, deleted_by int) ! {
	now := u32(time.now().unix())
	
	sql repo.db {
		update ChatORM set deleted_at = now, updated_by = deleted_by, updated_at = now
		where id == id
	}!
}

// List chats with filtering using ORM
pub fn (repo ChatRepository) list_chats(args_ ChatListArgs) ![]ChatORM {
	mut args := args_
	mut chats := []ChatORM{}
	
	if args.owner_id > 0 {
		chats = sql repo.db {
			select from ChatORM where owner_id == args.owner_id && deleted_at == 0
			order by updated_at desc limit args.limit offset args.offset
		}!
	} else {
		chats = sql repo.db {
			select from ChatORM where deleted_at == 0
			order by updated_at desc limit args.limit offset args.offset
		}!
	}
	
	return chats
}

// Search chats by name using ORM
pub fn (repo ChatRepository) search_chats(args_ ChatSearchArgs) ![]ChatORM {
	mut args := args_
	chats := sql repo.db {
		select from ChatORM where name like '%${args.search_term}%' && deleted_at == 0
		order by updated_at desc limit args.limit
	}!
	
	return chats
}

// Get chats by project using ORM
pub fn (repo ChatRepository) get_chats_by_project(project_id int) ![]ChatORM {
	chats := sql repo.db {
		select from ChatORM where project_id == project_id && deleted_at == 0 
		order by updated_at desc
	}!
	
	return chats
}

// Get chats by team using ORM
pub fn (repo ChatRepository) get_chats_by_team(team_id int) ![]ChatORM {
	chats := sql repo.db {
		select from ChatORM where team_id == team_id && deleted_at == 0 
		order by updated_at desc
	}!
	
	return chats
}

// Count total chats using ORM
pub fn (repo ChatRepository) count_chats() !int {
	result := sql repo.db {
		select count from ChatORM where deleted_at == 0
	}!
	
	return result
}

// Add member to chat using ORM
pub fn (mut repo ChatRepository) add_chat_member(args_ ChatMemberNewArgs) !ChatMemberORM {
	mut args := args_
	now := u32(time.now().unix())
	mut member := ChatMemberORM{
		user_id: args.user_id
		chat_id: args.chat_id
		role: args.role
		invited_by: args.invited_by
		joined_at: now
		created_at: now
		updated_at: now
		last_read_at: 0
		status: .active
		muted: false
		muted_until: 0
	}
	
	sql repo.db {
		insert member into ChatMemberORM
	}!
	
	// Get the last inserted ID
	member.id = repo.db.last_id()
	
	return member
}

// Get chat members using ORM
pub fn (repo ChatRepository) get_chat_members(chat_id int) ![]ChatMemberORM {
	members := sql repo.db {
		select from ChatMemberORM where chat_id == chat_id && status == MemberStatus.active
		order by joined_at
	}!
	
	return members
}

// Remove member from chat using ORM
pub fn (mut repo ChatRepository) remove_chat_member(chat_id int, user_id int) ! {
	now := u32(time.now().unix())
	sql repo.db {
		update ChatMemberORM set status = MemberStatus.inactive, updated_at = now
		where chat_id == chat_id && user_id == user_id
	}!
}

// Send message using ORM
pub fn (mut repo ChatRepository) send_message(args_ MessageNewArgs) !MessageORM {
	mut args := args_
	now := u32(time.now().unix())
	mut message := MessageORM{
		chat_id: args.chat_id
		sender_id: args.sender_id
		content: args.content
		message_type: args.message_type
		thread_id: args.thread_id
		reply_to_id: args.reply_to_id
		priority: args.priority
		scheduled_at: args.scheduled_at or { 0 }
		expires_at: args.expires_at or { 0 }
		created_by: args.created_by
		updated_by: args.created_by
		created_at: now
		updated_at: now
		deleted_at: 0
		edited_at: 0
		pinned: false
		pinned_at: 0
		delivery_status: .sent
		system_message: false
		bot_message: false
		version: 1
	}
	
	sql repo.db {
		insert message into MessageORM
	}!
	
	// Get the last inserted ID
	message.id = repo.db.last_id()
	
	// Update chat message count and last activity
	sql repo.db {
		update ChatORM set message_count = message_count + 1, last_activity = now, updated_at = now
		where id == args.chat_id
	}!
	
	return message
}

// Get messages for chat using ORM
pub fn (repo ChatRepository) get_messages(chat_id int, limit int, offset int) ![]MessageORM {
	messages := sql repo.db {
		select from MessageORM where chat_id == chat_id && deleted_at == 0 
		order by created_at desc limit limit offset offset
	}!
	
	return messages
}

// Get message by ID using ORM
pub fn (repo ChatRepository) get_message(id int) !MessageORM {
	message := sql repo.db {
		select from MessageORM where id == id && deleted_at == 0
	}!
	
	if message.len == 0 {
		return error('Message not found')
	}
	
	return message[0]
}

// Edit message using ORM
pub fn (mut repo ChatRepository) edit_message(id int, new_content string, edited_by int) ! {
	now := u32(time.now().unix())
	
	sql repo.db {
		update MessageORM set content = new_content, edited_at = now,
		edited_by = edited_by, updated_at = now
		where id == id
	}!
}

// Delete message using ORM
pub fn (mut repo ChatRepository) delete_message(id int, deleted_by int) ! {
	now := u32(time.now().unix())
	
	sql repo.db {
		update MessageORM set deleted_at = now, deleted_by = deleted_by, updated_at = now
		where id == id
	}!
}

// Pin message using ORM
pub fn (mut repo ChatRepository) pin_message(id int, pinned_by int) ! {
	now := u32(time.now().unix())
	
	sql repo.db {
		update MessageORM set pinned = true, pinned_at = now,
		pinned_by = pinned_by, updated_at = now
		where id == id
	}!
}

// Get pinned messages using ORM
pub fn (repo ChatRepository) get_pinned_messages(chat_id int) ![]MessageORM {
	messages := sql repo.db {
		select from MessageORM where chat_id == chat_id && pinned == true && deleted_at == 0 
		order by pinned_at desc
	}!
	
	return messages
}

// Mark messages as read using ORM
pub fn (mut repo ChatRepository) mark_as_read(chat_id int, user_id int, message_id int) ! {
	now := u32(time.now().unix())
	
	sql repo.db {
		update ChatMemberORM set last_read_at = now, last_read_message_id = message_id
		where chat_id == chat_id && user_id == user_id
	}!
}

// Get unread count using ORM
pub fn (repo ChatRepository) get_unread_count(chat_id int, user_id int) !int {
	// Get user's last read message ID
	member := sql repo.db {
		select from ChatMemberORM where chat_id == chat_id && user_id == user_id
	}!
	
	if member.len == 0 {
		return 0
	}
	
	last_read_id := member[0].last_read_message_id or { 0 }
	
	// Count messages after last read
	result := sql repo.db {
		select count from MessageORM where chat_id == chat_id &&
		id > last_read_id && deleted_at == 0 && system_message == false
	}!
	
	return result
}

// Delete all data from repository (removes all records from all tables)
pub fn (mut repo ChatRepository) delete_all()! {
	sql repo.db {
		delete from MessageORM where id > 0
	}!
	
	sql repo.db {
		delete from ChatMemberORM where id > 0
	}!
	
	sql repo.db {
		delete from ChatORM where id > 0
	}!
}

// Delete all data from PostgreSQL repository (removes all records from all tables)
pub fn (mut repo ChatRepositoryPG) delete_all()! {
	sql repo.db {
		delete from MessageORM where id > 0
	}!
	
	sql repo.db {
		delete from ChatMemberORM where id > 0
	}!
	
	sql repo.db {
		delete from ChatORM where id > 0
	}!
}

// Example usage function
pub fn example_usage() ! {
	// Initialize repository
	mut repo := new_chat_repository('chat_example.db')!
	
	// Create a new chat using the new parameter struct
	mut chat := repo.create_chat(
		name: 'Project Alpha Discussion'
		chat_type: .project_chat
		owner_id: 1
		created_by: 1
	)!
	println('Created chat: ${chat.name} with ID: ${chat.id}')
	
	// Add members to chat using the new parameter struct
	member1 := repo.add_chat_member(
		chat_id: chat.id
		user_id: 2
		role: .member
		invited_by: 1
	)!
	member2 := repo.add_chat_member(
		chat_id: chat.id
		user_id: 3
		role: .moderator
		invited_by: 1
	)!
	println('Added members: ${member1.user_id}, ${member2.user_id}')
	
	// Send messages using the new parameter struct
	msg1 := repo.send_message(
		chat_id: chat.id
		sender_id: 1
		content: 'Welcome to the project chat!'
		message_type: .text
		created_by: 1
	)!
	msg2 := repo.send_message(
		chat_id: chat.id
		sender_id: 2
		content: 'Thanks for adding me!'
		message_type: .text
		created_by: 2
	)!
	println('Sent messages: ${msg1.id}, ${msg2.id}')
	
	// Debug: Check what's in the database
	all_messages := sql repo.db {
		select from MessageORM
	}!
	println('Debug: Total messages in DB: ${all_messages.len}')
	for i, msg in all_messages {
		println('  DB Message ${i + 1}: ID=${msg.id}, chat_id=${msg.chat_id}, content="${msg.content}", deleted_at=${msg.deleted_at}')
	}
	
	// Get messages
	messages := repo.get_messages(chat.id, 10, 0)!
	println('Retrieved ${messages.len} messages')
	for i, msg in messages {
		println('  Message ${i + 1}: "${msg.content}" from user ${msg.sender_id}')
	}
	
	// Mark as read
	repo.mark_as_read(chat.id, 2, msg2.id)!
	
	// Get unread count
	unread := repo.get_unread_count(chat.id, 3)!
	println('User 3 has ${unread} unread messages')
	
	// Search chats using the new parameter struct
	found_chats := repo.search_chats(
		search_term: 'Alpha'
		limit: 5
	)!
	println('Found ${found_chats.len} chats matching "Alpha"')
	for i, found_chat in found_chats {
		println('  Chat ${i + 1}: "${found_chat.name}" (ID: ${found_chat.id})')
	}
	
	// Pin a message
	repo.pin_message(msg1.id, 1)!
	
	// Get pinned messages
	pinned := repo.get_pinned_messages(chat.id)!
	println('Found ${pinned.len} pinned messages')
	for i, pinned_msg in pinned {
		println('  Pinned message ${i + 1}: "${pinned_msg.content}"')
	}
	
	// Test the delete_all method
// 	println('Testing delete_all method...')
// 	repo.delete_all()!
// 	println('All data deleted successfully!')
}

// Run the example
example_usage() or { panic(err) }