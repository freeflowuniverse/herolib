# Task/Project Management System with Integrated CRM

A comprehensive task and project management system with integrated CRM capabilities, built using V language and V's built-in ORM.

## Overview

This system provides a complete solution for:
- **Project Management**: Projects, tasks, milestones with dependencies and time tracking
- **Scrum Methodology**: Sprints, story points, velocity tracking, burndown charts
- **Issue Tracking**: Bug tracking with severity levels and resolution workflow
- **Team Management**: Capacity planning, skill tracking, and performance metrics
- **CRM Integration**: Customer lifecycle management integrated with project work
- **Communication**: Real-time chat system with threading and integrations
- **Calendar/Scheduling**: Meeting management with recurrence and attendee tracking

## Architecture

### Data Storage Strategy
- **Root Objects**: Stored as JSON in database tables with matching names
- **Incremental IDs**: Each root object has auto-incrementing integer IDs
- **Targeted Indexing**: Additional indexes on frequently queried fields
- **ORM Integration**: Uses V's built-in ORM for type-safe database operations

### Core Models

#### Foundation
- [`BaseModel`](models/base.v) - Common fields and functionality for all entities
- [`Enums`](models/enums.v) - Comprehensive status and type definitions
- [`SubObjects`](models/subobjects.v) - Embedded objects like Contact, Address, TimeEntry

#### Business Objects
- [`User`](models/user.v) - System users with roles, skills, and preferences
- [`Customer`](models/customer.v) - CRM entities with contacts and project relationships
- [`Project`](models/project.v) - Main project containers with budgets and timelines
- [`Task`](models/task.v) - Work items with dependencies and time tracking
- [`Sprint`](models/sprint.v) - Scrum sprints with velocity and burndown tracking
- [`Milestone`](models/milestone.v) - Project goals with conditions and deliverables
- [`Issue`](models/issue.v) - Problem tracking with severity and resolution workflow
- [`Team`](models/team.v) - Groups with capacity planning and skill management
- [`Agenda`](models/agenda.v) - Calendar events with recurrence and attendee management
- [`Chat`](models/chat.v) - Communication channels with threading and integrations

## Using the ORM

### Database Setup

```v
import db.sqlite
import lib.biz.planner.examples

// Initialize SQLite database
mut repo := examples.new_chat_repository('myapp.db')!

// Or PostgreSQL
mut pg_repo := examples.new_chat_repository_pg('localhost', 5432, 'user', 'pass', 'mydb')!
```

### Model Definitions

Models use V's ORM attributes for database mapping:

```v
@[table: 'chat']
pub struct ChatORM {
pub mut:
	id              int    @[primary; sql: serial]
	name            string @[nonull]
	description     string
	chat_type       string @[nonull]
	status          string @[nonull]
	owner_id        int    @[nonull]
	project_id      int
	created_at      time.Time @[default: 'CURRENT_TIMESTAMP']
	updated_at      time.Time @[default: 'CURRENT_TIMESTAMP']
	deleted_at      time.Time
}
```

### CRUD Operations

#### Create
```v
// Create a new chat
mut chat := repo.create_chat('Project Discussion', 'project_chat', owner_id, created_by)!
println('Created chat with ID: ${chat.id}')
```

#### Read
```v
// Get by ID
chat := repo.get_chat(1)!

// List with filtering
chats := repo.list_chats('project_chat', 'active', owner_id, 10, 0)!

// Search
found := repo.search_chats('project', 5)!
```

#### Update
```v
// Update chat
mut chat := repo.get_chat(1)!
chat.description = 'Updated description'
repo.update_chat(mut chat, updated_by)!
```

#### Delete (Soft Delete)
```v
// Soft delete
repo.delete_chat(1, deleted_by)!
```

### Advanced Queries

#### Filtering with Multiple Conditions
```v
// Using ORM's where clause
chats := sql repo.db {
	select from ChatORM where chat_type == 'project_chat' && 
	status == 'active' && owner_id == user_id && 
	deleted_at == time.Time{} 
	order by updated_at desc limit 10
}!
```

