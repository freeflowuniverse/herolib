


```v
// Example usage:
// Initialize database client
mut db_client := postgresql_client.get(name: "default")!

// Create HeroDB for Circle type
mut circle_db := hero_db.new[circle.Circle](db_client)!
circle_db.ensure_table()!

// Create and save a circle
mut my_circle := circle.Circle{
    name: "Tech Community"
    description: "A community for tech enthusiasts"
    domain: "tech.example.com"
    config: circle.CircleConfig{
        max_members: 1000
        allow_guests: true
        auto_approve: false
        theme: "modern"
    }
    status: circle.CircleStatus.active
}

circle_db.save(&my_circle)!

// Retrieve the circle
retrieved_circle := circle_db.get_by_index({
    "domain": "tech.example.com"
})!

// Search circles by status
active_circles := circle_db.search_by_index("status", "active")!
```