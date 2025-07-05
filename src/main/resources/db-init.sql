-- DDL
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE work_item (
  id TEXT PRIMARY KEY,
  summary TEXT,
  managing_unit TEXT,
  priority TEXT,
  external_status TEXT,
  creation_date DATE,
  resolution_date DATE,
  planned_date DATE,
  demand_type TEXT,
  backlog_type TEXT,
  modified_date DATE,
  modified_by TEXT,
  parent TEXT
);

CREATE TABLE vitrine (
  id TEXT PRIMARY KEY,
  type TEXT,
  name TEXT,
  status TEXT,
  it_owner TEXT,
  modified_date DATE,
  delivery_start_date DATE,
  delivery_end_date DATE,
  description TEXT
);

CREATE TABLE task (
  id TEXT PRIMARY KEY,
  parent TEXT REFERENCES work_item(id),
  created_by TEXT,
  summary TEXT,
  status TEXT,
  modified_date DATE,
  planned_date DATE
);

CREATE TABLE pbi (
  work_item_id TEXT,
  problem_id TEXT,
  system TEXT,
  PRIMARY KEY (work_item_id, problem_id)
);

CREATE TABLE sm_field_event (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  work_item_id TEXT NOT NULL,
  field_name TEXT CHECK (field_name IN ('status', 'current_action')),
  old_value TEXT,
  new_value TEXT,
  user_id TEXT,
  timestamp TIMESTAMPTZ DEFAULT now(),
  reverted BOOLEAN DEFAULT false
);

CREATE TABLE sm_field_state (
  work_item_id TEXT NOT NULL,
  field_name TEXT CHECK (field_name IN ('status', 'current_action')),
  current_value TEXT,
  last_modified_by TEXT,
  last_modified_at TIMESTAMPTZ DEFAULT now(),
  PRIMARY KEY (work_item_id, field_name)
);

-- Seed data

INSERT INTO vitrine(id,type,name,status,it_owner,modified_date,delivery_start_date,delivery_end_date,description) VALUES
('VI1','Portal','Portal One','Active','Alice','2024-04-01','2024-05-01','2024-08-01','First vitrine'),
('VI2','Service','Service Two','Planning','Bob','2024-04-02','2024-05-15','2024-09-01','Second vitrine'),
('VI3','Portal','Portal Three','Active','Carol','2024-04-03','2024-05-20','2024-08-20','Third vitrine'),
('VI4','App','App Four','Closed','Dave','2024-04-04','2024-05-25','2024-07-30','Fourth vitrine'),
('VI5','Service','Service Five','Active','Eve','2024-04-05','2024-05-10','2024-10-01','Fifth vitrine');

