# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160217153425) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "admins", ["user_id"], name: "index_admins_on_user_id", using: :btree

  create_table "appointments", force: :cascade do |t|
    t.integer  "student_id"
    t.integer  "slot_id"
    t.integer  "course_id"
    t.datetime "start_time"
    t.integer  "status",     default: 0
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "charge_id"
    t.string   "location"
  end

  add_index "appointments", ["charge_id"], name: "index_appointments_on_charge_id", using: :btree
  add_index "appointments", ["course_id"], name: "index_appointments_on_course_id", using: :btree
  add_index "appointments", ["slot_id"], name: "index_appointments_on_slot_id", using: :btree
  add_index "appointments", ["student_id"], name: "index_appointments_on_student_id", using: :btree

  create_table "campus_managers", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "profile_pic"
    t.string   "phone_number"
    t.integer  "status"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "campus_managers", ["school_id"], name: "index_campus_managers_on_school_id", using: :btree
  add_index "campus_managers", ["user_id"], name: "index_campus_managers_on_user_id", using: :btree

  create_table "charges", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "axon_fee"
    t.integer  "tutor_fee"
    t.integer  "tutor_id"
    t.string   "token"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "promotion_id"
    t.integer  "student_id"
    t.string   "stripe_charge_id"
  end

  add_index "charges", ["promotion_id"], name: "index_charges_on_promotion_id", using: :btree
  add_index "charges", ["student_id"], name: "index_charges_on_student_id", using: :btree
  add_index "charges", ["tutor_id"], name: "index_charges_on_tutor_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.integer  "school_id"
    t.integer  "subject_id"
    t.string   "call_number"
    t.string   "friendly_name"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "courses", ["school_id"], name: "index_courses_on_school_id", using: :btree
  add_index "courses", ["subject_id"], name: "index_courses_on_subject_id", using: :btree

  create_table "csv_course_lists", force: :cascade do |t|
    t.integer  "school_id"
    t.integer  "subject_id"
    t.string   "csv_file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "promotions", force: :cascade do |t|
    t.string  "code"
    t.integer "issuer"
    t.integer "amount"
    t.date    "valid_from"
    t.date    "valid_until"
    t.integer "redemption_limit"
    t.integer "redemption_count", default: 0
    t.text    "description"
    t.integer "tutor_id"
    t.integer "course_id"
    t.integer "repeat_use",       default: 0
    t.integer "student_id"
    t.integer "single_appt"
    t.integer "redeemer"
  end

  add_index "promotions", ["student_id"], name: "index_promotions_on_student_id", using: :btree
  add_index "promotions", ["tutor_id"], name: "index_promotions_on_tutor_id", using: :btree

  create_table "schools", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.string   "campus_pic"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slug"
    t.float    "transaction_percentage"
    t.string   "timezone"
  end

  add_index "schools", ["slug"], name: "index_schools_on_slug", unique: true, using: :btree

  create_table "slots", force: :cascade do |t|
    t.integer  "tutor_id"
    t.integer  "status",          default: 0
    t.datetime "start_time"
    t.integer  "duration"
    t.integer  "reservation_min"
    t.integer  "reservation_max"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "slot_type",       default: 0
  end

  add_index "slots", ["tutor_id"], name: "index_slots_on_tutor_id", using: :btree

  create_table "students", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.string   "phone_number"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "customer_id"
    t.string   "last_4_digits"
    t.string   "card_brand"
  end

  add_index "students", ["school_id"], name: "index_students_on_school_id", using: :btree
  add_index "students", ["user_id"], name: "index_students_on_user_id", using: :btree

  create_table "students_promotions", force: :cascade do |t|
    t.integer  "student_id",   null: false
    t.integer  "promotion_id", null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "students_promotions", ["promotion_id"], name: "index_students_promotions_on_promotion_id", using: :btree
  add_index "students_promotions", ["student_id"], name: "index_students_promotions_on_student_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tutor_courses", force: :cascade do |t|
    t.integer  "tutor_id"
    t.integer  "course_id"
    t.integer  "rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "tutor_courses", ["course_id"], name: "index_tutor_courses_on_course_id", using: :btree
  add_index "tutor_courses", ["tutor_id"], name: "index_tutor_courses_on_tutor_id", using: :btree

  create_table "tutors", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "school_id"
    t.integer  "active_status",      default: 0
    t.integer  "application_status", default: 0
    t.integer  "rating"
    t.integer  "degree",             default: 0
    t.string   "major"
    t.string   "additional_degrees"
    t.text     "extra_info_1"
    t.text     "extra_info_2"
    t.text     "extra_info_3"
    t.string   "graduation_year"
    t.string   "phone_number"
    t.string   "profile_pic"
    t.string   "transcript"
    t.text     "appt_notes"
    t.integer  "onboarding_status",  default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "last_4_acct"
    t.string   "line1"
    t.string   "line2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "ssn_last_4"
    t.string   "acct_id"
    t.string   "slug"
    t.date     "dob"
    t.integer  "booking_buffer",     default: 6
  end

  add_index "tutors", ["school_id"], name: "index_tutors_on_school_id", using: :btree
  add_index "tutors", ["slug"], name: "index_tutors_on_slug", unique: true, using: :btree
  add_index "tutors", ["user_id"], name: "index_tutors_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "role",                   default: 0
    t.string   "payment_info"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.string   "sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "admins", "users"
  add_foreign_key "appointments", "charges"
  add_foreign_key "appointments", "courses"
  add_foreign_key "appointments", "slots"
  add_foreign_key "appointments", "students"
  add_foreign_key "campus_managers", "schools"
  add_foreign_key "campus_managers", "users"
  add_foreign_key "charges", "students"
  add_foreign_key "charges", "tutors"
  add_foreign_key "courses", "schools"
  add_foreign_key "courses", "subjects"
  add_foreign_key "slots", "tutors"
  add_foreign_key "students", "schools"
  add_foreign_key "students", "users"
  add_foreign_key "tutor_courses", "courses"
  add_foreign_key "tutor_courses", "tutors"
  add_foreign_key "tutors", "schools"
  add_foreign_key "tutors", "users"
end