#### Joins and Relationships
```v
// Get chat with member count
result := sql repo.db {
	select ChatORM.id, ChatORM.name, count(ChatMemberORM.id) as member_count
	from ChatORM 
	inner join ChatMemberORM on ChatORM.id == ChatMemberORM.chat_id
	where ChatORM.deleted_at == time.Time{} && ChatMemberORM.status == 'active'
	group by ChatORM.id
}!
```

#### Aggregations
```v
// Count records
total := sql repo.db {
	select count from ChatORM where deleted_at == time.Time{}
}!

// Sum and averages
stats := sql repo.db {
	select sum(message_count) as total_messages, avg(message_count) as avg_messages
	from ChatORM where status == 'active'
}!
```

### Working with Related Data

#### One-to-Many Relationships
```v
// Get chat and its messages
chat := repo.get_chat(1)!
messages := repo.get_messages(chat.id, 50, 0)!

// Get chat members
members := repo.get_chat_members(chat.id)!
```

#### Many-to-Many Relationships
```v
// Add user to chat
member := repo.add_chat_member(chat_id, user_id, 'member', invited_by)!

// Remove user from chat
repo.remove_chat_member(chat_id, user_id)!
```

### Transactions

```v
// Using transactions for data consistency
sql repo.db {
	begin
	
	// Create chat
	insert chat into ChatORM
	
	// Add owner as admin
	insert member into ChatMemberORM
	
	// Send welcome message
	insert message into MessageORM
	
	commit
}!
```

### Performance Optimization

#### Indexing Strategy
```v
// Create indexes for frequently queried fields
sql db {
	create index idx_chat_type on ChatORM(chat_type)
	create index idx_chat_owner on ChatORM(owner_id)
	create index idx_chat_project on ChatORM(project_id)
	create index idx_message_chat on MessageORM(chat_id)
	create index idx_message_created on MessageORM(created_at)
}!
```

#### Pagination
```v
// Efficient pagination
page_size := 20
offset := (page - 1) * page_size

chats := sql repo.db {
	select from ChatORM where deleted_at == time.Time{} 
	order by updated_at desc 
	limit page_size offset offset
}!
```

#### Selective Loading
```v
// Load only needed fields
chat_summaries := sql repo.db {
	select id, name, message_count, last_activity 
	from ChatORM where status == 'active'
}!
```

### Error Handling

```v
// Proper error handling
chat := repo.get_chat(id) or {
	eprintln('Failed to get chat: ${err}')
	return error('Chat not found')
}

// Validation before operations
if chat.name.len == 0 {
	return error('Chat name cannot be empty')
}
```

### Migration and Schema Evolution

```v
// Schema migrations
pub fn migrate_v1_to_v2(mut db sqlite.DB) ! {
	// Add new columns
	sql db {
		alter table ChatORM add column archived_at time.Time
		alter table ChatORM add column file_count int default 0
	}!
	
	// Create new indexes
	sql db {
		create index idx_chat_archived on ChatORM(archived_at)
	}!
}
```

## Example Usage

See [`examples/chat_orm_example.v`](examples/chat_orm_example.v) for a complete working example that demonstrates:

- Database initialization
- Table creation with ORM
- CRUD operations
- Relationship management
- Advanced querying
- Performance optimization

## Best Practices

1. **Use Transactions**: For operations that modify multiple tables
2. **Implement Soft Deletes**: Set `deleted_at` instead of hard deletes
3. **Index Strategically**: Add indexes on frequently queried fields
4. **Validate Input**: Always validate data before database operations
5. **Handle Errors**: Proper error handling for all database operations
6. **Use Pagination**: For large result sets
7. **Optimize Queries**: Select only needed fields and use appropriate filters

## Database Support

- **SQLite**: For development and small deployments
- **PostgreSQL**: For production environments with high concurrency
- **MySQL**: Supported through V's ORM (configuration needed)

## Performance Considerations

- JSON storage allows flexible schema evolution
- Targeted indexing on frequently queried fields
- Pagination support for large datasets
- Connection pooling for high-concurrency scenarios
- Prepared statements for security and performance

## Security

- Parameterized queries prevent SQL injection
- Soft deletes preserve audit trails
- User-based access control through role permissions
- Audit logging with created_by/updated_by tracking