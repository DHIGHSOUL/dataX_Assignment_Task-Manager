# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_05_12_094937) do
  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "color"
    t.integer "workspace_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workspace_id"], name: "index_categories_on_workspace_id"
  end

  create_table "invitation_codes", force: :cascade do |t|
    t.integer "workspace_id", null: false
    t.string "code"
    t.datetime "expires_at"
    t.boolean "used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workspace_id"], name: "index_invitation_codes_on_workspace_id"
  end

  create_table "jwt_blacklists", force: :cascade do |t|
    t.string "token"
    t.datetime "exp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_assignments", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_assignments_on_task_id"
    t.index ["user_id"], name: "index_task_assignments_on_user_id"
  end

  create_table "task_histories", force: :cascade do |t|
    t.integer "task_id", null: false
    t.integer "user_id", null: false
    t.string "action"
    t.json "before_data"
    t.json "after_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_histories_on_task_id"
    t.index ["user_id"], name: "index_task_histories_on_user_id"
  end

  create_table "task_progresses", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "workspace_id", null: false
    t.integer "total_tasks", default: 0, null: false
    t.integer "completed_tasks", default: 0, null: false
    t.float "progress_rate", default: 0.0, null: false
    t.datetime "calculated_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_task_progresses_on_user_id"
    t.index ["workspace_id"], name: "index_task_progresses_on_workspace_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "status", default: "pending", null: false
    t.datetime "due_date"
    t.integer "workspace_id", null: false
    t.integer "category_id", null: false
    t.integer "created_by_user", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_tasks_on_category_id"
    t.index ["workspace_id"], name: "index_tasks_on_workspace_id"
  end

  create_table "user_workspaces", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "workspace_id", null: false
    t.string "role", default: "member", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_workspaces_on_user_id"
    t.index ["workspace_id"], name: "index_user_workspaces_on_workspace_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", limit: 50, null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "job_title", limit: 50
    t.integer "age", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "categories", "workspaces"
  add_foreign_key "invitation_codes", "workspaces"
  add_foreign_key "task_assignments", "tasks"
  add_foreign_key "task_assignments", "users"
  add_foreign_key "task_histories", "tasks"
  add_foreign_key "task_histories", "users"
  add_foreign_key "task_progresses", "users"
  add_foreign_key "task_progresses", "workspaces"
  add_foreign_key "tasks", "categories"
  add_foreign_key "tasks", "workspaces"
  add_foreign_key "user_workspaces", "users"
  add_foreign_key "user_workspaces", "workspaces"
end
