// File: lib/clients/gitea_client/models.v
module gitea_client

import time

// NOTE: This file is auto-generated from a Swagger specification.
// All data models required for the Gitea API are defined here.

//
// Data Models from Swagger Definitions
//

pub struct APIError {
pub:
	message string @[json: 'message']
	url     string @[json: 'url']
}

pub struct AccessToken {
pub:
	id               i64      @[json: 'id']
	name             string   @[json: 'name']
	scopes           []string @[json: 'scopes']
	sha1             string   @[json: 'sha1']
	token_last_eight string   @[json: 'token_last_eight']
}

pub struct ActionVariable {
pub:
	owner_id i64    @[json: 'owner_id']
	repo_id  i64    @[json: 'repo_id']
	name     string @[json: 'name']
	data     string @[json: 'data']
}

pub struct Activity {
pub:
	act_user     &User     @[json: 'act_user']
	act_user_id  i64       @[json: 'act_user_id']
	comment      &Comment  @[json: 'comment']
	comment_id   i64       @[json: 'comment_id']
	content      string    @[json: 'content']
	created      time.Time @[json: 'created']
	id           i64       @[json: 'id']
	is_private   bool      @[json: 'is_private']
	op_type      string    @[json: 'op_type']
	ref_name     string    @[json: 'ref_name']
	repo         &Repository @[json: 'repo']
	repo_id      i64       @[json: 'repo_id']
	user_id      i64       @[json: 'user_id']
}

pub struct AddCollaboratorOption {
pub:
	permission string @[json: 'permission']
}

pub struct AddTimeOption {
pub:
	time      i64       @[json: 'time']
	created   time.Time @[json: 'created']
	user_name string    @[json: 'user_name']
}

pub struct AnnotatedTagObject {
pub:
	sha  string @[json: 'sha']
	typ  string @[json: 'type'] // `type` is a keyword in V
	url  string @[json: 'url']
}

pub struct AnnotatedTag {
pub:
	message      string                    @[json: 'message']
	object       &AnnotatedTagObject       @[json: 'object']
	sha          string                    @[json: 'sha']
	tag          string                    @[json: 'tag']
	tagger       &CommitUser               @[json: 'tagger']
	url          string                    @[json: 'url']
	verification &PayloadCommitVerification @[json: 'verification']
}

pub struct Attachment {
pub:
	browser_download_url string    @[json: 'browser_download_url']
	created_at           time.Time @[json: 'created_at']
	download_count       i64       @[json: 'download_count']
	id                   i64       @[json: 'id']
	name                 string    @[json: 'name']
	size                 i64       @[json: 'size']
	uuid                 string    @[json: 'uuid']
}

pub struct Badge {
pub:
	id          i64    @[json: 'id']
	slug        string @[json: 'slug']
	description string @[json: 'description']
	image_url   string @[json: 'image_url']
}

pub struct Branch {
pub:
	commit                           &PayloadCommit @[json: 'commit']
	effective_branch_protection_name string         @[json: 'effective_branch_protection_name']
	enable_status_check              bool           @[json: 'enable_status_check']
	name                             string         @[json: 'name']
	protected                        bool           @[json: 'protected']
	required_approvals               i64            @[json: 'required_approvals']
	status_check_contexts            []string       @[json: 'status_check_contexts']
	user_can_merge                   bool           @[json: 'user_can_merge']
	user_can_push                    bool           @[json: 'user_can_push']
}