-- Work items
INSERT INTO work_item(id,summary,managing_unit,priority,external_status,creation_date,resolution_date,planned_date,demand_type,backlog_type,modified_date,modified_by,parent) VALUES
('WI1','Work item 1','Unit A','High','Open','2024-04-01',NULL,'2024-06-01','Type A','Backlog','2024-04-01','user1',NULL),
('WI2','Work item 2','Unit B','Medium','In Progress','2024-04-02',NULL,'2024-06-05','Type B','Backlog','2024-04-02','user2',NULL),
('WI3','Work item 3','Unit C','Low','Closed','2024-04-03','2024-04-10','2024-06-10','Type C','Backlog','2024-04-03','user3',NULL),
('WI4','Work item 4','Unit A','Critical','Blocked','2024-04-04',NULL,'2024-06-15','Type A','Backlog','2024-04-04','user4',NULL),
('WI5','Work item 5','Unit B','Medium','Open','2024-04-05',NULL,'2024-06-20','Type B','Backlog','2024-04-05','user5',NULL),
('WI6','Work item 6','Unit C','Low','In Progress','2024-04-06',NULL,'2024-06-25','Type C','Backlog','2024-04-06','user1',NULL),
('WI7','Work item 7','Unit A','High','Open','2024-04-07',NULL,'2024-06-30','Type A','Backlog','2024-04-07','user2',NULL),
('WI8','Work item 8','Unit B','Medium','Blocked','2024-04-08',NULL,'2024-07-05','Type B','Backlog','2024-04-08','user3',NULL),
('WI9','Work item 9','Unit C','Low','Closed','2024-04-09','2024-04-20','2024-07-10','Type C','Backlog','2024-04-09','user4',NULL),
('WI10','Work item 10','Unit A','Critical','Open','2024-04-10',NULL,'2024-07-15','Type A','Backlog','2024-04-10','user5',NULL),
('WI11','Work item 11','Unit B','Medium','Open','2024-04-11',NULL,'2024-07-20','Type B','Backlog','2024-04-11','user1',NULL),
('WI12','Work item 12','Unit C','Low','In Progress','2024-04-12',NULL,'2024-07-25','Type C','Backlog','2024-04-12','user2',NULL),
('WI13','Work item 13','Unit A','High','Blocked','2024-04-13',NULL,'2024-07-30','Type A','Backlog','2024-04-13','user3',NULL),
('WI14','Work item 14','Unit B','Medium','Open','2024-04-14',NULL,'2024-08-04','Type B','Backlog','2024-04-14','user4',NULL),
('WI15','Work item 15','Unit C','Low','Closed','2024-04-15','2024-04-25','2024-08-09','Type C','Backlog','2024-04-15','user5',NULL),
('WI16','Work item 16','Unit A','Critical','In Progress','2024-04-16',NULL,'2024-08-14','Type A','Backlog','2024-04-16','user1',NULL),
('WI17','Work item 17','Unit B','Medium','Blocked','2024-04-17',NULL,'2024-08-19','Type B','Backlog','2024-04-17','user2',NULL),
('WI18','Work item 18','Unit C','Low','Open','2024-04-18',NULL,'2024-08-24','Type C','Backlog','2024-04-18','user3',NULL),
('WI19','Work item 19','Unit A','High','In Progress','2024-04-19',NULL,'2024-08-29','Type A','Backlog','2024-04-19','user4',NULL),
('WI20','Work item 20','Unit B','Medium','Open','2024-04-20',NULL,'2024-09-03','Type B','Backlog','2024-04-20','user5',NULL),
('WI21','Work item 21','Unit C','Low','Blocked','2024-04-21',NULL,'2024-09-08','Type C','Backlog','2024-04-21','user1',NULL),
('WI22','Work item 22','Unit A','Critical','Closed','2024-04-22','2024-04-30','2024-09-13','Type A','Backlog','2024-04-22','user2',NULL),
('WI23','Work item 23','Unit B','Medium','Open','2024-04-23',NULL,'2024-09-18','Type B','Backlog','2024-04-23','user3',NULL),
('WI24','Work item 24','Unit C','Low','In Progress','2024-04-24',NULL,'2024-09-23','Type C','Backlog','2024-04-24','user4',NULL),
('WI25','Work item 25','Unit A','High','Blocked','2024-04-25',NULL,'2024-09-28','Type A','Backlog','2024-04-25','user5',NULL),
('WI26','Work item 26','Unit B','Medium','Open','2024-04-26',NULL,'2024-10-03','Type B','Backlog','2024-04-26','user1',NULL),
('WI27','Work item 27','Unit C','Low','In Progress','2024-04-27',NULL,'2024-10-08','Type C','Backlog','2024-04-27','user2',NULL),
('WI28','Work item 28','Unit A','Critical','Open','2024-04-28',NULL,'2024-10-13','Type A','Backlog','2024-04-28','user3',NULL),
('WI29','Work item 29','Unit B','Medium','Closed','2024-04-29','2024-05-05','2024-10-18','Type B','Backlog','2024-04-29','user4',NULL),
('WI30','Work item 30','Unit C','Low','Open','2024-04-30',NULL,'2024-10-23','Type C','Backlog','2024-04-30','user5',NULL);

-- Associate some work items with vitrines or pbis
INSERT INTO pbi(work_item_id,problem_id,system) VALUES
('WI1','P1','SYS1'),
('WI6','P2','SYS2'),
('WI11','P3','SYS3'),
('WI16','P4','SYS4'),
('WI21','P5','SYS5');

