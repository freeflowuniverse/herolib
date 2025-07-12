module models

import time

// Customer represents a client or prospect in the CRM system
pub struct Customer {
	BaseModel
pub mut:
	name            string @[required]
	type            CustomerType
	status          CustomerStatus
	industry        string
	website         string
	description     string
	contacts        []Contact
	addresses       []Address
	projects        []int // Project IDs associated with this customer
	total_value     f64   // Total contract value
	annual_value    f64   // Annual recurring revenue
	payment_terms   string
	tax_id          string
	account_manager_id int // User ID of account manager
	lead_source     string
	acquisition_date time.Time
	last_contact_date time.Time
	next_followup_date time.Time
	credit_limit    f64
	payment_method  string
	billing_cycle   string // monthly, quarterly, annually
	notes           string
	logo_url        string
	social_media    map[string]string // platform -> URL
	custom_fields   map[string]string // Flexible custom data
}

// get_primary_contact returns the primary contact for this customer
pub fn (c Customer) get_primary_contact() ?Contact {
	for contact in c.contacts {
		if contact.is_primary {
			return contact
		}
	}
	return none
}

// get_primary_address returns the primary address for this customer
pub fn (c Customer) get_primary_address() ?Address {
	for address in c.addresses {
		if address.is_primary {
			return address
		}
	}
	return none
}

// add_contact adds a new contact to the customer
pub fn (mut c Customer) add_contact(contact Contact) {
	// If this is the first contact, make it primary
	if c.contacts.len == 0 {
		mut new_contact := contact
		new_contact.is_primary = true
		c.contacts << new_contact
	} else {
		c.contacts << contact
	}
}

// update_contact updates an existing contact
pub fn (mut c Customer) update_contact(contact_id int, updated_contact Contact) bool {
	for i, mut contact in c.contacts {
		if contact.id == contact_id {
			c.contacts[i] = updated_contact
			return true
		}
	}
	return false
}

// remove_contact removes a contact by ID
pub fn (mut c Customer) remove_contact(contact_id int) bool {
	for i, contact in c.contacts {
		if contact.id == contact_id {
			c.contacts.delete(i)
			return true
		}
	}
	return false
}

// add_address adds a new address to the customer
pub fn (mut c Customer) add_address(address Address) {
	// If this is the first address, make it primary
	if c.addresses.len == 0 {
		mut new_address := address
		new_address.is_primary = true
		c.addresses << new_address
	} else {
		c.addresses << address
	}
}

// update_address updates an existing address
pub fn (mut c Customer) update_address(address_id int, updated_address Address) bool {
	for i, mut address in c.addresses {
		if address.id == address_id {
			c.addresses[i] = updated_address
			return true
		}
	}
	return false
}

// remove_address removes an address by ID
pub fn (mut c Customer) remove_address(address_id int) bool {
	for i, address in c.addresses {
		if address.id == address_id {
			c.addresses.delete(i)
			return true
		}
	}
	return false
}

// add_project associates a project with this customer
pub fn (mut c Customer) add_project(project_id int) {
	if project_id !in c.projects {
		c.projects << project_id
	}
}

// remove_project removes a project association
pub fn (mut c Customer) remove_project(project_id int) {
	c.projects = c.projects.filter(it != project_id)
}

// has_project checks if a project is associated with this customer
pub fn (c Customer) has_project(project_id int) bool {
	return project_id in c.projects
}

// is_active_customer checks if the customer is currently active
pub fn (c Customer) is_active_customer() bool {
	return c.status == .active && c.is_active
}

// is_prospect checks if the customer is still a prospect
pub fn (c Customer) is_prospect() bool {
	return c.status in [.prospect, .lead, .qualified]
}

// convert_to_customer converts a prospect to an active customer
pub fn (mut c Customer) convert_to_customer(by_user_id int) {
	c.status = .active
	c.acquisition_date = time.now()
	c.update_timestamp(by_user_id)
}

// update_last_contact updates the last contact date
pub fn (mut c Customer) update_last_contact(by_user_id int) {
	c.last_contact_date = time.now()
	c.update_timestamp(by_user_id)
}

// set_next_followup sets the next followup date
pub fn (mut c Customer) set_next_followup(followup_date time.Time, by_user_id int) {
	c.next_followup_date = followup_date
	c.update_timestamp(by_user_id)
}

// is_followup_due checks if a followup is due
pub fn (c Customer) is_followup_due() bool {
	if c.next_followup_date.unix == 0 {
		return false
	}
	return time.now() >= c.next_followup_date
}

// calculate_lifetime_value calculates the total value from all projects
pub fn (c Customer) calculate_lifetime_value(projects []Project) f64 {
	mut total := f64(0)
	for project in projects {
		if project.customer_id == c.id {
			total += project.budget
		}
	}
	return total
}

// get_contact_by_type returns contacts of a specific type
pub fn (c Customer) get_contact_by_type(contact_type ContactType) []Contact {
	return c.contacts.filter(it.type == contact_type)
}

// get_address_by_type returns addresses of a specific type
pub fn (c Customer) get_address_by_type(address_type AddressType) []Address {
	return c.addresses.filter(it.type == address_type)
}

// set_account_manager assigns an account manager to this customer
pub fn (mut c Customer) set_account_manager(user_id int, by_user_id int) {
	c.account_manager_id = user_id
	c.update_timestamp(by_user_id)
}

// add_social_media adds a social media link
pub fn (mut c Customer) add_social_media(platform string, url string) {
	c.social_media[platform] = url
}

// get_social_media gets a social media URL by platform
pub fn (c Customer) get_social_media(platform string) ?string {
	return c.social_media[platform] or { none }
}

// set_custom_field sets a custom field value
pub fn (mut c Customer) set_custom_field(field string, value string) {
	c.custom_fields[field] = value
}

// get_custom_field gets a custom field value
pub fn (c Customer) get_custom_field(field string) ?string {
	return c.custom_fields[field] or { none }
}