pub struct BranchProtection {
pub:
	branch_name                       string
	rule_name                         string    @[json: 'rule_name']
	enable_push                       bool      @[json: 'enable_push']
	enable_push_whitelist             bool      @[json: 'enable_push_whitelist']
	push_whitelist_usernames          []string  @[json: 'push_whitelist_usernames']
	push_whitelist_teams              []string  @[json: 'push_whitelist_teams']
	push_whitelist_deploy_keys        bool      @[json: 'push_whitelist_deploy_keys']
	enable_merge_whitelist            bool      @[json: 'enable_merge_whitelist']
	merge_whitelist_usernames         []string  @[json: 'merge_whitelist_usernames']
	merge_whitelist_teams             []string  @[json: 'merge_whitelist_teams']
	enable_status_check               bool      @[json: 'enable_status_check']
	status_check_contexts             []string  @[json: 'status_check_contexts']
	required_approvals                i64       @[json: 'required_approvals']
	enable_approvals_whitelist        bool      @[json: 'enable_approvals_whitelist']
	approvals_whitelist_username      []string  @[json: 'approvals_whitelist_username']
	approvals_whitelist_teams         []string  @[json: 'approvals_whitelist_teams']
	block_on_rejected_reviews         bool      @[json: 'block_on_rejected_reviews']
	block_on_official_review_requests bool      @[json: 'block_on_official_review_requests']
	block_on_outdated_branch          bool      @[json: 'block: 'block_on_outdated_branch']
	dismiss_stale_approvals           bool      @[json: 'dismiss_stale_approvals']
	ignore_stale_approvals            bool      @[json: 'ignore_stale_approvals']
	require_signed_commits            bool      @[json: 'require_signed_commits']
	protected_file_patterns           string    @[json: 'protected_file_patterns']
	unprotected_file_patterns         string    @[json: 'unprotected_file_patterns']
	created_at                        time.Time @[json: 'created_at']
	updated_at                        time.Time @[json: 'updated_at']
}

pub struct ChangeFileOperation {
pub:
	operation string @[json: 'operation'] // "create", "update", "delete"
	path      string @[json: 'path']
	content   string @[json: 'content'] // base64 encoded
	from_path string @[json: 'from_path']
	sha       string @[json: 'sha']
}

pub struct ChangeFilesOptions {
pub:
	author     &Identity               @[json: 'author']
	branch     string                  @[json: 'branch']
	committer  &Identity               @[json: 'committer']
	dates      &CommitDateOptions      @[json: 'dates']
	files      []ChangeFileOperation   @[json: 'files']
	message    string                  @[json: 'message']
	new_branch string                  @[json: 'new_branch']
	signoff    bool                    @[json: 'signoff']
}

pub struct ChangedFile {
pub:
	additions         i64    @[json: 'additions']
	changes           i64    @[json: 'changes']
	contents_url      string @[json: 'contents_url']
	deletions         i64    @[json: 'deletions']
	filename          string @[json: 'filename']
	html_url          string @[json: 'html_url']
	previous_filename string @[json: 'previous_filename']
	raw_url           string @[json: 'raw_url']
	status            string @[json: 'status']
}

pub struct Commit {
pub:
	author    &User                 @[json: 'author']
	commit    &RepoCommit           @[json: 'commit']
	committer &User                 @[json: 'committer']
	created   time.Time             @[json: 'created']
	files     []CommitAffectedFiles @[json: 'files']
	html_url  string                @[json: 'html_url']
	parents   []CommitMeta          @[json: 'parents']
	sha       string                @[json: 'sha']
	stats     &CommitStats          @[json: 'stats']
	url       string                @[json: 'url']
}

pub struct CommitAffectedFiles {
pub:
	filename string @[json: 'filename']
	status   string @[json: 'status']
}

pub struct CommitDateOptions {
pub:
	author    time.Time @[json: 'author']
	committer time.Time @[json: 'committer']
}

pub struct CommitMeta {
pub:
	created time.Time @[json: 'created']
	sha     string    @[json: 'sha']
	url     string    @[json: 'url']
}

pub struct CommitStats {
pub:
	additions i64 @[json: 'additions']
	deletions i64 @[json: 'deletions']
	total     i64 @[json: 'total']
}

pub struct CommitUser {
pub:
	date  string @[json: 'date']
	email string @[json: 'email']
	name  string @[json: 'name']
}

pub struct CreateIssueOption {
pub:
	title     string    @[json: 'title']
	assignee  string    @[json: 'assignee']
	assignees []string  @[json: 'assignees']
	body      string    @[json: 'body']
	closed    bool      @[json: 'closed']
	due_date  time.Time @[json: 'due_date']
	labels    []i64     @[json: 'labels']
	milestone i64       @[json: 'milestone']
	ref       string    @[json: 'ref']
}

pub struct CreateRepoOption {
pub:
	name               string @[json: 'name']
	auto_init          bool   @[json: 'auto_init']
	default_branch     string @[json: 'default_branch']
	description        string @[json: 'description']
	gitignores         string @[json: 'gitignores']
	issue_labels       string @[json: 'issue_labels']
	license            string @[json: 'license']
	object_format_name string @[json: 'object_format_name'] // "sha1" or "sha256"
	private            bool   @[json: 'private']
	readme             string @[json: 'readme']
	template           bool   @[json: 'template']
	trust_model        string @[json: 'trust_model'] // "default", "collaborator", "committer", "collaboratorcommitter"
}

pub struct Identity {
pub:
	email string @[json: 'email']
	name  string @[json: 'name']
}

pub struct Issue {
pub:
	id                 i64          @[json: 'id']
	url                string       @[json: 'url']
	html_url           string       @[json: 'html_url']
	number             i64          @[json: 'number']
	user               &User        @[json: 'user']
	original_author    string       @[json: 'original_author']
	original_author_id i64          @[json: 'original_author_id']
	title              string       @[json: 'title']
	body               string       @[json: 'body']
	ref                string       @[json: 'ref']
	labels             []Label      @[json: 'labels']
	milestone          &Milestone   @[json: 'milestone']
	assignee           &User        @[json: 'assignee']
	assignees          []User       @[json: 'assignees']
	state              string       @[json: 'state'] // StateType
	is_locked          bool         @[json: 'is_locked']
	comments           i64          @[json: 'comments']
	created_at         time.Time    @[json: 'created_at']
	updated_at         time.Time    @[json: 'updated_at']
	closed_at          time.Time    @[json: 'closed_at']
	due_date           time.Time    @[json: 'due_date']
	pull_request       &PullRequestMeta @[json: 'pull_request']
	repository         &RepositoryMeta @[json: 'repository']
	assets             []Attachment @[json: 'assets']
	pin_order          i64          @[json: 'pin_order']
}

pub struct Label {
pub:
	id          i64    @[json: 'id']
	name        string @[json: 'name']
	exclusive   bool   @[json: 'exclusive']
	is_archived bool   @[json: 'is_archived']
	color       string @[json: 'color']
	description string @[json: 'description']
	url         string @[json: 'url']
}

pub struct Milestone {
pub:
	id            i64       @[json: 'id']
	title         string    @[json: 'title']
	description   string    @[json: 'description']
	state         string    @[json: 'state'] // StateType
	open_issues   i64       @[json: 'open_issues']
	closed_issues i64       @[json: "closed_issues"]
	created_at    time.Time @[json: 'created_at']
	updated_at    time.Time @[json: 'updated_at']
	closed_at     time.Time @[json: 'closed_at']
	due_on        time.Time @[json: 'due_on']
}

pub struct PayloadCommitVerification {
pub:
	payload   string     @[json: 'payload']
	reason    string     @[json: 'reason']
	signature string     @[json: 'signature']
	signer    &PayloadUser @[json: 'signer']
	verified  bool       @[json: 'verified']
}


pub struct PullRequestMeta {
pub:
	merged    bool      @[json: 'merged']
	merged_at time.Time @[json: 'merged_at']
	draft     bool      @[json: 'draft']
	html_url  string    @[json: 'html_url']
}

pub struct RepoCommit {
pub:
	author       &CommitUser               @[json: 'author']
	committer    &CommitUser               @[json: 'committer']
	message      string                    @[json: 'message']
	tree         &CommitMeta               @[json: 'tree']
	url          string                    @[json: 'url']
	verification &PayloadCommitVerification @[json: 'verification']
}

pub struct Repository {
pub:
	id                              i64              @[json: 'id']
	owner                           &User            @[json: 'owner']
	name                            string           @[json: 'name']
	full_name                       string           @[json: 'full_name']
	description                     string           @[json: 'description']
	empty                           bool             @[json: 'empty']
	private                         bool             @[json: 'private']
	fork                            bool             @[json: 'fork']
	template                        bool             @[json: 'template']
	parent                          &Repository      @[json: 'parent']
	mirror                          bool             @[json: 'mirror']
	size                            i64              @[json: 'size']
	language                        string           @[json: 'language']
	languages_url                   string           @[json: 'languages_url']
	html_url                        string           @[json: 'html_url']
	url                             string           @[json: 'url']
	link                            string           @[json: 'link']
	ssh_url                         string           @[json: 'ssh_url']
	clone_url                       string           @[json: 'clone_url']
	website                         string           @[json: 'website']
	stars_count                     i64              @[json: 'stars_count']
	forks_count                     i64              @[json: 'forks_count']
	watchers_count                  i64              @[json: 'watchers_count']
	open_issues_count               i64              @[json: 'open_issues_count']
	open_pr_counter                 i64              @[json: 'open_pr_counter']
	release_counter                 i64              @[json: 'release_counter']
	default_branch                  string           @[json: 'default_branch']
	archived                        bool             @[json: 'archived']
	created_at                      time.Time        @[json: 'created_at']
	updated_at                      time.Time        @[json: 'updated_at']
	archived_at                     time.Time        @[json: 'archived_at']
	permissions                     &Permission      @[json: 'permissions']
	has_issues                      bool             @[json: 'has_issues']
	internal_tracker                &InternalTracker @[json: 'internal_tracker']
	has_wiki                        bool             @[json: 'has_wiki']
	has_pull_requests               bool             @[json: 'has_pull_requests']
	has_projects                    bool             @[json: 'has_projects']
	has_releases                    bool             @[json: 'has_releases']
	has_packages                    bool             @[json: 'has_packages']
	has_actions                     bool             @[json: 'has_actions']
	ignore_whitespace_conflicts     bool             @[json: 'ignore_whitespace_conflicts']
	allow_merge_commits             bool             @[json: 'allow_merge_commits']
	allow_rebase                    bool             @[json: 'allow_rebase']
	allow_rebase_explicit           bool             @[json: 'allow_rebase_explicit']
	allow_squash_merge              bool             @[json: 'allow_squash_merge']
	allow_fast_forward_only_merge   bool             @[json: 'allow_fast_forward_only_merge']
	allow_rebase_update             bool             @[json: 'allow_rebase_update']
	default_delete_branch_after_merge bool           @[json: 'default_delete_branch_after_merge']
	default_merge_style             string           @[json: 'default_merge_style']
	default_allow_maintainer_edit   bool             @[json: 'default_allow_maintainer_edit']
	avatar_url                      string           @[json: 'avatar_url']
	internal                        bool             @[json: 'internal']
	mirror_interval                 string           @[json: 'mirror_interval']
	mirror_updated                  time.Time        @[json: 'mirror_updated']
	repo_transfer                   &RepoTransfer    @[json: 'repo_transfer']
}
pub struct RepositoryMeta {
pub:
	id        i64    @[json: 'id']
	name      string @[json: 'name']
	owner     string @[json: 'owner']
	full_name string @[json: 'full_name']
}

pub struct User {
pub:
	id                  i64       @[json: 'id']
	login               string    @[json: 'login']
	full_name           string    @[json: 'full_name']
	email               string    @[json: 'email']
	avatar_url          string    @[json: 'avatar_url']
	language            string    @[json: 'language']
	is_admin            bool      @[json: 'is_admin']
	last_login          time.Time @[json: 'last_login']
	created             time.Time @[json: 'created']
	restricted          bool      @[json: 'restricted']
	active              bool      @[json: 'active']
	prohibit_login      bool      @[json: 'prohibit_login']
	location            string    @[json: 'location']
	website             string    @[json: 'website']
	description         string    @[json: 'description']
	visibility          string    @[json: 'visibility']
	followers_count     i64       @[json: 'followers_count']
	following_count     i64       @[json: 'following_count']
	starred_repos_count i64       @[json: 'starred_repos_count']
	username            string    @[json: 'username']
}