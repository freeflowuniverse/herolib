module circle

import freeflowuniverse.herolib.hero.models.core

// Member represents a member within a circle
pub struct Member {
    core.Base
pub mut:
    circle_id         u32    // Reference to the circle this member belongs to @[index]
    user_id           u32    // Reference to the user entity @[index]
    role              MemberRole // Member's role within the circle
    status            MemberStatus // Current membership status
    joined_at         u64    // Unix timestamp when member joined
    invited_by        u32    // User ID of who invited this member
    permissions       []string // List of custom permissions
}

// MemberRole defines the possible roles a member can have
pub enum MemberRole {
    owner
    admin
    moderator
    member
    guest
}

// MemberStatus represents the current status of membership
pub enum MemberStatus {
    active
    pending
    suspended
    removed
}