-- tasks
INSERT INTO task(id,parent,created_by,summary,status,modified_date,planned_date) VALUES
('T1','WI2','user1','Task 1','Open','2024-04-02','2024-06-01'),
('T2','WI2','user1','Task 2','Open','2024-04-03','2024-06-02'),
('T3','WI3','user2','Task 3','Done','2024-04-10','2024-06-03'),
('T4','WI4','user3','Task 4','In Progress','2024-04-05','2024-06-04'),
('T5','WI5','user4','Task 5','Open','2024-04-06','2024-06-05'),
('T6','WI6','user5','Task 6','Open','2024-04-07','2024-06-06'),
('T7','WI7','user1','Task 7','In Progress','2024-04-08','2024-06-07'),
('T8','WI8','user2','Task 8','Blocked','2024-04-09','2024-06-08'),
('T9','WI9','user3','Task 9','Done','2024-04-20','2024-06-09'),
('T10','WI10','user4','Task 10','Open','2024-04-11','2024-06-10'),
('T11','WI11','user5','Task 11','In Progress','2024-04-12','2024-06-11'),
('T12','WI12','user1','Task 12','Open','2024-04-13','2024-06-12'),
('T13','WI13','user2','Task 13','Blocked','2024-04-14','2024-06-13'),
('T14','WI14','user3','Task 14','Open','2024-04-15','2024-06-14'),
('T15','WI15','user4','Task 15','Done','2024-04-25','2024-06-15'),
('T16','WI16','user5','Task 16','In Progress','2024-04-17','2024-06-16'),
('T17','WI17','user1','Task 17','Blocked','2024-04-18','2024-06-17'),
('T18','WI18','user2','Task 18','Open','2024-04-19','2024-06-18'),
('T19','WI19','user3','Task 19','In Progress','2024-04-20','2024-06-19'),
('T20','WI20','user4','Task 20','Open','2024-04-21','2024-06-20'),
('T21','WI21','user5','Task 21','Blocked','2024-04-22','2024-06-21'),
('T22','WI22','user1','Task 22','Done','2024-04-30','2024-06-22'),
('T23','WI23','user2','Task 23','Open','2024-04-24','2024-06-23'),
('T24','WI24','user3','Task 24','In Progress','2024-04-25','2024-06-24'),
('T25','WI25','user4','Task 25','Blocked','2024-04-26','2024-06-25'),
('T26','WI26','user5','Task 26','Open','2024-04-27','2024-06-26'),
('T27','WI27','user1','Task 27','In Progress','2024-04-28','2024-06-27'),
('T28','WI28','user2','Task 28','Open','2024-04-29','2024-06-28'),
('T29','WI29','user3','Task 29','Done','2024-05-05','2024-06-29'),
('T30','WI30','user4','Task 30','Open','2024-04-30','2024-06-30'),
('T31','WI2','user5','Task 31','Open','2024-04-02','2024-07-01'),
('T32','WI3','user1','Task 32','Open','2024-04-03','2024-07-02'),
('T33','WI4','user2','Task 33','In Progress','2024-04-04','2024-07-03'),
('T34','WI5','user3','Task 34','Blocked','2024-04-05','2024-07-04'),
('T35','WI6','user4','Task 35','Open','2024-04-06','2024-07-05'),
('T36','WI7','user5','Task 36','In Progress','2024-04-07','2024-07-06'),
('T37','WI8','user1','Task 37','Open','2024-04-08','2024-07-07'),
('T38','WI9','user2','Task 38','Done','2024-04-20','2024-07-08'),
('T39','WI10','user3','Task 39','Open','2024-04-10','2024-07-09'),
('T40','WI11','user4','Task 40','In Progress','2024-04-11','2024-07-10'),
('T41','WI12','user5','Task 41','Open','2024-04-12','2024-07-11'),
('T42','WI13','user1','Task 42','Blocked','2024-04-13','2024-07-12'),
('T43','WI14','user2','Task 43','Open','2024-04-14','2024-07-13'),
('T44','WI15','user3','Task 44','Done','2024-04-25','2024-07-14'),
('T45','WI16','user4','Task 45','Open','2024-04-16','2024-07-15'),
('T46','WI17','user5','Task 46','In Progress','2024-04-17','2024-07-16'),
('T47','WI18','user1','Task 47','Open','2024-04-18','2024-07-17'),
('T48','WI19','user2','Task 48','In Progress','2024-04-19','2024-07-18'),
('T49','WI20','user3','Task 49','Open','2024-04-20','2024-07-19'),
('T50','WI21','user4','Task 50','Blocked','2024-04-21','2024-07-20');

-- sm_field_state for 70% of work items (~21 rows each field)
INSERT INTO sm_field_state(work_item_id,field_name,current_value,last_modified_by) VALUES
('WI1','status','New','seed'),
('WI2','status','In Progress','seed'),
('WI2','current_action','Analysis','seed'),
('WI3','status','Done','seed'),
('WI4','status','Blocked','seed'),
('WI4','current_action','Waiting','seed'),
('WI5','status','In Progress','seed'),
('WI5','current_action','Development','seed'),
('WI6','status','In Progress','seed'),
('WI7','status','New','seed'),
('WI8','status','Blocked','seed'),
('WI8','current_action','Dependency','seed'),
('WI9','status','Done','seed'),
('WI10','status','In Progress','seed'),
('WI10','current_action','Testing','seed'),
('WI11','status','In Progress','seed'),
('WI12','status','Blocked','seed'),
('WI12','current_action','Review','seed'),
('WI13','status','In Progress','seed'),
('WI13','current_action','Design','seed'),
('WI14','status','New','seed'),
('WI15','status','Done','seed'),
('WI16','status','In Progress','seed'),
('WI16','current_action','Implementation','seed'),
('WI17','status','Blocked','seed'),
('WI18','status','In Progress','seed'),
('WI18','current_action','Analysis','seed'),
('WI19','status','In Progress','seed'),
('WI20','status','New','seed'),
('WI21','status','Blocked','seed'),
('WI21','current_action','Approval','seed'),
('WI22','status','Done','seed'),
('WI23','status','In Progress','seed'),
('WI23','current_action','Development','seed'),
('WI24','status','Blocked','seed'),
('WI24','current_action','Dependency','seed'),
('WI25','status','In Progress','seed'),
('WI25','current_action','Testing','seed'),
('WI26','status','New','seed'),
('WI27','status','In Progress','seed'),
('WI27','current_action','Implementation','seed');

-- End seed data
