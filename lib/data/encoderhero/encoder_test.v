module encoderhero

import freeflowuniverse.herolib.data.paramsparser
import freeflowuniverse.herolib.data.ourtime
import time
import v.reflection

struct Base {
	id      int
	remarks []Remark
}

pub struct Remark {
	text string
}

struct Company {
	name      string
	founded   ourtime.OurTime
	employees []Person
}

const company = Company{
	name:      'Tech Corp'
	founded:   ourtime.new('2022-12-05 20:14')!
	employees: [
		person,
		Person{
			id:       2
			name:     'Alice'
			age:      30
			birthday: time.new(
				day:   20
				month: 6
				year:  1990
			)
			car:      Car{
				name: "Alice's car"
				year: 2018
			}
			profiles: [
				Profile{
					platform: 'LinkedIn'
					url:      'linkedin.com/alice'
				},
			]
		},
	]
}

struct Person {
	Base
mut:
	name     string
	age      ?int = 20
	birthday time.Time
	deathday ?time.Time
	car      Car
	profiles []Profile
}

struct Car {
	name      string
	year      int
	insurance Insurance
}

struct Insurance {
	provider   string
	expiration time.Time
}

struct Profile {
	platform string
	url      string
}

const person_heroscript = "
!!person.configure id:1 name:Bob age:21 birthday:'2012-12-12 00:00:00'
!!person.car.configure name:'Bob\\'s car' year:2014
!!person.car.insurance.configure provider:insurer

!!person.profile.configure platform:Github url:github.com/example
"

const person = Person{
	id:       1
	name:     'Bob'
	age:      21
	birthday: time.new(
		day:   12
		month: 12
		year:  2012
	)
	car:      Car{
		name:      "Bob's car"
		year:      2014
		insurance: Insurance{
			provider: 'insurer'
		}
	}
	profiles: [
		Profile{
			platform: 'Github'
			url:      'github.com/example'
		},
	]
}

const company_script = "!!company.configure name:'Tech Corp' founded:'2022-12-05 20:14'
!!company.person.configure id:1 name:Bob age:21 birthday:'2012-12-12 00:00:00'
!!company.person.car.configure name:'Bob\\'s car' year:2014
!!company.person.car.insurance.configure provider:insurer

!!company.person.profile.configure platform:Github url:github.com/example

!!company.person.configure id:2 name:Alice age:30 birthday:'1990-06-20 00:00:00'
!!company.person.car.configure name:'Alice\\'s car' year:2018
!!company.person.car.insurance.configure

!!company.person.profile.configure platform:LinkedIn url:linkedin.com/alice"

fn test_encode() ! {
	person_script := encode[Person](person)!
	assert person_script.trim_space() == person_heroscript.trim_space()
	assert encode[Company](company)!.trim_space() == company_script.trim_space()
}
