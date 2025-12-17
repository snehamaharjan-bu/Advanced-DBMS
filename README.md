Fitness App Database Management System (DBMS)

📌 Project Overview

This project is a Database Management System (DBMS) designed for a Fitness Application that tracks users, workouts, hydration, gym classes, rewards, and health metrics. The goal of the system is to model real‑world fitness data accurately while demonstrating strong database design principles, normalization, and advanced SQL features.

The database supports core fitness use cases such as workout logging, hydration tracking, class enrollment, and reward credits, while ensuring data integrity, scalability, and efficient querying.

🎯 Project Objectives

Design a fully normalized relational database (1NF → BCNF)

Implement real‑world fitness tracking use cases

Enforce data integrity using primary keys, foreign keys, and constraints

Use advanced SQL features such as views, stored procedures, triggers, and indexes

Optimize queries for performance and analytics

🗂️ Core Features

User profile and fitness data management

Workout and workout type tracking

Hydration monitoring with history logging

Gym class and class type management

Reward and credit system

Health metrics and risk indicators

Historical tracking through trigger‑based audit tables

🧱 Database Design
Key Design Principles

Fully normalized schema (no partial or transitive dependencies)

Surrogate primary keys for scalability

Clear separation of entities and relationships

Derived attributes handled via queries or views (not stored redundantly)

Example Entities

AppUser

Workout

WorkoutType

HydrationMetric

HydrationHistory

GymClass

GymClassType

Credit / Reward

HealthRiskMetric

🔗 Relationships

One‑to‑many relationships between users and workouts

One‑to‑many relationships between users and hydration metrics

Many‑to‑many relationships resolved using associative entities where needed

Enforced referential integrity using foreign keys

⚙️ Advanced SQL Features

Stored Procedures for controlled inserts and business logic

Triggers to capture historical changes (e.g., hydration updates)

Views for frequently accessed analytical data

Indexes (primary, foreign key, and query‑driven) to improve performance

📊 Sample Use Cases

Track daily and monthly workout activity

Monitor hydration trends and send reminders

Analyze gym class participation

Evaluate health risk indicators over time

Generate summaries for user engagement and progress

🛠️ Technologies Used

Database: PostgreSQL

Design: ERD (Crow’s Foot notation)

Tools: pgAdmin, Lucidchart
